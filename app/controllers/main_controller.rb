class MainController < ApplicationController
    def main
        session[:user_id] = nil
        @user = User.new
    end
    def login
        # puts "vvvvvvv"
        @user = User.find_by(username: login_params[:username])
        if @user != nil
            if @user.authenticate(login_params[:password])
                session[:user_id] = @user.id
                redirect_to "/banner"
            else
                redirect_to "/main", alert: "Wrong password"
            end
        else
            redirect_to "/main", alert: "Incorrect email"
        end
    end
    def register
        @user = User.new
    end
    def create_user
        @user = User.new(user_params.except(:confirm_password))
        if [@user.valid?,@user.check_password(user_params[:confirm_password])].all?
            @user.save
            session[:user_id] = @user.id
            redirect_to "/banner"
        else
            render :register, status: :unprocessable_entity
        end
        # if @user.save
    end
    def banner
        @banners = Banner.all
        
    end
    def roll
        banner_id = params[:banner_id]
        banner = Banner.find(banner_id)
        rate = banner.getRate()
        total_rate = rate.deep_dup()
        for i in 1..rate.length-1 do
            total_rate[i][1] = total_rate[i-1][1]+rate[i][1]
        end
        total_rate[rate.length-1][1] = 1
        random = Random.new
        rng = random.rand()
        win = 0
        total_rate.each do |item, rate|
            if (rng <= rate)
                win = item
                break
            end
        end
        puts win
        Inventory.create(user_id: session[:user_id], item_id: win, status: "unsell", price: 0)
        u = User.find(session[:user_id])
        u.credit += 100
        u.save
        i = Item.find(win)
        render json: {name: i.name, rarity: i.rarity, credit: u.credit}
    end
    def inventory
        @inventories = User.find(session[:user_id]).getInventory
        @send_inv = Inventory.new
    end
    def sellItem
        inv_id = params[:item_id]
        user_id = session[:user_id]
        inv = Inventory.find(inv_id)
        inv.status = inv.status=="sell" ? "unsell" : "sell"
        inv.price = inv.status=="sell" ? params[:price].to_i : 0
        inv.save
        puts "#{inv_id}, #{user_id}"
        return render json: {status: "sell", price: params[:price].to_i}
    end
    def market
        @inventories = Inventory.getSell
    end
    def buy
        buyer = User.find(session[:user_id])
        seller = User.find(params[:seller])
        item = Inventory.find(params[:item_id])
        price = params[:price].to_i
        if (buyer.credit < price)
            return render json: {success: false}
        else
            item.user_id = buyer.id
            item.created_at = DateTime.now
            item.status = "unsell"
            item.price = 0
            item.save
            seller.credit += price
            buyer.credit -= price
            buyer.save
            seller.save
            return render json: {success: true, credit: buyer.credit}
        end
    end

    private
        def user_params
            params.require(:user).permit(:username, :password, :confirm_password, :credit)
        end
        def login_params
            params.require(:user).permit(:username, :password)
        end

        def isLogin
            if (session[:user_id])
                return true
            else
                redirect_to "/main", alert: "Please login"
                return false
            end 
        end
end
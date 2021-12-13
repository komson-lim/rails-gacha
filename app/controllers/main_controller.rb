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
        if isLogin
            @banners = Banner.all    
        end       
    end
    def favorite
        if isLogin
            @banners = User.find(session[:user_id]).getLikeBanner
        end       
    end
    def roll
        if isLogin
            banner_id = params[:banner_id]
            banner = Banner.find(banner_id)
            u = User.find(session[:user_id])
            if (banner.price <= u.credit)
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
                u.credit -= banner.price
                u.save
                i = Item.find(win)
                # render json: {success: true, name: i.name, rarity: i.rarity, credit: u.credit}
                render json: {success: true, result: [{name: i.name, rarity: i.rarity}], credit: u.credit}
            else
                render json: {success: false, reason: "Not have enough credit"}
            end
        end
    end
    def roll10
        if isLogin
            banner_id = params[:banner_id]
            banner = Banner.find(banner_id)
            u = User.find(session[:user_id])
            if (banner.price * 10 <= u.credit)
                rate = banner.getRate()
                total_rate = rate.deep_dup()
                for i in 1..rate.length-1 do
                    total_rate[i][1] = total_rate[i-1][1]+rate[i][1]
                end
                total_rate[rate.length-1][1] = 1
                random = Random.new
                win = []
                for i in 1..10 do
                    rng = random.rand()
                    total_rate.each do |item, rate|
                        if (rng <= rate)
                            Inventory.create(user_id: session[:user_id], item_id: item, status: "unsell", price: 0)
                            i = Item.find(item)
                            win.push({name: i.name, rarity: i.rarity})
                            break
                        end
                    end
                end
                puts win
                u.credit -= (banner.price * 10)
                u.save
                render json: {success: true, result: win, credit: u.credit}
            else
                render json: {success: false, reason: "Not have enough credit"}
            end
        end
    end
    def inventory
        if isLogin
            @inventories = User.find(session[:user_id]).getInventory
            @send_inv = Inventory.new
        end
    end
    def sellItem
        if isLogin
            inv_id = params[:item_id]
            user_id = session[:user_id]
            inv = Inventory.find(inv_id)
            inv.status = inv.status=="sell" ? "unsell" : "sell"
            inv.price = inv.status=="sell" ? params[:price].to_i : 0
            inv.save
            puts "#{inv_id}, #{user_id}"
            return render json: {status: "sell", price: params[:price].to_i}
        end
    end
    def market
        if isLogin
            @inventories = Inventory.getSell
        end
    end
    def buy
        if isLogin
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
                Transaction.create(buyer_id: buyer.id, seller_id: seller.id, amount: price, item_id: item.item_id)
                return render json: {success: true, credit: buyer.credit}
            end
        end
    end
    def transaction
        if isLogin
            @transactions = User.find(session[:user_id]).getTransaction
        end
    end
    def like
        if isLogin
            Like.create(user_id: session[:user_id], banner_id: params[:banner_id])
            redirect_to request.referer
        end
    end
    def unlike
        if isLogin
            l = Like.find_by(user_id: session[:user_id], banner_id: params[:banner_id])
            Like.destroy(l.id)
            redirect_to request.referer
        end
    end
    def redeem_display
        if isLogin
            render 'redeem'
        end
    end
    def redeem
        if isLogin
            r = RedeemCode.find_by(code: params[:code], status: "available")
            if (r != nil)
                u = User.find(session[:user_id])
                u.credit += r.amount
                r.status = "redeemed"
                r.save
                u.save
                return render json: {success: true, credit: u.credit, amount: r.amount}
            else
                return render json: {success: false, reason: "Invalid code"}
            end
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
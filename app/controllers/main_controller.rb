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
    def feed
        if isLogin
            @user = User.find(session[:user_id])
        end
    end
    def banner
        @banners = Banner.all
    end
    def roll
        banner_id = 2
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
        Item.find(win)
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
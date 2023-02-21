class SessionsController < ApplicationController

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.find_by_credentials(params[:user][:email], params[:user][:password])
        if @user.save
            login!(@user)
            redirect_to user_url(@user)
        else
            flash.now[:errors] = ["incorrect login information"]
            render :new
        end
    end

    def delete
        logout!
        redirect_to new_session_url
    end
end

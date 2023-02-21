class UsersController < ApplicationController

    def show
        @user = User.find_by(id: params[:id])
        render :show
    end

    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.create(strong_params)
        if @user.save
            redirect_to user_url(@user)
        else
            flash.now[:errors] = @user.errors.full_messages
            render :new
        end
    end

    
    private

    def strong_params
        params.require(:user).permit(:email, :password, :session_token, :password_digest)
    end
end

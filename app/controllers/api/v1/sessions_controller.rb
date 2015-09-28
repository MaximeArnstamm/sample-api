module Api
  module V1

    class SessionsController < Devise::SessionsController
      respond_to :json
      skip_before_filter :verify_authenticity_token
      acts_as_token_authentication_handler_for User, only: [:destroy], fallback_to_devise: false
      skip_before_filter :verify_signed_out_user, only: :destroy

      def create
        @user = User.find_by_email(params[:email])
        if (@user && @user.valid_password?(params[:password]))
          sign_in(:user, @user)
        else
          render json: { message: 'Bad credentials' }, status: 401
        end
      end

      def destroy
        if user_signed_in?
          @user = current_user
          @user.authentication_token = nil
          @user.save

          render json: { message: 'Logged out successfully.' }, status: 200
        else
          render json: { message: 'Failed to log out. User must be logged in.' }, status: 401
        end
      end

    end

  end
end

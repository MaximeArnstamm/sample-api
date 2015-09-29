module Api
  module V1

    class UsersController < ApiController
      before_action :fetch_and_authorize_user

      def show
      end

      def update
        if @user.update(user_params)
          render 'show', formats: [:json], handlers: [:jbuilder], status: 201
        else
          # TODO : more meaningful message
          render json: { message: 'Bad request' }, status: 500
        end
      end

      private

      def user_params
        params.permit(:first_name,
                      :last_name,
                      :password)
      end

      def fetch_and_authorize_user
        @user = User.find(params[:id])
        authorize @user
      end

    end # class

  end
end

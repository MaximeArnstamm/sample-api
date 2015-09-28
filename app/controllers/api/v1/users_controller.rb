module Api
  module V1

    class UsersController < ApiController

      def show
        @user = User.find(params[:id])
        authorize @user
      end

      def update
        @user = User.find(params[:id])
        authorize @user

        if @user.update(user_params)
          render 'show', formats: [:json], handlers: [:jbuilder], status: 201
        else
          render json: { message: 'Bad request' }, status: 500
        end
      end

      private

      def user_params
        params.permit(:first_name,
                      :last_name,
                      :password)
      end

    end # class

  end
end

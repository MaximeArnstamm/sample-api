module Api
  module V1

    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      skip_before_filter :verify_authenticity_token

      acts_as_token_authentication_handler_for User
      skip_before_filter :authenticate_entity_from_token!, only: [:create]
      skip_before_filter :authenticate_entity!, only: [:create]

      skip_before_filter :authenticate_scope!
      append_before_filter :authenticate_scope!, only: [:destroy]

      def create
        build_resource(sign_up_params)

        if !resource.valid?
          status = 422
          message = "#{resource.errors.full_messages.join(', ')}"
          render json: { message: message }, status: status
        elsif ! resource.save!
          clean_up_passwords resource
          status = 500
          message = "Failed to create new account for email #{sign_up_params[:email]}."
          render json: { message: message }, status: status
        else
          render '/api/v1/sessions/create', formats: [:json], handlers: [:jbuilder], status: 201
        end
      end

      def destroy
        resource.destroy
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

        render json: { message: 'Successfully deleted the account.' }, status: 200
      end

      private

      def sign_up_params
        params.permit(:email, :password, :password_confirmation)
      end
    end

  end
end

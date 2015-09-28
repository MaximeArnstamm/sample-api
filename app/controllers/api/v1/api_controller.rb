module Api
  module V1

    class ApiController < ApplicationController
      # define which model will act as token authenticatable
      acts_as_token_authentication_handler_for User, fallback: :exception

      # Prevent CSRF attacks by raising an exception.
      # For APIs, you may want to use :null_session instead.
      protect_from_forgery with: :null_session
      # vire le token CSRF vu qu'on est en API (rien à voir avec le token d'authent)
      skip_before_filter :verify_authenticity_token, if: :json_request?

      respond_to :json

      private

      def json_request?
        request.format.json?
      end

    end

  end
end

module Api
  module V1

    class EventsController < ApiController
      skip_after_action :verify_policy_scoped, only: :index

      def index
        user = User.find(params[:user_id])
        authorize user

        @events = user.events
      end

      def show
        user = User.find(params[:user_id])
        authorize user

        @event = Event.find(params[:id])
      end

      def create
        user = User.find(params[:user_id])
        authorize user

        @event = Event.new(event_params)
        user.events << @event
        
        if user.save
          render 'show', formats: [:json], handlers: [:jbuilder], status: 201
        else
          render json: { message: 'Bad request' }, status: 500
        end
      end

      private

      def event_params
        params.require(:event).permit(:name, :date)
      end
    end

  end
end

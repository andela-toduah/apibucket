module Api
  module V1
    class SessionsController < ApplicationController
      before_action :authenticate_token, only: [:logout, :valid]

      def login
        auth_command = Api::UserAuthentication.call(
          params[:email],
          params[:password]
        )
        respond_with_command auth_command
      end

      def logout
        current_user.update api_token: nil
        render json: { "message": "Logged out successfully." }
      end

      def valid
        render json: { "message": "Token valid." }
      end

      private

        def respond_with_command(auth_command)
          if auth_command.success?
            render json: auth_command.result
          else
            render json: auth_command.errors, status: :unauthorized
          end
        end
    end
  end
end

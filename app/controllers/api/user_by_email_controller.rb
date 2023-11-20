# frozen_string_literal: true

module Api
  class UserByEmailController < ApplicationController
    def show
      @user = User.find_by(email: params[:email])
      if @user
        render json: @user
      else
        render json: { error: 'User not found' }, status: :not_found
      end
    end
  end
end

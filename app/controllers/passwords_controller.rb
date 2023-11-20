#frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    authorize @user, policy_class: PasswordPolicy
  end

  def update
    @user = User.find(params[:id])
    authorize @user, policy_class: PasswordPolicy
    if @user.update_with_password(password_params)
      by_pass_sign_in(@user)
      flash[:notice] = "Password updated"
      redirect_to password_path(@user)
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  private

  def password_params
    params.require(:password).permit(:current_password, :password, :password_confirmation)
  end
end

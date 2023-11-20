#frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    authorize @user, policy_class: AccountPolicy
  end

  def update
    @user = User.find(params[:id])
    authorize @user, policy_class: AccountPolicy
    if @user.update(account_params)
      flash[:notice] = "Account updated"
      redirect_to account_path
    else
      flash[:alert] = "Something went wrong"
      render :show
    end
  end

  private

  def account_params
    params.require(:account).permit(:email)
  end
end

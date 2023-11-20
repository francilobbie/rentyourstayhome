# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @profile = Profile.find(params[:id])
    authorize @profile, policy_class: ProfilePolicy
  end

  def update
    @profile = Profile.find(params[:id])
    authorize @profile, policy_class: ProfilePolicy
    if @profile.update(profile_params)
      flash[:notice] = "Profile updated"
      redirect_to profile_path(@profile)
    else
      flash[:alert] = "Something went wrong"
      render :show
    end
  end

  def delete_avatar
    @profile = Profile.find_by(user_id: params[:id])
    authorize @profile, :delete_avatar?
    avatar_attachment = @profile.avatar

    respond_to do |format|
      if avatar_attachment
        avatar_attachment.purge
        format.html { redirect_to @profile, notice: 'Avatar successfully deleted.' }
        format.json { render json: { status: "success", message: "Avatar successfully deleted." }, status: :ok }
      else
        format.html { redirect_to @profile, alert: 'Avatar does not exist or has already been deleted.' }
        format.json { render json: { status: "error", message: "Avatar does not exist or has already been deleted." }, status: :unprocessable_entity }
      end
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :phone_number, :description, :avatar)
  end
end

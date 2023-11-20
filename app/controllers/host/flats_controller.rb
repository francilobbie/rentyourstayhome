class Host::FlatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_flat, only: [:edit, :update, :destroy, :delete_image]

  def new
    authorize current_user, policy_class: HostPolicy
    @flat = Flat.new(user: current_user)
  end

  def create
    authorize current_user, policy_class: HostPolicy
    @flat = current_user.flats.new(flat_params)

    return render :new unless address_valid?

    if @flat.save
      redirect_to host_dashboard_path
    else
      render :new
    end
  end

  def edit
    authorize current_user, policy_class: HostPolicy
  end

  def update
    authorize current_user, policy_class: HostPolicy

    return render :edit unless address_valid?

    @flat.flat_type = flat_params[:flat_type].downcase if flat_params[:flat_type].present?

    if @flat.update(flat_params)
      redirect_to host_dashboard_path
    else
      render :edit
    end
  end

  def destroy
    authorize current_user, policy_class: HostPolicy
    @flat.destroy
    redirect_to host_dashboard_path
  end

  def delete_image
    blob = ActiveStorage::Blob.find_by(key: params[:image_key])
    image = blob.attachments.find_by(record: @flat) if blob

    if image
      image.purge
      redirect_to edit_host_flat_path(@flat), notice: 'Image was successfully deleted.'
    else
      redirect_to edit_host_flat_path(@flat), alert: 'Image could not be deleted.'
    end
  end

  private

  def flat_params
    params.require(:flat).permit(:name, :price, :title, :description, :flat_type, :latitude, :longitude, :city, :state, :country_code, :zip_code, :address, images: [])
  end

  def compile_address(address, city, state, zip_code)
    "#{address}, #{city}, #{state}, #{zip_code}"
  end

  def address_valid?
    full_address = compile_address(flat_params[:address], flat_params[:city], flat_params[:state], flat_params[:zip_code])
    if Geocoder.search(full_address).present?
      true
    else
      @flat.errors.add(:address, "is not valid. Please ensure you've provided a correct address.")
      false
    end
  end

  def set_flat
    @flat = Flat.find(params[:id])
  end
end

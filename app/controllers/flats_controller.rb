class FlatsController < ApplicationController
  before_action :authenticate_user! , except: [:index, :show]
  before_action :set_flat, only: [:edit, :update, :destroy, :delete_image]


  def index
    @flats = Flat.all
  end

  def show
    @flat = Flat.find(params[:id])
    @booking = Booking.new

    @markers = [{
      lat: @flat.latitude,
      lng: @flat.longitude,
      info_html: render_to_string(partial: "flats/search/info", locals: { flat: @flat })
    }]
  end



  def new
    authorize current_user, policy_class: HostPolicy
    @flat = Flat.new(user: current_user)
  end

  def create
    authorize current_user, policy_class: HostPolicy
    @flat = current_user.owned_flats.new(flat_params)
    # Assign the converted price to @flat
    @flat.price_cents = params[:price].to_i * 100
    # @flat.price = params[:price].to_i

    if @flat.save
      redirect_to host_dashboard_path
    else
      render 'host/flats/new'
    end
  end

  def edit
    authorize current_user, policy_class: HostPolicy
  end



  def update
    authorize current_user, policy_class: HostPolicy
    # Append new images to the existing ones
    if flat_params[:images]
      @flat.images.attach(flat_params[:images])
    end

    # Assign the converted price to @flat
    @flat.price_cents = params[:price].to_i * 100

    # Update other attributes excluding the images

    if  @flat.update(flat_params.except(:images))
      redirect_to host_dashboard_path
    else
      render 'host/flats/edit'
    end
  end



  def destroy
    authorize current_user, policy_class: HostPolicy
    @flat.destroy
    redirect_to host_dashboard_path
  end


  def delete_image
    # Find the blob by its key
    blob = ActiveStorage::Blob.find_by(key: params[:image_key])

    # Ensure that the @flat instance variable is set

    # Find the attachment for that blob and this flat
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
    params.require(:flat).permit(:name, :title, :description, :flat_type, :price, :city, :latitude, :longitude, :state, :country_code, :zip_code, :address, images: [])
  end


  def set_flat
    @flat = Flat.find(params[:id])
  end
end

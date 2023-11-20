ActiveAdmin.register Flat do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment

  index do
    column :id
    column :name
    column :title
    # column :last_name
    # column :admin
    actions
  end

  form do |f|
    f.input :name
    f.input :title
    # f.input :admin
    f.actions
  end
  #
  permit_params :name, :title, :description, :city, :state, :country, :address, :latitude, :longitude, :price_cents, :price_currency, :reviews_count, :average_rating, :user_id, :zip_code, :country_code, :flat_type
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :title, :description, :city, :state, :country, :address, :latitude, :longitude, :price_cents, :price_currency, :reviews_count, :average_rating, :user_id, :zip_code, :country_code, :flat_type]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end

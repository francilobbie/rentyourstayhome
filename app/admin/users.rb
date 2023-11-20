ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  index do
    column :id
    column :email
    column :first_name
    column :last_name
    column :admin
    actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :admin
    end

    f.inputs "Profile Details", for: [:profile, f.object.profile || f.object.build_profile] do |profile_form|
      profile_form.input :first_name
      profile_form.input :last_name
      # Add any other profile-related fields here if needed
    end

    f.actions
  end


  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :stripe_id, :role, :admin
  permit_params :email, :password, :password_confirmation, :admin, profile_attributes: [:first_name, :last_name, :id]

  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :stripe_id, :role, :admin]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # permit_params do

  #   permitted = [:email, :password, :password_confirmation, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :stripe_id, :role, :admin]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


end

class AddFirstNameAndLastNameToProfiles < ActiveRecord::Migration[7.0]
  def change
    add_column :profiles, :first_name, :string
    add_column :profiles, :last_name, :string

    query = <<~SQL
    UPDATE profiles
    SET first_name = users.first_name,
        last_name = users.last_name
    FROM users
    WHERE profiles.user_id = users.id
  SQL

    ActiveRecord::Base.connection.execute(query)
  end
end

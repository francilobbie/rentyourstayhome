#####################################################################################################################



# def generate_flat_description(title, address)
#   prompt = "Write a 600-word detailed and attractive description for a flat titled '#{title}' located at '#{address}' in the style of an Airbnb property."

#   response = HTTParty.post(
#     "https://api.openai.com/v1/engines/text-davinci-003/completions",
#     headers: {
#       "Content-Type" => "application/json",
#       "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}"
#     },
#     body: {
#       prompt: prompt,
#       max_tokens: 1024
#     }.to_json
#   )

#   if response.code == 200
#     description = response.parsed_response['choices'].first['text'].strip
#     puts "Generated description: #{description}" # Debugging line
#     description
#   else
#     puts "Error: Response Code #{response.code}, Body: #{response.body}" # Debugging line
#     nil
#   end
# rescue => e
#   puts "Error generating description: #{e.message}"
#   nil
# end


require 'open-uri'
require 'faker'
require 'httparty'


####################################################################################################


              # SEEDING IS TAKING ABOUT 10 MINUTES TO RUN

####################################################################################################

def generate_flat_description
  Faker::Lorem.paragraphs(number: 10, supplemental: true).join("\n\n")
end

def fetch_details_from_mapbox(address, access_token)
  url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{CGI.escape(address)}.json?access_token=#{access_token}"
  response = HTTParty.get(url)
  data = JSON.parse(response.body)

  if data["features"] && data["features"][0]
    feature = data["features"][0]
    latitude = feature["center"][1]
    longitude = feature["center"][0]

    city = feature["context"].find { |c| c["id"].include?("place") }&.fetch("text", "")
    country_code = feature["context"].find { |c| c["id"].include?("country") }&.fetch("short_code", "").upcase

    return [latitude, longitude, city, country_code]
  end
end

mapbox_access_token = ENV["MAPBOX_API_KEY"]

p "Cleaning all flats........."
Flat.destroy_all

p "Cleaning all users........."
User.destroy_all



# User creation
users_data = [
  { email: 'franci@mail.com', first_name: 'Franci-lobbie', last_name: 'Lalane' },
  { email: 'augustin@mail.com', first_name: 'Augustin', last_name: 'Dubois' },
  { email: 'julien@mail.com', first_name: 'Julien', last_name: 'Legrand' },
  { email: 'alex@mail.com', first_name: 'Alex', last_name: 'Herme' },
  { email: 'marine@mail.com', first_name: 'Marine', last_name: 'Petit' },
  { email: 'julie@mail.com', first_name: 'Julie', last_name: 'Peltier' }
]

users = users_data.map do |user_data|
  user = User.create!(email: user_data[:email], password: 'azerty')
  user.profile.update(first_name: user_data[:first_name], last_name: user_data[:last_name])
  user
end

# Assigning avatars to users
users.each_with_index do |user, index|
  avatar = URI.open('https://source.unsplash.com/1600x900/?portrait')
  user.profile.avatar.attach(io: avatar, filename: "user_#{index}.jpg", content_type: 'image/jpg')
end

p "Creating flats........."
flat_types = %w[room apartment]  # Array of valid flat types

users.each do |user|
  next if user.email == 'julie@mail.com'  # Skip for Julie

  user.hostify!

  4.times do
    title = Faker::Address.street_address
    address = Faker::Address.full_address
    flat_description = generate_flat_description
    flat_type = flat_types.sample

    latitude, longitude, city, country_code = fetch_details_from_mapbox(address, mapbox_access_token)

    flat = Flat.new(
      user: user,
      name: Faker::Lorem.word,
      title: title,
      description: flat_description,
      address: address,
      latitude: latitude,
      longitude: longitude,
      city: city,
      country_code: country_code,
      price_cents: rand(4000..30000),
      flat_type: flat_type
    )

    # Attach images using Cloudinary
    image_count = rand(5..11) # Ensure at least 5 images are attached
    images = []
    image_count.times do
      image_url = 'https://source.unsplash.com/1600x900/?house'
      uploaded_image = Cloudinary::Uploader.upload(image_url)
      images << { io: URI.open(uploaded_image['url']), filename: "flat_#{flat.id}_#{SecureRandom.uuid}.jpg" }
    end

    # Attach all images at once to the flat
    flat.images.attach(images)

      flat.save!

    # Creating reviews
    (5..10).to_a.sample.times do
      Review.create!(
        title: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        rating: rand(3..5),
        reviewable: flat,
        user: User.all.sample
      )
    end

    flat.save!
  end
end

p "Created #{Flat.count} flats."
AdminUser.create!(email: 'admin@example.com', password: 'password_myclone', password_confirmation: 'password_myclone') if Rails.env.development?

# Rent Your Stay Home

## Introduction
Welcome to `Rent Your Stay Home`, a comprehensive Ruby on Rails application designed as an Airbnb clone. This project showcases full-stack development skills, including front-end, back-end, and database management. A special thanks to Chris Jeon for his insightful Airbnb clone tutorial on YouTube. This project, which took about 6 months to develop, is a testament to continuous learning and improvement in web development.

[View the tutorial here](https://www.youtube.com/watch?v=D889P37r3bc&list=PLCawOXF4xaJK1_-KVgXyREULRVy_W_1pe&pp=iAQB)

## Features
- User Authentication with Devise
- Property Listing
- Booking System
- Stripe Integration for Payments
- User Reviews and Ratings
- Geolocation with Mapbox
- Cloud Image Storage with Cloudinary

## Technologies Used
- Ruby on Rails
- PostgreSQL
- HTML, CSS, JavaScript, Tailwind CSS

## Installation

### Prerequisites 🚨
- Ruby, version `3.1.2`
- Rails, version `7.0.8`
- PostgreSQL
- Cloudinary API key
- Mapbox API key
- Stripe API key

### Setup
1. Clone the repository:
   ```bash
   git clone git@github.com:francilobbie/rentyourstayhome.git

2. Change directory:
   ```bash
   cd rentyourstayhome

4. Install dependencies:
   ```bash
   bundle install

6. Set up the database:
   ```bash
   rails db:create db:migrate db:seed
   
5. Start the development server:
    ```bash
    bin/dev
    ```
## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

## Acknowledgments

1. Chris Jeon for his Ruby on Rails Airbnb clone tutorial
2. Ruby on Rails Community
3. Faker for generating seed data
4. Unsplash for images

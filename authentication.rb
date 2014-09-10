# Gemfile
gem 'devise'
rails generate devise_install

# run Devise generator for User
rails generate devise User

# Check the migration file and comment out unwatned features

# Go to User model and add modules included in migration
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :trackable, :validatable
end

# Pundit for access policy control
# Gemfile
gem 'pundit'
rails generate pundit:install

# Inlude Pundit methods in ApplicatonController
class ApplicationController < ActionController::Base
  include Pundit
end

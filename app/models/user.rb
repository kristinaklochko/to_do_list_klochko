class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,:validatable


  has_many :projects
  has_many :tasks, :through => :projects
end

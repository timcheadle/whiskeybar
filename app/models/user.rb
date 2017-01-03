class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :timeoutable,
         :validatable

  has_many :bottles
end

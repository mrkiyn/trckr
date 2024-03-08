class Category < ApplicationRecord
    validates :name, presence: { message: "Name can't be blank" }
  
    belongs_to :user
    has_many :tasks, dependent: :destroy
  end
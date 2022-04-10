class Contact < ApplicationRecord
  validates :email, presence: true
	validates :name, presence: true
	validates :subject, presence: true
	validates :message, presence: true
end

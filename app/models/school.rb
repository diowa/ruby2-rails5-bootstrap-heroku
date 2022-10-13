# frozen_string_literal: true

class School < ApplicationRecord
  include ChronoModel::TimeMachine

  belongs_to :city
  has_one :country, through: :city

  has_many :students, dependent: :destroy

  validates :name, presence: true
end

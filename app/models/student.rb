# frozen_string_literal: true

class Student < ApplicationRecord
  include ChronoModel::TimeMachine

  belongs_to :school
  has_one :city, through: :school
  has_one :country, through: :city

  validates :name, presence: true
end

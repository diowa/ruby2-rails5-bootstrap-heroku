# frozen_string_literal: true

class City < ApplicationRecord
  include ChronoModel::TimeMachine

  validates :name, presence: true

  belongs_to :country

  has_many :schools, dependent: :destroy
end

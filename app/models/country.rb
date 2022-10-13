# frozen_string_literal: true

class Country < ApplicationRecord
  include ChronoModel::TimeMachine

  has_many :cities, dependent: :destroy

  validates :name, presence: true
end

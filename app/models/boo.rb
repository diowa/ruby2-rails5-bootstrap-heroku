# frozen_string_literal: true

class Boo < ApplicationRecord
  include ChronoModel::TimeMachine

  belongs_to :goo, touch: true

  validates :name, presence: true
end

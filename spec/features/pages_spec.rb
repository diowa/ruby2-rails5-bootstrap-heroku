# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages' do
  describe 'Home' do
    it 'has application name in title' do
      visit root_path

      expect(page).to have_title I18n.t('app_name')
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'コンストラクタ' do
    let(:event) { FactoryBot.build(:event) }

    it 'インスタンスが有効であること' do
      expect(event).to be_valid
    end
  end
end

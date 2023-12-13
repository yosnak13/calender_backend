# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EventsControllers', type: :request do
  describe 'GET #index' do
    let(:event) { FactoryBot.create(:event) }
    let(:events) { [event] }

    it 'ステータスが200であること' do
      get '/events'
      expect(response.status).to eq(200)
      expect(events.count).to eq(1)
      expect(events[0].id).to eq(event.id)
      expect(events[0].name).to eq(event.name)
      expect(events[0].timed).to eq(event.timed)
      expect(events[0].description).to eq(event.description)
      expect(events[0].color).to eq(event.color)
      expect(events[0].start).to eq(event.start)
      expect(events[0].finish).to eq(event.finish)
    end
  end

  describe 'GET #show' do
    let(:event) { FactoryBot.create(:event) }

    it 'ステータスが200であること' do
      get "/events/#{event.id}"
      expect(response.status).to eq(200)

      response_json = JSON.parse(response.body)
      expect(response_json['id']).to eq(event.id)
      expect(response_json['name']).to eq(event.name)
      expect(response_json['timed']).to eq(event.timed)
      expect(response_json['description']).to eq(event.description)
      expect(response_json['color']).to eq(event.color)

      # 時刻は実際の値を期待値のフォーマットに合わせて変換
      actual_start = Time.parse(response_json['start']).strftime('%Y-%m-%d %H:%M:%S.%L %z')
      expect(actual_start).to eq(event.start.strftime('%Y-%m-%d %H:%M:%S.%L %z'))
      actual_finish = Time.parse(response_json['finish']).strftime('%Y-%m-%d %H:%M:%S.%L %z')
      expect(actual_finish).to eq(event.finish.strftime('%Y-%m-%d %H:%M:%S.%L %z'))
    end
  end
end

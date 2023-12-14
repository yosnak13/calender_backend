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

      res = JSON.parse(response.body)
      expect(res['id']).to eq(event.id)
      expect(res['name']).to eq(event.name)
      expect(res['timed']).to eq(event.timed)
      expect(res['description']).to eq(event.description)
      expect(res['color']).to eq(event.color)

      # 時刻は実際の値を期待値のフォーマットに合わせて変換。秒単位が合致していればよい
      actual_start = Time.parse(res['start']).strftime('%Y-%m-%d %H:%M:%S')
      expect(actual_start).to eq(event.start.strftime('%Y-%m-%d %H:%M:%S'))
      actual_finish = Time.parse(res['finish']).strftime('%Y-%m-%d %H:%M:%S')
      expect(actual_finish).to eq(event.finish.strftime('%Y-%m-%d %H:%M:%S'))
    end
  end

  describe 'POST #create' do
    let(:event_hash) { FactoryBot.attributes_for(:event) }

    context '成功' do
      it 'リクエストが返却され、ステータスが200であること' do
        post '/events', params: { event: event_hash }
        expect(response.status).to eq(200)

        res = JSON.parse(response.body)
        expect(res['name']).to eq(event_hash[:name])
        expect(res['timed']).to eq(event_hash[:timed])
        expect(res['description']).to eq(event_hash[:description])
        expect(res['color']).to eq(event_hash[:color])

        # 時刻は実際の値を期待値のフォーマットに合わせて変換。秒単位が合致していればよい
        expected_start = event_hash[:start].in_time_zone(Time.zone).strftime('%Y-%m-%d %H:%M:%S')
        actual_start = res['start'].to_time.strftime('%Y-%m-%d %H:%M:%S')
        expect(actual_start).to eq(expected_start)

        expected_finish = event_hash[:finish].in_time_zone(Time.zone).strftime('%Y-%m-%d %H:%M:%S')
        actual_finish = res['finish'].to_time.strftime('%Y-%m-%d %H:%M:%S')
        expect(actual_finish).to eq(expected_finish)
      end
    end

    context '失敗' do
      it 'エラーメッセージが返却され、ステータスが422になること' do
        event = instance_double('Event', save: false, errors: { name: ['Name cannot be blank'] })
        allow(Event).to receive(:new).and_return(event)

        post '/events', params: { event: event_hash }
        expect(response.status).to eq(422)
        expect(response.body).to include('Name cannot be blank')
      end
    end
  end
end

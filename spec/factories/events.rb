# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    id { 1 }
    name { Faker::Lorem.word }
    start { Faker::Time.between(from: DateTime.now, to: DateTime.now + 7) }
    finish { Faker::Time.between(from: DateTime.now + 7, to: DateTime.now + 14) }
    timed { [true, false].sample }
    description { Faker::Lorem.paragraph }
    color { Faker::Color.hex_color }
    created_at { DateTime.now }
    updated_at { DateTime.now }
  end
end

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '123456' }
  end
end

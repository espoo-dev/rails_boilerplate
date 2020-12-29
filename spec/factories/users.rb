include ActionDispatch::TestProcess
FactoryBot.define do
  factory :user do
    username { Faker::Name.unique.name }
    password { Faker::String.random(length: 3) }
    access_level { User.access_levels[:registred] }

    trait :registred do
      access_level { User.access_levels[:registred] }
    end

    trait :admin do
      access_level { User.access_levels[:admin] }
    end

    trait :without_username do
      username { nil }
    end

    trait :without_password do
      password { nil }
    end

    trait :user_with_invalid_password do
      password { Faker::String.random(length: 2) }
    end
  end
end

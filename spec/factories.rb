FactoryBot.define do
  factory :contact do
    name { 'Jagmeet Singh' }
    url  { 'http://example.com' }
    shortened_url { 'https://ndp.ca' }

    created_at { Time.current }
    updated_at { Time.current }

    trait :from_form do
      shortened_url { nil }
    end
  end

  factory :friendship do
    association :contact
    association :friend, factory: :contact
  end
end

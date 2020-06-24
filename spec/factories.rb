FactoryBot.define do
  factory :contact do
    name { 'Jagmeet Singh' }
    url  { 'http://example.com' }
    shortened_url { 'https://ndp.ca' }

    created_at { Time.current }
    updated_at { Time.current }

    transient do
      topics { [] }
    end

    after(:build) do |contact, evaluator|
      Array(evaluator.topics).map { |t| contact.topics.build(name: t, heading_level: 2) }
    end

    trait :from_form do
      shortened_url { nil }
    end
  end

  factory :friendship do
    association :contact
    association :friend, factory: :contact
  end

  factory :topic do
    name { 'Cool beans' }
    heading_level { 2 }
    association :contact
  end
end

FactoryBot.define do
  factory :contact do
    name { 'Jagmeet Singh' }
    url  { 'https://www.ndp.ca/' }
    shortened_url { 'https://n.dp' }

    created_at { Time.current }
    updated_at { Time.current }

    trait :from_form do
      shortened_url { nil }
    end
  end
end

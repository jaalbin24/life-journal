FactoryBot.define do
  factory :note do
    for_person # Default to the for_person trait

    association :user
    content { "Test note" }

    trait :for_person do
      association :notable, factory: :person
    end
  end
end

FactoryBot.define do
  factory :entry do
    association :author, factory: :user
    title { "Test Title" }
    text_content { ActionText::Content.new(Faker::Lorem.paragraphs.join("\n\n")) }

    trait :published do
      status { "published" }
    end
    trait :draft do
      status { "draft" }
    end
    trait :deleted do
      deleted { true }
    end
  end
end
  
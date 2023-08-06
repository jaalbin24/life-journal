FactoryBot.define do
  factory :person do
    first_name {"John"}

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new(Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample, 'image/jpeg') }
    end
  
    before :create do |person, evaluator|
      person.user = create(:user) if person.user.nil?
    end
  end
end
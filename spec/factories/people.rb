FactoryBot.define do
  factory :person do
    avatar { Rack::Test::UploadedFile.new(Dir.glob("#{Rails.root.join('db', 'seed_data', 'avatars')}/*").sample, 'image/jpeg') }
  end
end
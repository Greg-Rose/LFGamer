FactoryGirl.define do
  factory :game do
    sequence(:name) { |n| "Cool Game #{n}" }
    online true
    split_screen false
    cover_image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'test_cover.jpg'), 'image/jpg') }

    before(:create) { |instance| instance.consoles << create(:console) }
  end
end

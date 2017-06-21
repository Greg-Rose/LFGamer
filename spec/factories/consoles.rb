FactoryGirl.define do
  factory :console do
    sequence(:name) { |n| "PlayBox #{n}" }
    logo { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'images', 'test_logo.png'), 'image/png') }
  end
end

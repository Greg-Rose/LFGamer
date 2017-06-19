FactoryGirl.define do
  factory :game do
    sequence(:name) { |n| "Cool Game #{n}" }
    online true
    split_screen false

    console
  end
end

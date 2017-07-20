FactoryGirl.define do
  factory :console do
    sequence(:name) { |n| "PlayBox #{n}" }
    sequence(:abbreviation) { |n| "PB#{n}" }
  end
end

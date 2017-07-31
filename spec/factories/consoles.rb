FactoryGirl.define do
  factory :console do
    sequence(:name) { |n| "PlayStation #{n}" }
    sequence(:abbreviation) { |n| "PS#{n}" }
  end
end

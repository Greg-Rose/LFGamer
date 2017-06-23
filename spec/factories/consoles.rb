FactoryGirl.define do
  factory :console do
    sequence(:name) { |n| "PlayBox #{n}" }
    abbreviation "PB"
  end
end

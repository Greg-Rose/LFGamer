FactoryGirl.define do
  factory :console do
    sequence(:name) { |n| "PlayBox #{n}" }
  end
end

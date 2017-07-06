FactoryGirl.define do
  factory :user do
    first_name "Rose"
    last_name "Tyler"
    sequence(:username) { |n| "Rose#{n}" }
    sequence(:email) { |n| "Rose#{n}@bluebox.com" }
    password "DoctorWho"
    password_confirmation "DoctorWho"
  end
end

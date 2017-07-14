FactoryGirl.define do
  factory :profile do
    about_me "I like playing games. etc. etc. etc."
    sequence(:psn_id) { |n| "Firefly#{n}" }
    sequence(:xbox_gamertag) { |n| "FireFLY#{n}" }
    zipcode "01234"
    psn_id_public true
    xbox_gamertag_public true
    active true
    
    after(:create) do |profile|
      profile.updated_at += 1
      profile.save
    end

    user
  end
end

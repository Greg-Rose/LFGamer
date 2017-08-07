FactoryGirl.define do
  factory :lfg do
    sequence(:specifics) { |n| "Lets play, etc. etc. etc. #{n}" }
    show_console_username true

    ownership
  end
end

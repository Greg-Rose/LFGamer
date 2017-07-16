require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_valid(:first_name).when('Amy', 'Rory') }
  it { should_not have_valid(:first_name).when('', nil) }

  it { should have_valid(:last_name).when('Pond', 'Williams') }
  it { should_not have_valid(:last_name).when('', nil) }

  it { should have_valid(:username).when('AmyP', 'rwilliams') }
  it { should_not have_valid(:username).when('', 'amy pond', nil) }

  it { should have_valid(:email).when('Amy@bluebox.com', 'rory@tardis.net') }
  it { should_not have_valid(:email).when('', nil, 'amy', 'rorygmail.com') }

  it 'has a matching password confirmation for the password' do
    user = User.new
    user.password = 'tardis'
    user.password_confirmation = 'doctorwho'

    expect(user).to_not be_valid
    expect(user.errors[:password_confirmation]).to_not be_blank
  end

  it { should have_valid(:admin).when(true, false) }
  it { should_not have_valid(:admin).when('', nil) }
end

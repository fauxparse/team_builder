FactoryGirl.define do
  factory :team do
    name "JediStormPilot"
  end

  factory :user do
    name "Poe Dameron"
    email "poe@resistance.org"
    password "Finn <3 <3 <3"

    before(:create) { |user| user.skip_confirmation! }
  end
end

FactoryGirl.define do
  factory :event do
    team
    name "An Awakening"
    description "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
    starts_at "2015-12-18 00:00:00 +1300"
    stops_at nil
  end

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

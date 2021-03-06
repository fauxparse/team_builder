FactoryGirl.define do
  factory :team do
    name "JediStormPilot"
  end

  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@resistance.org" }
    password "p4$$w0rd"
    avatar_url "https://placeimg.com/200/200/animals"

    factory :poe do
      name "Poe Dameron"
      email "poe@resistance.org"
    end

    factory :finn do
      name "Finn"
      email "finn@resistance.org"
    end

    factory :rey do
      name "Rey"
      email "rey@resistance.org"
    end
  end

  factory :member do
    user
    team

    factory :newbie do
      sequence(:email) { |n| "n00b-#{n}@resistance.org" }
      display_name "Newbie"
      user nil
    end

    trait :admin do
      admin true
    end
  end

  factory :event do
    team
    name "An Awakening"
    description "Lorem ipsum dolor sit amet, consectetur adipisicing elit."
    starts_at "2015-12-17 00:01:00 +1300"
    stops_at nil
    duration 8100
    time_zone_name "Wellington"

    trait :weekly do
      recurrence_rules do
        [Event::RecurrenceRule.new(repeat_type: :weekly, stops_at: "2016-01-17 00:01:00+1300")]
      end
    end

    trait :with_pilots do
      transient do
        pilot_count 2
      end

      after(:create) do |event, evaluator|
        pilot = FactoryGirl.create(:pilot_role, team: event.team)
        event.allocations.create(role: pilot, maximum: evaluator.pilot_count)
      end
    end
  end

  factory :role do
    team

    factory :pilot_role do
      name "pilot"
    end

    factory :jedi_role do
      name "Jedi"
      plural "Jedi"
    end
  end

  factory :recurrence_rule, :class => 'Event::RecurrenceRule' do
    event

    trait :never_recurs do
      repeat_type :never
    end

    trait :daily do
      repeat_type :daily
    end

    trait :weekly do
      repeat_type :weekly
    end

    trait :weekdays do
      repeat_type :weekly
      weekdays [1, 2, 3, 4, 5]
    end

    trait :monthly_by_day do
      repeat_type :monthly_by_day
    end

    trait :monthly_by_week do
      repeat_type :monthly_by_week
    end

    trait :yearly_by_date do
      repeat_type :yearly_by_date
    end

    trait :yearly_by_day do
      repeat_type :yearly_by_day
    end

    trait :three_times do
      count 3
    end

    trait :date_limited do
      stops_at { event.starts_at + 1.month }
    end
  end
end

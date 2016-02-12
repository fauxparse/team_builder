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

  factory :member do
    user
    team
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
        [FactoryGirl.build(:recurrence_rule, :weekly, :date_limited)]
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

require 'rails_helper'

describe ScheduleBuilder do
  subject(:builder) { ScheduleBuilder.new(event) }
  let(:event) { FactoryGirl.create(:event) }
  let(:schedule) { builder.schedule }
  let(:occurrences) { schedule.all_occurrences }

  context 'for an event that does not repeat' do
    context 'by default' do
      it 'has one occurrence' do
        expect(occurrences.length).to eq(1)
      end
    end

    context 'explicitly' do
      before do
        FactoryGirl.create(:recurrence_rule, :never_recurs, event: event)
      end

      it 'has one occurrence' do
        expect(occurrences.length).to eq(1)
      end
    end
  end

  context 'for an event that repeats daily' do
    before do
      FactoryGirl.create(:recurrence_rule, :daily, :three_times, event: event)
    end

    it 'happens on three consecutive days' do
      expect(occurrences).to eq (0..2).map { |d| event.starts_at + d.days }
    end
  end

  context 'for an event that repeats on weekdays' do
    before do
      FactoryGirl.create(:recurrence_rule, :weekdays, :three_times, event: event)
    end

    it 'skips the weekend' do
      expect(occurrences).to eq([
        event.starts_at,          # Thursday
        event.starts_at + 1.day,  # Friday
        event.starts_at + 4.days  # Monday
      ])
    end
  end

  context 'for an event that repeats weekly' do
    before do
      FactoryGirl.create(:recurrence_rule, :weekly, :three_times, event: event)
    end

    it 'repeats each week' do
      expect(occurrences).to eq([
        event.starts_at,
        event.starts_at + 1.week,
        event.starts_at + 2.weeks
      ])
    end
  end

  context 'for an event that repeats monthly' do
    before do
      FactoryGirl.create(:recurrence_rule, :monthly_by_day,
        :three_times, event: event)
    end

    it 'repeats each month' do
      expect(occurrences).to eq([
        event.starts_at,
        event.starts_at + 1.month,
        event.starts_at + 2.months
      ])
    end
  end

  context 'for an event that repeats monthly by week' do
    before do
      FactoryGirl.create(:recurrence_rule, :monthly_by_week,
        :three_times, event: event)
    end

    it 'repeats on the third Thursday of each month' do
      expect(occurrences).to eq([
        Time.parse("2015-12-17 00:00:00 +1300"),
        Time.parse("2016-01-21 00:00:00 +1300"),
        Time.parse("2016-02-18 00:00:00 +1300")
      ])
    end
  end

  context 'for an event that repeats yearly by date' do
    before do
      FactoryGirl.create(:recurrence_rule, :yearly_by_date,
        :three_times, event: event)
    end

    it 'repeats annually on the same date' do
      expect(occurrences).to eq([
        event.starts_at,
        event.starts_at + 1.year,
        event.starts_at + 2.years
      ])
    end
  end

  context 'for an event that repeats yearly by day' do
    before do
      FactoryGirl.create(:recurrence_rule, :yearly_by_day,
        :three_times, event: event)
    end

    it 'repeats annually on the same day' do
      expect(occurrences).to eq([
        event.starts_at,
        Time.parse("2016-12-16 00:00:00 +1300"),
        Time.parse("2017-12-17 00:00:00 +1300")
      ])
    end
  end

  describe '#schedule' do
    subject { schedule }

    context 'for an event with no end date and no count' do
      before do
        FactoryGirl.create(:recurrence_rule, :daily, event: event)
      end

      it { is_expected.not_to be_terminating }
    end

    context 'for an event with a set end date' do
      before do
        FactoryGirl.create(:recurrence_rule, :daily, :date_limited,
          event: event)
      end

      it 'has a limited number of occurrences' do
        expect(occurrences.count).to eq(31)
      end
    end
  end
end

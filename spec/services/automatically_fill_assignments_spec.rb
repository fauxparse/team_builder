require 'rails_helper'

describe AutomaticallyFillAssignments do
  subject(:service) { AutomaticallyFillAssignments.new(occurrence) }
  let(:event) { FactoryGirl.create(:event, :weekly, :with_pilots) }
  let(:occurrence) { occurrences.fourth }
  let(:pilot) { event.allocations.first }
  let(:members) { [poe, finn, rey] }

  let(:occurrences) do
    event.occurrences_between(
      event.starts_at,
      event.stops_at
    )
  end

  [:poe, :finn, :rey].each do |name|
    let(name) do
      FactoryGirl.create(:member,
        user: FactoryGirl.create(name),
        team: event.team
      )
    end
  end

  # we don't want any randomness in our specs, thanks
  class Array
    def shuffle
      sort
    end
  end

  def make_available(member)
    occurrence.availabilities.create!(member: member)
  end

  def assign!(member, allocation, occurrence)
    Assignment.create(
      allocation: allocation,
      occurrence: occurrence,
      member: member
    )
  end

  before do
    occurrences.each(&:save!)
  end

  context 'with no availability' do
    it 'does not create any assignments' do
      expect { service.call }
        .not_to change { Assignment.count }
    end
  end

  context 'with availability' do
    let(:available_members) { [finn, poe] }

    before do
      available_members.each { |member| make_available(member) }
    end

    it 'creates two assignments' do
      expect { service.call }
        .to change { Assignment.count }.by(2)
    end

    it 'creates unique assignments' do
      service.call
      expect(occurrence.assignments.map(&:member).uniq)
        .to have_exactly(2).items
    end

    context 'when `save_results` is false' do
      subject(:service) { AutomaticallyFillAssignments.new(occurrence, false) }

      it 'does not create the assignments' do
        expect { service.call }
          .not_to change { Assignment.count }
      end

      it 'builds the assignments on the occurrence' do
        expect { service.call }
          .to change { occurrence.assignments.size }.by(2)
      end
    end

    context 'and previous assignments' do
      let(:available_members) { [finn, poe, rey] }

      before do
        assign!(finn, pilot, occurrences.first)
        assign!(poe, pilot, occurrences.second)
        assign!(finn, pilot, occurrences.third)
      end

      it 'prioritises people who haven’t had a go in a while' do
        service.call
        expect(occurrence.assignments.map(&:member))
          .not_to include(finn)
      end

      context 'and multiple allocations for the same role' do
        before do
          event.allocations.create!(role: pilot.role, maximum: 2)
          service.call
        end

        it 'divides the members up between the allocations' do
          split = occurrence.assignments
            .group_by(&:allocation)
            .map { |key, assignments| [key, assignments.map(&:member)] }

          expect(split).to eq([
            [event.allocations.first, [rey, finn]],
            [event.allocations.second, [poe]]
          ])
        end
      end
    end
  end
end

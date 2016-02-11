require 'rails_helper'

describe PruneEventOccurrences do
  subject(:service) { PruneEventOccurrences.new(event) }
  let(:event) { FactoryGirl.create(:event, :weekly) }

  before do
    event
      .occurrences_between(event.starts_at, event.starts_at + 2.months)
      .map(&:save)
    expect(Occurrence.count).to eq(5)
  end

  context 'when a recurrence rule is destroyed' do
    it 'is called' do
      expect_any_instance_of(PruneEventOccurrences)
        .to receive(:call)
      event.recurrence_rules.first.destroy
    end

    it 'deletes all occurrences except the first' do
      expect { event.recurrence_rules.first.destroy }
        .to change { Occurrence.count }.by(-4)
    end
  end
end

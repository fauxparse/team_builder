require 'rails_helper'

describe RecordAvailability do
  subject(:service) { RecordAvailability.new(member, event, time) }
  let(:event) { FactoryGirl.create(:event) }
  let(:member) { FactoryGirl.create(:member, team: event.team) }
  let(:time) { event.starts_at }

  describe '#call' do
    subject { service.call }

    it 'creates the availability' do
      expect { subject }.to change { Availability.count }.by(1)
    end

    context 'when availability has already been recorded' do
      let(:availability) do
        occurrence.availabilities.build(member: member,
          enthusiasm: :unavailable)
      end
      let(:occurrence) { event.first_occurrence.tap(&:save) }

      before { availability.save! }

      it 'does not create a new availability record' do
        expect { subject }.not_to change { Availability.count }
      end

      it 'updates the current record' do
        expect { subject }
          .to change { availability.reload.enthusiasm }
          .from("unavailable")
          .to("available")
      end
    end

    context 'when the time is not a proper occurrence time' do
      let(:time) { event.starts_at - 1.month }

      it { is_expected.to be false }
    end
  end
end

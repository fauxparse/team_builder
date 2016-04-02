require 'rails_helper'

describe UpdateAvailability do
  subject(:service) { UpdateAvailability.new(occurrence, hash) }
  let(:occurrence) { event.first_occurrence }
  let(:event) { FactoryGirl.create(:event) }
  let(:team) { event.team }
  let(:availability) { occurrence.availabilities }

  %i[poe finn rey].each do |name|
    let(name) do
      FactoryGirl.create(:member,
        user: FactoryGirl.create(name),
        team: team
      )
    end
  end

  let(:hash) { { poe.id => "available" } }

  context 'adding for the first time' do
    it 'adds availability records' do
      expect { service.call }
        .to change { Availability.count }
        .from(0).to(1)
    end

    it 'sets the availability' do
      service.call
      expect(Availability.last).to be_available
    end

    it 'sets the membership' do
      service.call
      expect(Availability.last.member).to eq poe
    end
  end

  context 'updating existing availability' do
    before do
      Availability.create!(
        occurrence: event.first_occurrence,
        member: poe,
        enthusiasm: 'possible'
      )
    end

    it 'does not create a new record' do
      expect { service.call }
        .not_to change { Availability.count }
    end

    it 'updates the existing record' do
      expect { service.call }
        .to change { Availability.last.reload.enthusiasm }
        .from('possible')
        .to('available')
    end

    context 'with a null value' do
      let(:hash) { { poe.id => nil } }

      it 'removes availability records' do
        expect { service.call }
          .to change { Availability.count }
          .from(1).to(0)
      end
    end

    context 'with somebody else' do
      let(:hash) { { poe.id => 'available', finn.id => 'keen' } }

      it 'adds availability records' do
        expect { service.call }
          .to change { Availability.count }
          .from(1).to(2)
      end

      it 'updates Poe’s availability' do
        expect { service.call }
          .to change { availability.find_by(member: poe).enthusiasm }
          .from('possible')
          .to('available')
      end

      it 'adds Finn’s availability' do
        expect { service.call }
          .to change { availability.find_by(member: finn).present? }
          .from(false)
          .to(true)
      end

      it 'sets Finn’s availability correctly' do
        service.call
        expect(availability.find_by(member: finn)).to be_keen
      end
    end
  end
end

require 'rails_helper'

RSpec.describe AddMembers do
  subject(:service) { AddMembers.new(sponsor, team, members) }
  let(:sponsor) { FactoryGirl.create(:member, :admin) }
  let(:team) { sponsor.team }
  let(:members) do
    [
      member("Poe", "poe@resistance.org"),
      member("Finn", "finn@resistance.org"),
      member("Rey", "rey@resistance.org")
    ]
  end

  def member(name, email)
    Struct.new(:name, :email).new(name, email)
  end

  describe '#call' do
    before do
      @succeeded = @failed = nil
      service
        .on(:success) { |members| @succeeded = members }
        .on(:failure) { |members| @failed = members }
    end

    context 'with some members' do
      it 'adds the members' do
        expect { service.call }
          .to change { Member.count }
          .by(3)
      end

      it 'invites the members' do
        expect { service.call }
          .to change { Invitation.count }
          .by(3)
      end

      it 'publishes the new members' do
        service.call
        expect(@succeeded.map(&:display_name))
          .to match_array(%w(Poe Finn Rey))
      end
    end

    context 'with some bad members' do
      let(:members) do
        [member("Kylo", nil)]
      end

      it 'does not add the members' do
        expect { service.call }
          .not_to change { Member.count }
      end

      it 'does not invite the members' do
        expect { service.call }
          .not_to change { Invitation.count }
      end

      it 'publishes the failed members' do
        service.call
        expect(@failed.map(&:display_name))
          .to match_array(%w(Kylo))
      end
    end

    context 'when the invitation fails' do
      before do
        allow_any_instance_of(Invitation)
          .to receive(:save)
          .and_return(false)
      end

      it 'does not add the members' do
        expect { service.call }
          .not_to change { Member.count }
      end

      it 'does not invite the members' do
        expect { service.call }
          .not_to change { Invitation.count }
      end

      it 'publishes the failed members' do
        service.call
        expect(@failed.map(&:display_name))
          .to match_array(%w(Poe Finn Rey))
      end
    end
  end

  context 'when the sponsor is not an admin' do
    before { sponsor.update(admin: false) }

    it 'raises an error' do
      expect { service }
        .to raise_error(ArgumentError)
    end
  end

  context 'when the sponsor belongs to a different team' do
    let(:team) { FactoryGirl.create(:team) }

    it 'raises an error' do
      expect { service }
        .to raise_error(ArgumentError)
    end
  end
end

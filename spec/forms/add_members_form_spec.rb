require 'rails_helper'

RSpec.describe AddMembersForm do
  subject(:form) { AddMembersForm.new(user, team, members: input) }
  let(:user) { sponsor.user }
  let(:sponsor) { FactoryGirl.create(:member) }
  let(:team) { sponsor.team }
  let(:members) { form.members }

  context 'with all valid addresses' do
    let(:input) do
      <<~EOF
        "Chewie" <chewie@resistance.org>
        Finn <finn@resistance.org>
        rey@resistance.org
      EOF
    end

    it 'parses names correctly' do
      expect(members.map(&:display_name))
        .to eq %w(Chewie Finn Rey)
    end

    it 'parses email addresses correctly' do
      expect(members.map(&:email))
        .to eq [
          "chewie@resistance.org",
          "finn@resistance.org",
          "rey@resistance.org"
        ]
    end

    describe '#process' do
      before { form }

      it 'saves the members' do
        form.process
        expect(form.members.all?(&:persisted?))
          .to be true
      end

      it 'creates the members' do
        expect { form.process }.to change { Member.count }.by(3)
      end

      it 'invites the members' do
        expect { form.process }.to change { Invitation.count }.by(3)
      end
    end
  end

  context 'with some invalid addresses' do
    let(:input) do
      <<~EOF
        Chewie chewie@resistance.org
        Finn
        rey@resistance.org
      EOF
    end

    it 'parses names correctly' do
      expect(members.map(&:display_name))
        .to eq %w(Chewie Finn Rey)
    end

    it 'parses email addresses correctly' do
      expect(members.map(&:email))
        .to eq [
          "chewie@resistance.org",
          "Finn",
          "rey@resistance.org"
        ]
    end

    describe '#process' do
      before { form }

      it 'validates the members' do
        form.process
        expect(form.members.map(&:valid?))
          .to eq [true, false, true]
      end

      it 'creates the members' do
        expect { form.process }.to change { Member.count }.by(2)
      end

      it 'invites the members' do
        expect { form.process }.to change { Invitation.count }.by(2)
      end
    end
  end

  context 'with failing invitations' do
    let(:input) do
      <<~EOF
        Chewie <chewie@resistance.org>
      EOF
    end

    before do
      allow_any_instance_of(Invitation)
        .to receive(:save)
        .and_return(false)
    end

    describe '#process' do
      before { form }

      it 'validates the members' do
        form.process
        expect(form.members.map(&:valid?))
          .to eq [true]
      end

      it 'destroys the failed members' do
        expect { form.process }.not_to change { Member.count }
      end

      it 'does not invite the members' do
        expect { form.process }.not_to change { Invitation.count }
      end
    end
  end
end

require 'rails_helper'

describe ApplicationController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:logged_in_user) { member.user }

  login

  describe '#current_member' do
    context 'when there is no membership in context' do
      it 'returns the first membership by default' do
        expect(subject.send(:current_member))
          .to eq member
      end
    end

    context 'when a team has been selected' do
      let(:another) { FactoryGirl.create(:member, user: member.user) }

      before do
        @request.cookies[:team_id] = another.team_id
      end

      it 'selects the correct membership' do
        expect(subject.send(:current_member))
          .to eq another
      end
    end
  end

  describe '#current_team' do
    it 'selects the correct team' do
      expect(subject.send(:current_team))
        .to eq member.team
    end

    context 'when a team has been selected' do
      let(:another) { FactoryGirl.create(:member, user: member.user) }

      before do
        @request.cookies[:team_id] = another.team_id
      end

      it 'selects the correct membership' do
        expect(subject.send(:current_team))
          .to eq another.team
      end
    end
  end
end

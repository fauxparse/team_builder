require 'rails_helper'

RSpec.describe InvitationsController, type: :controller do
  let(:member) { FactoryGirl.create(:member) }
  let(:team) { member.team }
  let(:logged_in_user) { member.user }
  let(:sponsor) { FactoryGirl.create(:member, :admin, team: team) }
  let(:newbie) { FactoryGirl.create(:newbie) }
  let(:invitation) { Invitation.create(member: member, sponsor: sponsor) }
  let(:expected_json) do
    {
      "code" => invitation.code,
      "status" => expected_status,
      "member" => {
        "id" => member.id,
        "name" => member.display_name,
        "email" => member.email,
        "admin" => false,
        "avatar" => "https://placeimg.com/200/200/animals"
      }
    }
  end
  let(:expected_status) { "pending" }
  let(:json) { ActiveSupport::JSON.decode(response.body) }

  login

  describe 'GET /invitations/:id' do
    context 'as JSON' do
      let(:request) { get :show, params: { format: :json, id: invitation.code } }

      it 'is successful' do
        request
        expect(response).to be_success
      end

      it 'renders the invitation as JSON' do
        request
        expect(json).to eq(expected_json)
      end
    end
  end

  describe 'POST /invitations/:id/accept' do
    context 'as JSON' do
      let(:request) { post :accept, params: { format: :json, id: invitation.code } }
      let(:expected_status) { "accepted" }

      it 'is successful' do
        request
        expect(response).to be_success
      end

      it 'renders the invitation as JSON' do
        request
        expect(json).to eq(expected_json)
      end

      it 'accepts the invitation' do
        expect { request }
          .to change { invitation.reload.status }
          .from("pending")
          .to("accepted")
      end
    end

    context 'as HTML' do
      let(:request) { post :accept, params: { id: invitation.code } }

      it 'redirects to the team page' do
        request
        expect(response).to redirect_to(team)
      end

      it 'accepts the invitation' do
        expect { request }
          .to change { invitation.reload.status }
          .from("pending")
          .to("accepted")
      end

      context 'when the invitation fails' do
        before do
          expect_any_instance_of(Invitation)
            .to receive(:update!)
            .with(status: :accepted)
            .and_raise(ActiveRecord::RecordInvalid)
        end

        it 'renders with an error' do
          request
          expect(response).to have_http_status(:not_acceptable)
        end

        it 'does not change the status of the request' do
          expect { request }
            .not_to change { invitation.reload.status }
        end
      end

      context 'when the invitation is not pending' do
        before do
          invitation.update(status: :declined)
        end

        it 'raises an error' do
          expect { request }
            .to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'POST /invitations/:id/decline' do
    context 'as JSON' do
      let(:request) { post :decline, params: { format: :json, id: invitation.code } }
      let(:expected_status) { "declined" }

      it 'is successful' do
        request
        expect(response).to be_success
      end

      it 'renders the invitation as JSON' do
        request
        expect(json).to eq(expected_json)
      end

      it 'accepts the invitation' do
        expect { request }
          .to change { invitation.reload.status }
          .from("pending")
          .to("declined")
      end
    end
  end
end

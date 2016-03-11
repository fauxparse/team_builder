class InvitationsController < ApplicationController
  respond_to :html, :json

  def show
    respond_with invitation
  end

  def accept
    process_invitation(AcceptInvitation, invitation.team)
  end

  def decline
    process_invitation(DeclineInvitation, root_path)
  end

  private

  def invitation
    @invitation ||= Invitation.pending.find_by!(code: params[:id])
  end

  def process_invitation(service_class, redirect_on_success)
    respond_to do |format|
      service = service_class.new(invitation, current_user)

      format.html do
        service
          .on(:success) { redirect_to redirect_on_success }
          .on(:failure) { render :show, status: :not_acceptable }
          .call
      end

      format.json do
        service
          .on(:success, :failure) { respond_with invitation }
          .call
      end
    end
  end
end

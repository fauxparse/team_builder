class TeamsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: current_user.teams }
    end
  end

  def show
  end
end

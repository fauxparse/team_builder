class CreateTeam
  include Shout

  def initialize(user, attributes)
    @user = user
    @attributes = attributes
  end

  def call
    Team.transaction do
      begin
        @team = Team.new(@attributes)
        @team.save!
        JoinTeam.new(@user, @team, true).call
        publish!(:success, @team)
      rescue
        publish!(:failure, @team)
      end
    end
  end
end

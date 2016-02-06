class CreateTeam
  attr_reader :user, :attributes, :team

  def initialize(user, attributes)
    @user = user
    @attributes = attributes
  end

  def call
    Team.transaction do
      @team = Team.create!(attributes)
      JoinTeam.new(user, @team, true).call
    end
  end
end

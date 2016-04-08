class EventForm
  include Shout

  attr_reader :event

  delegate :name=, :slug=, :starts_at=, :duration=, :valid?, to: :event
  delegate :repeat_type=, to: :recurrence_rule

  def initialize(event, params = {})
    @event = event
    @params = sanitize(params)
    process
  end

  def save
    if event.save
      publish!(:success)
    else
      publish!(:failure)
    end
  end

  def as_json
    ActiveModel::SerializableResource.new(event)
      .as_json
      .merge(errors: errors)
  end

  def recurrence_rule
    @recurrence_rule ||=
      @event.recurrence_rules.first ||
      @event.recurrence_rules.build
  end

  private

  def process
    @params.each_pair do |key, value|
      send :"#{key}=", value
    end
  end

  def sanitize(params)
    params
      .require(:event)
      .permit(:name, :slug, :starts_at, :duration, :repeat_type)
  end

  def errors
    messages = [event, recurrence_rule].flat_map do |record|
      record.errors.map do |attr, _|
        [attr, record.errors.full_messages_for(attr)]
      end

    end
    Hash[messages]
  end
end

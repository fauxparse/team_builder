class EventForm
  include Shout
  extend ActiveModel::Naming

  attr_reader :event, :errors

  delegate :name, :slug, :starts_at, :duration, :valid?, to: :event
  delegate :repeat_type, to: :recurrence_rule
  delegate :name=, :slug=, :starts_at=, :duration=, to: :event
  delegate :repeat_type=, to: :recurrence_rule

  def initialize(event, params = {})
    @event = event
    @params = sanitize(params)
    @errors = ActiveModel::Errors.new(self)
    process
  end

  def save
    if errors.empty? && event.save
      publish!(:success)
    else
      [event, recurrence_rule].each do |record|
        record.errors.each do |key, message|
          errors.add(key, message)
        end unless record.valid?
      end
      publish!(:failure)
    end
  end

  def as_json
    ActiveModel::SerializableResource.new(event)
      .as_json
      .merge(errors: error_messages)
  end

  def recurrence_rule
    @recurrence_rule ||=
      event.recurrence_rules.first ||
      event.recurrence_rules.build
  end

  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, options = {})
    if Event.column_names.include?(attr.to_s)
      Event.human_attribute_name(attr, options)
    else
      Event::RecurrenceRule.human_attribute_name(attr, options)
    end
  end

  private

  def process
    @params.each_pair do |key, value|
      begin
        send :"#{key}=", value
      rescue ArgumentError => e
        errors.add(key, :invalid)
      end
    end
  end

  def sanitize(params)
    params
      .require(:event)
      .permit(:name, :slug, :starts_at, :duration, :repeat_type)
  end

  def error_messages
    messages = errors.map do |attr, _|
      [attr, errors.full_messages_for(attr)]
    end
    Hash[messages]
  end
end

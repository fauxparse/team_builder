module Shout
  NoListenersError = Class.new(StandardError)

  def on(*events, &block)
    events.each do |event|
      shout_listeners_for(event) << block
    end

    self
  end

  protected

  def shout_listeners
    @shout_listeners ||= {}
  end
  
  def shout_listeners_for(event)
    shout_listeners[event] ||= []
  end

  def publish(event, *args)
    shout_listeners_for(event).each do |listener|
      listener.try!(:call, *args)
    end
  end

  def publish!(event, *args)
    raise NoListenersError, "No listeners for event #{event}" \
      if shout_listeners_for(event).empty?

    publish(event, *args)
  end
end


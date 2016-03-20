module Defaults
  extend ActiveSupport::Concern

  included do
    after_initialize :apply_default_values
  end

  def apply_default_values
    self.class.defaults.each do |attribute, value|
      next unless self.send(attribute).nil?
      self[attribute] = value.respond_to?(:call) ? value.call(self) : value.dup
    end
  end

  class_methods do
    def default(attribute, value = nil, &block)
      defaults[attribute] = block_given? ? block : value
    end

    def defaults
      @defaults ||= {}
    end
  end
end

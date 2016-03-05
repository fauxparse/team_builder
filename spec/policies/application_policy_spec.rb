require 'rails_helper'

describe ApplicationPolicy do
  subject { described_class }

  class Thing < Struct.new(:id)
    def exists?
      true
    end

    def self.where(conditions = {})
      new(id: conditions[:id] || 42)
    end
  end

  class ThingPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
    end
  end

  let(:user) { FactoryGirl.create(:user) }
  let(:record) { Thing.new(42) }

  permissions :index? do
    it { is_expected.to permit(user, record) }
  end

  permissions :show? do
    it { is_expected.to permit(user, record) }
  end

  permissions :new?, :create?, :edit?, :update?, :destroy? do
    it { is_expected.not_to permit(user, record) }
  end
end

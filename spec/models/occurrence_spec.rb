require 'rails_helper'

RSpec.describe Occurrence, type: :model do
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_uniqueness_of(:starts_at).scoped_to(:event_id) }

  describe '#first?' do
    subject { event.first_occurrence.first? }

    context 'for a non-repeating event’s first occurrence' do
      let(:event) { FactoryGirl.create(:event) }

      it { is_expected.to be true }
    end

    context 'for a repeating event’s first occurrence' do
      let(:event) { FactoryGirl.create(:event, :weekly) }

      it { is_expected.to be true }
    end
  end

  describe '#last?' do
    subject { event.first_occurrence.last? }

    context 'for a non-repeating event’s first occurrence' do
      let(:event) { FactoryGirl.create(:event) }

      it { is_expected.to be true }
    end

    context 'for a repeating event’s first occurrence' do
      let(:event) { FactoryGirl.create(:event, :weekly) }

      it { is_expected.to be false }
    end
  end

  describe '#next_starts_at' do
    subject { event.first_occurrence.next_starts_at }

    context 'for a non-repeating event’s first occurrence' do
      let(:event) { FactoryGirl.create(:event) }

      it { is_expected.to be_nil }
    end

    context 'for a repeating event’s first occurrence' do
      let(:event) { FactoryGirl.create(:event, :weekly) }

      it { is_expected.to eq(event.starts_at + 1.week) }
    end
  end
end

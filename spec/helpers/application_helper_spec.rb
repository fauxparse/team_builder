require 'rails_helper'

describe ApplicationHelper do
  describe '#serialize' do
    subject(:serialize) { helper.serialize(member) }
    let(:member) { FactoryGirl.create(:member) }
    let(:json) do
      {
        id: member.id,
        admin: false,
        email: member.email,
        name: member.display_name
      }
    end

    it 'uses ActiveModel::Serializers' do
      expect(ActiveModel::Serializer)
        .to receive(:serializer_for)
        .with(member)
        .and_return(MemberSerializer)
      serialize
    end

    it { is_expected.to be_an_instance_of(Hash) }
    it { is_expected.to eq(json) }
  end
end

require 'rails_helper'

describe ApplicationHelper do
  describe '#serialize' do
    subject(:serialize) { helper.serialize(member) }
    let(:member) { FactoryGirl.create(:member) }
    let(:json) { { id: member.id, admin: false, name: member.display_name } }

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

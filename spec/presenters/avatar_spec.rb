require 'rails_helper'

describe Avatar do
  subject(:avatar) { Avatar.new(member) }
  let(:member) { instance_double("Member") }

  context 'when the member is not attached to a user' do
    before do
      expect(member).to receive(:email).and_return("test@example.com")
      expect(member).to receive(:user).and_return(nil)
    end

    describe '#url' do
      subject { avatar.url }

      it { is_expected.to eq("http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=128") }
    end
  end

  context 'when the member is attached to a user' do
    let(:user) { instance_double("User") }

    before do
      expect(member).to receive(:user).and_return(user)
    end

    context 'without a custom avatar' do
      describe '#url' do
        subject { avatar.url }

        before do
          expect(member).to receive(:email).and_return("test@example.com")
          expect(user).to receive(:avatar_url).and_return(nil)
        end

        it { is_expected.to eq("http://www.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=128") }
      end
    end

    context 'with a custom avatar' do
      describe '#url' do
        subject { avatar.url }

        before do
          expect(user).to receive(:avatar_url)
            .and_return("https://placeimg.com/200/200/animals")
        end

        it { is_expected.to eq("https://placeimg.com/200/200/animals") }
      end
    end
  end
end

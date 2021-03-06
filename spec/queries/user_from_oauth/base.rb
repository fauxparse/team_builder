require 'rails_helper'

describe UserFromOauth::Base do
  subject(:query) { UserFromOauth::Base.new(auth) }
  let(:provider) { :google }
  let(:uid) { '0123456789ABCDEF'}
  let(:user_attributes) { FactoryGirl.attributes_for(:poe) }
  let(:name) { user_attributes[:name] }
  let(:email) { user_attributes[:email] }
  let(:password) { user_attributes[:password] }
  let(:auth) { Struct.new(:provider, :uid, :info).new(provider, uid, info) }
  let(:info) { Struct.new(:name, :email).new(name, email) }
  let(:user) { FactoryGirl.build(:poe) }

  context 'without an existing user' do
    it 'creates a user' do
      expect { query.user }.to change { User.count }.by(1)
    end

    it 'creates an identity' do
      expect { query.user }.to change { Identity.count }.by(1)
    end
  end

  context 'with an existing user' do
    before do
      user.save!
    end

    it 'does not create a user' do
      expect { query.user }.not_to change { User.count }
    end

    it 'creates an identity' do
      expect { query.user }.to change { Identity.count }.by(1)
    end

    it 'returns the existing user' do
      expect(query.user).to eq(user)
    end

    context 'with an existing identity' do
      before do
        user.identities.create!(provider: provider, uid: uid)
      end

      it 'does not create an identity' do
        expect { query.user }.not_to change { Identity.count }
      end

      it 'returns the existing identity' do
        expect(query.identity).to eq(user.identities.first)
      end
    end
  end
end

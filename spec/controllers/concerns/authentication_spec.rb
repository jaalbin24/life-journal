require 'rails_helper'


RSpec.describe Authentication, type: :controller do
  # ================ Define an anonymous controller ================
  controller ApplicationController do
    before_action :redirect_unauthenticated
    include Authentication
    def test; render plain: "test"; end
  end

  # ========== Define routes for the anonymous controller ==========
  before do
    routes.draw {
      get 'test' => 'anonymous#test'
    }
  end

  let(:user) { create(:user) } # Define the user fixture
  before { sign_out } # Make sure each test starts with no user signed in

  describe '#sign_in' do
    context 'with valid credentials' do
      it 'signs in the user' do
        expect(controller.sign_in(email: user.email, password: user.password)).to be_truthy
        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'with invalid credentials' do
      it 'does not sign in the user' do
        expect(controller.sign_in(email: user.email, password: 'wrongpassword')).to be_falsey
        expect(session[:user_id]).to be_nil
      end
    end
  end

  describe '#sign_out' do
    it 'resets the session' do
      session[:user_id] = user.id
      controller.sign_out
      expect(session[:user_id]).to be_nil
    end
  end

  describe '#current_user' do
    context 'when user is signed in' do
      before { sign_in user }
      it 'returns the current user' do
        expect(controller.send(:current_user)).to eq(user)
      end
    end

    context 'when user is not signed in' do
      it 'returns nil' do
        expect(controller.send(:current_user)).to be_nil
      end
    end
  end

  describe '#user_signed_in?' do
    context 'when user is signed in' do
      before { sign_in user }
      it 'returns true' do
        expect(controller.send(:user_signed_in?)).to be_truthy
      end
    end

    context 'when user is not signed in' do
      it 'returns false' do
        session[:user_id] = nil
        expect(controller.send(:user_signed_in?)).to be_falsey
      end
    end
  end

  describe '#redirect_unauthenticated' do
    context "when the user is signed in" do
      before { sign_in user }
      before { get :test }
      it "does nothing" do
        expect(controller).not_to receive(:redirect_to)
        controller.send(:redirect_unauthenticated)
      end
    end

    context "when the user is not signed in" do
      before { get :test }
      it "redirects to the sign in page" do
        expect(controller).to receive(:redirect_to).with(controller.send(:sign_in_path))
        controller.send(:redirect_unauthenticated)
      end

      it "redirects to the sign in page and sets the after_sign_in_path cookie" do
        expect(response).to redirect_to(sign_in_path)
        expect(response.cookies['after_sign_in_path']).to eq('/test')
      end
    end
  end
end

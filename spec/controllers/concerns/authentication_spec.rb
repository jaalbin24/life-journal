require 'rails_helper'


RSpec.describe Authentication, type: :controller do
  # ================ Define an anonymous controller ================
  controller ApplicationController do
    before_action :redirect_unauthenticated, only: :auth_required
    include Authentication
    def auth_required; render plain: "test"; end
    def no_auth_required; render plain: "test"; end
  end

  # ========== Define routes for the anonymous controller ==========
  before do
    routes.draw do
      get 'auth_required' => 'anonymous#auth_required'
      get 'no_auth_required' => 'anonymous#no_auth_required'
    end
  end

  let(:user) { create(:user) } # Define the user fixture
  before { sign_out } # Make sure each test starts with no user signed in

  describe "#sign_in" do
    it "saves the user id in the session cookie" do
      controller.sign_in(user)
      expect(session[:user_id]).to eq user.id
    end
    it "returns the user" do
      expect(controller.sign_in(user)).to eq user
    end
    context "with remember me set to true" do
      it "rolls the user's remember me token" do
        expect(user).to receive :roll_remember_me_token
        controller.sign_in(user, remember_me: true)
      end
      it "saves the new remember me token in a signed cookie" do
        controller.sign_in(user, remember_me: true)
        get :no_auth_required
        expect(cookies.signed[:remember_me]).to eq user.remember_me_token
      end
    end
    context "with remember me set to false" do
      it "does not roll the user's remember me token" do
        expect(user).to_not receive :roll_remember_me_token
        controller.sign_in(user, remember_me: false)
      end
      it "does not save the new remember me token in a cookie" do
        controller.sign_in(user, remember_me: false)
        get :no_auth_required
        expect(cookies.signed[:remember_me]).to_not eq user.remember_me_token
      end
    end
  end
  describe "#sign_out" do
    it "resets the session" do
      session[:user_id] = user.id
      controller.sign_out
      expect(session[:user_id]).to be_nil
    end
  end
  describe "#current_user" do
    it "calls set_current_user if Current.user is nil" do
      Current.user = nil
      expect(controller).to receive :set_current_user
      controller.send(:current_user)
    end
    it "returns Current.user" do
      Current.user = user
      expect(controller.send(:current_user)).to eq user
    end
  end
  describe "#set_current_user" do
    let(:remember_me_cookie) { { value: user.remember_me_token, expires: user.remember_me_token_expires_at, http_only: true, secure: Rails.env.production? } }
    context "the session has a user id" do
      before { sign_in user }
      it "returns the user with that id" do
        expect(controller.send(:set_current_user)).to eq(user)
      end
      context "there is a remember_me_token cookie" do
        before { cookies.signed[:remember_me] = remember_me_cookie }
        it "does not query the database for a user with a remember me token" do
          expect { controller.send(:set_current_user) }.to_not make_database_queries(matching: /remember_me_token/)
        end
        it "queries the database only once" do
          expect { controller.send(:set_current_user) }.to make_database_queries(count: 1)
        end
      end
      context "there is no remember_me_token cookie" do
        it "does not query the database for a user with a remember_me_token" do
          expect { controller.send(:set_current_user) }.to_not make_database_queries(matching: /remember_me_token/)
        end
        it "queries the database only once" do
          expect { controller.send(:set_current_user) }.to make_database_queries(count: 1)
        end
      end
    end
    context "the session does not have a user id" do
      # Simulate no user id in the session
      before do
        allow(controller.send(:session)).to receive(:[]) # Default stub
        allow(controller.send(:session)).to receive(:[]).with(:user_id).and_return(nil)
      end
      context "there is a remember me token cookie" do
        before { cookies.signed[:remember_me] = remember_me_cookie }
        it "queries the database for the expiration date of the remember me token" do
          expect { get :auth_required }.to make_database_queries(matching: /remember_me_token/)
        end
        context "the cookie is expired" do
          # Simulate an expired cookie
          before { user.update!(remember_me_token_expires_at: 1.week.ago) }
          it "returns nil" do
            get :auth_required
            expect(controller.send(:set_current_user)).to be_nil
          end
        end
        context "the cookie is not expired" do
          # Simulate a non-expired cookie
          before { user.update!(remember_me_token_expires_at: 1.week.from_now) }
          it "queries the database for a user with the remember me token" do
            get :auth_required
            expect(controller.send(:set_current_user)).to eq user
          end
          it "queries the database only once" do
            expect { get :auth_required }.to make_database_queries(count: 1)
          end
        end
      end
    end
  end
  describe "#user_signed_in?" do
    context "when user is signed in" do
      before { sign_in user }
      it "returns true" do
        expect(controller.send(:user_signed_in?)).to be_truthy
      end
    end

    context "when user is not signed in" do
      it "returns false" do
        session[:user_id] = nil
        expect(controller.send(:user_signed_in?)).to be_falsey
      end
    end
  end
  describe "#redirect_unauthenticated" do
    context "when the user is signed in" do
      before { sign_in user }
      it "does nothing" do
        expect(controller).not_to receive(:redirect_to)
        controller.send(:redirect_unauthenticated)
      end
    end

    context "when the user is not signed in" do
      it "redirects to the sign in page" do
        expect(controller).to receive(:redirect_to).with(controller.send(:sign_in_path))
        controller.send(:redirect_unauthenticated)
      end

      it "redirects to the sign in page and sets the after_sign_in_path cookie" do
        get :auth_required
        expect(response).to redirect_to(sign_in_path)
        expect(response.cookies["after_sign_in_path"]).to eq(request.path)
      end
    end
  end
end

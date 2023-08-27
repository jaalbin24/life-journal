require "rails_helper"


RSpec.shared_examples Authentication do |controller_class|
  let(:user) { create :user }
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
      it "saves the new remember me token in a signed, HTTP only cookie set to expire in two weeks" do
        controller.sign_in(user, remember_me: true)
        expect(cookies.signed[:remember_me]).to eq user.remember_me_token
        expect() # Expect cookie to have an expiration date 2 weeks from now
        expect(response.headers['Set-Cookie']).to include('HttpOnly')
      end
    end
    context "with remember me set to false" do
      
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
      pending
      fail
    end
    it "returns Current.user" do
      pending
      fail
    end
  end
  describe "#set_current_user" do
    context "the session has a user id" do
      before { sign_in user }
      it "returns the user with that id" do
        expect(controller.send(:current_user)).to eq(user)
      end
      context "there is a remember_me_token cookie" do
        it "does not query the database for a user with a remember_me_token" do
          pending
          fail
        end
        it "queries the database only once" do
          pending
          fail
        end
      end
      context "there is no remember_me_token cookie" do
        it "does not query the database for a user with a remember_me_token" do
          pending
          fail
        end
        it "queries the database only once" do
          pending
          fail
        end
      end
    end
    context "the session does not have a user id" do
      context "there is a remember_me_token cookie" do
        it "queries the database for the expiration date of the remember me token" do
          pending
          fail
        end
        context "the cookie is expired" do
          # It is assumed that if the server receives a remember_me_token that has expired, the expiration date was maliciously modified.
          # Modern browsers will not send expired cookies automatically. Therefore, the token should be rolled.
          it "calls #roll_remember_me_token" do 
            pending
            fail
          end
          it "returns nil" do
            expect(controller.send(:current_user)).to be_nil
          end
        end
        context "the cookie is not expired" do
          it "queries the database for a user with the remember me token" do
            pending
            fail
          end
          it "queries the database only once" do
            pending
            fail
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
        get controller_class.action_methods.first
        expect(response).to redirect_to(sign_in_path)
        expect(response.cookies["after_sign_in_path"]).to eq(request.path)
      end
    end
  end
end

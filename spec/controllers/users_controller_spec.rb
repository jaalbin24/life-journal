require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  it "has no unexpected actions" do
    pending
    fail
  end
  
  describe "actions" do
    before do
      @user = create :user
      sign_in @user
    end

    describe 'GET #index' do
      it 'does not do anything' do
        pending
        fail
      end
    end

    describe 'GET #show' do
      before {get :show, params: {id: @user.id}}
      it 'renders the show view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
      it "assigns the current user to @user" do
        pending; fail
      end
      it "requires authentication" do
        pending; fail
      end
      it 'returns a 200 code' do
        pending; fail
      end
    end

    describe 'GET #new' do
      before {get :new}
      it 'renders the new view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
      it 'builds the view using a non-saved user' do
        expect(assigns(:user).persisted?).to be false
      end
      it "does not require authentication" do
        pending; fail
      end
      it 'returns a 200 code' do
        pending; fail
      end
    end

    describe 'GET #edit' do
      # before {get :edit}
      it 'renders the edit view' do
        pending; fail
      end
      it 'builds the view using the current user' do
        pending; fail
      end
      it "requires authentication" do
        pending; fail
      end
      it 'returns a 200 code' do
        pending; fail
      end
    end

    describe 'PUT #update' do
      # before {get :edit}
      context "with valid parameters" do
        it "will update the user record" do
          pending; fail
        end
        it "will redirect to the user show page" do
          pending; fail
        end
        it 'returns a 303 code' do
          pending; fail
        end
      end
      context "with invalid parameters" do
        it "will not update the user record" do
          pending; fail
        end
        it "will render the edit view" do
          pending; fail
        end
        it 'returns a 422 code' do
          pending; fail
        end
      end
      it "assigns the requested user as @user" do
        pending; fail
      end
      it "requires authentication" do
        pending; fail
      end
    end

    describe 'POST #create' do
      # before {post :create}
      context "with valid parameters" do
        it 'creates a new user' do
          pending; fail
        end
        it 'redirects to the after sign up path' do
          pending; fail
        end
        it 'returns a 303 code' do
          pending; fail
        end
      end
      context "with invalid parameters" do
        it 'does not create a new user' do
          pending; fail
        end
        it 'renders the new view' do
          pending; fail
        end
        it 'returns a 422 code' do
          pending; fail
        end
      end
      it "does not require authentication" do
        pending; fail
      end
    end
  end
  
  describe "methods" do
    describe "#after_sign_up_path" do
      it "is private" do
        pending; fail
      end
      it "returns the root path" do # For now
        pending; fail
      end
    end
    describe "#user_params" do
      it "is private" do
        pending; fail
      end
      it "whitelists the expected params" do
        pending; fail
      end
    end
  end
end
  
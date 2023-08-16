require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  it "has no unexpected actions" do
    pending
    fail
  end

  describe 'GET #index' do
    it 'does not do anything' do
      pending
      fail
    end
  end

  context "when the user is signed in" do
    before do
      @user = create :user
      create_list :entry, 3, :published, user: @user
      create_list :entry, 3, :draft, user: @user
      create_list :entry, 3, :deleted, user: @user
      sign_in @user
    end
    
    describe 'GET #show' do
      before {get :show, params: {id: @user.id}}
      it 'renders the show view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
      it "assigns the current user to @user" do

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
    end

    describe 'GET #edit' do
      before {get :edit}
      it 'renders the edit view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
      it 'builds the view using the current user' do
        pending
        fail
      end
    end

    describe 'PUT #update' do
      before {get :edit}
      context "with valid parameters" do

      end
      context "with invalid parameters" do

      end
      it 'updates the user' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
      it 'builds the view using the current user' do
        pending
        fail
      end
    end

    describe 'POST #create' do
      # before {post :create}
      it 'creates a new user' do
        # expect(response).to change(Entry, :count).by(1)
        pending; fail
      end
    end
  end
  # Add more test cases for other controller actions as needed
end
  
require 'rails_helper'

RSpec.describe EntriesController, type: :controller do
  context "when the user is signed in" do
    before do
      user = create :user
      create_list :entry, 3, :published, author: user
      create_list :entry, 3, :draft, author: user
      create_list :entry, 3, :deleted, author: user
      sign_in user
    end
    
    describe 'GET #index' do
      before {get :index}
      it 'renders the index view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
      it 'shows published entries' do
        expect(assigns(:entries).count).to eq assigns(:entries).published.count
      end
      it 'does not show deleted entries' do
        expect(assigns(:entries).deleted.count).to eq 0
      end
      it 'does not show draft entries' do
        expect(assigns(:entries).drafts.count).to eq 0
      end
      it 'does not show empty entries' do
        expect(assigns(:entries).empty.count).to eq 0
      end
    end

    describe 'GET #drafts' do
      before {get :drafts}
      it 'renders the index view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
      it 'does not show published entries' do
        expect(assigns(:entries).published.count).to eq 0
      end
      it 'does not show deleted entries' do
        expect(assigns(:entries).deleted.count).to eq 0
      end
      it 'shows draft entries' do
        expect(assigns(:entries).drafts.count).to eq assigns(:entries).count
      end
      it 'does not show empty entries' do
        expect(assigns(:entries).empty.count).to eq 0
      end
    end

    describe 'GET #deleted' do
      before {get :deleted}
      it 'renders the index view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
      it 'only shows deleted entries' do
        expect(assigns(:entries).deleted.count).to eq assigns(:entries).count
        expect(assigns(:entries).not_deleted.count).to eq 0
      end
    end

    describe 'POST #create' do
      it 'creates a new entry' do
        expect {
          post :create, params: { entry: { title: 'Test Entry', content: 'This is a test entry.' } }
        }.to change(Entry, :count).by(1)
      end
    end
  end
  # Add more test cases for other controller actions as needed
end
  
require 'rails_helper'

RSpec.describe EntriesController, type: :controller do

  let(:user)                    { create :user }
  let(:valid_params)            { { content: 'Test content', title: 'Test Title' } }
  let(:invalid_params)          { { } }
  let(:send_edit_request)       { get :edit, params: { id: user.entries.sample.id } }
  let(:send_update_request)     { put :update, params: { id: user.entries.sample.id, entry: valid_params } }
  let(:send_new_request)        { get :new }
  let(:send_show_request)       { get :show, params: { id: user.entries.sample.id } }
  let(:send_index_request)      { get :index }
  let(:send_drafts_request)     { get :index, params: { status: "drafts" } }
  let(:send_published_request)  { get :published }

  it 'has no unexpected actions' do
    pending
    fail
  end

  it "implements the Authentication concern" do
    expect(EntriesController.ancestors).to include Authentication
  end

  before do
    sign_in user
    create :user
    User.all.each do |u|
      create_list :entry, 3, :published,  user: u
      create_list :entry, 2, :draft,      user: u
      create_list :entry, 1, :deleted,    user: u
    end
  end

  describe 'actions' do
    describe 'GET #index' do
      it "requires authentication" do
        sign_out
        send_index_request
        expect(response).to redirect_to(sign_in_path)
      end
      context "with draft as the status param" do
        before { send_drafts_request }
        it 'renders the index view' do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
        end
        it 'shows draft entries' do
          expect(assigns(:entries).count).to eq assigns(:entries).drafts.count
        end
        it 'does not show deleted entries' do
          expect(assigns(:entries).deleted.count).to eq 0
        end
        it 'does not show published entries' do
          expect(assigns(:entries).published.count).to eq 0
        end
        it 'does not show empty entries' do
          expect(assigns(:entries).empty.count).to eq 0
        end
        it 'only shows entries that belong to the current user' do
          expect(assigns(:entries)).to eq user.entries.not_deleted.drafts.not_empty.order(updated_at: :desc)
        end
      end
      context "with anything else as the status param" do
        before { get :index, params: { status: "yeet" } }
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
        it 'only shows entries that belong to the current user' do
          expect(assigns(:entries)).to eq user.entries.not_deleted.published.order(published_at: :desc)
        end
      end
    end
    describe 'GET #drafts' do
      before { send_drafts_request }
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
      it 'only shows entries that belong to the current user' do
        pending
        fail
      end
      it 'requires authentication' do
        pending
        fail
      end
    end
    # describe 'GET #deleted' do
    #   before { get :deleted }
    #   it 'renders the index view' do
    #     expect(response).to have_http_status(:success)
    #     expect(response).to render_template(:index)
    #   end
    #   it 'only shows deleted entries' do
    #     expect(assigns(:entries).deleted.count).to eq assigns(:entries).count
    #     expect(assigns(:entries).not_deleted.count).to eq 0
    #   end
    #   it 'only shows entries that belong to the current user' do
    #     pending
    #     fail
    #   end
    #   it 'requires authentication' do
    #     pending
    #     fail
    #   end
    # end
    describe 'GET #show' do
      before { send_show_request }
      it 'renders the show view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
      it 'only shows an entry if it belongs to the current user' do
        get :show, params: { id: Entry.where.not(id: user.entries.pluck(:id)).sample.id }
        expect(response)
      end
      it 'requires authentication' do
        pending
        fail
      end
    end
    describe 'GET #edit' do
      it 'renders the edit view' do
        send_edit_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
      it 'only edits an entry if it belongs to the current user' do
        pending
        fail
      end
      it 'requires authentication' do
        sign_out
        send_edit_request
        expect(response).to redirect_to(sign_in_path)
      end
    end
    describe 'PUT #update' do
      context 'with valid parameters' do
        before { send_update_request }
        it 'updates the entry' do
          pending
          fail
        end
        it 'redirects to the entry show page' do
          pending
          fail
        end
        it 'returns a 303 code' do
          pending
          fail
        end
      end
      context 'with invalid parameters' do
        # before {put :update, params: {id: user.entries.sample.id, entry: nil}}
        it 'does not update the entry' do
          pending "The entry model has no validations. Invalid parameters are currently not possible."
          fail
        end
        it 'renders the edit view' do
          pending "The entry model has no validations. Invalid parameters are currently not possible."
          fail
        end
        it 'returns a 422 code' do
          pending "The entry model has no validations. Invalid parameters are currently not possible."
          fail
        end
      end
      it 'only updates an entry if it belongs to the current user' do
        pending
          fail
      end
      it 'requires authentication' do
        pending
        fail
      end
    end
    describe 'GET #new' do
      before { send_new_request }
      it 'renders the new view' do
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
      end
      it 'builds the view using an empty draft entry' do
        expect(assigns(:entry).draft?).to be true
        expect(assigns(:entry).empty?).to be true
      end
      it 'requires authentication' do
        pending
        fail
      end
    end
    describe 'POST #create' do
      # before { post :create }
      context 'with valid parameters' do
        it 'creates a new entry' do
          pending
          fail
        end
        it 'redirects to the entry show page' do
          pending
          fail
        end
        it 'returns a 303 code' do
          pending
          fail
        end
      end
      context 'with invalid parameters' do
        it 'does not create a new entry' do
          pending "The entry model has no validations. Invalid parameters are currently not possible."
          fail
        end
        it 'renders the new view' do
          pending "The entry model has no validations. Invalid parameters are currently not possible."
          fail
        end
        it 'returns a 422 code' do
          pending "The entry model has no validations. Invalid parameters are currently not possible."
          fail
        end
      end
      it 'only creates entries for the current user' do
        pending
        fail
      end
      it 'requires authentication' do
        pending
        fail
      end
    end
  end

  describe 'methods' do
    describe '#set_entry' do
      it 'is private' do
        pending
        fail
      end
      it 'assigns @entry with the requested entry' do
        pending
        fail
      end
    end
    describe '#entry_params' do
      let(:entry_params) do
        ActionController::Parameters.new(
          entry: {
            content: 'Some content',
            title: 'Some title',
            status: 'draft',
            mentions_attributes: [
              { person_id: 1 },
              { person_id: 2, _destroy: '1' }
            ],
            pictures_attributes: [
              { file: 'file1.jpg' },
              { file: 'file2.jpg', _destroy: '1' }
            ]
          }
        )
      end
      it 'is private' do
        expect(EntriesController.private_instance_methods).to include(:entry_params)
      end
      it 'whitelists the expected params' do
        allow(controller).to receive(:params).and_return(entry_params)

        expect(entry_params).to receive(:require).with(:entry).and_return(entry_params)
        expect(entry_params).to receive(:permit).with(
          :content,
          :title,
          :status,
          mentions_attributes: [:id, :person_id, :_destroy],
          pictures_attributes: [:file, :id, :_destroy]
        )

        controller.send(:entry_params)
      end
    end
  end
end
  
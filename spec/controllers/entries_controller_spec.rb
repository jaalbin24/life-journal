require "rails_helper"

RSpec.describe EntriesController, type: :controller do

  let(:user)                    { create :user }
  let(:valid_params)            { { content: "Test content", title: "Test Title" } }
  # let(:invalid_params)          { { } }
  let(:send_edit_request)       { get :edit, params: { id: user.entries.sample.id } }
  let(:send_new_request)        { get :new }
  let(:send_show_request)       { get :show, params: { id: user.entries.sample.id } }
  let(:send_index_request)      { get :index }
  let(:send_drafts_request)     { get :index, params: { status: "drafts" } }
  let(:send_published_request)  { get :published }
  let(:send_update_request)     { put :update, params: { id: user.entries.sample.id, entry: valid_params } }
  let(:send_create_request)     { post :create, params: { entry: valid_params } }


  it "has no unexpected actions" do
    expected_actions = [
      :create,
      :new,
      :update,
      :index,
      :search,
      :destroy,
      :edit,
      :show,
      :not_found,
      :configure_continue_path,
      :continue_path,
      :sign_out,
      :sign_in
    ]
    unexpected_actions = EntriesController.action_methods.map(&:to_sym) - expected_actions
    expect(unexpected_actions.size).to eq(0), "Unexpected actions found: #{unexpected_actions.inspect}" 
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

  describe "actions" do
    describe "GET #index" do
      it "requires authentication" do
        sign_out
        send_index_request
        expect(response).to redirect_to(sign_in_path)
      end
      context "with draft as the status param" do
        before { send_drafts_request }
        it "renders the index view" do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
        end
        it "shows the correct type of entries" do
          # Shows only draft entries
          expect(assigns(:entries).count).to eq assigns(:entries).drafts.count
          # Does not show deleted entries
          expect(assigns(:entries).deleted.count).to eq 0
          # Does not show published entries
          expect(assigns(:entries).published.count).to eq 0
          # Only shows entries belonging to the user
          expect(assigns(:entries).where.not(user_id: user.id).count).to eq 0
        end
      end
      context "with anything else as the status param" do
        before { get :index, params: { status: "yeet" } }
        it "renders the index view" do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:index)
        end
        it "shows the correct type of entries" do
          # Shows only published entries
          expect(assigns(:entries).count).to eq assigns(:entries).published.count
          # Does not show deleted entries
          expect(assigns(:entries).deleted.count).to eq 0
          # Does not show draft entries
          expect(assigns(:entries).drafts.count).to eq 0
          # Only shows entries belonging to the user
          expect(assigns(:entries).where.not(user_id: user.id).count).to eq 0
        end
      end
    end
    describe "GET #show" do
      it "renders the show view" do
        send_show_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:show)
      end
      it "returns 404 if attempting to see another user's entry" do
        get :show, params: { id: User.all.excluding(user).first.entries.sample.id }
        expect(response).to have_http_status(:not_found)
      end
      it "requires authentication" do
        sign_out
        send_index_request
        expect(response).to redirect_to(sign_in_path)
      end
    end
    describe "GET #edit" do
      it "renders the edit view" do
        send_edit_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:edit)
      end
      it "returns 404 if attempting to edit another user's entry" do
        get :edit, params: { id: User.all.excluding(user).first.entries.sample.id }
        expect(response).to have_http_status(:not_found)
      end
      it "requires authentication" do
        sign_out
        send_edit_request
        expect(response).to redirect_to(sign_in_path)
      end
    end
    describe "GET #new" do
      it "renders the new view" do
        send_new_request
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:new)
        # Builds the view using a non-persisted entry
        expect(assigns(:entry).persisted?).to be false
      end
      it "requires authentication" do
        sign_out
        send_new_request
        expect(response).to redirect_to(sign_in_path)
      end
    end
    describe "PUT #update" do
      it "returns 404 if attempting to update another user's entry" do
        put :update, params: { id: User.all.excluding(user).first.entries.sample.id, entry: valid_params }
        expect(response).to have_http_status(:not_found)
      end
      context "with valid parameters" do
        it "updates the entry" do
          entry = user.entries.sample
          new_title = "UPDATED TEST TITLE"
          expect(entry.title).to_not eq new_title
          put :update, params: { id: entry.id, entry: { title: new_title } }
          entry.reload
          expect(entry.title).to eq new_title
        end
        it "redirects to the edit page with a 302 code" do
          entry = user.entries.sample
          put :update, params: { id: entry.id, entry: valid_params }
          expect(response).to redirect_to edit_entry_path(entry)
          expect(response).to have_http_status(302)
        end
      end
      # The entry model currently has no possible invalid parameters
      # context "with invalid parameters" do
      #   it "does not update the entry" do
      #     pending "The entry model has no validations. Invalid parameters are currently not possible."
      #     fail
      #   end
      #   it "renders the edit view" do
      #     pending "The entry model has no validations. Invalid parameters are currently not possible."
      #     fail
      #   end
      #   it "returns a 422 code" do
      #     pending "The entry model has no validations. Invalid parameters are currently not possible."
      #     fail
      #   end
      # end
      # it "only updates an entry if it belongs to the current user" do
      #   pending
      #     fail
      # end
      # it "requires authentication" do
      #   pending
      #   fail
      # end
    end
    describe "POST #create" do
      it "requires authentication" do
        sign_out
        send_create_request
        expect(response).to redirect_to(sign_in_path)
      end
      context "with valid parameters" do
        it "creates a new entry" do
          expect {
            send_create_request
          }.to change(Entry, :count).by(1)
        end
        it "redirects to the edit page with a 302 code" do
          send_create_request
          expect(response).to redirect_to edit_entry_path(Entry.order(:created_at).last)
          expect(response).to have_http_status(302)
        end
      end
      # The entry model currently has no possible invalid parameters
      # context "with invalid parameters" do
      #   it "does not create a new entry" do
      #     pending "The entry model has no validations. Invalid parameters are currently not possible."
      #     fail
      #   end
      #   it "renders the new view" do
      #     pending "The entry model has no validations. Invalid parameters are currently not possible."
      #     fail
      #   end
      #   it "returns a 422 code" do
      #     pending "The entry model has no validations. Invalid parameters are currently not possible."
      #     fail
      #   end
      # end
    end
  end

  describe "methods" do
    describe "#entry_params" do
      let(:entry_params) do
        ActionController::Parameters.new(
          entry: {
            content: "Some content",
            title: "Some title",
            status: "draft",
            mentions_attributes: [
              { person_id: 1 },
              { person_id: 2, _destroy: "1" }
            ],
            pictures_attributes: [
              { file: "file1.jpg" },
              { file: "file2.jpg", _destroy: "1" }
            ]
          }
        )
      end
      it "is private" do
        expect(EntriesController.private_instance_methods).to include(:entry_params)
      end
      it "whitelists the expected params" do
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
  
require "rails_helper"

RSpec.describe EmailsController, type: :controller do
  let(:old_email)               { "test@example.com" }
  let(:new_email)               { "new@example.com" }
  let(:password_challenge)      { "password123" }
  let(:user)                    { create :user, email: old_email, password: password_challenge }
  let(:valid_params)            { { user: { email: new_email, password_challenge: password_challenge } } }
  let(:invalid_params)          { { user: { email: new_email, password_challenge: "WrongPassword" } } }


  it "has no unexpected actions" do
    expected_actions = [
      :update,
      :edit,
      :set_user,
      :email_params,
      :not_found,
      :page,
      :alerts,
      :alerts_now,
      :sign_out,
      :sign_in
    ]
    unexpected_actions = EmailsController.action_methods.map(&:to_sym) - expected_actions
    expect(unexpected_actions.size).to eq(0), "Unexpected actions found: #{unexpected_actions.inspect}" 
  end

  before do
    sign_in user
  end

  describe "actions" do
    describe "GET #edit" do
      it "renders the edit view" do
        get :edit
        expect(response).to have_http_status :success
        expect(response).to render_template :edit
      end
      it "renders using the current user" do
        get :edit
        expect(assigns(:user)).to eq user
      end
      it "requires authentication" do
        sign_out
        get :edit
        expect(response).to redirect_to(sign_in_path)
      end
    end
    describe "PUT #update" do
      it "uses the current user" do
        put :update, params: valid_params
        expect(assigns(:user)).to eq user
      end
      context "with valid parameters" do
        it "returns a 303 code" do
          put :update, params: valid_params
          expect(response).to have_http_status :see_other
        end
      end
      context "with invalid parameters" do
        it "returns a 422 code" do
          put :update, params: invalid_params
          expect(response).to have_http_status :unprocessable_entity
        end
      end
      it "requires authentication" do
        sign_out
        put :update, params: valid_params
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe "methods" do
    describe "#email_params" do
      it { should permit(:email, :password_challenge).for(:update, params: valid_params) }
    end
  end
end
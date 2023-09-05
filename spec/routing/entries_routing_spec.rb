require 'rails_helper'

RSpec.describe "EntryRoutes", type: :routing do
  let(:entry) { create :entry }

  describe "the 7 basic CRUD operations" do
    # INDEX
    it "routes GET /entries to entries#index" do
      expect(get "/entries").to route_to(
        controller: "entries",
        action: "index"
      )
    end
    # NEW
    it "routes GET /entries/new to entries#new" do
      expect(get "/entries/new").to route_to(
        controller: "entries",
        action: "new"
      )
    end
    # SHOW
    it "routes GET /entries/:id to entries#show" do
      expect(get "/entries/#{entry.id}").to route_to(
        controller: "entries",
        action: "show",
        id: entry.id
      )
    end
    # EDIT
    it "routes GET /entries/:id/edit to entries#edit" do
      expect(get "/entries/#{entry.id}/edit").to route_to(
        controller: "entries",
        action: "edit",
        id: entry.id
      )
    end
    # CREATE
    it "routes POST /entries to entries#create" do
      expect(post "/entries").to route_to(
        controller: "entries",
        action: "create"
      )
    end
    # UPDATE
    it "routes PATCH /entries/:id to entries#update" do
      expect(patch "/entries/#{entry.id}").to route_to(
        controller: "entries",
        action: "update",
        id: entry.id
      )
    end
    # DESTROY
    it "routes DELETE /entries/:id to entries#destroy" do
      expect(delete "/entries/#{entry.id}").to route_to(
        controller: "entries",
        action: "destroy",
        id: entry.id
      )
    end
  end
  describe "tab" do
    it "routes GET /entries/published to entries#index" do
      expect(get "/entries/published").to route_to(
        controller: "entries",
        action: "index",
        tab: "published"
      )
    end
    it "routes GET /entries/drafts to entries#index" do
      expect(get "/entries/drafts").to route_to(
        controller: "entries",
        action: "index",
        tab: "drafts"
      )
    end
  end
  describe "pages" do
    it "routes GET /entries/page/:page to entries#index" do
      expect(get "/entries/page/24").to route_to(
        controller: "entries",
        action: "index",
        page: "24"
      )
    end
    it "routes GET /entries/page/:page to entries#index" do
      expect(get "/entries/page/24").to route_to(
        controller: "entries",
        action: "index",
        page: "24"
      )
    end
  end
end
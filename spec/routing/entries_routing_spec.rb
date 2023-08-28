require 'rails_helper'

RSpec.describe "EntryRoutes", type: :routing do
  let(:entry) { create :entry }

  it "routes GET /entries to entries#index" do
    expect(get "/entries").to route_to(
      controller: "entries",
      action: "index"
    )
  end
  it "routes GET /entries/new to entries#new" do
    expect(get "/entries/new").to route_to(
      controller: "entries",
      action: "new"
    )
  end
  it "routes GET /entries/:id to entries#show" do
    expect(get "/entries/#{entry.id}").to route_to(
      controller: "entries",
      action: "show",
      id: entry.id
    )
  end
  it "routes POST /entries to entries#create" do
    expect(post "/entries").to route_to(
      controller: "entries",
      action: "create"
    )
  end
  it "routes PATCH /entries/:id to entries#update" do
    expect(patch "/entries/#{entry.id}").to route_to(
      controller: "entries",
      action: "update",
      id: entry.id
    )
  end
  it "routes DELETE /entries/:id to entries#destroy" do
    expect(delete "/entries/#{entry.id}").to route_to(
      controller: "entries",
      action: "destroy",
      id: entry.id
    )
  end
  describe "collection" do
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
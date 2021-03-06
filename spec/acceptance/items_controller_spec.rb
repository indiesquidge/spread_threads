require "acceptance_helper"

resource "Items" do
  header "Accept", "application/json"
  header "Host", "https://spreadthreads.herokuapp.com"

  let!(:item1) { Item.create!(title: "Latex gloves",
                              blurb: "for my importing/exporting business",
                              author: "Art Vandelay",) }

  before :each do
    Fabricate.times(4, :item)
  end

  let!(:item2) { Item.create!(title: "Mining Drill",
                              blurb: "for my silver mine in Peru",
                              author: "H.E. Pennypacker",) }

  context "#index" do
    get "/items" do
      parameter :page, "page scope"
      parameter :per_page, "items per page (default value is 20)"
      let(:page) { 1 }
      let(:per_page) { 5 }

      example_request "return a collection of items" do
        expect(status).to eq 200
        expect(response_body).to include(item1.title)
        expect(response_body).not_to include(item2.title)
      end
    end
  end
end

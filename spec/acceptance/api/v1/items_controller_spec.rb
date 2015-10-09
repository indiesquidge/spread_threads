require "acceptance_helper"

resource "Items" do
  header "Accept", "application/json"

  let!(:item1) { Item.create!(title: "Latex gloves",
                              blurb: "for my importing/exporting business",
                              author: "Art Vandelay",) }

  before :each do
    4.times do
      Item.create!(title: Faker::App.name,
                   blurb: Faker::Lorem.sentence(3),
                   author: Faker::App.author)
    end
  end

  let!(:item2) { Item.create!(title: "Mining Drill",
                              blurb: "for my silver mine in Peru",
                              author: "H.E. Pennypacker",) }

  context "#index" do
    get "/api/v1/items" do
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

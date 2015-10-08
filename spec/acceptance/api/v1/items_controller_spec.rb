require "acceptance_helper"

resource "Items" do
  header "Accept", "application/json"

  let!(:item1) { Item.create!(title: "Latex gloves",
                              blurb: "for my importing/exporting business",
                              author: "Art Vandelay",) }

  let!(:item2) { Item.create!(title: "Mining Drill",
                              blurb: "for my silver mine in Peru",
                              author: "H.E. Pennypacker",) }

  context "#index" do
    get "/api/v1/items" do
      it "Returns all items" do
        do_request

        expect(status).to eq 200
        expect(response_body).to include(item1.title)
        expect(response_body).to include(item2.title)
      end
    end
  end
end

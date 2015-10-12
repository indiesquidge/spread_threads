require "rails_helper"

RSpec.describe "Item index", type: :feature do
  let!(:item) { Fabricate(:item) }

  it "loads more items when scrolled to the bottom of the page", js: true do
    default_per_page = Kaminari.config.default_per_page
    Fabricate.times(default_per_page, :item)

    expect(Item.count).to be > default_per_page
    page.visit current_path
    expect(page).to have_css(".item", count: default_per_page)
    page.execute_script("window.scrollTo(0,100000)")
    expect(page).to have_css(".item", count: Item.count)
  end
end

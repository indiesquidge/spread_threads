Fabricator(:item) do
  title "Latex gloves"
  blurb "the perfect mitt for all your importing and exporting business tasks"
  author "Art Vandelay"
  thumbnail_url Faker::Avatar.image
  details_url Faker::Internet.url('example.com', '/foobar.html')
end

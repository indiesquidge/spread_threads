class SeedItem
  def self.create_items(number_of_items)
    number_of_items.times do
      item = Item.create!(title: Faker::App.name,
                          blurb: Faker::Lorem.sentence(rand(5..40)),
                          author: Faker::App.author,
                          thumbnail_url: Faker::Avatar.image,
                          details_url: Faker::Internet.url('example.com', '/foobar.html'))

      puts "Created Item #{item.title}"
    end
  end
end

SeedItem.create_items(60)

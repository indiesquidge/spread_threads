# Spread Threads
A fashion discovery platform product mock, using a Pinterest-like board layout.

#### Production Site
Hosted on Heroku: [https://spreadthreads.herokuapp.com/](https://spreadthreads.herokuapp.com/)

For API documentation, click [here](https://spreadthreads.herokuapp.com/api/docs).

#### Running Project Locally
Download the code
```sh
git clone https://github.com/indiesquidge/spread_threads.git
cd spread_threads
```

Install dependencies
```sh
bundle install
```

Make sure the tests are passing
```sh
rspec
```

Start the server
```sh
rails server
```

Visit [localhost:3000](http://localhost:3000/) to see the main dashboard.

#### Technical Specifications
> _The backend should be a RESTful API delivering JSON data via AJAX calls and
using infinite scroll to add content to the page as the user scrolls down. The
API should take a page parameter and deliver pages of items with randomized
content._

> _At the very least each board item should feature the thumbnail image, the
post title, and the blurb field, truncated to display 32 words and featuring a
"Read more" link. The backend should have 20 items per page and deliver at least
3 pages of data._

#### Technical Challenges While Building
For the most part this project went smoothly. I have built my own Rails API
backend before, so it wasn't particularly difficult to create those endpoints
and serve JSON data from the database.

The main difficulty came in when I was attempting to implement infinite scroll
via
AJAX. When I first created the Rails backend API, it was nested under `:api` and
`:v1` namespaces. This made it so that calls to the API needed to look something
like this

```sh
curl "http://localhost:3000/api/v1/items?page=2"
```

This worked fine when I was simply making one request to the endpoint to load
the initial page of data. In fact, I wasn't even using a Rails view; all of my
calls and HTML structure came from a JavaScript file. Obviously not the
prettiest thing to have a tree of HTML elements nested in a JS file, but it was
a first run to make sure the data was coming through and being organized as
expected.

It got challenging when I realized that I would need to keep track of what page
parameter I was sending on each subsequent AJAX call. The gem I was using for
pagination, [kaminari](https://github.com/amatsuda/kaminari), came with very
useful helper methods like `current_page`, `total_pages`, and `next_page`, all
of which would be very helpful in grabbing the next set of items. Of course, in
order to use these methods, I needed a collection in which to call them on that
would be usable in a view template. This posed a problem because at the time, my
view was under `dashboard#index` and my actual API handling was done in
`api::v1::items#index`. By Rails convention, controller names represent view
folders and controller actions represent each individual view file. This meant
that I could not pass any instance variable I created in the
`api::v1::items#index` action to the view template I was using as the root
(`views/dashboard/index.html.erb`). Something needed to change structurally on
the controller level.

After I debated with myself over the pros and cons of keeping the controller
namespaced, breaking certain Rails conventions, etc. I ended up pulling my
`items_controller` out of the namespaces, making a new API call look like

```sh
curl "http://localhost:3000/items?page=2"
```

In all seriousness, I actually find this call a bit easier to manage than
having it namespaced. Of course, as the project became larger, and the front
end moved away from Rails entirely, switching the controller back under an API
namespace would be no problem at all. The solution I came up with is viable for
the foreseeable future of this application.

This made my view templates much easier to use since I can now make my root page
point at `items#index` and use instance variables directly from that controller
action, allowing me to still serve the data asynchronously but also giving me
access to those helper methods. The only real thing that had to change was
allowing my API to respond to HTML and JS on top of JSON, giving me the best of
all worlds. I could load the first page of data directly from Rails into the
view using HTML, each subsequent call would be made using AJAX and responding
with JavaScript, and the API still responds with JSON to outside consumers.

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

Setup environment
```sh
rake db:setup
```

Make sure the tests are passing
```sh
rspec
```

**NOTE**: Keep in mind that `Capybara's` driver, `selenium`, requires you to have
Firefox installed on your computer.

`Capybara's` uses selenium` as it's default browser. After a lot of slow and
painful debugging to get another driver, `poltergeist` (faster and headless),
working without errors on OS X 10.11, the tests fail on an expectation that
passes with `selenium`, and I can't figure out why. It fails on expecting a
higher item count on the page after the user has scrolled. So, for now,
`selenium` is what is being used.

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

 > _Deliverable should be runnable, e.g can be a deployed Heroku app or a
codebase on GitHub, with a README showing how to run this. Extra points for
unit-tests, code formatting/conventions, and comments around the code._

I just want to point out a few minor cases where I strayed away from the exact
specifications. First, I did not end up displaying a truncated blurb field on
each item because it often turns out to look like this

![Items with truncated blurb](http://i.imgur.com/Pjb4PY3.png)

Which is just ugly. Now I could impose some sort of div height limit, or
truncate at exactly the same place for every item, or \<insert other fancy work
around here\>, but I thought that just displaying the item title was enough. It
keeps the page clean, it keeps the rows formatted, it's less noisy, and I found
a very easy way to show the item's details without a page load or AJAX call or
modal, making it easy to load and keeping it responsive.

![Item cards](http://i.imgur.com/sfQcHf4.gif)

This negates the need for the `details_url` property of each item. I have
left that piece of data in the application in case the client is set on the
truncation and I can't convince them otherwise. One reason I could see the
truncation being needed is if the client wanted a search feature for filtering
items based on their blurbs, but that isn't the case for this mock-up.

---

The second thing I did not do was implement unit tests. This application is
(very) small right now, and only contains one model, `Item`. By the
specifications, there isn't even a feature to create new items. This nullifies
the need for any unit tests on `Item` since we have no validations to begin
with, only pre-made seed data to display. Even if there were validations on the
model (i.e. "an item must have a title to be valid"), those validations are
tested on the `validate` method in Rails itself. It wouldn't only make sense to
have unit tests if I had authorization permissions for items, validations or
filters (i.e. this is where truncating the blurb would come in), or any other
custom methods.

As it stands, I can only really see two things that need to be tested. Whether
or not my API calls work and their corresponding parameters, and whether or not
infinite scroll is working as the user traverses the page.

---

The last thing I did not do is write any comments in the code. For high level
languages such as Ruby or JavaScript, I believe the code should speak for
itself. If I have written something that another developer does not understand
or cannot follow, then I have failed and probably need to re-write my code.

> _"Programs must be written for people to read, and only incidentally for
machines to execute." -Abelson and Sussman_

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

#### Known Bugs
For some reason (unknown to me), my search filtering will not work when _some_
individual letters are typed in to the input. For example, if I type in "o",
absolutely nothing changes on the screen; items not containing the letter "o"
are still present. Of course if I type more letters after "o", the filtering
works as it should. The curious part is that other letters, such as "q", will
filter the items just fine.

**FIXED**: So I sat and tried each letter to see which ones were causing the
issue and which ones were working fine. It was kind of like a fun game of
hangman, and in the end I ended up winning when I noticed that the letters that
were "broken" were "e, r, t, o, v, m", _exactly_ the same letters that are
being used to render the vertical ellipses on each item, `more_vert`. I had
messed up my placement of the `title` class and had my icon wrapped in the div,
thus causing the issue with only those six letters.

#### Ideas for the Future
- [x] Filtering option
- [ ] Sorting option
- [ ] Use Angular, React, or Ember for the front-end

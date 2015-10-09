$(document).ready(function () {
  getItems();
});

var ItemRepo = {
  all: function () {
    return $.getJSON('/api/v1/items?page=1');
  }
};

function getItems() {
  ItemRepo.all().then(function (items) {
    var renderedItems = items.map(renderItem);
    $('body').prepend(renderedItems);
  });
}

function renderItem(item) {
  var truncatedBlurb = trimBlurb(item.blurb);

  return $('<div class="item" style="border: 2px solid;">' +
           '<img src=' + item.thumbnail_url + '>' +
           '<h3>' + item.title + '</h3>' +
           '<h4>' + item.author + '</h4>' +
           '<p>' + truncatedBlurb + '<a href=' + item.details_url + '>Read more</a>' + '</p>' +
         '</div>');
}

function trimBlurb(string) {
  var words = string.split(' ');

  if (words.length > 32) {
    return string.split(' ', 32).join(' ') + '...';
  }
  return string;
}

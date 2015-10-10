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
    $('.items').prepend(renderedItems);
  });
}

function renderItem(item) {
  var truncatedBlurb = trimBlurb(item.blurb);

  return $('<div class="col s12 m3">' +
             '<div class="card">' +
               '<div class="card-image waves-effect waves-block waves-light">' +
                 '<img class="activator" src=' + item.thumbnail_url + '>' +
               '</div>' +
               '<div class="card-content">' +
                 '<span class="card-title activator grey-text text-darken-4">' +
                   item.title + '<i class="material-icons right">more_vert</i>' +
                 '</span>' +
                 '<p><a href=' + item.details_url + '>Read more</a></p>' +
               '</div>' +
               '<div class="card-reveal">' +
                 '<span class="card-title grey-text text-darken-4">' +
                   item.title + '<i class="material-icons right">close</i>' +
                 '</span>' +
                 '<p>' + item.author + '</p>' +
                 '<p>' + item.blurb + '</p>' +
               '</div>' +
             '</div>' +
           '</div>');
}

function trimBlurb(string) {
  var words = string.split(' ');

  if (words.length > 32) {
    return string.split(' ', 32).join(' ') + '...';
  }
  return string;
}

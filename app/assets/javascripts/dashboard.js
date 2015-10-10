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
  return $('<div class="col s12 m6 l3">' +
             '<div class="card grey lighten-5">' +
               '<div class="card-image waves-effect waves-block waves-light">' +
                 '<img class="activator" src=' + item.thumbnail_url + '>' +
               '</div>' +
               '<div class="card-content white">' +
                 '<span class="card-title activator grey-text text-darken-4">' +
                   item.title + '<i class="material-icons right">more_vert</i>' +
                 '</span>' +
               '</div>' +
               '<div class="card-reveal blue-grey">' +
                 '<span class="card-title white-text">' +
                   item.title + '<i class="material-icons right">close</i>' +
                 '</span>' +
                 '<span class="white-text">' +
                   '<p>Creator: ' + item.author + '</p>' +
                   '<p>' + item.blurb + '</p>' +
                 '</span>' +
               '</div>' +
             '</div>' +
           '</div>');
}

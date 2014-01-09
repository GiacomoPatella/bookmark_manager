function animateLinks() {
  $('.link').show(1000);
}

$(function() {
  animateLinks();
})

function addFavouritesHandler() {
  $(".star.solid").click(function() {
    $(this).animate({opacity: 1}, 500);
  });
}

$(function() {
  addFavouritesHandler();
})
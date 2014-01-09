function animateLinks() {
  $('.link').show(1000);
}

$(function() {
  animateLinks();
})

function prepareRemoteFormsHandler() {
  $('.add-link, new-user, .new-session').click(function(event) {
    $.get($(this).attr("href"), function(data) {
      if ($("#ajax-form").length == 0) {
        $("#container").html("<div id='ajax-form'></div>");
      }
      $("#container #ajax-form").html(data);
    });
    event.preventDefault();
  });
}

$(function() {
  prepareRemoteFormsHandler();
})


function addFavouritesHandler() {
  $(".star.solid").click(function(event) {
    var link = $(this).parent();
    var favourited = !!$(link).data("favourited");
    var newOpacity = favourited ? 0 : 1;
    $(link).data("favourited", !favourited);
    $(this).animate({opacity: newOpacity}, 500);
    showLinkFavouriteNotice(link)
  });
}

$(function() {
  addFavouritesHandler();
})


function showLinkFavouriteNotice(link) {
  var favourited = !!$(link).data("favourited");
  var name = $(link).find('.title').text();
  var message = favourited ?
                name + " was added to favourites" :
                name + " was removed from favourites";
  // here $flash is not a jQuery object but just a variable name
  // the $ is used as a reminder that the variable holds a jQuery object              
  var $flash = $("<div></div>").addClass('flash notice').html(message);
  $flash.appendTo('#flash-container');
  window.setTimeout(function() {
  $flash.fadeOut();
  }, 3000); 
}

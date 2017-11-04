$(document).ready(function(){
  paginationListener();
});

var paginationListener = function () {
  if ($('.browse-games-results').length && $('.pagination').length) {
    $('.pagination').hide();
    $('#load_more_games').click(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url) {
        $.getScript(url);
      }
    });
  }
};

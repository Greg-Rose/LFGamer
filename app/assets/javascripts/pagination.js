$(document).ready(function(){
  paginationListener();
  profilePaginationListener();
});

// games#index pagination
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

// profiles#show pagination
var profilePaginationListener = function () {
  if ($('.profile-show').length && $('.pagination').length) {
    $('.profile-show .pagination a').click(function(e) {
      e.preventDefault();
      $.getScript(this.href, function(){
        profilePaginationListener();
      });
    });
  }
};

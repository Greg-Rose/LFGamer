$(document).ready(function() {
  $(".admin-dashboard").on("click", ".count-stats", function(event) {
    $( ".admin-dashboard h2").slideUp(500);
    $(".admin-dashboard .count-stats").removeClass("stats-clicked");
    $(this).addClass("stats-clicked");
  });

  $(".admin-dashboard").on("click", ".count-stats", function(event) {
    var type = $(this).attr("data");
    if (!$(".admin-dashboard .admin-" + type).length) {
      if ($(".admin-dashboard .panel-body").children().length > 2) {
        $(".admin-dashboard .panel-body").children().last().remove();
      }
      $.get( "/admin/" + type, function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-" + type).hide().slideDown(500);
      });
    }

    $(".admin-dashboard").on("click", "." + type + "-table-div .pagination-links a", function(event) {
      event.preventDefault();
      var link = $(this).attr('href');
      $.get( link, function( data ) {
        $('.admin-dashboard .panel-body .admin-' + type).remove();
        $('.admin-dashboard .panel-body').append(data);
      });
    });
  });

  $(".admin-dashboard").on("click", ".admin-back-btn", function(event) {
    $(".admin-back-btn").parent().parent().remove();
    $(".admin-dashboard h2").slideDown(500);
    $(".admin-dashboard .count-stats").removeClass("stats-clicked");
  });

  $(".admin-dashboard").on("click", ".user-info-btn", function(event) {
    event.preventDefault();
    var uid = $(this).data('uid');
    $.get( '/admin/users/' + uid, function( data ) {
      if ($('.admin-dashboard .modal').length) {
        $('.admin-dashboard .modal').remove();
      }
      $('.admin-dashboard .admin-users').append(data);
      $('#userModal').modal('show');
    });
  });

  $(".admin-dashboard").on("click", "#add-game-btn", function(event) {
    event.preventDefault();
    $.get( '/admin/games/new', function( data ) {
      if ($('.admin-dashboard .modal').length) {
        $('.admin-dashboard .modal').remove();
      }
      $('.admin-dashboard .admin-games').append(data);
      $('#addGameModal').modal('show');
    });
  });

  $(".admin-dashboard").on("click", ".admin-games #search-btn", function(event) {
    event.preventDefault();
    if ($('.games-search-results').length) {
      $('.games-search-results').slideUp();
    }
    var search = $("#add-game-search").val();
    $.get( '/admin/games/search', { search: search }, function( data ) {
      $('.games-search-results').remove();
      $('#addGameModal .modal-body').append(data);
      $('.games-search-results').slideDown();
    });
  });
});

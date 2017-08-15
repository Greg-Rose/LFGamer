$(document).ready(function() {
  $(".admin-dashboard").on("click", ".count-stats", function(event) {
    $( ".admin-dashboard h2").slideUp(500);
    $(".admin-dashboard .count-stats").removeClass("stats-clicked");
    $(this).addClass("stats-clicked");
  });

  $(".admin-dashboard").on("click", ".users-count a", function(event) {
    if (!$(".admin-dashboard .admin-users").length) {
      $.get( "/admin/users", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-users").hide().slideDown(500);
      });
    }
  });

  $(".admin-dashboard").on("click", ".pagination-links a", function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    $.get( link, function( data ) {
      $('.admin-dashboard .panel-body .admin-users').remove();
      $('.admin-dashboard .panel-body').append(data);
    });
  });

  $(".admin-dashboard").on("click", ".admin-back-btn", function(event) {
    $(".admin-back-btn").parent().parent().remove();
    $( ".admin-dashboard h2").slideDown(500);
    $(".admin-dashboard .count-stats").removeClass("stats-clicked");
  });
});

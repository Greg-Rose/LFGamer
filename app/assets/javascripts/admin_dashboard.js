$(document).ready(function() {
  $(".admin-dashboard").on("click", ".count-stats", function(event) {
    $( ".admin-dashboard h2").slideUp(500);
    $(".admin-dashboard .count-stats").css("background-color", "#4d4d4d");
    $(this).css("background-color", "#333333");
  });

  $(".admin-dashboard").on("click", ".users-count a", function(event) {
    if (!$(".admin-dashboard .admin-users").length) {
      $.get( "/admin/users", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-users").hide().slideDown(500);
      });
    }
  });
});

$(document).ready(function() {
  $(".admin-dashboard").on("click", ".count-stats", function(event) {
    $( ".admin-dashboard h2").slideUp(500);
    $(".admin-dashboard .count-stats").removeClass("stats-clicked");
    $(this).addClass("stats-clicked");
  });

  $(".admin-dashboard").on("click", ".users-count a", function(event) {
    if (!$(".admin-dashboard .admin-users").length) {
      if ($(".admin-dashboard .panel-body").children().length > 2) {
        $(".admin-dashboard .panel-body").children().last().remove();
      }
      $.get( "/admin/users", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-users").hide().slideDown(500);
      });
    }
  });

  $(".admin-dashboard").on("click", ".users-table-div .pagination-links a", function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    $.get( link, function( data ) {
      $('.admin-dashboard .panel-body .admin-users').remove();
      $('.admin-dashboard .panel-body').append(data);
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

  $(".admin-dashboard").on("click", ".consoles-count a", function(event) {
    if (!$(".admin-dashboard .admin-consoles").length) {
      if ($(".admin-dashboard .panel-body").children().length > 2) {
        $(".admin-dashboard .panel-body").children().last().remove();
      }
      $.get( "/admin/consoles", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-consoles").hide().slideDown(500);
      });
    }
  });

  $(".admin-dashboard").on("click", ".consoles-table-div .pagination-links a", function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    $.get( link, function( data ) {
      $('.admin-dashboard .panel-body .admin-consoles').remove();
      $('.admin-dashboard .panel-body').append(data);
    });
  });
});

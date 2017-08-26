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

  $(".admin-dashboard").on("click", ".ownerships-count a", function(event) {
    if (!$(".admin-dashboard .admin-ownerships").length) {
      if ($(".admin-dashboard .panel-body").children().length > 2) {
        $(".admin-dashboard .panel-body").children().last().remove();
      }
      $.get( "/admin/ownerships", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-ownerships").hide().slideDown(500);
      });
    }
  });

  $(".admin-dashboard").on("click", ".ownerships-table-div .pagination-links a", function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    $.get( link, function( data ) {
      $('.admin-dashboard .panel-body .admin-ownerships').remove();
      $('.admin-dashboard .panel-body').append(data);
    });
  });

  $(".admin-dashboard").on("click", ".games-count a", function(event) {
    if (!$(".admin-dashboard .admin-games").length) {
      if ($(".admin-dashboard .panel-body").children().length > 2) {
        $(".admin-dashboard .panel-body").children().last().remove();
      }
      $.get( "/admin/games", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-games").hide().slideDown(500);
      });
    }
  });

  $(".admin-dashboard").on("click", ".games-table-div .pagination-links a", function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    $.get( link, function( data ) {
      $('.admin-dashboard .panel-body .admin-games').remove();
      $('.admin-dashboard .panel-body').append(data);
    });
  });

  $(".admin-dashboard").on("click", ".lfgs-count a", function(event) {
    if (!$(".admin-dashboard .admin-lfgs").length) {
      if ($(".admin-dashboard .panel-body").children().length > 2) {
        $(".admin-dashboard .panel-body").children().last().remove();
      }
      $.get( "/admin/lfgs", function( data ) {
        $('.admin-dashboard .panel-body').append(data);
        $( ".admin-dashboard .admin-lfgs").hide().slideDown(500);
      });
    }
  });

  $(".admin-dashboard").on("click", ".lfgs-table-div .pagination-links a", function(event) {
    event.preventDefault();
    var link = $(this).attr('href');
    $.get( link, function( data ) {
      $('.admin-dashboard .panel-body .admin-lfgs').remove();
      $('.admin-dashboard .panel-body').append(data);
    });
  });
});

var fadeFormAlert = function() {
  $(".alert-disappear").fadeTo(3000, 1000).slideUp(1000, function(){
    $(".alert-disappear").slideUp(1000);
  });
};

// prevent alert from blocking user nav dropdown
$(document).ready(function() {
  if ($(".user-nav-dropdown").length) {
    $(".user-nav-dropdown a").click(function() {
      if ($(".alert-disappear").length) {
        $(".alert-disappear").stop().hide();
      }
    });
  }
});

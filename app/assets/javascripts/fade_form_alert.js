var fadeFormAlert = function() {
  $(".alert-disappear").fadeTo(3000, 1000).slideUp(1000, function(){
    $(".alert-disappear").slideUp(1000);
  });
};

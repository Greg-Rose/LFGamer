function checkAlertOffset() {
  if ($(document).scrollTop() <= $('.navbar').height()) {
    $('.alert-disappear').css('top', $('.navbar').height() - $(document).scrollTop());
  }
  if ($(document).scrollTop() > $('.navbar').height()) {
    $('.alert-disappear').css('top', 0);
  }
}

$(document).scroll(function() {
  if ($('.alert').length) {
    checkAlertOffset();
  }
});

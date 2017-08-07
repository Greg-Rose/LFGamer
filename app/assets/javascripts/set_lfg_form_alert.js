var setLfgFormAlert = function(type, message) {
  $('.lfg-form-alert').remove();
  var alert = '<div class="col-md-12 lfg-form-alert">' +
                  '<div class="alert alert-' + type + ' alert-dismissible" role="alert">' +
                    '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
                    '<ul>' + message + '</ul>' +
                  '</div>' +
                '</div>';
  $(".lfg-form").find("h4").after(alert);
  if (type == "info") {
    $(".lfg-form-alert").fadeTo(2000, 500).slideUp(500, function(){
      $(".lfg-form-alert").slideUp(500);
    });
  }
};

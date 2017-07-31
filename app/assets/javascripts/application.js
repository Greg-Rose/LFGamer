// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require timeago
//= require channels/lfg
//= require_tree ./channels
//= require_tree .

$(document).ready(function() {
  $("time.timeago").timeago();
  lfgChannel();
  $(function() {
    $("form#new_lfg").submit(function(event) {
      if ($("form#new_lfg").length) {
        event.preventDefault();
        var lfgForm = newLfgForm("form#new_lfg");
        var lfgCreator = newLfgCreator(lfgForm.attributes());
        lfgCreator.create();
      }
    });
    $("form.edit_lfg").submit(function(event) {
      // if ($("form.edit_lfg").length) {
        event.preventDefault();
        var lfgForm = newLfgForm("form.edit_lfg");
        var lfgUpdater = editLfgUpdater(lfgForm.attributes());
        lfgUpdater.update();
      // }
    });
  });
});

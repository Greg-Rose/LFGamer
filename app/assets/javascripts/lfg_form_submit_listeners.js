var lfgNewFormListener = function() {
  $("div.lfg-form").on("submit", "form#new_lfg", function(event) {
    event.preventDefault();
    var lfgForm = newLfgForm("form#new_lfg");
    var lfgCreator = newLfgCreator(lfgForm.attributes());
    lfgCreator.create();
  });
};

var lfgEditFormListener = function() {
  $("div.lfg-form").on("submit", "form.edit_lfg", function(event) {
    event.preventDefault();
    var lfgForm = newLfgForm("form.edit_lfg");
    var lfgUpdater = editLfgUpdater(lfgForm.attributes());
    lfgUpdater.update();
  });
};

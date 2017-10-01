var lfgRemoveButtonListener = function() {
  $("div.lfg-form").on("click", "#delete-lfg-btn", function(event) {
    event.preventDefault();
    event.stopPropagation();
    var deleter = lfgDeleter();
    deleter.delete();
  });
};

var lfgFormListener = function(form, newLfg) {
  $("div.lfg-form").on("submit", form, function(event) {
    event.preventDefault();
    var lfgForm = newLfgForm(form);
    var lfg;
    if (newLfg === true) {
      lfg = newLfgCreator(lfgForm.attributes());
      lfg.create();
    } else {
      lfg = editLfgUpdater(lfgForm.attributes());
      lfg.update();
    }
  });
};

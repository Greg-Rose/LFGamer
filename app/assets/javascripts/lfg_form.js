var newLfgForm = function(formId) {
  return {
    element: $(formId),
    ownershipId: function() {
      return this.element.find(":selected").val();
    },
    specifics: function() {
      return this.element.find("#lfg_specifics").val();
    },
    showConsoleUsername: function() {
      if(this.element.find("#lfg_show_console_username").is(":checked")) {
        return "1";
      }
      else {
        return "0";
      }
    },
    attributes: function() {
      var result = {
        ownership_id: this.ownershipId(),
        specifics: this.specifics(),
        show_console_username: this.showConsoleUsername()
      };
      return result;
    }
  };
};

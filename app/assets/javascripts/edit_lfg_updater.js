//= require channels/lfg

var editLfgUpdater = function(lfgAttributes) {
  return {
    lfg: lfgAttributes,
    update: function() {
      var lfgUpdaterObject = this;
      var id = $('form.edit_lfg').attr('id').split("lfg_").pop();
      var request = $.ajax({
        method: "PATCH",
        url: "/api/v1/lfgs/" + id,
        data: { lfg: lfgUpdaterObject.lfg, id: id }
      });

      request.done(function(response) {
        lfgUpdaterObject.updateForm(response);
        setLfgFormAlert("info", "Your LFG Has Been Updated!");
        lfgUpdaterObject.updateLfgsList(response);
      });

      // lfgFormErrorHandler() is in new_lfg_creator.js
      request.error(lfgFormErrorHandler());
    },
    updateForm: function(json) {
      var lfgId = json.lfg.id;
      $('.lfg-form-alert').remove();
      $('.edit_lfg').attr('id','edit_lfg_' + lfgId);
      $('.edit_lfg').attr('action', '/lfgs/' + lfgId);
      $('div#form-buttons').find('input').removeAttr('disabled');
      $('#delete-lfg-btn').attr('href', '/lfgs/' + lfgId);
    },
    updateLfgsList: function(json) {
      if (json.hasOwnProperty('games_console_id')) {
        $('.lfgs-table').data('lfgs-games-console-id', json.games_console_id);
        $('th').first().find('div').last().text('Console - ' + json.console_username_type);
        $('tr:first').nextAll().remove();
        $('.lfgs-table tr:last').after(json.lfgs_list);
        $("time.timeago").timeago();
        lfgChannel();
      }
    }
  };
};

//= require channels/lfg

var lfgDeleter = function() {
  return {
    delete: function() {
      var lfgDeleterObject = this;
      var id = $('form.edit_lfg').attr('id').split("lfg_").pop();
      var request = $.ajax({
        method: "DELETE",
        url: "/api/v1/lfgs/" + id,
        data: { id: id }
      });

      request.done(function() {
        App.lfgs.unsubscribe();
        lfgDeleterObject.updateForm();
        setLfgFormAlert("info", "Your LFG Has Been Removed");
        lfgDeleterObject.removeLfgsList();
      });

      request.error(function() {
      });
    },
    updateForm: function() {
      $('.lfg-form').find('h4').text('Create LFG');
      $('.lfg-form-alert').remove();
      $('.edit_lfg').addClass('new_lfg').removeClass('edit_lfg');
      $('.new_lfg').attr('id','new_lfg');
      $('.new_lfg').attr('action', '/lfgs');
      $("input[name='_method']").remove();
      $("#lfg_show_console_username").prop("checked", false);
      $("#lfg_specifics").val("");
      $('#delete-lfg-btn').remove();
    },
    removeLfgsList: function() {
      $('.game-lfgs-list').remove();
    }
  };
};

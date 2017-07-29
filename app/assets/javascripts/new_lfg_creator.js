//= require channels/lfg

var newLfgCreator = function(lfgAttributes) {
  return {
    lfg: lfgAttributes,
    create: function() {
      var lfgCreatorObject = this;
      var request = $.ajax({
        method: "POST",
        url: "/api/v1/lfgs",
        data: { lfg: lfgCreatorObject.lfg }
      });

      request.done(function(response) {
        // lfgCreatorObject.setFlash("notice", "Thank you for your input!");
        lfgCreatorObject.updateForm(response);
        lfgCreatorObject.showLfgsList(response);
        lfgChannel();
      });

      request.error(function() {
        // lfgCreatorObject.setFlash("alert", "There was a problem with your comment.");
      });
    },
    // setFlash: function(type, message) {
    //   $("div.flash").remove();
    //   var flash = $("<div>", { "class": "flash flash-" + type }).text(message);
    //   $("body").prepend(flash);
    // },
    updateForm: function(json) {
      var lfgId = json.lfg.id;
      $('.lfg-form').find('h4').text('Edit LFG');
      $('.new_lfg').addClass('edit_lfg').removeClass('new_lfg');
      $('.edit_lfg').attr('id','edit_lfg_' + lfgId);
      $('.edit_lfg').attr('action', '/lfgs/' + lfgId);
      var hiddenPatchInput = '<input type="hidden" name="_method" value="patch">';
      $('.edit_lfg').prepend(hiddenPatchInput);
      $('div#form-buttons').find('input').removeAttr('disabled');
      var removeButton = `<a class="btn btn-danger" id="delete-lfg-btn" rel="nofollow" data-method="delete" href="/lfgs/${lfgId}">Remove</a>`;
      $('div#form-buttons').append(removeButton);
    },
    showLfgsList: function(json) {
      var lfgsListHtml =  '<div class="col-sm-12 game-lfgs-list">' +
                            '<div class="panel panel-default">' +
                              '<div class="panel-body">' +
                                '<h4 class="text-center">LFGs</h4>' +
                                '<div class="table-responsive">' +
                                  `<table class="table table-striped table-bordered lfgs-table" data-lfgs-games-console-id="${json.games_console_id}">` +
                                    '<tr>' +
                                      '<th class="text-center">' +
                                        '<div>LFG Username</div>' +
                                        `<div>Console - ${json.console_username_type}</div>` +
                                      '</th>' +
                                      '<th class="text-center">Specifics</th>' +
                                      '<th class="text-center">When</th>' +
                                      '<th class="text-center">' +
                                        '<div>Request To</div>' +
                                        '<div>Play Together</div>'+
                                      '</th>' +
                                    '</tr>' +
                                  '</table>' +
                                '</div>' +
                              '</div>' +
                            '</div>' +
                          '</div>';
      $('div.show-game').append(lfgsListHtml);
      $.each(json.lfgs_list, function(index, value) {
        $('.lfgs-table tr:last').after(value);
      });
    }
  };
};

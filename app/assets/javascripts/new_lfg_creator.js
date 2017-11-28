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
        lfgCreatorObject.updateForm(response);
        setLfgFormAlert("info", "You Are Now LFG!");
        lfgCreatorObject.showLfgsList(response);
        listenForChatboxes();
        lfgChannel();
      });

      request.error(lfgFormErrorHandler());
    },
    updateForm: function(json) {
      var lfgId = json.lfg.id;
      $('.lfg-form').find('h4').text('Edit LFG');
      $('.lfg-form-alert').remove();
      $('.new_lfg').addClass('edit_lfg').removeClass('new_lfg');
      $('.edit_lfg').attr('id','edit_lfg_' + lfgId);
      $('.edit_lfg').attr('action', '/lfgs/' + lfgId);
      var hiddenPatchInput = '<input type="hidden" name="_method" value="patch">';
      $('.edit_lfg').prepend(hiddenPatchInput);
      $('div#form-buttons').find('input').removeAttr('disabled');
      var removeButton = '<a class="btn btn-danger" id="delete-lfg-btn" rel="nofollow" data-method="delete" href="/lfgs/' + lfgId + '">Remove</a>';
      $('div#form-buttons').append(removeButton);
    },
    showLfgsList: function(json) {
      var themed_console_color_class;
      if (json.console_username_type.includes("PSN")) {
        themed_console_color_class = 'playstation';
      }
      else if (json.console_username_type.includes("Xbox")) {
        themed_console_color_class = 'xbox';
      }
      var lfgsListHtml =  '<div class="col-sm-12 game-lfgs-list">' +
                            '<div class="panel panel-default">' +
                              '<div class="panel-body">' +
                                '<h4 class="text-center">LFGs</h4>' +
                                '<div class="table-responsive">' +
                                  '<table class="table table-striped table-bordered lfgs-table" data-lfgs-games-console-id="' + json.games_console_id + '">' +
                                    '<tr>' +
                                      '<th class="text-center">' +
                                        '<div><span class="lfg-username">Username</span></div>' +
                                        '<span class="' + themed_console_color_class + '">Console</span> - <span class="' + themed_console_color_class + '">' + json.console_username_type + '</span></div>' +
                                      '</th>' +
                                      '<th class="text-center"><span class="lfgs-specifics-header">Specifics</span></th>' +
                                      '<th class="text-center"><span class="lfg-when">When</span> - <span class="lfg-chat-btns">Chat</span></th>' +
                                    '</tr>' +
                                  '</table>' +
                                '</div>' +
                              '</div>' +
                            '</div>' +
                          '</div>';
      $('div.show-game').append(lfgsListHtml);
      $('.lfgs-table tr:last').after(json.lfgs_list);
      $("time.timeago").timeago();
    }
  };
};

var lfgFormErrorHandler = function() {
  setLfgFormAlert("danger", "Specifics is too long (maximum is 150 characters)");
  setTimeout(function() {
    $('div#form-buttons').find('input').removeAttr('disabled');
  }, 50);
};

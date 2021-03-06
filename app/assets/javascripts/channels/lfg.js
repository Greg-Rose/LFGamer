//= require cable
//= require_self

var lfgChannel = function() {
  if ($('.lfgs-table').length) {
    var lfgsGamesConsoleId = $('.lfgs-table').data('lfgs-games-console-id').toString();
    // If a subscription already exists, remove it
    if (App.hasOwnProperty("lfgs")) {
      App.lfgs.unsubscribe();
      delete App.lfgs;
    }
    // Subscribe to the class name of the channel
    App.lfgs = App.cable.subscriptions.create({
      channel: 'LfgsChannel',
      lfgs_games_console_id: lfgsGamesConsoleId
    }, {
        /**
         * Whenever this channel pushes content, it is received here
         */
        received: function(lfg) {
            var $lfgs = $('tr');
            var $lfg = $('[data-lfg-id="' + lfg.id + '"]');
            if ($lfg.length > 0) {
                // Existing Lfg
                switch (lfg.status) {
                    case 'saved':
                        $lfg.replaceWith(lfg.html);
                        listenForChatboxes();
                        break;

                    case 'deleted':
                        $lfg.remove();
                        break;
                }
            } else {
                // New Lfg
                $('.lfgs-table tr:first').after(lfg.html);
                listenForChatboxes();
            }
            $("time.timeago").timeago();
        }
    });
  }
};

//= require cable
//= require_self

(function() {
    // Subscribe to the class name of the channel
    App.lfgs = App.cable.subscriptions.create('LfgsChannel', {
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
                        break;

                    case 'deleted':
                        $lfg.remove();
                        break;
                }
            } else {
                // New Lfg
                $('.lfgs-table tr:first').after(lfg.html);
            }
            $("time.timeago").timeago();
        }
    });
}).call(this);

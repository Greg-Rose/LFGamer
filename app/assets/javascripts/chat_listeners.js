var listenForChatboxes = function () {

    /**
     * When the send message link is clicked
     * send an ajax request to our rails app with recipient_id
     */

    $('.start-conversation').off('click').click(function (e) {
        e.preventDefault();
        var recipient_id = $(this).data('rid');
        var cid;
        $.post("/conversations", { recipient_id: recipient_id }, function (data) {
            cid = data.conversation_id;
            chatBox.chatWith(cid);
        }).done(function() {
          setTimeout(function() {
            $("#chatbox_" + cid + " .chatboxtextarea").focus();
          }, 100);
        });
    });

    /**
     * Used to minimize the chatbox
     */

    changeChatBox("minimize");

    /**
     * Used to close the chatbox
     */

    changeChatBox("close");

    /**
     * Listen on keypress' in our chat textarea and call the
     * chatInputKey in chat.js for inspection
     */

    $(document).on('keydown', '.chatboxtextarea', function (event) {
        var id = $(this).data('cid');
        chatBox.checkInputKey(event, $(this), id);
    });

};

// params: "minimize" or "close"
var changeChatBox = function(type) {
  var className;
  if(type == "minimize") {
    className = ".toggleChatBox";
  }else if (type == "close") {
    className = ".closeChat";
  }else {
    return undefined;
  }

  $(document).off('click', className).on('click', className, function (e) {
      e.preventDefault();

      var id = $(this).data('cid');
      if(type == "minimize") {
        chatBox.toggleChatBoxGrowth(id);
      }else {
        chatBox.close(id);
      }
  });
};

$(document).ready(listenForChatboxes);

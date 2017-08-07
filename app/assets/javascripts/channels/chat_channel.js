//= require cable
//= require_self

var chatChannel = function(chatboxId) {
  if (!App.hasOwnProperty("chat" + chatboxId)) {
    App["chat" + chatboxId] = App.cable.subscriptions.create({
      channel: 'ChatsChannel',
      conversation_id: chatboxId
    }, {
        /**
         * Whenever this channel pushes content, it is received here
         */
        received: function(message) {
          var otherUsersUsername = $("#chatbox_" + chatboxId + " .chatboxtitle").find("h1").text();

          if (message.status == 'sent') {
            if ($("#chatbox_" + chatboxId).length > 0) {
              html = $.parseHTML(message.html);
              if ($(html).hasClass('msg-usr-' + otherUsersUsername)) {
                $(html).addClass('other');
              }
              else {
                $(html).addClass('self');
              }
              $("#chatbox_" + chatboxId + " .chatboxcontent").append(html);
              $("#chatbox_" + chatboxId + " .chatboxcontent").scrollTop($("#chatbox_" + chatboxId + " .chatboxcontent")[0].scrollHeight);
            }
            else {
              chatBox.chatWith(chatboxId);
            }
          }
          else if (message.status == 'deleted') {
            var deletedMessage = $.parseHTML("<li>" + otherUsersUsername + " has left the chat</li>");
            $("#chatbox_" + chatboxId + " .chatboxcontent").append(deletedMessage);
            $("#chatbox_" + chatboxId + " .chatboxcontent").scrollTop($("#chatbox_" + chatboxId + " .chatboxcontent")[0].scrollHeight);
            $("#chatbox_" + chatboxId + " .chatboxtextarea").prop("disabled", true);
          }
        },
        send_message: function(message, conversationId) {
          return this.perform('send_message', {
            message: message,
            conversation_id: conversationId
          });
        }
    });
  }
};

var checkForChats = function() {
  $.get( "/conversations", function( data ) {
    var chatChannels = data.conversation_ids;
    if (chatChannels.length) {
      $.each(chatChannels, function(key, value) {
        if (!App.hasOwnProperty("chat" + value)) {
          chatBox.chatWith(value);
        }
      });
    }
  });
};

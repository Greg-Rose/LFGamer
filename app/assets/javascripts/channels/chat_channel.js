//= require cable
//= require_self

var chatChannel = function(chatboxId) {
  App["chat" + chatboxId] = App.cable.subscriptions.create({
    channel: 'ChatsChannel',
    conversation_id: chatboxId
  }, {
      /**
       * Whenever this channel pushes content, it is received here
       */
      received: function(message) {
        html = $.parseHTML(message.html);
        var otherUsersUsername = $("#chatbox_" + chatboxId + " .chatboxtitle").find("h1").text();
        if ($(html).hasClass('msg-usr-' + otherUsersUsername)) {
          $(html).addClass('other');
        }
        else {
          $(html).addClass('self');
        }
        $(`#chatbox_${chatboxId} .chatboxcontent`).append(html);
        $("#chatbox_" + chatboxId + " .chatboxcontent").scrollTop($("#chatbox_" + chatboxId + " .chatboxcontent")[0].scrollHeight);
      },
      send_message: function(message, conversationId) {
        return this.perform('send_message', {
          message: message,
          conversation_id: conversationId
        });
      }
  });
};

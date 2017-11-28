var chatboxFocus = [];
var chatBoxes = [];

var ready = function () {
    chatBox = {
        chatWith: chatWith,
        close: chatClose,
        notify: chatNotify,
        restructure: chatRestructure,
        createChatBox: createChatBox,
        checkInputKey: chatCheckInputKey,
        toggleChatBoxGrowth: toggleChatBoxGrowth
    };
};

/**
 * creates an inline chatbox on the page by calling the
 * createChatBox function passing along the unique conversation_id
 *
 * @param conversation_id
 */

var chatWith = function (conversation_id) {

    chatBox.createChatBox(conversation_id);
    $("#chatbox_" + conversation_id + " .chatboxtextarea").focus();
    chatBox.restructure();
};

/**
 * closes the chatbox by essentially hiding it from the page
 *
 * @param conversation_id
 */

var chatClose = function (conversation_id) {
    $('#chatbox_' + conversation_id).remove();
    chatBoxes.splice(chatBoxes.indexOf(conversation_id), 1);
    if (App.hasOwnProperty("chat" + conversation_id)) {
      App["chat" + conversation_id].unsubscribe();
      delete App["chat" + conversation_id];
    }
    chatBox.restructure();

    var request = $.ajax({
      method: "DELETE",
      url: "/conversations/" + conversation_id,
      data: { id: conversation_id }
    });

    request.done(function() {
    });

    request.error(function() {
    });
};

/**
 * Plays a notification sound when a new chat message arrives
 */

var chatNotify = function () {
    var audioplayer = $('#chatAudio')[0];
    audioplayer.play();
};

/**
 * Handles 'smart layouts' of the chatboxes. Like when new chatboxes are
 * added or removed from the view, it restructures them so that they appear
 * neatly aligned on the page
 */

var chatRestructure = function () {
    align = 0;
    totalWidth = 0;
    for (var x in chatBoxes) {
        chatbox_id = chatBoxes[x];

        if ($("#chatbox_" + chatbox_id).css('display') !== 'none') {
            if (align === 0) {
                $("#chatbox_" + chatbox_id).css('right', '20px');
                totalWidth += 20;
            } else {
                $("#chatbox_" + chatbox_id).css('right', totalWidth + 'px');
            }
            align++;
            totalWidth += $("#chatbox_" + chatbox_id).width() + 7;
        }
    }

};

/**
 * Takes in two parameters. It is responsible for fetching the specific conversation's
 * html and appending it to the page e.g if conversation_id = 1
 *
 * $.get("conversations/1, function(data){
 *    // rest of the logic here
 * }, "html")
 *
 * @param conversation_id
 * @param minimizeChatBox
 */

var createChatBox = function (conversation_id, minimizeChatBox) {
    if ($("#chatbox_" + conversation_id).length > 0) {
      if ($("#chatbox_" + conversation_id).css('display') === 'none') {
          $("#chatbox_" + conversation_id).css('display', 'block');
          chatBox.restructure();
      }
      $("#chatbox_" + conversation_id + " .chatboxtextarea").focus();
      return;
    }

    $("body").append('<div id="chatbox_' + conversation_id + '" class="chatbox"></div>');

    getConversation(conversation_id);

    $("#chatbox_" + conversation_id).css('bottom', '0px');

    chatBoxeslength = 0;

    for (var x in chatBoxes) {
        if ($("#chatbox_" + chatBoxes[x]).css('display') !== 'none') {
            chatBoxeslength++;
        }
    }

    if (chatBoxeslength === 0) {
        $("#chatbox_" + conversation_id).css('right', '20px');
    } else {
        width = (chatBoxeslength) * (280 + 7) + 20;
        $("#chatbox_" + conversation_id).css('right', width + 'px');
    }

    chatBoxes.push(conversation_id);

    setChatBoxFocus(conversation_id);

    $("#chatbox_" + conversation_id).show();
    chatChannel(conversation_id);
};

var getConversation = function(conversation_id) {
  $.get("/conversations/" + conversation_id, function (data) {
      var html = $.parseHTML(data);
      var title = $(html[0]).children()[0];
      var h1 = $(title).children()[1];
      var otherUsersUsername = $(h1).text();
      $(html[2]).children("li").addClass('self');
      $(html[2]).children("li.msg-usr-" + otherUsersUsername).removeClass('self').addClass('other');
      $('#chatbox_' + conversation_id).append(html);
      $("#chatbox_" + conversation_id + " .chatboxcontent").scrollTop($("#chatbox_" + conversation_id + " .chatboxcontent")[0].scrollHeight);
  }, "html");
};

var setChatBoxFocus = function(conversation_id) {
  chatboxFocus[conversation_id] = false;

  $("#chatbox_" + conversation_id + " .chatboxtextarea").blur(function () {
      chatboxFocus[conversation_id] = false;
      $("#chatbox_" + conversation_id + " .chatboxtextarea").removeClass('chatboxtextareaselected');
  }).focus(function () {
      chatboxFocus[conversation_id] = true;
      $('#chatbox_' + conversation_id + ' .chatboxhead').removeClass('chatboxblink');
      $("#chatbox_" + conversation_id + " .chatboxtextarea").addClass('chatboxtextareaselected');
  });

  $("#chatbox_" + conversation_id).click(function () {
      if ($('#chatbox_' + conversation_id + ' .chatboxcontent').css('display') !== 'none') {
          $("#chatbox_" + conversation_id + " .chatboxtextarea").focus();
      }
  });
};

/**
 * Responsible for listening to the keypresses when chatting. If the Enter button is pressed,
 * we submit our conversation form to our rails app
 *
 * @param event
 * @param chatboxtextarea
 * @param conversation_id
 */

var chatCheckInputKey = function (event, chatboxtextarea, conversationId) {
    if (event.keyCode === 13 && event.shiftKey === false) {
        event.preventDefault();
        event.stopPropagation();

        message = chatboxtextarea.val();
        message = message.replace(/^\s+|\s+$/g, "");

        if (message !== '') {
            App["chat" + conversationId].send_message(message, conversationId);
            $(chatboxtextarea).val('');
            $(chatboxtextarea).focus();
            $(chatboxtextarea).css('height', '44px');
        }
    }

    var adjustedHeight = chatboxtextarea.clientHeight;
    var maxHeight = 94;

    if (maxHeight > adjustedHeight) {
        adjustedHeight = Math.max(chatboxtextarea.scrollHeight, adjustedHeight);
        if (maxHeight)
            adjustedHeight = Math.min(maxHeight, adjustedHeight);
        if (adjustedHeight > chatboxtextarea.clientHeight)
            $(chatboxtextarea).css('height', adjustedHeight + 8 + 'px');
    } else {
        $(chatboxtextarea).css('overflow', 'auto');
    }
};

/**
 * Responsible for handling minimize and maximize of the chatbox
 *
 * @param conversation_id
 */

var toggleChatBoxGrowth = function (conversation_id) {
    if ($('#chatbox_' + conversation_id + ' .chatboxcontent').css('display') === 'none') {
        $('#chatbox_' + conversation_id).removeClass('chatboxminimized');
        $('#chatbox_' + conversation_id + ' .chatboxcontent').css('display', 'block');
        $('#chatbox_' + conversation_id + ' .chatboxinput').css('display', 'block');
        $("#chatbox_" + conversation_id + " .chatboxcontent").scrollTop($("#chatbox_" + conversation_id + " .chatboxcontent")[0].scrollHeight);
    } else {
        $('#chatbox_' + conversation_id + ' .chatboxcontent').css('display', 'none');
        $('#chatbox_' + conversation_id + ' .chatboxinput').css('display', 'none');
        $('#chatbox_' + conversation_id).addClass('chatboxminimized');
    }

    chatBox.restructure();
};

$(document).ready(ready);

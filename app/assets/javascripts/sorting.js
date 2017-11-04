$(document).ready(function(){
  sortListener();
});

var sortListener = function () {
  if ($(".index-games-sort").length) {
    $(".index-games-sort a").click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      $.getScript(this.href, function() {
        sortListener();
      });
    });
  }
};

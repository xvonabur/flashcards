$(document).ready(function () {
  if($('#translation_check').length > 0) {
    for (i = 0; i < 60; i++) {
      setTimeout(function(){ setAnswerTime($('#card_answer_time')) }, 1000 * i);
    }
  }
});

function setAnswerTime(domID) {
  var currentValue = parseInt(domID.val(), 10);
  domID.val(++currentValue);
}

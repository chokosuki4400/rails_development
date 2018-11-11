// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

var charcount = function (str) {
  len = 0;
  str = escape(str);
  for (i=0;i<str.length;i++,len++) {
    if (str.charAt(i) == "%") {
      if (str.charAt(++i) == "u") {
        i += 3;
        len++;
      }
      i++;
    }
  }
  return len;
}

window.onload = function(){

  var textArea = document.getElementById("c-validation__area");
  var checkText = document.getElementById("c-validation__count");
  var submitBtn = document.getElementById("c-validation__submit");
  var textValue = textArea.value;
  var textCount = charcount(textValue);
  checkText.innerHTML = textCount;

  textArea.addEventListener("keyup",function(){
    var textValue = textArea.value;
    var textCount = charcount(textValue);

    checkText.innerHTML = textCount;

    if(textCount <= 238){
      textArea.style.borderColor = "#4E84FF";
      submitBtn.disabled = false;
    }else{
      textArea.style.borderColor = "red";
      submitBtn.disabled = true;
    }
    console.log(textCount);
  });
}

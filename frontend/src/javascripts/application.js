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

  var entryTextArea = document.getElementById("message_message_text");
  var entrySubmitBtn = document.getElementById("c-validation__entry");

  if(entryTextArea != null && entrySubmitBtn != null) {
    entrySubmitBtn.disabled = true;

    entryTextArea.addEventListener("keyup",function(){
      var entryTextValue = entryTextArea.value;
      var entryTextCount = charcount(entryTextValue);

      if(entryTextCount == 0 ){
        entrySubmitBtn.disabled = true;
      }else{
        entrySubmitBtn.disabled = false;
      }
    });
  }

  var textArea = document.getElementById("c-validation__area");
  var checkText = document.getElementById("c-validation__count");
  var submitBtn = document.getElementById("c-validation__submit");

  if(textArea != null) {

    var textValue = textArea.value;
    var textCount = charcount(textValue);
    checkText.innerHTML = textCount;

    textArea.addEventListener("keyup",function(){
      var textValue = textArea.value;
      var textCount = charcount(textValue);

      checkText.innerHTML = textCount;

      if(textCount == 0){
        textArea.style.borderColor = "red";
        submitBtn.disabled = true;
      }else if (textCount >= 238 ) {
        textArea.style.borderColor = "red";
        submitBtn.disabled = true;
      }else{
        textArea.style.borderColor = "#4E84FF";
        submitBtn.disabled = false;
      }
    });
  }
}

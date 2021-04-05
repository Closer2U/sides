window.onload = function() {
  document.getElementById('dark_field').value = '';
  }

function makePassword(maxLengthPass) {
   // initialize vars
   // get Input PW Length from input-field
    var maxLengthPass = document.getElementById("dark_field").value;
    var generatedPassword = "";
    var chars = document.getElementById("charsChecked").checked;
    var numbers =  document.getElementById("numbersChecked").checked;

   // Create allPossibilities var
    var possibleLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
     var possibleNumbers = "0123456789";
     var possibleChars = "()-+#_<>/*[]~%&€!?=:@.;{}";
     var allPossibilities = "";

   // create allPossibilities string //OPTIMIZE find better, more efficient solution!
    if(chars == true){
      allPossibilities = possibleLetters + possibleChars;
      console.log(allPossibilities);
    }

    if(numbers == true){
      allPossibilities = possibleLetters + possibleNumbers;
      console.log(allPossibilities);
    }

    if(numbers == true && chars == true){
      allPossibilities = possibleLetters + possibleNumbers + possibleChars;
      console.log(allPossibilities);
    }

    if(numbers == false && chars == false){
      allPossibilities = possibleLetters;
      console.log(allPossibilities);
    }

   // get the Length of allPossibilities var
    var size = allPossibilities.length;
    
   // generate the PW
    for (var i = 0; i < maxLengthPass; ++i) {
       generatedPassword = generatedPassword + allPossibilities.charAt(Math.floor(Math.random() * size));
    }
    console.log(generatedPassword);

    var pwBox = document.getElementById("yourPassword");
    pwBox.innerHTML = generatedPassword;

    // console.log('pwLength: ' + pwLength);
     console.log('maxLengthPass: ' + maxLengthPass);

    if(maxLengthPass == '') {
      alert("*Password length* was empty. \nPlease input number.")
    }

    document.getElementById("isCopied").style.opacity = 0;
    return maxLengthPass;
    // return pwBox;
    // return generatedPassword; 
 }

 console.log(makePassword(5));
 console.log(makePassword(pwLength));
 console.log(makePassword(maxLengthPass));

 function copyPW(){
    copyer("yourPassword");
    window.getSelection().removeAllRanges();
    document.getElementById("isCopied").style.opacity = 1;

     
    /*alert --> fixen, damit angezeigt wird, was kopiert wurde */

}

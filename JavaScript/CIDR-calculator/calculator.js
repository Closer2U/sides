//TODO get current IP via API

function calculate(firstTrip , secondTrip , thirdTrip , fourthTrip, hostAmount2){
   /* read all user input Triplets*/
    var firstTrip = document.getElementById("firstTriplet").value;
    var secondTrip = document.getElementById("secondTriplet").value;
    var thirdTrip = document.getElementById("thirdTriplet").value;
    var fourthTrip = document.getElementById("fourthTriplet").value;
       
    /* join Triplets to ip */
        var ip = firstTrip + "." + secondTrip + "." + thirdTrip + "." + fourthTrip;
        console.log("Concated ip: " + ip);

    var hostAmount = document.getElementById("hostAmount2").value;
        console.log("How many hosts? " + hostAmount);

    // Number of hosts to accommodate --> calculate CIDR table SUFFIX
    var suffixHelper = Math.ceil(Math.log2(hostAmount));
        console.log(suffixHelper);
        //TODO output into html 
    var maxHosts = Math.pow(2, suffixHelper)-2;
        console.log("Max hosts with given suffix: " + maxHosts);
        //TODO output into html 
    

}

// SLIDER
//__-------------------------------------------
// var slider = document.getElementById("hostAmount").value;
// var output = document.getElementById("demo");
// output.innerHTML = slider.value;

// function sliderValue(slider) {
// output.innerHTML = this.value;
// console.log(slider);
// }
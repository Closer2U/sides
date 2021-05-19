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
         console.log("How many hosts? (userInput) " + hostAmount);
 
     // Number of hosts to accommodate --> calculate CIDR table SUFFIX
     var suffixHelper = Math.ceil(Math.log2(hostAmount));
         console.log("suffix" + suffixHelper);
         //TODO output into html  --> /suffix
 
     var netBit = suffixHelper;
         console.log("Network Bit: " + netBit);
         //TODO output into html 
 
     var hostBit = 32 - netBit;
         console.log("Host Bits: " + hostBit);
         //TODO output into html 
 
     var maxSubnets = Math.pow(2, netBit);
         console.log("maximum Subnets in Network: " + maxSubnets);
         //TODO this is WRONG! -- must be immensively high number;
 
     var maxHosts = Math.pow(2, hostBit);
         console.log("Max hosts per subnet with given suffix: " + maxHosts);
         //TODO output into html 
 
     var a = 32;
         console.log("Testing bitwise Subnetmask: " + (a >> hostBit));    
 
 
 
 
 
     
 
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
 
// TODO get current IP via API
// TODO use array methods (.join etc) consistently --> fix esp. subnetmask und so
    
function calculate(firstTrip, secondTrip, thirdTrip, fourthTrip, hostAmount2) {
    /* read all user input Triplets*/
    var firstTrip = document.getElementById("firstTriplet").value;
    var secondTrip = document.getElementById("secondTriplet").value;
    var thirdTrip = document.getElementById("thirdTriplet").value;
    var fourthTrip = document.getElementById("fourthTriplet").value;
    
    /* ====== push nTrips into array  ====
        TODO use this array instead of var in entire script!!!!
    */
        let ipArr = [
            firstTrip,
            secondTrip,
            thirdTrip,
            fourthTrip,
        ];

/* ===== join Triplets to ip ===== */
    var ip = firstTrip + "." + secondTrip + "." + thirdTrip + "." + fourthTrip;
    console.log("Concated ip: " + ip);


//==========================
//======= INPUT ============

    // ======= User input how many Computers need to be joined? =====
    var hostAmount = document.getElementById("hostAmount2").value;
    console.log("How many hosts? (userInput) " + hostAmount);
    // !!! display error message if forgot to fill 
    // TODO display error message if forgot to fill 
    
    /* function below freezes browser-tab completely */
    // if (hostAmount == "") {
        // confirm("Please enter number of required hosts!");
        
    // }


//==========================
//======= OUTPUT ===========

    // ===== Number of hosts to accommodate --> calculate CIDR table SUFFIX
    var suffix = 32 - Math.ceil(Math.log2(hostAmount));
    // 
    document.getElementById("suffix").placeholder = suffix;
    console.log("suffix .innerHTML: " + document.getElementById("suffix").innerHTML.valueOf());

    // ==== trying to solve problem to write into INPUT field
            // let suffixtest = document.getElementById("suffix").innerHTML.valueOf();
            // document.getElementById("suffix").innerHTML = suffixtest;
            // console.log("suffixtest: " + suffixtest);

    console.log("suffix: " + suffix);
    //TODO output into html  --> /suffix

    var netBit = suffix;
    console.log("Network Bit: " + netBit);
    document.getElementById("networkBits").innerHTML = netBit;

    var hostBit = 32 - netBit;
    console.log("Host Bits: " + hostBit);
    document.getElementById("hostBits").innerHTML = hostBit;

    var maxSubnets = Math.pow(2, netBit);
    console.log("maximum Subnets in Network: " + maxSubnets);
    document.getElementById("subnetMax").innerHTML = maxSubnets;

    var maxHosts = Math.pow(2, hostBit);
    console.log("Max hosts per subnet with given suffix: " + maxHosts);
    document.getElementById("hostMax").innerHTML = maxHosts;

    //  var a = netBit.toString(2);
    //      b = a << 8;
    //      console.log("Testing bitwise Subnetmask: " + (a.toString(2)));    




    var subnetmaskBinarySplit;
    var arr = [];
    var subnetmask = function() {
        var subnetmaskHelper = '';
        for (var i = 0; i < hostBit; i++) {
            subnetmaskHelper = subnetmaskHelper + 1;
        };
        console.log("subnetmaskHelper before BitShift: " + subnetmaskHelper);


        // ====== concat the 0s up to 32 =====
        console.log(subnetmaskHelper.length)
        for (j = subnetmaskHelper.length; j < 32; j++) {
            subnetmaskHelper = subnetmaskHelper + 0;
        };
        console.log("concated String: " + subnetmaskHelper);


        // ========== split into octets --> not yet awesome... ======
        subnetmaskBinary = subnetmaskHelper.toString(2).match(/.{1,8}/g);
        console.log("Octets: " + subnetmaskBinary);
        subnetmaskBinarySplit = subnetmaskBinary.toString().split(',');
            // !!! returns ARRAY!!!!!

        // ======== join binary array with '.'
        // subnetmaskBinaryFinal = subnetmaskBinarySplit.join('.');
        // console.log(subnetmaskBinaryFinal);

        // ========= convert binaries to decimal
        // https://stackoverflow.com/questions/9329446/for-each-over-an-array-in-javascript
        var index;

        for (index = 0; index < subnetmaskBinarySplit.length; ++index) {
            decimal = parseInt((subnetmaskBinarySplit[index]), 2);
            arr.push(decimal);
            console.log(decimal);
        }

        subnetmaskFinal = arr.join('.'); // var  subnetmaskFinal = arr.join('.');

        document.getElementById("subnetmask").innerHTML = subnetmaskFinal;
    };
    subnetmask();


// ====== function to invert numbers
    var wildcardmaskHelper = [];
    var wildcardmask = function() {

        var wildcardmaskHelperB = "";
        // ======= call convert() for each item in subnetmaskBinarySplit 
        subnetmaskBinarySplit.forEach(convert);

            /* ====== das passiert eigentlich alles erst nach convert(item)*/
            // ====== entferne letzten Punkt bei 0.0.0.127.
            var willdcardmaskFinal = wildcardmaskHelperB.slice(0, -1);
            document.getElementById("wildcardmask").innerHTML = willdcardmaskFinal;
            
            // ====== wird von subnetmaskBinarySplit.forEach() aufgerufen
            function convert(item) {
                var octettItem = "";
                for (let index = 0; index < item.length; index++) {
                    // ======= konvertieren subnetmaske und rechnen alles -1 --> invertieren sozusagen 0en und 1sen
                    let _inverted = Math.abs(parseInt(item[index], 10) - 1);
                    // ======= je 8 Mal durchlaufen (Bits) --> fügt zu einem Byte (8) zusammen

                    octettItem += _inverted.toString();
                
                };
                // ====== hier werden alle Bytes zur wildcardmask 'concated'
                wildcardmaskHelperB += parseInt(octettItem, 2) + ".";

                // TODO use wildcardmaskHelper.join('.') instead of this string-Kauderweltsch oben
                wildcardmaskHelper.push(parseInt(octettItem, 2));
                    console.table(wildcardmaskHelper);
                
            };

    };
    wildcardmask();
    
    
    var networkaddressHelper = [];
    var networkaddress = function() {
        /* === Herleitung der oben aufgeführten for-Schleife
            console.log((parseInt(secondTrip,10)) + " " + " & "  + arr[1] + " " + " " + " = "+ (parseInt(secondTrip,10)&arr[1])); //112.3.2.0
        */
        
        // ===== Bitwise AND von den IPTriplets und den SubnetmaskBits (arr[]) ====
        for (j = 0; j < ipArr.length; ++j) {
            //console.log(parseInt(ipArr[j],10) + " " + (arr[j]));
            netByte = (parseInt(ipArr[j],10) & arr[j]);
                networkaddressHelper.push(netByte);
        };
 
        networkaddressFinal = networkaddressHelper.join('.'); 
        document.getElementById("networkAddress").innerHTML = networkaddressFinal;
        /* ### DEBUG only
            console.log("*** networkaddressHelper *** Array below: ");
            console.table(networkaddressHelper);
        */
    };
    networkaddress();
    
    var broadcastaddressHelper = [];
    var broadcastaddress = function() {
        // console.log((parseInt(ipArr[0],10)) + " " + " & "  + (parseInt(wildcardmaskHelper[0],10)) + " " + " " + " = "+ (parseInt(ipArr[0],10)|parseInt(wildcardmaskHelper[0],10))); //112.3.2.127
        
        // ===== Bitwise OR von den IPTriplets und den wildcardmask-items ====
        for (k = 0; k < ipArr.length; ++k) {
            broadByte = (parseInt(ipArr[k],10) | parseInt(wildcardmaskHelper[k],10));
                broadcastaddressHelper.push(broadByte);
        };
        
        broadcastaddressFinal = broadcastaddressHelper.join('.'); 
        document.getElementById("broadcastAddress").innerHTML = broadcastaddressFinal;
    };
    broadcastaddress();
}


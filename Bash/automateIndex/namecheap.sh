#!/usr/bin/env bash 

####################################################################################################
# >> Register a domain with namecheap. Automatically sets hosts <<                                 #
#                                                                                                  #
# 16.01.2024    -   E                                                                              #
#   TODO: (✔)Errors/Success-Meldungen abfangen (if)                                                #
#         (✔)Testen  setDns()                                                                      #
#         ( )debug-Option für cURL --> via parameter -z                                            #
#                                                                                                  #
# 17.01.2024    -   E                                                                              #
#         (✔) curl Error in bash 5.1.16 --> in URL alle Leerzeichen durch %20 ersetzt              #
#                                                                                                  #
# 08.02.2024    -   E                                                                              #
#         (✔) add WhoisGuard                                                                       #
#                                                                                                  #
####################################################################################################

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "-------------------------------------"
   echo 
   echo "Registrieren einer Namecheap-Domain"
   echo
   echo "Syntax: namecheap.sh [-h|d]"
   echo "options:"
   echo "   h   Diese Hilfe anzeigen."
   echo "   d   * Domain-Name"
   echo 
   echo "Beispiel: ./namecheap.sh -d <DOMAIN>"
   echo
   echo "-------------------------------------"
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

############################################################
# Process the input options.                               #
############################################################
# Get the domain from user input
while getopts "hd:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      d) Domain=$OPTARG;;
      *) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

############################################################
# Set variables                                            #
############################################################
ApiKey="000000"
User="00000"
ClientIP=$(dig @resolver4.opendns.com myip.opendns.com +short)
FirstName=""
LastName="00000"
Address1="0000000"
City="0000"
StateProvince="000000"
PostalCode="00000"
Country="Germany"
Phone="000000"
EmailAddress="000000"

# Split Domain into SLD and TLD
SLD=$(echo $Domain | cut -d'.' -f1) 
TLD=$(echo $Domain | cut -d'.' -f2-)
 

############################################################
# Build "create" Request and cURL                          #
############################################################
registerDomain(){
  echo
  echo -e "\033[1m Registriere Domain...\033[10"
  echo
  curl https://api.namecheap.com/xml.response?ApiUser="$User"\&ApiKey="$ApiKey"\&UserName="$User"\&Command=namecheap.domains.create\&ClientIp="$ClientIP"\&DomainName="$Domain"\&Years=1\&AuxBillingFirstName="$FirstName"\&AuxBillingLastName="$LastName"\&AuxBillingAddress1="$Address1"\&AuxBillingStateProvince="$StateProvince"\&AuxBillingPostalCode="$PostalCode"\&AuxBillingCountry="$Country"\&AuxBillingPhone="$Phone"\&AuxBillingEmailAddress="$EmailAddress"\&AuxBillingOrganizationName=syret\&AuxBillingCity="$City"\&TechFirstName="$FirstName"\&TechLastName="$LastName"\&TechAddress1="$Address1"d\&TechStateProvince="$StateProvince"\&TechPostalCode="$PostalCode"\&TechCountry="$Country"\&TechPhone="$Phone"\&TechEmailAddress="$EmailAddress"\&TechOrganizationName=NC\&TechCity="$City"\&AdminFirstName="$FirstName"\&AdminLastName="$LastName"\&AdminAddress1="$City"\&AdminStateProvince="$StateProvince"\&AdminPostalCode=9004\&AdminCountry="$Country"\&AdminPhone="$Phone"\&AdminEmailAddress=info@syret.de\&AdminOrganizationName=syret\&AdminCity="$City"\&RegistrantFirstName="$FirstName"\&RegistrantLastName="$LastName"\&RegistrantAddress1="$Address1"d\&RegistrantStateProvince=CS\&RegistrantPostalCode="$PostalCode"\&RegistrantCountry="$Country"\&RegistrantPhone="$Phone"\&RegistrantEmailAddress=info@syret.de\&RegistrantOrganizationName=syret\&RegistrantCity="$City"\&AddFreeWhoisguard=yes\&WGEnabled=yes
}

############################################################
# Build "setHosts" Request and cURL                        #
############################################################
setDns(){
  echo
  echo -e "\033[1m Richte DNS-records ein...\033[10"
  echo
  curl https://api.namecheap.com/xml.response?apiuser="$User"\&apikey="$ApiKey"\&username="$User"\&Command=namecheap.domains.dns.setHosts\&ClientIp="$ClientIP"\&SLD="$SLD"\&TLD="$TLD"\&HostName2=@\&RecordType2=A\&Address2=5.45.109.248\&TTL2=60\&HostName3=*\&RecordType3=A\&Address3=5.45.109.248\&TTL3=60\&HostName4=@\&RecordType4=TXT\&Address4="0000000"\&TTL4=60\&HostName5=_dmarc\&RecordType5=TXT\&Address5="v=DMARC1;%20p=none"\&TTL5=60\&HostName6=dkim._domainkey\&RecordType6=TXT\&Address6="v=DKIM1;k=rsa;t=s;s=email;p=000000000"\&TTL6=60\&HostName7=@\&RecordType7=MX\&Address7="0000000(Mailserver)"\&MXPref7=10\&EmailType=MX\&TTL7=60

}

############################################################
# init                                                     #
############################################################
__main__(){
  registerDomain
  setDns
}

__main__

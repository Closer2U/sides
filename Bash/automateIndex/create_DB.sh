#!/bin/bash

#########################################################################
# Changelog                                                             #
#########################################################################
# 22.01.24 - E      FIX auto-increment id-parameter von teams-login     #
#                   verhindert, dass jede ID nur einmal genutzt werden  #
#                   kann.                                               #
#                                                                       #
#########################################################################


############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Zum Erstellen von Datenbank, Nutzer und Tables für unsere "
   echo " Social Engineering Kampagnen."
   echo
   echo "Syntax: create_DB.sh [-h|n|t]"
   echo "options:"
   echo "   h   Print this Help."
   echo "   n   * username and database name"
   echo "   t   * Art der Kampagne"
   echo "          parameter: [afs|google|teams] "
   echo 
   echo "Beispiel: ./create_DB.sh -n <DATENBANKNAME> -t afs"
   echo
}

####################################

afs_c() {
mysql -u root -p${rootpasswd} -e "${query_afs}"
}

google_c () {
mysql -u root -p${rootpasswd} -e "${query_google}"
}

teams_c() {
mysql -u root -p${rootpasswd} -e "${query_teams}"
}


result(){
echo "MySQL user and database created."
echo '$servername = "127.0.0.1";'
echo "\$username = $Name;" 
echo "\$password = ${PASS};"
echo "\$dbname = $Name;"
}
############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Set variables
Name="test"
Type="teams"
PASS=`openssl rand -base64 8`

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hn:t:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      n) Name=$OPTARG;;
      t) Type=$OPTARG;;
      \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo
echo  "-----------------"
echo -e "\033[1m Please enter root user MySQL password! \033[0m"
echo " Note: password will be hidden when typing"
read -s rootpasswd

query_afs=$(cat << EOF
CREATE DATABASE $Name;
CREATE USER '$Name'@'localhost' IDENTIFIED BY '$PASS';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, DROP, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON $Name.* TO '$Name'@'localhost';
USE $Name;
CREATE TABLE \`user\` (
  \`id\` int(11) NOT NULL primary key auto_increment,
  \`user\` text NOT NULL,
  \`time\` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TABLE \`token\` (
  \`id\` int(11) NOT NULL primary key auto_increment,
  \`token\` text NOT NULL,
  \`time\` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

EOF
)

query_teams=$(cat << EOF
CREATE DATABASE $Name;
CREATE USER '$Name'@'localhost' IDENTIFIED BY '$PASS';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, DROP, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON $Name.* TO '$Name'@'localhost';
USE $Name;
CREATE TABLE \`username\` (
  \`id\` int(11) NOT NULL primary key auto_increment, 
  \`campaign\` int(11) NOT NULL,
  \`username\` text NOT NULL,
  \`time\` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE \`userparameter\` (
  \`id\` int(11) NOT NULL primary key auto_increment, 
  \`campaign\` int(11) NOT NULL,
  \`username\` text NOT NULL,
  \`time\` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

EOF
)

query_google=$(cat << EOF
CREATE DATABASE $Name;
CREATE USER '$Name'@'localhost' IDENTIFIED BY '$PASS';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, INDEX, DROP, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON $Name.* TO '$Name'@'localhost';
USE $Name;
CREATE TABLE \`token\` (
  \`token\` text NOT NULL,
  \`time\` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE \`user\` (
  \`user\` text NOT NULL,
  \`time\` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
EOF
)



case $Type in
    afs) afs_c
        result
      exit;;
    google | gdrive | youtube) google_c
        result
        exit;;
    teams | ms | microsoft) teams_c
        result
        exit;;
    \?) echo "invalid"
        Help
        exit;;    
esac
    


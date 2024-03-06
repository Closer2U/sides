#!/usr/bin/env bash

################################################################################
#                               redirect.sh                                    #
#                                                                              #
# *Angaben:* Fake-Domain, echte Domain                                         #
# *Vorlagen:* Microsoft 365, OWA, Google (Youtube/G-Drive), AFS                #
# *Aufgabe:* Holt sich ein SSL-Zertifikat für Fake-Domain mit und ohne www     #
#  und richtet eine Umleitung ein (siehe XXXX.de)                            #
#                                                                              #
# Change History                                                               #
# 02.08.2023  E   Original code.                                               #
# 10.08.2023  E   Kommentare einfügen und aufräumen                            # 
#                                                                              #
#                                                                              #
#                                                                              #
################################################################################
################################################################################

################################################################################
# Error Handling                                                               #
################################################################################
set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes


################################################################################
# Farbcode Deklaration                                                         #
################################################################################
RED="\e[31m"
ITALICRED="\e[3;${RED}m"
GREEN="\e[32m"
BOLDGREEN="\e[1;${GREEN}m"
BOLD="\e[1m"
LIGHTCYAN="\e[96m"
GREY="\e[37m"
STRIKETHORUGH="\e[9m"
RESET="\e[0m"


################################################################################
# Variablen Deklaration                                                        #
################################################################################
SITESAVAILABLE="/etc/nginx/sites-available"
SITESENABLED="/etc/nginx/sites-enabled"
TEMPLATEDIR="/var/www/_templates/_configs"
declare -x realeDomain
declare -x fakeDomain


################################################################################
################################################################################
#                            Main Program                                      #
################################################################################
################################################################################
change_dir() { cd "$SITESAVAILABLE"; }

get_userinput() {
    clear
    printf "\n=============================================================================\n"
    printf "=============================================================================\n"
    printf "\n"
    printf "            ███████████████████████████████████████████████\n"
    printf "            █▄─▄▄▀█▄─▄▄─█▄─▄▄▀█▄─▄█▄─▄▄▀█▄─▄▄─█─▄▄▄─█─▄─▄─█\n"
    printf "            ██─▄─▄██─▄█▀██─██─██─███─▄─▄██─▄█▀█─███▀███─███\n"
    printf "            ▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▀▀▄▄▄▀▄▄▀▄▄▀▄▄▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀\n"
    printf "\n"
    printf "==============================  erstellen ===================================\n"
    printf "=============================================================================\n"
    printf "\n"
    printf "Beschreibung:\n"
    printf "Holt sich ein SSL-Zertifikat für Fake-Domain mit und ohne www und richtet eine Umleitung ein."
    printf "\n"
    printf "\n"
    read -p "REALE Domain eingeben, auf die redirected werden soll (z.B. google.com): " realeDomain 
    printf "\n"
    read -p "FAKE Domain eingeben (z.B. fake.de): " fakeDomain 
    printf "\n"
}

create_config() {
    cd $SITESAVAILABLE
    cp $TEMPLATEDIR/000INSERT-example-config-file000 "$fakeDomain"
    # "#" anstatt "/", da bei $fakeDomain ggf "/" schon vorkommt und sed zerschießt
    sed -i -e "#ssl_certificate#! s#tu-chernitz.de#$fakeDomain#gI" "$fakeDomain" && sed -i "s#000INSERT-example-config-file000#$realeDomain#gI" "$fakeDomain" && sed -i "s#000INSERT-example-config-file000#$fakeDomain#g" "$fakeDomain" &&  sed -i "s#live/$fakeDomain#live/000INSERT-example-config-file000#g" "$fakeDomain" 
}

get_confirmation() {
    printf "\n${BOLD}  [!] Bitte überprüfen, ob alles soweit korrekt ist:${RESET}\n"
    sleep 2s
    (cat $SITESAVAILABLE/$fakeDomain || true)
    printf "\n"
    printf "\n${BOLD}[!]${RESET} Falls etwas nicht stimmt, bitte das Script mit 'Strg + C' terminieren und bereits erstellte Dateien manuell löschen:\n==> ${BOLD}rm $SITESAVAILABLE/$fakeDomain && rm $SITESENABLED/$fakeDomain${RESET}\n"
    read -n 1 -p "==> [!] Überprüfung beenden (ENTER)"
}

create_symlink() {
    ln -s $SITESAVAILABLE/$fakeDomain $SITESENABLED/$fakeDomain
}

get_cert() {
    nginx -s reload
    printf "  ${BOLD}[+] Zertifikat wird geholt.\n  [+] Bitte warten...${RESET}\n "

    certbot run -n --nginx --agree-tos -d $fakeDomain,www.$fakeDomain --redirect --quiet || true 
       # -n no user input
       #NICE "|| true" = damit auch nach EXIT durch Fehler (zB nicht registrierte Domain das Script weiter ausgeführt wird)
    if [[ $? = 0 ]]; then
      printf " ${BOLD}[+] Certbot ist fehlerfrei durchgelaufen (ggf. obigen output beachten!).${RESET}\n"
      else  printf "  ${BOLD}${RED}[-] Certbot ist mit Fehlern abgebrochen.${RESET}\n"
    fi
}

development() {
    # !!! Funktion in __main__ auskommentieren für Production
    #     for cleanup purposes while testing ONLY
    rm $SITESAVAILABLE/$fakeDomain && rm $SITESENABLED/$fakeDomain
#    printf "\n${GREY}[DEBUG] development() fake.de should be deleted by now --> check: ${RESET}\n" && (ls  $SITESAVAILABLE/ | grep $fakeDomain)
}

__main__ () {
change_dir
get_userinput
create_config
get_confirmation
create_symlink
get_cert
development
}


#  ===-=== invoke functions ===-===
__main__

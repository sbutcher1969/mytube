#!/bin/bash

if [[ $1=="test" ]];
    then echo "there is something here";sleep 5;
fi






echo " ">cspace
function clear_vars(){
    echo "">options
    echo "">teminfo
    echo "">csearch
    echo "">sfinal
    echo "">configs
    echo "">dchoice
    main
}

function add_options(){
    dialog --no-lines --single-quoted --notags --no-shadow --colors --checklist "\ZbOPTIONS\ZB" 18 40 10 ' -t' "thumbs" off ' -l' "loop" off ' -r' "random" off ' -a' "auto play" off ' -H' "history" off ' -D' "dMenu" off ' -A' "Select all" off ' -m' "Audio only" off ' -f' "formats available" off ' --sort' "Sort by Date (most recent)" off ' -d' "Download" off 2>options
    sed -i s/"'"/""/g  options
   ## if grep options = -d then add --ytdl-path=downpath to line
    main
};
function features_str(){
    dialog --no-lines --single-quoted --notags --no-shadow --colors --checklist "\ZbFEATURES\ZB" 12 40 6 'hd,' "HD" off '3d,' "3-D" off '4k,' "4k" off '360,' "360" off 'hdr,' "HDR" off 'creative_commons,' "Creative Commons," off 2>configs
    main

};

info_str(){
    echo " -I">teminfo
    dialog --no-lines --no-shadow --colors --menu "\ZbINFO\ZB" 12 40 5 " L" "Link" " VJ" "video-JSON" " J" "JSON" " F" "Format" " R" " Raw" 2>&1>teminfo
    main
};

conf_str(){
    main
}

subs_str(){

    main
}

function search_item (){
    dialog --inputbox "Search Item(s):" 8 25 2> csearch                         # input box to ask for search string (csearch)

    clear

    cat cspace options cspace configs teminfo cspace dchoice csearch > sfinal
    echo $(cat ./sfinal)
    ytfzf $(cat ./sfinal)
    if [[ -N teminfo ]];
    then echo "enter to continue" ; read newlin ; clear_vars
    fi
}

function download_video(){

    dialog --stdout --title "Video Download Path" --dselect $HOME/ 14 48 2>&1>dschoice
echo " --ytdl-path=">dpath
    cat dpath dschoice cspace >>dchoice
    main

}

main(){

    choice=""

    choice=$(dialog --menu "SELECT" 15 50 6 "1" "Search Videos" "2" "Search Options" "3" "Features" "4"  "Information" "5" "Configuration" "6" "Subscriptions" "7" "Set Download Path" "8" "Quit" 2>&1>/dev/tty)

case $choice in
    1) search_item;;
    2) add_options;;
    3) features_str;;
    4) info_str;;
    5) conf_str;;
    6) subs_str ;;
    7) download_video;;
    8) exit;;
esac
};
main
clear_vars



### mytube needs to be a command line or menu driven program
# utilizing the ytfzf command and the borne again shell.
# punchlist:
#       - make a conditional that detects if more than just the
#         mytube command.
#       - generate a config checklist for CLI for the user
#       - get subscriptions working
#       - setup configuration of downloads/delete choice
#       - make video vault section

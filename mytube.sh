#!/bin/bash
#                 __       __
#     __ _  __ __/ /___ __/ /  ___
#    /  ' \/ // / __/ // / _ \/ -_)
#   /_/_/_/\_, /\__/\_,_/_.__/\__/
#         /___/'
#
#           was written by:
#
#                           Scott Butcher
#      Date: Oct. 2022
#      System: Arcolinux Arch 5.19.13
#
#      **********************************
#      *  Check for CLI search attempt  *
#      **********************************
echo " ">cspace
if [[ -n $* ]];
then echo $*>.lsearch; cat myconfigs.txt cspace .lsearch>.search ; ytfzf $(cat ./.search); exit
fi

#      *********************************
#      *  Clear all variables & files  *
#      *********************************

function clear_vars(){
    echo "">options
    echo "">teminfo
    echo "">csearch
    echo "">sfinal
    echo "">configs
    echo "">dchoice
    main
}

#      *********************************
#      *      Add search options       *
#      *********************************

function add_options(){
    dialog --single-quoted --notags --colors --checklist "\ZbOPTIONS\ZB" 18 40 10 ' -t' "thumbs" off ' -l' "loop" off ' -r' "random" off ' -a' "auto play" off ' -H' "history" off ' -D' "dMenu" off ' -A' "Select all" off ' -m' "Audio only" off ' -f' "formats available" off ' --sort' "Sort by Date (most recent)" off ' -d' "Download" off 2>options
  ## if [[ grep " -d" ./options ]]options then dchoice>>options
    sed -i s/"'"/""/g  options
    main
};

#      *********************************
#      *   Add Video/Audio features    *
#      *********************************

function features_str(){
    dialog --single-quoted --notags --colors --checklist "\ZbFEATURES\ZB" 12 40 6 'hd,' "HD" off '3d,' "3-D" off '4k,' "4k" off '360,' "360" off 'hdr,' "HDR" off 'creative_commons,' "Creative Commons," off 2>configs
    main

};

#      *********************************
#      *    Add Information options    *
#      *********************************

info_str(){
    echo " -I">teminfo
    dialog --no-lines --colors --menu "\ZbINFO\ZB" 12 40 5 " L" "Link" " VJ" "video-JSON" " J" "JSON" " F" "Format" " R" " Raw" 2>&1>teminfo
    main
};

#      ********************************
#      *  CLI & Search Configuration  *
#      ********************************

conf_str(){
    dialog --notags --single-quoted --colors --visit-items --buildlist "\ZbCONFIGURATION\ZB" 15 25 11 ' -t' "thumbs" unselected ' -l' "loop" unselected ' -r' "random" unselected ' -a' "auto play" unselected ' -H' "history" unselected ' -D' "dMenu" unselected ' -A' "Select all" unselected ' -m' "Audio only" unselected ' -f' "formats available" unselected ' --sort' "Sort by Date (most recent)" unselected ' -d' "Download" unselected 2>myconfigs.txt
    sed -i s/"'"/""/g  myconfigs.txt
    main
};

#      ********************************
#      *    Add Subscriptions/List    *
#      ********************************

subs_str(){

    main
};

#      ********************************
#      #     Search Item / String     *
#      ********************************

function search_item (){
    dialog --inputbox "Search Item(s):" 8 25 2> csearch                         # input box to ask for search string (csearch)

    clear

    cat cspace options cspace configs teminfo cspace dchoice csearch > sfinal   # assemble the query string for ytfzf
    ytfzf $(cat ./sfinal)
    if [[ -N teminfo ]];
    then echo "enter to continue" ; read newlin ; clear_vars
    fi
};

#      ********************************
#      *      Download Path/File      *
#      ********************************
function download_video(){

    dialog --stdout --title "Video Download Path" --dselect $HOME/ 14 48 2>&1>dschoice
    echo " --ytdl-path=">dpath
    cat dpath dschoice cspace >>dchoice
    main

};

#      *******************************
#      #    Main Menu / Main loop    *
#      *******************************

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
#       - generate a config checklist for CLI for the user
#       - get subscriptions working
#       - setup configuration of downloads/delete choice
#       - make video vault section

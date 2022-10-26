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
#      System: MX Linux & Termux
#
#      **********************************
#      *  Check for CLI search attempt  *
#      **********************************
echo " ">.cspace
#set -x                                #  functrace
if [[ -n $* ]];
then echo $*>.lsearch; cat .fconfig .cspace .lsearch>.search ; ytfzf $(cat ./.search); exit
fi

#      *********************************
#      *  Clear all variables & files  *
#      *********************************

function clear_vars(){
    echo "">.options
    echo "">.teminfo
    echo "">.csearch
    echo "">.sfinal
    echo "">.configs
    echo "">.dchoice
   return 
}
#      *********************************
#      *      Add search .options       *
#      *********************************

function add_.options(){
    dialog --single-quoted --notags --colors --checklist "\Zb.options\ZB" 18 40 10 ' -t' "thumbs" off ' -l' "loop" off ' -r' "random" off ' -a' "auto play" off ' -H' "history" off ' -D' "dMenu" off ' -A' "Select all" off ' -m' "Audio only" off ' -f' "formats available" off ' --sort' "Sort by Date (most recent)" off ' -d' "Download" off 2>.options
  ## if [[ grep " -d" ./.options ]].options then.dchoice>>.options
    sed -i s/"'"/""/g  .options
    return
}

#      *********************************
#      *   Add Video/Audio features    *
#      *********************************

function features_str(){
	echo "">>.configs
	echo "">>.fconfigs
	echo " --features=">>.feats
    dialog --single-quoted --notags --colors --checklist "\ZbFEATURES\ZB" 12 40 6 'hd,' "HD" off '3d,' "3-D" off '4k,' "4k" off '360,' "360" off 'hdr,' "HDR" off 'creative_commons,' "Creative Commons," off 2>.fconfigs
    if [[ -n .fconfigs ]];
    then cat .feats .fconfigs > .configs
    return

}

#      *********************************
#      *    Add Information .options    *
#      *********************************

info_str(){
    echo " -I">.teminfo
    infochoice=$(dialog --no-lines --colors --menu "\ZbINFO\ZB" 12 40 5 " L" "Link" " VJ" "video-JSON" " J" "JSON" " F" "Format" " R" " Raw" 2>&1>/dev/tty)
    echo $infochoice>>.teminfo
    return
}

#      ********************************
#      *  CLI & Search Configuration  *
#      ********************************

conf_str(){
    dialog --notags --single-quoted --colors --visit-items --buildlist "\ZbCONFIGURATION\ZB" 15 25 11 ' -t' "thumbs" unselected ' -l' "loop" unselected ' -r' "random" unselected ' -a' "auto play" unselected ' -H' "history" unselected ' -D' "dMenu" unselected ' -A' "Select all" unselected ' -m' "Audio only" unselected ' -f' "formats available" unselected ' --sort' "Sort by Date (most recent)" unselected ' -d' "Download" unselected 2>.configs.txt
    sed -i s/"'"/""/g  .configs.txt
    dialog --single-quoted --notags --colors --checklist "\ZbFEATURES\ZB" 12 40 6 ' hd,' "HD" off ' 3d,' "3-D" off ' 4k,' "4k" off ' 360,' "360" off ' hdr,' "HDR" off ' creative_commons,' "Creative Commons," off 2>.confi
    cat .configs.txt .confi > .fconfig

    return
}

#      ********************************
#      *    Add Subscriptions/List    *
#      ********************************

subs_str(){

    return
};

#      ********************************
#      #     Search Item / String     *
#      ********************************

function search_item (){
    dialog --inputbox "Search Item(s):" 8 25 2> .csearch                         # input box to ask for search string (.csearch)

    clear

    cat .cspace .options .cspace .configs .teminfo .cspace.dchoice .csearch > .sfinal   # assemble the query string for ytfzf
    ytfzf $(cat ./.sfinal)
    if [[ -N .teminfo ]];
    then echo "enter to continue" ; read newlin ; clear_vars
    fi
}

#      ********************************
#      *      Download Path/File      *
#      ********************************
function download_video(){

    dialog --stdout --title "Video Download Path" --dselect $HOME/ 14 48 2>&1>dschoice
    echo " --ytdl-path=">.dpath
    cat .dpath dschoice .cspace >.dchoice
    return

}

#      *******************************
#      #    Main Menu / Main loop    *
#      *******************************

main(){

    choice=""

    choice=$(dialog --menu "SELECT" 15 50 6 "1" "Search Videos" "2" "Search .options" "3" "Features" "4"  "Information" "5" "Configuration" "6" "Subscriptions" "7" "Set Download Path" "8" "Quit" 2>&1>/dev/tty)

case $choice in
    1) search_item;;
    2) add_.options;main;;
    3) features_str;main;;
    4) info_str;main;;
    5) conf_str;main;;
    6) subs_str;main;;
    7) download_video;main;;
    8) clear;exit;;
esac
}
main

clear_vars



### mytube needs to be a command line or menu driven program
# utilizing the ytfzf command and the borne again shell.
# punchlist:
#       - generate a config checklist for CLI for the user
#       - get subscriptions working
#       - setup configuration of downloads/delete choice
#       - make video vault section
#   use declare to functions for return to work

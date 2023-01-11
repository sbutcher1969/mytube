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
set -x -v									#  functrace
#if [[ -n $* ]];
#then echo $*>.lsearch; cat .fconfig .cspace .lsearch>.search ; ytfzf $(cat ./.search); exit
#fi

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
clear_vars
#      *********************************
#      *      Add search .options       *
#      *********************************

function add_.options(){
    dialog --single-quoted --notags --colors --checklist "\Zb.options\ZB" 18 40 10 ' -t' "thumbs" off ' -l' "loop" off ' -r' "random" off ' -a' "auto play" off ' -H' "history" off ' -D' "dMenu" off ' -A' "Select all" off ' -m' "Audio only" off ' -f' "formats available" off ' --sort' "Sort by Date (most recent)" off ' -d' "Download" off 2>.options
    #if [[ grep " -d" ]].options then .dchoice>>.options
    #fi
	sed -i s/"'"/""/g  .options
    return
}

#      *********************************
#      *     Sorting/Type options      *
#      *********************************

function sorting_type(){
	#echo "">>.configs
	#echo "">>.fconfigs
	#echo " --features=">>.feats
    #dialog --single-quoted --notags --colors --checklist "\ZbFEATURES\ZB" 12 40 6 'hd,' "HD" off '3d,' "3-D" off '4k,' "4k" off '360,' "360" off 'hdr,' "HDR" off 'creative_commons,' "Creative Commons," off 2>.fconfigs
    #if [[ -n .fconfigs ]]; then cat .feats .fconfigs > .configs
	#fi
	return
}

#      *********************************
#      *       Scraper Settings        *
#      *********************************

function scraper_set(){
   # echo " -I">.teminfo
    #infochoice=$(dialog --no-lines --colors --menu "\ZbINFO\ZB" 12 40 5 " L" "Link" " VJ" "video-JSON" " J" "JSON" " F" "Format" " R" " Raw" 2>&1>/dev/tty)
    #echo $infochoice>>.teminfo
    return
}

#      ********************************
#      *  CLI & Search Configuration  *
#      ********************************

function urls(){
   # dialog --notags --single-quoted --colors --visit-items --buildlist "\ZbCONFIGURATION\ZB" 15 25 11 ' -t' "thumbs" unselected ' -l' "loop" unselected ' -r' "random" unselected ' -a' "auto play" unselected ' -H' "history" unselected ' -D' "dMenu" unselected ' -A' "Select all" unselected ' -m' "Audio only" unselected ' -f' "formats available" unselected ' --sort' "Sort by Date (most recent)" unselected ' -d' "Download" unselected 2>.configs.txt
   # sed -i s/"'"/""/g  .configs.txt
   # dialog --single-quoted --notags --colors --checklist "\ZbFEATURES\ZB" 12 40 6 ' hd,' "HD" off ' 3d,' "3-D" off ' 4k,' "4k" off ' 360,' "360" off ' hdr,' "HDR" off ' creative_commons,' "Creative Commons," off 2>.confi
   # cat .configs.txt .confi > .fconfig

    return
}

#      ********************************
#      *    Add Subscriptions/List    *
#      ********************************

function subs_str(){

    return
};

#      ********************************
#      #     Search Item / String     *
#      ********************************

function search_item (){
    dialog --inputbox "Search Item(s):" 8 25 2> .csearch                         # input box to ask for search string (.csearch)

    clear

    cat .cspace .options .cspace .configs .teminfo .cspace .dchoice .csearch > .sfinal   # assemble the query string for ytfzf
    ytfzf $(cat ./.sfinal)
    if [[ -N .teminfo ]];
    then echo "enter to continue" ; read newlin ; clear_vars
    fi
}

#      ********************************
#      *Download Path/File/Info/Vault *
#      ********************************
function download_info(){
	dselect	=$(dialog --menu "Select" 15 35 5 "1" "Download Path" "2" "Video Vault" "3" "Information" "4" "Download Video" "5" "Return to Main Menu" 2>&1>/dev/tty)
    case $dselect in
		1) down_path;;
		2) vid_vault;;
		3) info;;
		4) downld;;
		5) main;;
	esac
	
	
	
	
	dialog --stdout --title "Video Download Path" --dselect $HOME/ 14 48 2>&1>.dschoice
    echo " --ytdl-path=">.dpath
    cat .dpath .dschoice .cspace >.dchoice
    # ADD Place to use url list or input your own url
	# ADD place to view info and view video from url or vault.
	return

}
#      *******************************
#      #    Main Menu / Main loop    *
#      *******************************

main(){

    choice=""

	choice=$(dialog --title "YourTube" --menu "select(1-9)" 16 35 8 "1" "Search Videos" "2" "Search Options" "3" "Sorting/Type Settings" "4"  "Scraper Settings" "5" "URLS" "6" "Subscriptions" "7" "Downloading/Download Path/Information" "8" "Quit" 2>&1>/dev/tty)

case $choice in
    1) search_item;;
    2) add_.options;main;;
    3) sorting_type;main;;
	4) scrapers;main;;
    5) urls;main;;
    6) subs_str;main;;
    7) download_info;main;;
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
#		-condense commands
#		- figure out how to interface with newsboat
#		- option for type of lists to generate
#		- video and audio setup for mpv config and ytfzf config so users can craft their own environment
#		- subscriptions viewer and adder.
#
# new menu items
#
# upload_date=time-frame
#						
#							hour
#							today
#							week
#							month
#							year
# type=type			
#				video
#				playlist
#				channel
#				all
#
# scraper options
#		
#			Which ones: 
#				-c scrapers, --scrape=scrapers
#				youtube|Y
#				youtube-channel
#				invidious-channel
#				video-recommended|R
#				youtube-playlist|invidious-playlist
#				youtube-trending|T
#				M|Multi	gaming music movies
#				youtube-subscriptions|S|SI
#				scrape-list|SL
#				peertube|P
#				odysee|lbry|O
#				history|H *only if $enable_hist is on
#				url|u
#				comments

#				pages=amount
#				page-start=page
#				max-threads=amount
#				odysee-video-count=amount
#				

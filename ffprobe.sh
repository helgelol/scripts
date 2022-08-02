#!/bin/bash
IFS=$'\n'   

# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red


VideoFiles=$(find ./ -maxdepth 10 -regex ".*\.\(mkv\|mp4\|wmv\|flv\|webm\|mov\|avi\|m4v\)")  

for i in $VideoFiles  
do  
  filename=$(basename "$i");
  extension="${filename##*.}";
  filename="${filename%.*}";
echo -e "${UGreen}############################################################################################################################################################################${Color_Off}\n";
echo -e "${Color_Off}Getting info of ${BCyan}$i${Color_Off}";

    eval $(ffprobe -v quiet -show_format -of flat=s=_ -show_entries stream=height,width,nb_frames,duration,codec_name -sexagesimal "$i");
    width=${streams_stream_0_width};
    height=${streams_stream_0_height};
    bitrate=${format_bit_rate};
    kbitrate=$((bitrate/1000));
    duration=${format_duration};
    #duration=$((durationSec/60));
    d=$(dirname "$i")
echo -e "${Color_Off}Duration = ${URed}$duration ${Color_Off}, Height/Width = ${URed}$height/$width ${Color_Off} Bitrate =${URed} $bitrate${Color_Off}\n";
echo -e "${UGreen}############################################################################################################################################################################${Color_Off}";
#mkdir $d/Processed;

if ((1<= $height &&  $height<=400))
then    
    desired="200k";
    min="100k";
    max="800k";
    echo -e "This is a ${UPurple}LOW Quality${Color_Off} File\n.";

elif ((401<= $height &&  $height<=660))
then
    desired="500k";
    min="200k";
    max="1000k";
    echo -e "This is a ${UPurple}480p${Color_Off} File\n";
elif ((661<= $height &&  $height<=890))
then
    desired="800k";
    min="250k";
    max="1300k";
    echo -e "This is a ${UPurple}720p${Color_Off} File\n";

elif ((891<= $height &&  $height<=1200))
then
    desired="1200k";
    min="350k";
    max="2300k";
    echo -e "This is a ${UPurple}1080p${Color_Off} File\n";
elif (($height=A && $height=N/A))
then
    echo -e "${UPurple}Unknown media height in ${Color_Off} File\n";
else
    desired="1500k";
    min="550k";
    max="2700k";
    echo -e "This is a ${UPurple}HQ${Color_Off} File\n";
fi
#    ffmpeg -n -i "$i" -c:v hevc_nvenc -hide_banner -preset fast -x265-params keyint=33:min-keyint=33 -crf 30 -b:v $desired -minrate $min -maxrate $max -bufsize 25M -c:a copy "$d/X265_$filename.mp4"
# mv $i $d/Processed;
done

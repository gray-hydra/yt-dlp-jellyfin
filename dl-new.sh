#!/bin/bash

# this script accepts parameters ${username}, ${channelName}, and ${channelUrl}
for arg in "$@"; do
    case "$arg" in
        username=*) username="${arg#username=}" ;;
        channelName=*) channelName="${arg#channelName=}" ;;
        channelUrl=*) channelUrl="${arg#channelUrl=}" ;;
        *) /usr/bin/echo "Invalid argument: $arg" ;;
    esac
done

folderName="/home/$username/yt/$channelName"

if [ ! -d "$folderName" ]; then
    /usr/bin/mkdir "$folderName"
    /usr/bin/echo "Folder '$folderName' created."
    /usr/bin/mkdir "$folderName/text"
    /usr/bin/echo "Folder '$folderName/text' created."
else
    /usr/bin/echo "Folder '$folderName' already exists."
fi

# create list of all completed downloads. output to a text file down.txt
/usr/bin/ls /home/${username}/yt/${channelName} | /usr/bin/grep mp4 | /usr/bin/grep -Po "(?<=\[).*?(?=\])" > /home/${username}/yt/${channelName}/text/down.txt && /usr/bin/echo "down.txt created"

# create list of all videos on channel. output to a text file all.txt
/home/${username}/.local/bin/yt-dlp ${channelUrl} --print filename --cookies-from-browser firefox | /usr/bin/grep -Po "(?<=\[).*?(?=\])" > /home/${username}/yt/${channelName}/text/all.txt && /usr/bin/echo "all.txt created"

# create list of videos on channel but not downloaded. output to a text file up.txt
/usr/bin/grep -F -x -v -f /home/${username}/yt/${channelName}/text/down.txt /home/${username}/yt/${channelName}/text/all.txt > /home/${username}/yt/${channelName}/text/up.txt && /usr/bin/echo "up.txt created" && /usr/bin/cat /home/${username}/yt/${channelName}/text/up.txt

# download all videos in up.txt
while read i; do
        /home/${username}/.local/bin/yt-dlp https://piped.kavin.rocks/watch?v=$i -f mp4 --write-thumbnail --sponsorblock-remove sponsor,selfpromo --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36" -P /home/${username}/yt/${channelName}/ -S "res:360" >> /home/${username}/yt-logs/${channelName}.txt 2>&1;
done </home/${username}/yt/${channelName}/text/up.txt

# convert thumbnails into a format jellyfin can read
cd /home/${username}/yt/${channelName} && /usr/bin/rename "s/webp$/png/" *.webp
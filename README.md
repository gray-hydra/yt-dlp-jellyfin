# yt-dlp-jellyfin
Download youtube videos and self-host them locally with jellyfin

### Pre-requisites:
* Links to youtube channel(s)
* yt-dlp https://github.com/yt-dlp/yt-dlp
* Jellyfin https://jellyfin.org/
* Always-on Linux server

### Downloading new videos for selected channels
1. Create a new folder called "yt" in home directory
> mkdir ~/yt
2. Create a new folder called "yt-logs" in home directory
> mkdir ~/yt-logs
2. For each channel, create a new directory in ~/yt. Then create a sub-directory called "text"
> mkdir ~/yt/{channel}
> mkdir ~/yt/{channel}/text
3. Copy dl-new.sh from this repo to ~/yt
4. Make dl-new.sh executable
> sudo chmod +x /home/{user}/yt/dl-new.sh
5. Edit crontab
> crontab -e
6. Add the following, which will download all videos from the selected channel every day at midnight:
> 0 0 * * * /home/{user}/yt/dl-new.sh username={user} channelName={channel name} channelUrl={channel URL} >> /home/{user}/yt-logs/{channel name}.txt 2>&1
7. Add a similar line for each channel. I recommend staggering the times at which each script runs.
8. Add the following lines to crontab. This will update yt-dlp, and clear log files before starting downloads
> 50 23 * * * /usr/bin/pip3 install yt-dlp --upgrade >> /home/{user}/yt-logs/pip-log.txt 2>&1
> 
> 0 0 * * * rm /home/{user}/yt-logs/*
9. Set up a jellyfin library for each channel. Make sure to enable real time monitoring https://jellyfin.org/docs/

# czibok-greetings

Czibok Greetings is a shell script to download every video from
 [Czibok Laszlo youtube channel](https://www.youtube.com/channel/UClkrEAh4ygvlywtIEIJJ-rA),
cut the usual greetings, and concatenate all of them into a single long video.

### Requirements

* [bash](http://git.savannah.gnu.org/cgit/bash.git)
* [youtube-dl](https://github.com/ytdl-org/youtube-dl)
* [ffmpeg](https://ffmpeg.org)

### Usage

`./czibok-greetings.sh`

The script downlads every available video from the channel and uses a download-archive feature. With this feature you will initially download the complete channel archive. An `archive.txt` file will be created to record identifiers of all the videos in a special file. Each subsequent run will download only new videos and skip all videos that have been downloaded before. Note that only successful downloads are recorded in the file.

The final video file will be generated as `czibok-greetings.mp4`.

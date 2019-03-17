#!/bin/bash
# =============================================================================
# Description     : To download, cut and concatenate greetings of Czibok Laszlo
# =============================================================================
YOUTUBEDL=$(which youtube-dl)
FFMPEG=$(which ffmpeg)

if [ ! -x "${YOUTUBEDL}" ]; then
	echo "Error: This script requires youtube-dl (https://github.com/ytdl-org/youtube-dl)"
	exit 1
fi

if [ ! -x "${FFMPEG}" ]; then
	echo "Error: This script requires ffmpeg (https://ffmpeg.org/)"
	exit 1
fi


# Download every video from the channel and cut the meaningful seconds
${YOUTUBE-DL} -i https://www.youtube.com/channel/UClkrEAh4ygvlywtIEIJJ-rA --download-archive archive.txt \
-o 'archive/%(upload_date)s-%(id)s.%(location)s.%(ext)s' -f 'bestvideo[ext=webm]+bestaudio[ext=webm]' \
--postprocessor-args '-ss 00:00:00.00 -t 00:00:03.30' --recode-video mp4

# Add label to every greeting
TOTAL=`ls archive/2*.mp4|wc -l`
COUNTER=1
for i in `(cd archive; ls 2*.mp4)`; do
	YEAR=${i:0:4}
	MONTH=${i:4:2}
	DAY=${i:6:2}
	IN=archive/$i
	LBL=archive/label-$i
 	MTS=archive/label-$i.MTS
	
	# Draw text
	${FFMPEG} -i ${IN} \
	-vf "[in]drawtext=OpenSans-Regular.ttf:text='Uploaded at\: ${YEAR}.${MONTH}.${DAY}':bordercolor=black@0.4:borderw=2:fontcolor=white:fontsize=48:x=75:y=100,drawtext=OpenSans-Regular.ttf:text='Counter\: ${COUNTER}':bordercolor=black@0.4:borderw=2:fontcolor=white:fontsize=48:x=75:y=160" \
	-y ${LBL}

	# Convert to intermediate .MTS to avoid DTS in wrong order when concatenating mp4
	${FFMPEG} -i $LBL -q 0 -y $MTS
	let COUNTER=COUNTER+1
done

# Concatenate
${FFMPEG} -f concat -safe 0 -i <(for f in ./archive/label-*.mp4.MTS; do echo "file '$PWD/$f'"; done) -y czibok-greetings.mp4

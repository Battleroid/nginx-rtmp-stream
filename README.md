# nginx-rtmp-stream

Dockerfile for streaming to YouTube, Livecoding, and Twtich simultaneously.

### Usage

1. Clone this repository and change the values for YouTube, Livecoding, and
Twitch keys within `nginx.conf`.
2. Build the image (you'll need to rebuild the image any time you make
modifications to `nginx.conf`) using `docker build -t nginx-rtmp-stream .`.
3. Create the directories _logs_ and _vids_ somewhere, keep note of their
location.
4. Run the docker image using the following: `docker run -p 1935:1935 -p
8080:80 -v /path/to/host/logs:/logs -v /path/to/host/vids:/vids --rm
nginx-rtmp-latest`.
  * You can confirm if it's functioning by visiting http://localhost:8080/.
5. Stream your content to `rtmp://localhost:1935/all/name` with `name` being
your stream's name (duh). In OBS (or OBS Studio) name will be your stream key.
6. You should be able to view the output content for each individual stream by
using VLC, MPV, or any other video player with the ability to view network
streams by using the streaming service with your stream name. For example `mpv
rtmp://localhost:1935/livecoding/name` will give the output of the Livecoding
stream.

Obviously if you do not want to use a service simply turn off its block (`live
on` to `live off``) and also remove the ffmpeg command within `application
all`.

Do the same for the recording of videos; if you don't need that just remove the
mount and turn off the recorder altogether (`record all` to `record off`).

#!/bin/bash
export LANG=en
ZOOM_LINK_AND_VERSION=$(wget -S --spider --max-redirect=0 'https://zoom.us/client/latest/zoom_amd64.deb' --header 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36' 2>&1 | grep "Location" | sed -E 's/.*(https.*prod\/(.*)\/zoom.*\.deb).*/\1 \2/')
parts=($ZOOM_LINK_AND_VERSION)
ZOOM_DOWNLOAD_LINK=${parts[0]}
ZOOM_VERSION_AVAILABLE=${parts[1]}
echo zoom version available for download: $ZOOM_VERSION_AVAILABLE
ZOOM_VERSION_AVAILABLE_MAJOR=$(echo $ZOOM_VERSION_AVAILABLE | sed -e 's/\([^\.]\+\.[^\.]\+\).*/\1/')
echo "major" zoom version available for download: $ZOOM_VERSION_AVAILABLE_MAJOR
ZOOM_VERSION_AVAILABLE_MINOR=$(echo $ZOOM_VERSION_AVAILABLE | sed -e 's/[^\(]\+(\(.*\)).*/\1/')
echo "minor" zoom version available for download: $ZOOM_VERSION_AVAILABLE_MINOR
ZOOM_VERSION_INSTALLED=$(apt-cache policy zoom | grep "Installed:" | sed -e 's/.*Installed: \(.*\)/\1/')
echo zoom version installed: $ZOOM_VERSION_INSTALLED
if [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE_MINOR"* ]] || [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE_MAJOR"* ]]; then
   echo downloading new version...
   wget --quiet $ZOOM_DOWNLOAD_LINK -P /tmp
   export DEBIAN_FRONTEND=noninteractive
   apt-get install -y /tmp/zoom_amd64.deb
   rm /tmp/zoom_amd64.deb
else
   echo already at latest version
fi

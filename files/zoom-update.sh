#!/bin/bash
export LANG=en
ZOOM_VERSION_AVAILABLE=$(curl -s 'https://zoom.us/support/download' --header 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.75 Safari/537.36' | grep "class=\"linux-ver-text\"" | sed -e 's/.*Version \(.*\)<.*/\1/')
echo zoom version available for download: $ZOOM_VERSION_AVAILABLE
ZOOM_VERSION_AVAILABLE_MAJOR=$(echo $ZOOM_VERSION_AVAILABLE | sed -e 's/\([^\.]\+\.[^\.]\+\).*/\1/')
echo "major" zoom version available for download: $ZOOM_VERSION_AVAILABLE_MAJOR
ZOOM_VERSION_AVAILABLE_MINOR=$(echo $ZOOM_VERSION_AVAILABLE | sed -e 's/[^\(]\+(\(.*\)).*/\1/')
echo "minor" zoom version available for download: $ZOOM_VERSION_AVAILABLE_MINOR
ZOOM_VERSION_INSTALLED=$(apt-cache policy zoom | grep "Installed:" | sed -e 's/.*Installed: \(.*\)/\1/')
echo zoom version installed: $ZOOM_VERSION_INSTALLED
if [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE_MINOR"* ]] || [[ "$ZOOM_VERSION_INSTALLED" != *"$ZOOM_VERSION_AVAILABLE_MAJOR"* ]]; then
   echo downloading new version...
   wget --quiet https://zoom.us/client/latest/zoom_amd64.deb -P /tmp
   export DEBIAN_FRONTEND=noninteractive
   apt-get install -y /tmp/zoom_amd64.deb
   rm /tmp/zoom_amd64.deb
else
   echo already at latest version
fi

# Example Radio Stations

This document shows how to configure the plugin for different radio stations.

## Wholesome Radio (Default)

```bash
RADIO_URL="https://streams.radio.co/s2c3cc784b/listen"
METADATA_URL="https://public.radio.co/stations/s2c3cc784b/status"
```

## Other Radio.co Stations

If you want to use a different radio.co station, you can find the URLs in a similar pattern:

```bash
# Example format:
RADIO_URL="https://streams.radio.co/STATION_ID/listen"
METADATA_URL="https://public.radio.co/stations/STATION_ID/status"
```

## Generic Internet Radio Streams

For other internet radio stations:

### SomaFM Groove Salad
```bash
RADIO_URL="https://ice1.somafm.com/groovesalad-128-mp3"
METADATA_URL=""  # SomaFM doesn't provide easy metadata API
# The script will show "Wholesome Radio" as fallback - you can change the text
```

### BBC Radio (UK only, may require VPN)
```bash
RADIO_URL="http://stream.live.vc.bbcmedia.co.uk/bbc_radio_one"
METADATA_URL=""  # BBC doesn't provide public metadata API in this format
```

### Custom Station Without Metadata

```bash
RADIO_URL="http://your-stream-url-here.com/stream"
METADATA_URL=""  # Leave empty if no API available

# Modify the fallback text in the get_now_playing function:
# Change the echo "Wholesome Radio" line to your station name
```

## Modifying the Script

1. Open `wholesome_radio.sh` in a text editor
2. Find the configuration section at the top:
   ```bash
   # Configuration
   RADIO_URL="..."
   METADATA_URL="..."
   ```
3. Replace with your preferred station URLs
4. If using a station without metadata API, also update the fallback text in the `get_now_playing` function

## Multiple Stations

Want to have multiple radio stations? Create separate scripts:

```bash
cd ~/.config/waybar/scripts/
cp wholesome_radio.sh rock_radio.sh
cp wholesome_radio.sh jazz_radio.sh

# Edit each file with different station URLs
# Use different cache directories for each:
# Edit rock_radio.sh: CACHE_DIR="$HOME/.cache/rock_radio"
# Edit jazz_radio.sh: CACHE_DIR="$HOME/.cache/jazz_radio"
```

Then add multiple modules to your Waybar config:

```json
{
    "modules-right": [
        "custom/wholesome-radio",
        "custom/rock-radio",
        "custom/jazz-radio"
    ],
    
    "custom/wholesome-radio": {
        "exec": "~/.config/waybar/scripts/wholesome_radio.sh",
        "return-type": "json",
        "interval": 5,
        "on-click": "~/.config/waybar/scripts/wholesome_radio.sh toggle"
    },
    
    "custom/rock-radio": {
        "exec": "~/.config/waybar/scripts/rock_radio.sh",
        "return-type": "json",
        "interval": 5,
        "on-click": "~/.config/waybar/scripts/rock_radio.sh toggle"
    }
}
```

## Finding Stream URLs

### For Radio.co Stations
1. Visit the radio station's website
2. Open browser developer tools (F12)
3. Go to Network tab
4. Click play on the website
5. Look for a request to `streams.radio.co` or similar
6. Copy the URL

### For Other Stations
1. Many stations publish their stream URLs on their website
2. Look for "Listen Live" links
3. Right-click and copy link address
4. Common formats: `.mp3`, `.aac`, `.pls`, `.m3u`
5. cvlc can handle most common stream formats

## Testing Streams

Before adding to the plugin, test the stream with cvlc:

```bash
cvlc --intf dummy "https://your-stream-url-here.com/stream"
# Press Ctrl+C to stop
```

If it plays successfully, you can use it in the plugin!

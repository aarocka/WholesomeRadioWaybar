# Quick Start Guide

## For the Impatient

```bash
# 1. Install VLC
sudo pacman -S vlc curl jq  # Arch
# or: sudo apt install vlc curl jq  # Debian/Ubuntu
# or: sudo dnf install vlc curl jq  # Fedora

# 2. Run the installation script
cd WholesomeRadioWaybar
./install.sh

# 3. Add to your Waybar config (~/.config/waybar/config):
{
    "modules-right": ["custom/wholesome-radio", ...],
    "custom/wholesome-radio": {
        "exec": "~/.config/waybar/scripts/wholesome_radio.sh",
        "return-type": "json",
        "interval": 5,
        "on-click": "~/.config/waybar/scripts/wholesome_radio.sh toggle",
        "format": "{}",
        "max-length": 50
    }
}

# 4. Add styles to ~/.config/waybar/style.css:
#custom-wholesome-radio {
    padding: 0 10px;
    color: #ffffff;
}

#custom-wholesome-radio.playing {
    color: #a6e3a1;
    font-weight: bold;
}

# 5. Restart Waybar
killall waybar && waybar &
```

## What You Get

- **Click to Play**: Click the module to start playing Wholesome Radio
- **Click to Stop**: Click again to stop playback
- **Now Playing**: See what's currently playing (updates every 5 seconds)
- **Scrolling Text**: Long song titles scroll automatically (Waybar handles this via max-length)
- **Visual Feedback**: Different colors for playing/stopped states

## How It Works

1. The Bash script manages a cvlc process in the background
2. It fetches "Now Playing" data from the radio.co API using curl
3. Waybar displays the formatted output as JSON
4. Clicking triggers the toggle action to start/stop playback

## Customization

Edit `wholesome_radio.sh` to:
- Change radio station URL
- Modify the icon (default: ♫)
- Adjust metadata fetch interval
- Change PID file location

Edit your Waybar config to:
- Adjust update interval (default: 5 seconds)
- Change max-length for scrolling behavior
- Modify module placement in bar

## Troubleshooting

**Module doesn't appear:**
- Check Waybar logs: `waybar -l debug`
- Verify script path in config
- Make sure script is executable: `chmod +x wholesome_radio.sh`

**Radio doesn't play:**
- Test manually: `cvlc https://streams.radio.co/s2c3cc784b/listen`
- Check if VLC is installed: `which cvlc`

**Now Playing doesn't update:**
- The metadata API might be temporarily unavailable
- Check internet connection
- The script will fall back to showing "Wholesome Radio"

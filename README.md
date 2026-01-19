# WholesomeRadioWaybar

A Waybar plugin that allows you to listen to Wholesome Radio with a single click. Features:
- 🎵 Toggle radio playback (play/stop) with a click
- 📻 Displays "Now Playing" information
- 📜 Scrolling text to save space on your bar
- 🎨 Visual feedback for play/stop states

## Prerequisites

- [Waybar](https://github.com/Alexays/Waybar)
- VLC media player with cvlc (command-line interface)
- Python 3.6+

### Installing VLC

**Arch Linux:**
```bash
sudo pacman -S vlc
```

**Debian/Ubuntu:**
```bash
sudo apt install vlc
```

**Fedora:**
```bash
sudo dnf install vlc
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/aarocka/WholesomeRadioWaybar.git
cd WholesomeRadioWaybar
```

2. Make the script executable:
```bash
chmod +x wholesome_radio.py
```

3. Copy the script to a location in your PATH (optional but recommended):
```bash
sudo cp wholesome_radio.py /usr/local/bin/wholesome_radio
```

Or keep it in a local directory and reference the full path in your Waybar config.

## Configuration

### Waybar Config

Add the following to your Waybar configuration file (usually `~/.config/waybar/config`):

```json
{
    "modules-right": ["custom/wholesome-radio", "other-modules"],
    
    "custom/wholesome-radio": {
        "exec": "/path/to/wholesome_radio.py",
        "return-type": "json",
        "interval": 5,
        "on-click": "/path/to/wholesome_radio.py toggle",
        "format": "{}",
        "max-length": 50
    }
}
```

Replace `/path/to/wholesome_radio.py` with the actual path to the script (e.g., `/usr/local/bin/wholesome_radio` or `~/.config/waybar/scripts/wholesome_radio.py`).

### Style Configuration

Add custom styling to your Waybar style file (usually `~/.config/waybar/style.css`):

```css
#custom-wholesome-radio {
    padding: 0 10px;
    color: #ffffff;
}

#custom-wholesome-radio.playing {
    color: #a6e3a1;
    font-weight: bold;
}

#custom-wholesome-radio.stopped {
    color: #cdd6f4;
}

#custom-wholesome-radio:hover {
    background-color: rgba(255, 255, 255, 0.1);
}
```

### Configuration Options

You can customize the following settings in the `wholesome_radio.py` script:

- **RADIO_URL**: The streaming URL for the radio station (default: Wholesome Radio)
- **METADATA_URL**: The API endpoint for fetching "Now Playing" information
- **MAX_LENGTH**: Maximum text length before Waybar truncates/scrolls (default: 50)
- **PID_FILE**: Location of the PID file for tracking the cvlc process

## Usage

Once configured, the module will appear in your Waybar. Simply click on it to:
- **Start playing** Wholesome Radio when stopped
- **Stop playing** when music is active

The module automatically updates every 5 seconds (configurable via `interval` in Waybar config) to show the current track information.

### Manual Control

You can also control the radio from the command line:

```bash
# Toggle playback
/path/to/wholesome_radio.py toggle

# Check status
/path/to/wholesome_radio.py
```

## Troubleshooting

### Radio doesn't play
- Check if VLC is installed: `which cvlc`
- Try playing the stream manually: `cvlc https://streams.radio.co/s2c3cc784b/listen`
- Check the logs: look at Waybar output for error messages

### "Now Playing" doesn't update
- Verify the metadata URL is accessible: `curl https://public.radio.co/stations/s2c3cc784b/status`
- The module updates based on the `interval` setting in Waybar config (default: 5 seconds)

### Multiple instances playing
- Check for orphaned processes: `pgrep -a vlc`
- Kill them manually if needed: `pkill vlc`
- The script should handle this automatically, but manual cleanup might be needed in rare cases

## Customization

### Using a Different Radio Station

To use a different radio station, modify these variables in `wholesome_radio.py`:

```python
RADIO_URL = "your-stream-url-here"
METADATA_URL = "your-metadata-api-url-here"  # Optional, for "Now Playing" info
```

If your station doesn't have a metadata API, the script will simply display the station name.

### Changing the Icon

Modify the text in the script to use a different icon:

```python
text = f"🎵 {now_playing}"  # Change the emoji/icon here
```

## License

GPL-3.0 - See LICENSE file for details

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.

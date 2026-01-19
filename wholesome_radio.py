#!/usr/bin/env python3
"""
Waybar custom module for Wholesome Radio
Displays now playing info and controls playback with cvlc
"""

import json
import os
import signal
import subprocess
import sys
import time
import urllib.request
import urllib.error

# Configuration
RADIO_URL = "https://streams.radio.co/s2c3cc784b/listen"  # Wholesome Radio stream URL
METADATA_URL = "https://public.radio.co/stations/s2c3cc784b/status"  # Metadata endpoint

# Use user-specific cache directory for PID file
CACHE_DIR = os.path.expanduser("~/.cache/wholesome_radio")
PID_FILE = os.path.join(CACHE_DIR, "radio.pid")


def get_pid():
    """Get the PID of the running cvlc process"""
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, 'r') as f:
                pid = int(f.read().strip())
                # Check if process is still running
                os.kill(pid, 0)
                return pid
        except (OSError, ValueError):
            # Process not running or invalid PID
            if os.path.exists(PID_FILE):
                os.remove(PID_FILE)
    return None


def start_radio():
    """Start playing the radio"""
    # Kill any existing process
    stop_radio()
    
    # Create cache directory if it doesn't exist
    os.makedirs(CACHE_DIR, mode=0o700, exist_ok=True)
    
    # Start cvlc in background
    process = subprocess.Popen(
        ['cvlc', '--intf', 'dummy', RADIO_URL],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    
    # Save PID with secure permissions
    old_umask = os.umask(0o077)  # Temporarily set umask to create file with 0o600
    try:
        with open(PID_FILE, 'w') as f:
            f.write(str(process.pid))
    finally:
        os.umask(old_umask)  # Restore original umask
    
    return process.pid


def stop_radio():
    """Stop playing the radio"""
    pid = get_pid()
    if pid:
        try:
            os.kill(pid, signal.SIGTERM)
            # Wait for process to terminate gracefully
            time.sleep(0.5)
            # Check if process still exists before sending SIGKILL
            try:
                os.kill(pid, 0)  # Check if process exists
                # Process still running, force kill
                os.kill(pid, signal.SIGKILL)
            except OSError:
                # Process already terminated, no need to SIGKILL
                pass
        except OSError:
            # Process doesn't exist
            pass
        
        if os.path.exists(PID_FILE):
            os.remove(PID_FILE)


def get_now_playing():
    """Fetch the now playing information from radio.co API"""
    try:
        with urllib.request.urlopen(METADATA_URL, timeout=5) as response:
            data = json.loads(response.read().decode())
            
            # Extract title from the API response
            if 'current_track' in data and data['current_track']:
                title = data['current_track'].get('title', 'Wholesome Radio')
                # Clean up the title
                if title and title.strip():
                    return title.strip()
            
            return "Wholesome Radio"
    except (urllib.error.URLError, urllib.error.HTTPError, json.JSONDecodeError, KeyError):
        return "Wholesome Radio"


def toggle_radio():
    """Toggle radio playback on/off"""
    if get_pid():
        stop_radio()
    else:
        start_radio()


def main():
    """Main function - outputs JSON for Waybar"""
    # Check if we're toggling
    if len(sys.argv) > 1 and sys.argv[1] == "toggle":
        toggle_radio()
        return
    
    # Get current state
    is_playing = get_pid() is not None
    
    if is_playing:
        now_playing = get_now_playing()
        text = f"♫ {now_playing}"
        tooltip = f"Now Playing: {now_playing}\nClick to stop"
        css_class = "playing"
    else:
        text = "♫ Wholesome Radio"
        tooltip = "Click to play Wholesome Radio"
        css_class = "stopped"
    
    # Output JSON for Waybar
    output = {
        "text": text,
        "tooltip": tooltip,
        "class": css_class
    }
    
    print(json.dumps(output))


if __name__ == "__main__":
    main()

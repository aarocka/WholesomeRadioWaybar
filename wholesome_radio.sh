#!/bin/bash
# Waybar custom module for Wholesome Radio
# Displays now playing info and controls playback with cvlc

# Configuration
RADIO_URL="https://streams.radio.co/s2c3cc784b/listen"
METADATA_URL="https://public.radio.co/stations/s2c3cc784b/status"

# Use user-specific cache directory for PID file
CACHE_DIR="$HOME/.cache/wholesome_radio"
PID_FILE="$CACHE_DIR/radio.pid"

# Get the PID of the running cvlc process
get_pid() {
    if [ -f "$PID_FILE" ]; then
        local pid
        pid=$(cat "$PID_FILE" 2>/dev/null)
        
        # Check if process is still running
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            echo "$pid"
            return 0
        else
            # Process not running, clean up PID file
            rm -f "$PID_FILE"
        fi
    fi
    return 1
}

# Start playing the radio
start_radio() {
    # Stop any existing process first
    stop_radio
    
    # Create cache directory if it doesn't exist
    mkdir -p "$CACHE_DIR"
    chmod 700 "$CACHE_DIR"
    
    # Start cvlc in background
    cvlc --intf dummy "$RADIO_URL" >/dev/null 2>&1 &
    local pid=$!
    
    # Save PID with secure permissions
    (umask 077; echo "$pid" > "$PID_FILE")
}

# Stop playing the radio
stop_radio() {
    local pid
    pid=$(get_pid)
    
    if [ -n "$pid" ]; then
        # Send SIGTERM for graceful shutdown
        kill -TERM "$pid" 2>/dev/null
        
        # Wait for process to terminate gracefully (1 second total, 5 checks)
        for i in {1..5}; do
            sleep 0.2
            if ! kill -0 "$pid" 2>/dev/null; then
                # Process terminated successfully
                break
            fi
            
            # On last iteration, force kill if still running
            if [ $i -eq 5 ]; then
                kill -KILL "$pid" 2>/dev/null
            fi
        done
        
        # Clean up PID file
        rm -f "$PID_FILE"
    fi
}

# Fetch the now playing information from radio.co API
get_now_playing() {
    local response
    local title
    
    # Fetch metadata with 2 second timeout
    response=$(curl -s --max-time 2 "$METADATA_URL" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$response" ]; then
        # Extract title using jq if available, otherwise use grep/sed
        if command -v jq >/dev/null 2>&1; then
            title=$(echo "$response" | jq -r '.current_track.title // "Wholesome Radio"' 2>/dev/null)
        else
            # Fallback to basic text parsing
            title=$(echo "$response" | grep -o '"title":"[^"]*"' | head -1 | sed 's/"title":"\(.*\)"/\1/')
        fi
        
        # Clean up and validate title
        if [ -n "$title" ] && [ "$title" != "null" ] && [ "$title" != "Wholesome Radio" ]; then
            echo "$title"
            return 0
        fi
    fi
    
    # Fallback
    echo "Wholesome Radio"
}

# Toggle radio playback on/off
toggle_radio() {
    if get_pid >/dev/null; then
        stop_radio
    else
        start_radio
    fi
}

# Main function - outputs JSON for Waybar
main() {
    # Check if we're toggling
    if [ "$1" = "toggle" ]; then
        toggle_radio
        exit 0
    fi
    
    # Get current state
    local is_playing=false
    if get_pid >/dev/null; then
        is_playing=true
    fi
    
    # Build output based on state
    if [ "$is_playing" = true ]; then
        local now_playing
        now_playing=$(get_now_playing)
        local text="♫ $now_playing"
        local tooltip="Now Playing: $now_playing\\nClick to stop"
        local css_class="playing"
    else
        local text="♫ Wholesome Radio"
        local tooltip="Click to play Wholesome Radio"
        local css_class="stopped"
    fi
    
    # Output JSON for Waybar
    # Use printf to avoid issues with special characters
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tooltip" "$css_class"
}

# Run main function
main "$@"

#!/bin/bash

select_sink() {
    local prompt="$1"
    local list="$2"
    local selected_sink=$(echo "$list" | fzf +m --prompt="$prompt")

    if [ -n "$selected_sink" ]; then
        local sink_index=$(echo "$selected_sink" | awk '{print $1}')
        pactl set-default-sink "$sink_index"
        echo "Default sink set to: $selected_sink"
    else
        echo "No sink selected. Exiting."
    fi
}

select_source() {
    local prompt="$1"
    local list="$2"
    local selected_source=$(echo "$list" | fzf +m --prompt="$prompt")

    if [ -n "$selected_source" ]; then
        local source_index=$(echo "$selected_source" | awk '{print $1}')
        pactl set-default-source "$source_index"
        echo "Default source set to: $selected_source"
    else
        echo "No source selected. Exiting."
    fi
}

# Get the list of sinks and sources using pactl and extract their names
sink_list=$(pactl list short sinks | awk '{print $2}')
source_list=$(pactl list short sources | awk '{print $2}')

# Use fzf to select a sink and source interactively
select_sink "Select a PulseAudio sink: " "$sink_list"
select_source "Select a PulseAudio source: " "$source_list"


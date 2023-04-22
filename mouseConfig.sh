#!/bin/bash

# Check if the xinput command is available
if ! [ -x "$(command -v xinput)" ]; then
  echo "Error: xinput is not installed."
  exit 1
fi

# Get the id of the mouse device
device_id=$(xinput --list | grep -i "pointer" | grep -i "ELECOM TrackBall Mouse DEFT Pro TrackBall" | grep -o "id=[0-9]*" | cut -d= -f2)

# Check if the device was found
if [ -n "$device_id" ]; then
  # Set the button mapping for the device
  echo "device_id: $device_id"
  xinput set-button-map $device_id 1 9 8 4 5 6 7 3 2 10 11 12
else
  # Print an error message if the device was not found
  echo "ELECOM TrackBall Mouse not found"
fi

# Confirm the button mapping was set successfully
button_map=$(xinput get-button-map $device_id)
button_map="$(echo $button_map)"
if [ "$button_map" == "1 9 8 4 5 6 7 3 2 10 11 12" ]; then
  echo "Button mapping for ELECOM TrackBall Mouse successfully set."

else
  xinput get-button-map $device_id
  echo "Error: Failed to set button mapping for ELECOM TrackBall Mouse mouse."
  exit 1
fi

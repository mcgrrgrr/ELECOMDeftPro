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
  xinput set-button-map $device_id 10 2 3 4 5 6 7 8 9 1 11 12

else
  # Print an error message if the device was not found
  echo "ELECOM TrackBall Mouse not found"
fi

# First mapping
# xinput set-button-map $device_id 1 9 8 4 5 6 7 3 2 10 11 12

    # Set the mouse matrix
    # Default matrix 1 0 0 0 1 0 0 0 1
    # This represents
    # | 1 0 0 |
    # | 0 1 0 |
    # | 0 0 1 |
    
# Get the Current matrix
mouse_matrix=$(xinput list-props $device_id | grep Matrix)

# Check to see if matrix was found
if [ -n "$mouse_matrix" ]; then
    # Set matrix for mouse
    echo "current mouse_matrix: $mouse_matrix"
    # Invert mouse output5
    xinput set-prop $device_id Coordinate Tranformation Matrix -1 0 0 0 -1 0 0 0 1
    echo "mouse_matrix iverted. Current mouse matrix: $mouse_matrix"
else
    # Print error message
    echo "Failed to invert mouse"
fi


# Confirm the button mapping was set successfully
button_map=$(xinput get-button-map $device_id)
button_map="$(echo $button_map)"
if [ "$button_map" == "10 2 3 4 5 6 7 8 9 1 11 12" ]; then
  echo "Button mapping for ELECOM TrackBall Mouse successfully set."

else
  xinput get-button-map $device_id
  echo "Error: Failed to set button mapping for ELECOM TrackBall Mouse."
  exit 1
fi

#!/bin/bash

# Check if the xinput command is available
if ! [ -x "$(command -v xinput)" ]; then
  echo "Error: xinput is not installed."
  exit 1
fi

# Get the id of the mouse device
device_id=$(xinput --list | grep -i "pointer" | grep -i "ELECOM TrackBall Mouse DEFT Pro TrackBall" | grep -o "id=[0-9]*" | cut -d= -f2)


# First mapping
# xinput set-button-map $device_id 1 9 8 4 5 6 7 3 2 10 11 12

# Check if the device was found
if [ -n "$device_id" ]; then
  # Set the button mapping for the device
  echo "device_id: $device_id"
  xinput set-button-map $device_id 10 2 3 4 5 6 7 8 9 1 11 12

else
  # Print an error message if the device was not found
  echo "ELECOM TrackBall Mouse not found"
fi

# This is the current construction zone
#
# Set the mouse matrix
# Default matrix 1 0 0 0 1 0 0 0 1
#
# This represents the affine matrix
# | 1 0 0 |
# | 0 1 0 |
# | 0 0 1 |
#
# I am attempting to take the output from xinput list-props and format it
# to appear the same as it does for the input for xinput set-prop and 
# print it to the screen before and after the input is inverted on the 
# origin. This will also be helpful in producing a check to make sure the
# matrix was set properly.

mouse_matirix=$(xinput list-props 10 | grep 'Coordinate Transformation Matrix' | awk '{printf "%.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f\n", $4, $5, $6, $7, $8, $9, $10, $11, $12}')


# Check to see if matrix was found
if [ -n "$mouse_matrix" ]; then
    # Set matrix for mouse
    echo "mouse_matrix: $mouse_matrix"
    xinput set-prop $device_id "Coordinate Tranformation Matrix" -1 0 0 0 -1 0 0 0 1
else
    # Print error message
    echo "Failed to set current Transformation Matrix"
fi
    # Invert mouse output
    echo "new matrix: $mouse_matrix"


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

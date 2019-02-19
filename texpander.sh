!/bin/bash

# Version: 2.0
# Release: November 24, 2017

# Store base directory path, expand complete path using HOME environemtn variable
base_dir=$(realpath "${HOME}/.texpander")

# Set globstar shell option (turn on) ** for filename matching glob patterns on subdirectories of ~/.texpander
shopt -s globstar

# Find regular files in base_dir, pipe output to sed
abbrvs=$(find "${base_dir}" -type f | sort | sed "s?^${base_dir}/??g" )

name=$(zenity --list --title=Texpander --width=275 --height=400 --column=Abbreviations $abbrvs)

path="${base_dir}/${name}"

if [ -f "${base_dir}/${name}" ]
then
  if [ -e "$path" ]
  then
    # Preserve the current value of the clipboard
    clipboard=$(xsel -b -o)

    # Put text in primary buffer for Shift+Insert pasting
    echo -n "$(cat "$path")" | xsel -p -i

    # Put text in clipboard selection for apps like Firefox that 
    # insist on using the clipboard for all pasting
    echo -n "$(cat "$path")" | xsel -b -i

  else
    zenity --error --text="Abbreviation not found:\n${name}"
  fi
fi

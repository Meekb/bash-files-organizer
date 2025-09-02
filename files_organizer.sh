#!/usr/bin/env bash

# Note vars only need $ prefix if they need to be made available to other scripts
USER="Meebs"
UNORGANIZED=$1
ORGANIZED=$2


# Greeting
echo "Hello $USER!"

# 1. Clear out the organized folder
echo "** 1 **"
echo "Clearing out $ORGANIZED"
rm -rf "${ORGANIZED:?}"/* # :? means if $ORGANIZED is unset or empty, Bash will throw an error and exit
# otherwise it will sub an empty string which will tell Bash to delete from root /* which would be catastrophic!

echo "Current contents of $ORGANIZED:"
ls -l "$ORGANIZED"
echo

# 2. Copy files into organized folder
echo "** 2 **"
echo "Copying files from $UNORGANIZED to $ORGANIZED"
cp -R "$UNORGANIZED"/* "$ORGANIZED"
echo

# 4. Scan files and prepare dirs
echo "** 4 **"
echo "mkdir for each file type"

# Declare Associative Array - key/val pairs [{ext : num}]
declare -A filetypes

for file in "${ORGANIZED:?}"/*; do
  # ${file##*.} ## strips off (longest) everything up to the last dot in the filename, leaving just the extension
  # Important: the dot itself is consumed by the pattern *. so the result has NO leading dot
  # Example: my.photo.JPG → JPG,  file.png → png
  ext="${file##*.}"

  # ${ext,,} ,, converts the value to all lowercase (Bash 4+)
  # Example: JPG becomes jpg
  ext="${ext,,}"

  # basename strips directories, leaving just the filename
  # Example: basename /Users/me/file.txt is file.txt
  name="$(basename "$file")"
  echo "NAME: $name"
  
  # If no dot in the filename, treat as "no-ext-files"
  if [[ "$name" == "${name%.*}" ]]; then
    ext="no-ext-files"
  fi
  
  # bump count for this extension
  (( filetypes["$ext"]++ ))
done
echo

echo "${!filetypes[@]}"

for ext in "${!filetypes[@]}"; do
  echo "$ext : ${filetypes[$ext]}"
  if [ -f "$ext" ]; then
    echo "MAKING /no-ext-files"
    echo
    mkdir /"no-ext-files"
    
    # Set permissions for mv
    chmod u="rwx" "$ORGANIZED"/"$ext"
  fi
  echo "MAKING $ext"
  mkdir "$ORGANIZED"/"$ext"
  
  # Set permissions for mv
  chmod u="rwx" "$ORGANIZED"/"$ext"
done
echo

# Move files into their extension folders inside $ORGANIZED
# `shopt -s nullglob` means set nullglob so when you use a wildcard (* or ?) that doesnt match anything,
# instead of leaving the literal pattern, Bash substitutes nothing (a null string)
shopt -s nullglob

for file in "${ORGANIZED:?}"/*; do
  [[ -f "$file" ]] || continue

  name="$(basename "$file")"

  if [[ "$name" == "${name%.*}" ]]; then
    ext="no-ext-files" # if no ext, put in nef
  else
    ext="${name##*.}" # last-suffix of the filename
    ext="${ext,,}" # lower-cased
  fi

  dest="${ORGANIZED%/}/$ext"
  
  # as extra insurance, safely check dir exists before moving file
  mkdir -p "$dest" # `-p` create the whole path if necessary

  echo "→ $name  →  $ext/"
  mv -- "$file" "$dest/"
done

echo
echo "Contents of $ORGANIZED:"
ls -l "$ORGANIZED"

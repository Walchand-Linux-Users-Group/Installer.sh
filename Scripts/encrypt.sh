#!/bin/bash

read -rp "Enter filename (any prefix, suffix, substring): " key

files=(*"$key"*)
files=($(printf "%s\n" "${files[@]}" | grep -v '\.gpg$'))

if [ ${#files[@]} -eq 0 ]; then
    echo "No files found with the keyword '$key'"
    exit 1
fi

while true; do
    echo "Select a file to encrypt:"
    select file in "${files[@]}"; do
        if [ -n "$file" ]; then
            echo "Encrypting file: $file"
            gpg -c "$file"
            echo "I have encrypted the file successfully..."
            echo "Now I will be removing the original file"
            rm -rf "$file"
            files=(*"$key"*)  
            files=($(printf "%s\n" "${files[@]}" | grep -v '\.gpg$'))
            if [ ${#files[@]} -eq 0 ]; then
                echo "No more files left to encrypt. Exiting."
                exit 0
            fi
            break
        else
            echo "Invalid selection. Exiting."
            exit 1
        fi
    done
done

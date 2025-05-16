#!/bin/bash

function source_meta() {
    local meta_file="$1"
    if [ -f "$meta_file" ]; then
        while IFS='=' read -r key value || [ -n "$key" ]; do
            # Skip blank lines and comment lines
            echo "key: $key, value: $value"
            [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
            # Remove leading and trailing spaces
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs)
            # export variable
            export "${key}=${value}"
        done < "$meta_file"
    fi
}


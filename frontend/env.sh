#!/bin/sh

# Replace the placeholder in main.*.js files with the environment variable
if [ -z "$BACKEND_URL" ]; then
    echo "BACKEND_URL environment variable is not set."
    echo "Shutting down the container..."
    exit 1
fi

# Find all minified JavaScript files (main.*.js)
for file in $(find /usr/share/nginx/html -type f -name 'main.*.js'); do
    # Perform the replacement in the minified JS file
    sed -i "s|__BACKEND_URL__|$BACKEND_URL|g" "$file"

    echo "Updated $file to use $BACKEND_URL"
done

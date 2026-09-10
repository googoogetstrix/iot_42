#!/bin/sh

set -e

IMAGES="app1 app2 app3"

if [ "$1" = "-c" ]; then
    echo "Cleaning up Docker images..."

    for image in $IMAGES; do
        echo "  Removing $image:latest"
        docker image rm "$image:latest"
        rm -f "./scripts/$image.tar"
    done

    echo "Cleanup complete."
    exit 0
fi

echo "Building Docker images..."

for image in $IMAGES; do
    echo "  Building $image:latest..."
    docker build -t "$image:latest" "./scripts/$image"
    echo "  Created $image:latest"
done

echo "All images built successfully."

if [ "$1" = "-o" ]; then
    echo "Exporting Docker images..."

    for image in $IMAGES; do
        echo "  Exporting $image:latest → $image.tar"
        docker save "$image:latest" -o "./scripts/$image.tar"
        echo "  Created $image.tar"
    done

    echo "Export complete."
fi
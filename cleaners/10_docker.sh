#!/bin/bash

# Docker Cleaner - Removes unused Docker artifacts

echo "🐳 Docker Cleanup"
echo "=================="

# Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "ℹ️  Docker not installed or not in PATH."
    echo ""
    return 0
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "ℹ️  Docker daemon is not running."
    echo ""
    return 0
fi

DOCKER_CLEANED=false

# Clean up stopped containers
STOPPED_CONTAINERS=$(docker ps -aq --filter status=exited 2>/dev/null)
if [ ! -z "$STOPPED_CONTAINERS" ]; then
    DOCKER_CLEANED=true
    if [[ "$DRY_RUN" == "true" ]]; then
        container_count=$(echo "$STOPPED_CONTAINERS" | wc -l | tr -d ' ')
        echo "🔍 Would remove $container_count stopped containers"
    else
        echo "Removing stopped containers..."
        docker rm $STOPPED_CONTAINERS &
        loading_animation $!
        wait
        echo "✅ Removed stopped containers"
    fi
fi

# Clean up dangling images
DANGLING_IMAGES=$(docker images -qf dangling=true 2>/dev/null)
if [ ! -z "$DANGLING_IMAGES" ]; then
    DOCKER_CLEANED=true
    if [[ "$DRY_RUN" == "true" ]]; then
        image_count=$(echo "$DANGLING_IMAGES" | wc -l | tr -d ' ')
        echo "🔍 Would remove $image_count dangling images"
    else
        echo "Removing dangling images..."
        docker rmi $DANGLING_IMAGES &
        loading_animation $!
        wait
        echo "✅ Removed dangling images"
    fi
fi

# Clean up unused networks
if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 Would clean unused networks"
else
    echo "Removing unused networks..."
    docker network prune -f &
    loading_animation $!
    wait
    echo "✅ Cleaned unused networks"
fi
DOCKER_CLEANED=true

# Clean up unused volumes
if [[ "$DRY_RUN" == "true" ]]; then
    echo "🔍 Would clean unused volumes"
else
    echo "Removing unused volumes..."
    docker volume prune -f &
    loading_animation $!
    wait
    echo "✅ Cleaned unused volumes"
fi
DOCKER_CLEANED=true

if [ "$DOCKER_CLEANED" = false ]; then
    echo "ℹ️  No Docker cleanup needed."
fi

echo ""

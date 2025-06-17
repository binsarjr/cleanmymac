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
    echo "Removing stopped containers..."
    docker rm $STOPPED_CONTAINERS &
    loading_animation $!
    wait
    echo "✅ Removed stopped containers"
    DOCKER_CLEANED=true
fi

# Clean up dangling images
DANGLING_IMAGES=$(docker images -qf dangling=true 2>/dev/null)
if [ ! -z "$DANGLING_IMAGES" ]; then
    echo "Removing dangling images..."
    docker rmi $DANGLING_IMAGES &
    loading_animation $!
    wait
    echo "✅ Removed dangling images"
    DOCKER_CLEANED=true
fi

# Clean up unused networks
echo "Removing unused networks..."
docker network prune -f &
loading_animation $!
wait
echo "✅ Cleaned unused networks"
DOCKER_CLEANED=true

# Clean up unused volumes
echo "Removing unused volumes..."
docker volume prune -f &
loading_animation $!
wait
echo "✅ Cleaned unused volumes"
DOCKER_CLEANED=true

if [ "$DOCKER_CLEANED" = false ]; then
    echo "ℹ️  No Docker cleanup needed."
fi

echo ""

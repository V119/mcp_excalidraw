#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

start_canvas() {
  if docker ps --format '{{.Names}}' | grep -q '^mcp-excalidraw-canvas$'; then
    echo "Canvas server is already running."
  else
    echo "Starting canvas server..."
    docker rm -f mcp-excalidraw-canvas 2>/dev/null || true
    docker run -d \
      --name mcp-excalidraw-canvas \
      -p 3000:3000 \
      --restart unless-stopped \
      mcp-excalidraw-canvas:latest
    echo "Canvas server started on http://localhost:3000"
  fi
}

stop_canvas() {
  echo "Stopping canvas server..."
  docker stop mcp-excalidraw-canvas 2>/dev/null || true
  echo "Canvas server stopped."
}

case "${1:-start}" in
  start)  start_canvas ;;
  stop)   stop_canvas ;;
  restart)
    stop_canvas
    sleep 1
    start_canvas
    ;;
  status)
    docker ps --filter name=mcp-excalidraw-canvas --format '{{.Names}}: {{.Status}}'
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

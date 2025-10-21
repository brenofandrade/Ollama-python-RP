#!/bin/bash

# Check if START_OLLAMA is set to true (case-insensitive)
if [ "${START_OLLAMA,,}" = "true" ]; then
  echo "***** Environment variable START_OLLAMA is set to TRUE *****"
  echo "***** Starting Ollama server... *****"
  ollama serve > /workspace/logs/ollama.log 2>&1 &
  echo "***** Ollama server started and logging to /workspace/logs/ollama.log *****"
else
  echo "***** START_OLLAMA is not set to TRUE. Skipping Ollama server start. *****"
fi

echo "***** Starting App server... *****"
cd workspace/runpod_backend
source env/bin/activate
waitress-serve --listen=0.0.0.0:8000 main:app > ../logs/app.log
echo "***** App server started *****"

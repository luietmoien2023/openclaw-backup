#!/bin/bash
# Whisper Local Transcription Script - MEDIUM MODEL (Fastest)
# Usage: transcribe.sh <audio_file> [--language fr]

set -e

AUDIO_FILE="$1"
LANGUAGE="${LANGUAGE:-fr}"
MODEL="${MODEL:-medium}"  # MEDIUM = FASTEST

# Parse arguments
while [[ $# -gt 1 ]]; do
    case "$2" in
        --language) LANGUAGE="$3"; shift 2 ;;
        --model) MODEL="$3"; shift 2 ;;
        *) shift ;;
    esac
done

if [[ -z "$AUDIO_FILE" ]] || [[ ! -f "$AUDIO_FILE" ]]; then
    echo "Usage: $0 <audio_file> [--language fr]"
    exit 1
fi

# Check if faster-whisper is installed
if ! python3 -c "import faster_whisper" 2>/dev/null; then
    echo "Installing faster-whisper..."
    pip3 install faster-whisper --break-system-packages -q
fi

# Convert to wav if needed
TEMP_WAV=""
if [[ "$AUDIO_FILE" == *.ogg ]] || [[ "$AUDIO_FILE" == *.mp3 ]] || [[ "$AUDIO_FILE" == *.m4a ]]; then
    TEMP_WAV="/tmp/whisper_$(basename "$AUDIO_FILE" | sed 's/\.[^.]*$/.wav/')"
    ffmpeg -i "$AUDIO_FILE" -ar 16000 -ac 1 -c:a pcm_s16le "$TEMP_WAV" -y -hide_banner -loglevel error 2>/dev/null || {
        echo "Error: ffmpeg required"
        exit 1
    }
    AUDIO_FILE="$TEMP_WAV"
fi

# Run transcription with MEDIUM model (FASTEST)
python3 << EOF
from faster_whisper import WhisperModel
import sys

model_size = "$MODEL"
audio_path = "$AUDIO_FILE"
language = "$LANGUAGE"

print(f"Loading Whisper model: {model_size} (1.5GB - Fastest)", file=sys.stderr)
model = WhisperModel(model_size, device="cpu", compute_type="int8")

segments, info = model.transcribe(audio_path, language=language, beam_size=5)

print(f"Detected language: {info.language} (probability: {info.language_probability:.2f})")
print("")
for segment in segments:
    print(segment.text, end="", flush=True)
print("")
EOF

# Cleanup
if [[ -n "$TEMP_WAV" ]] && [[ -f "$TEMP_WAV" ]]; then
    rm -f "$TEMP_WAV"
fi

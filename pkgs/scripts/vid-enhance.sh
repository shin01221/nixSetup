#!/usr/bin/env bash
set -e

# ---------- defaults ----------
noise="-25"
volume="0"
preset="normal"
mono=1

usage() {
    echo "Usage: enhance-screencast input.[mp4|mkv|webm] [options]

Options:
  -o FILE        output file
  -n VALUE       noise reduction (default: -25)  e.g. -30 stronger
  -v VALUE       volume boost in dB (default: 0) e.g. 3
  -p PRESET      preset: normal | noisy | loud | strong
  --stereo       keep stereo (default mono)
  -h             help
"
}

[[ $# -eq 0 ]] && usage && exit 1

input=""

# ---------- parse ----------
while [[ $# -gt 0 ]]; do
    case "$1" in
    -o)
        output="$2"
        shift 2
        ;;
    -n)
        noise="$2"
        shift 2
        ;;
    -v)
        volume="$2"
        shift 2
        ;;
    -p)
        preset="$2"
        shift 2
        ;;
    --stereo)
        mono=0
        shift
        ;;
    -h)
        usage
        exit 0
        ;;
    *)
        if [[ -z "$input" ]]; then
            input="$1"
        else
            echo "Unknown arg: $1"
            exit 1
        fi
        shift
        ;;
    esac
done

[[ -z "$input" ]] && echo "No input file" && exit 1

# ---------- auto output ----------
if [[ -z "$output" ]]; then
    ext="${input##*.}"
    name="${input%.*}"
    output="${name}-enhanced.${ext}"
fi

# ---------- presets ----------
case "$preset" in
normal)
    noise="${noise:--25}"
    comp="threshold=-18dB:ratio=3"
    ;;
noisy)
    noise="-30"
    comp="threshold=-22dB:ratio=4"
    ;;
loud)
    volume="3"
    comp="threshold=-20dB:ratio=4"
    ;;
strong)
    noise="-32"
    volume="4"
    comp="threshold=-24dB:ratio=5"
    ;;
*)
    echo "Unknown preset: $preset"
    exit 1
    ;;
esac

# ---------- filters ----------
filters="highpass=f=80,afftdn=nf=${noise},acompressor=${comp},dynaudnorm"

if [[ "$volume" != "0" ]]; then
    filters="${filters},volume=${volume}dB"
fi

# ---------- run ----------
cmd=(ffmpeg -i "$input" -af "$filters" -c:v copy)

if [[ "$mono" == 1 ]]; then
    cmd+=(-ac 1)
fi

cmd+=("$output")

echo ">>> ${cmd[*]}"
"${cmd[@]}"

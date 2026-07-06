#!/usr/bin/env bash
source "$HOME/.local/bin/functions.sh"

usage() {
	cat <<EOF
Usage: magick.sh [--replace] <mode> <args>

Modes:
  --resize-height <in> <out> <HEIGHT> [top|bottom]
  --resize-width  <in> <out> <WIDTH>  [left|right|center]
  --downscale     <in> <out> <PERCENT>
  --sort          <DIR>

If <in> is a directory, all images in it are processed in-place.

With --replace (in-place, multiple files):
  --replace --resize-height <in>... <HEIGHT> [top|bottom]
  --replace --resize-width  <in>... <WIDTH>  [left|right|center]
  --replace --downscale     <in>... <PERCENT>

Options:
  --replace  Edit files in-place (output = input)
  --help     Show this help
EOF
	exit 0
}

replace_flag=false
batch_flag=false
mode=""
args=()

for arg in "$@"; do
	case "$arg" in
	--help) usage ;;
	--replace) replace_flag=true ;;
	--batch) batch_flag=true ;;
	--resize-height | --resize-width | --downscale | --sort) mode="$arg" ;;
	*) args+=("$arg") ;;
	esac
done
set -- "${args[@]}"

command -v magick >/dev/null 2>&1 || { echo "Error: ImageMagick (magick) not found" >&2; exit 1; }
command -v identify >/dev/null 2>&1 || { echo "Error: ImageMagick (identify) not found" >&2; exit 1; }

process_file() {
	local input="$1" output="$2" mode="$3"
	shift 3
	local rest=("$@")

	identify "$input" >/dev/null 2>&1 || { echo "Error: '$input' is not an image — please choose an image" >&2; return 1; }

	case "$mode" in
	--resize-height)
		local height_offset="${rest[0]}"
		local position="${rest[1]:-bottom}"
		local h
		h=$(identify -format "%h" "$input") || {
			echo "Error: Failed to read height of '$input'" >&2
			return 1
		}
		local new_height=$((h - height_offset))
		[ "$new_height" -gt 0 ] || { echo "Error: Resulting height $new_height <= 0 for '$input'" >&2; return 1; }
		local gravity
		case "$position" in
		top) gravity="South" ;;
		bottom | *) gravity="North" ;;
		esac
		magick "$input" -gravity "$gravity" -crop "x${new_height}+0+0" +repage "$output" || {
			echo "Error: Failed to process '$input'" >&2
			return 1
		}
		;;
	--resize-width)
		local width_offset="${rest[0]}"
		local position="${rest[1]:-center}"
		local w
		w=$(identify -format "%w" "$input") || {
			echo "Error: Failed to read width of '$input'" >&2
			return 1
		}
		local new_width=$((w - width_offset))
		[ "$new_width" -gt 0 ] || { echo "Error: Resulting width $new_width <= 0 for '$input'" >&2; return 1; }
		local gravity
		case "$position" in
		left) gravity="East" ;;
		right) gravity="West" ;;
		center | *) gravity="Center" ;;
		esac
		magick "$input" -gravity "$gravity" -crop "${new_width}x+0+0" +repage "$output" || {
			echo "Error: Failed to process '$input'" >&2
			return 1
		}
		;;
	--downscale)
		local val="${rest[0]}"
		val="${val%\%}"
		[ "$val" -gt 0 ] 2>/dev/null || { echo "Error: Invalid percentage '$val'" >&2; return 1; }
		magick "$input" -resize "${val}%" "$output" || {
			echo "Error: Failed to downscale '$input'" >&2
			return 1
		}
		;;
	esac
}

case "$mode" in
--resize-height | --resize-width | --downscale)
	if $batch_flag; then
		[ -d "$1" ] || { echo "Error: '$1' is not a directory" >&2; exit 1; }
		dir="$1"
		val="$2"
		[[ -z "$val" ]] && { echo "Error: Missing value argument for $mode" >&2; exit 1; }
		position="$3"

		fail=0
		while IFS= read -r -d '' img; do
			process_file "$img" "$img" "$mode" "$val" "$position" || fail=1
		done < <(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print0)
		exit $fail
	elif $replace_flag; then
		case "$mode" in
		--downscale)
			last_idx=$((${#args[@]} - 1))
			percent="${args[$last_idx]}"
			inputs=("${args[@]:0:$last_idx}")
			;;
		--resize-height | --resize-width)
			last_idx=$((${#args[@]} - 1))
			val="${args[$last_idx]}"
			position=""
			prev="${args[$((last_idx - 1))]:-}"
			case "$prev" in
			top | bottom | center | left | right)
				position="$prev"
				inputs=("${args[@]:0:$((last_idx - 1))}")
				;;
			*)
				inputs=("${args[@]:0:$last_idx}")
				;;
			esac
			;;
		esac
		[ ${#inputs[@]} -eq 0 ] && { echo "Error: No input files" >&2; exit 1; }
		fail=0
		for input in "${inputs[@]}"; do
			[ -f "$input" ] || { echo "Error: '$input' is not a file" >&2; fail=1; continue; }
			process_file "$input" "$input" "$mode" "$val" "$position" || fail=1
		done
		exit $fail
	elif [ -d "$1" ]; then
		dir="$1"
		val="$2"
		[[ -z "$val" ]] && { echo "Error: Missing value argument for $mode" >&2; exit 1; }
		position="$3"

		fail=0
		while IFS= read -r -d '' img; do
			process_file "$img" "$img" "$mode" "$val" "$position" || fail=1
		done < <(find "$dir" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -print0)
		exit $fail
	else
		input="$1" output="$2"
		[[ -z "$input" || -z "$output" ]] && { echo "Error: Missing arguments for $mode" >&2; exit 1; }
		[ -f "$input" ] || { echo "Error: '$input' is not a file" >&2; exit 1; }
		shift 2
		process_file "$input" "$output" "$mode" "$@"
	fi
	;;

--sort)
	dir="${1:-.}"
	[ -d "$dir" ] || { echo "Error: '$dir' is not a directory" >&2; exit 1; }
	sort_images "$dir"
	;;

*)
	usage
	;;
esac

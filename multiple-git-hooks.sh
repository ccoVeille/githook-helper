#!/bin/sh

# This script should be saved in a git repo as a hook file, e.g. .git/hooks/pre-receive.
# It looks for scripts in the .git/hooks/pre-receive.d directory and executes them in order,
# passing along stdin. If any script exits with a non-zero status, this script exits.

blue=$(tput setaf 247)
invert=$(tput rev)
red=$(tput setaf 1)
reset=$(tput sgr0)

script_dir=$(dirname "$0")
hook_name=$(basename "$0")

hook_dir="$script_dir/$hook_name.d"

if [ ! -d "$hook_dir" ]; then
	print "${invert}$hook_dir not found${reset}"
	exit 0
fi

found=0
tmp=$(mktemp)
trap 'rm $tmp' EXIT
find "$hook_dir" -perm -u=x -not -type d >"$tmp"
# see https://github.com/koalaman/shellcheck/wiki/SC2044 for the strange loop
while IFS= read -r hook; do
	found=1
	hook_cmd="$hook_name.d/$(basename "$hook")"
	printf %s "Running ${blue}${hook_cmd}${reset} hook"

	ts=$(date +%s%N)
	$hook "$@" </dev/tty
	exit_code=$?
	if [ $exit_code != 0 ]; then
		printf "\n%s\n" "${hook_cmd} hook returned ${red}${exit_code}${reset}"
		exit $exit_code
	fi
	tt=$((($(date +%s%N) - ts) / 1000000))
	printf " %s\n" "${blue}${tt} ms${reset}"
done <"$tmp"

if [ "$found" -eq 0 ]; then
	printf "%s\n" "${red}no hook found in ${hook_dir}${reset}"
	exit 0
fi

exit 0

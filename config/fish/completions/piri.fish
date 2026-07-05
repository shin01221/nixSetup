# Print an optspec for argparse to handle cmd's options that are independent of any subcommand.
function __fish_piri_global_optspecs
	string join \n c/config= d/debug h/help
end

function __fish_piri_needs_command
	# Figure out if the current invocation already has a command.
	set -l cmd (commandline -opc)
	set -e cmd[1]
	argparse -s (__fish_piri_global_optspecs) -- $cmd 2>/dev/null
	or return
	if set -q argv[1]
		# Also print the command, so this can be used to figure out what it is.
		echo $argv[1]
		return 1
	end
	return 0
end

function __fish_piri_using_subcommand
	set -l cmd (__fish_piri_needs_command)
	test -z "$cmd"
	and return 1
	contains -- $cmd[1] $argv
end

complete -c piri -n "__fish_piri_needs_command" -s c -l config -d 'Configuration file path' -r
complete -c piri -n "__fish_piri_needs_command" -s d -l debug -d 'Enable debug logging'
complete -c piri -n "__fish_piri_needs_command" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_needs_command" -f -a "daemon" -d 'Start piri as a daemon'
complete -c piri -n "__fish_piri_needs_command" -f -a "scratchpads" -d 'Scratchpads management'
complete -c piri -n "__fish_piri_needs_command" -f -a "singleton" -d 'Singleton management'
complete -c piri -n "__fish_piri_needs_command" -f -a "window-order" -d 'Window order management'
complete -c piri -n "__fish_piri_needs_command" -f -a "stop" -d 'Stop the daemon'
complete -c piri -n "__fish_piri_needs_command" -f -a "completion" -d 'Generate shell completion script'
complete -c piri -n "__fish_piri_needs_command" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand daemon" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and not __fish_seen_subcommand_from toggle add help" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and not __fish_seen_subcommand_from toggle add help" -a "toggle" -d 'Toggle scratchpad visibility'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and not __fish_seen_subcommand_from toggle add help" -a "add" -d 'Add current focused window as scratchpad'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and not __fish_seen_subcommand_from toggle add help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and __fish_seen_subcommand_from add" -l swallow-to-focus -d 'If true, swallow the scratchpad window to the focused window when shown'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and __fish_seen_subcommand_from add" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and __fish_seen_subcommand_from help" -f -a "toggle" -d 'Toggle scratchpad visibility'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and __fish_seen_subcommand_from help" -f -a "add" -d 'Add current focused window as scratchpad'
complete -c piri -n "__fish_piri_using_subcommand scratchpads; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand singleton; and not __fish_seen_subcommand_from toggle help" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand singleton; and not __fish_seen_subcommand_from toggle help" -a "toggle" -d 'Toggle singleton (focus if exists, launch if not)'
complete -c piri -n "__fish_piri_using_subcommand singleton; and not __fish_seen_subcommand_from toggle help" -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand singleton; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand singleton; and __fish_seen_subcommand_from help" -f -a "toggle" -d 'Toggle singleton (focus if exists, launch if not)'
complete -c piri -n "__fish_piri_using_subcommand singleton; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand window-order; and not __fish_seen_subcommand_from toggle help" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand window-order; and not __fish_seen_subcommand_from toggle help" -f -a "toggle" -d 'Toggle window order (reorder windows in current workspace)'
complete -c piri -n "__fish_piri_using_subcommand window-order; and not __fish_seen_subcommand_from toggle help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand window-order; and __fish_seen_subcommand_from toggle" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand window-order; and __fish_seen_subcommand_from help" -f -a "toggle" -d 'Toggle window order (reorder windows in current workspace)'
complete -c piri -n "__fish_piri_using_subcommand window-order; and __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand stop" -s h -l help -d 'Print help'
complete -c piri -n "__fish_piri_using_subcommand completion" -s h -l help -d 'Print help (see more with \'--help\')'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "daemon" -d 'Start piri as a daemon'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "scratchpads" -d 'Scratchpads management'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "singleton" -d 'Singleton management'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "window-order" -d 'Window order management'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "stop" -d 'Stop the daemon'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "completion" -d 'Generate shell completion script'
complete -c piri -n "__fish_piri_using_subcommand help; and not __fish_seen_subcommand_from daemon scratchpads singleton window-order stop completion help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c piri -n "__fish_piri_using_subcommand help; and __fish_seen_subcommand_from scratchpads" -f -a "toggle" -d 'Toggle scratchpad visibility'
complete -c piri -n "__fish_piri_using_subcommand help; and __fish_seen_subcommand_from scratchpads" -f -a "add" -d 'Add current focused window as scratchpad'
complete -c piri -n "__fish_piri_using_subcommand help; and __fish_seen_subcommand_from singleton" -f -a "toggle" -d 'Toggle singleton (focus if exists, launch if not)'
complete -c piri -n "__fish_piri_using_subcommand help; and __fish_seen_subcommand_from window-order" -f -a "toggle" -d 'Toggle window order (reorder windows in current workspace)'

[ -n "$PS1" ] && source ~/.bash/profile;

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" = ~screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
 exec tmux
fi

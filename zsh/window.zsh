title() {
  case $TERM in
    screen*) print -Pn "\ek$1:$3\e\\" ;;
    xterm*|rxvt*) print -Pn "\e]2;$2\a" ;;
  esac
}

_dotfiles_set_title() { title "zsh" "%m" "%55<...<%~" }

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_set_title

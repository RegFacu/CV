echo "${BASH_COLOR_BLUE}Installing latest version of rbenv${BASH_COLOR_NC}"
brew install rbenv

echo "${BASH_COLOR_BLUE}Initializing rbenv${BASH_COLOR_NC}"
log=$(eval 'rbenv init' zsh)
echo $log

if [[ ! $log =~ "already configured" ]]; then
  echo "${BASH_COLOR_ORANGE}Warning: Close your Terminal window and open a new one so your changes take effect${BASH_COLOR_NC}"
fi

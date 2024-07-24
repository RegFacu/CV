ruby_version=$(cat "$WORKSPACE_DIR/.ruby-version")
echo "${BASH_COLOR_BLUE}Installing ruby $ruby_version by rbenv${BASH_COLOR_NC}"
rbenv install -s
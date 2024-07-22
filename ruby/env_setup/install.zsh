#!/bin/zsh
# Define useful dirs
FILE_PATH=${FILE_PATH:=${${(%):-%N}}}
export INITIAL_DIR=$( cd -- "$( dirname -- "." )" &> /dev/null && pwd )
export SCRIPT_DIR=$( cd -- "$( dirname -- "$FILE_PATH" )" &> /dev/null && pwd )
export WORKSPACE_DIR=$( cd -- "$SCRIPT_DIR/../.." &> /dev/null && pwd )

# Define bash colors
export BASH_COLOR_RED='\033[0;31m'
export BASH_COLOR_ORANGE='\033[0;33m'
export BASH_COLOR_BLUE='\033[0;34m'
export BASH_COLOR_NC='\033[0m' # No Color

clear

echo "${BASH_COLOR_BLUE}Running script from $INITIAL_DIR dir${BASH_COLOR_NC}"
echo "${BASH_COLOR_BLUE}Moving to $WORKSPACE_DIR dir${BASH_COLOR_NC}"
cd $WORKSPACE_DIR

$SCRIPT_DIR/install_rbenv.zsh
$SCRIPT_DIR/install_bundler.zsh
$SCRIPT_DIR/install_project_ruby_version.zsh

echo "${BASH_COLOR_BLUE}Moving back to $INITIAL_DIR dir${BASH_COLOR_NC}"
cd $INITIAL_DIR

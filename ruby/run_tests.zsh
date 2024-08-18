bundle install
clear

rubocop
if [ "$?" != "0" ]; then
  echo ""
  read -p "Do you want to try to automatically fix the issues? (y/n): " fix_issues
  if [ "$fix_issues" == "y" ]; then
    clear
    rubocop -A
  fi
fi

rspec --format j -o ruby/tests.json --format RSpec::Github::Formatter ruby
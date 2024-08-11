bundle install
clear
ruby ruby/scripts/generate_cv.rb --path=assets/data/spanish.json
ruby ruby/scripts/generate_cv.rb --path=assets/data/english.yml

rubocop
if [ "$?" != "0" ]; then
  echo ""
  read -p "Do you want to try to automatically fix the issues? (y/n): " fix_issues
  if [ "$fix_issues" == "y" ]; then
    clear
    rubocop -A
  fi
fi

terminal_title='Quick Brick React Native Packager'

echo -n -e "\033]0;${terminal_title}\007"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd $DIR
if [ -d "quick_brick" ];
then
  yarn start
else
  echo "no quick_brick app prepared - skipping packager"
fi
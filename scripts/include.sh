GITHUB_TOKEN="GENERATE_ME_A_PERSONAL_ACCESS_TOKEN_PRETTY_PLEASE"
GITHUB_USERNAME="vroomfondel"

# echo \$0: $0

include_local_sh="./include.local.sh"
include_local_sh2="$(dirname "$0")/scripts/include.local.sh"

if [ -e "${include_local_sh}" ] ; then
  echo "${include_local_sh}" to be read...
  source "${include_local_sh}"
else
  # echo "${include_local_sh}" does not exist...
  if [ -e "${include_local_sh2}" ] ; then
    echo "${include_local_sh2}" to be read...
    source "${include_local_sh2}"
  else
    echo NEITHER "${include_local_sh}" NOR "${include_local_sh2}" exist...
  fi
fi
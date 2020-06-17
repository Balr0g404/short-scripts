#!/bin/bash
#Author : Balr0g404

# ------------------ COLORS
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
# ------------------ COMMAND AND DEPENDENCES
d="$(which docker)"
s="$(which screen)"
g="$(which git)"

test -z $d && echo -e "${RED}[+]Docker is not installed. Use 'sudo apt install docker' ${NC}" && exit 1
test -z $s && echo -e "${RED}[+]Screen is not installed. Use 'sudo apt install screen' ${NC}" && exit 2
test -z $g && echo -e "${RED}[+]Git is not installed. Use 'sudo apt install git' ${NC}" && exit 3

test $(id -u) -eq 0 && echo "${RED}[+]Cannot be launched as root ${NC}" && exit 255

d="sudo $(which docker)"
# ------------------ FUNCTIONS
Help() {
  echo -e "${RED}[+] Usage : ${NC} "$(basename $0)" ${RED}[options]${NC} "
  echo "Options and arguments :"
  echo "-h, --help         : Print this help."
  echo "-l, --launch      : Launch bot. Check for existing container and image with the name 'hackerbot'"
  echo "                  : This options launches the bot inside a detached screen."
  echo "-u, --update      : Update bot. It pulls the code from github and launches the bot."
  echo "-s, --stop        : Stop the bot."
}

Launch() {
  checkimage="$($d image ls hackerbot)"
  checkcontainer="$($d container ls)"
  if [[ $checkimage == *hackerbot* ]]; then
    if [[ $checkcontainer == *hackerbot* ]]; then
      echo -e "${BLUE}[+]Container is already running, deleting it${NC}"
      $d container rm -f hackerbot
      echo -e "${GREEN}[+]Container deleted${NC}"
    fi
    echo -e "${GREEN}[+]Launching container${NC}"
    $s -dm $d run -w /home/bot/bot_python --name hackerbot hackerbot
  else
    echo -e "${BLUE}[+]Building image, this may take some times${NC}"
    $s build --tag hackerbot .
    echo -e "${GREEN} [+]Image built !${NC}"
  fi
    echo -e "${GREEN} [+]Running bot !${NC}"
    $s -dm $d run -w /home/bot/bot_python --name hackerbot hackerbot
}

Update(){
  echo -e "${GREEN}[+]Pulling code from github${NC}"
  $g pull
  echo -e "${BLUE}[+]Launching bot ${NC}"
  Launch
}

Stop(){
  echo -e "${RED}[+]Stopping bot ${NC}"
  $d container rm -f hackerbot
  echo -e "${RED}[+]Bot stopped ${NC}"
}

# ------- MAIN
case $1 in
  "-h" | "--help")
    Help
    ;;

  "-l" | "--launch")
    Launch
    ;;

  "-u" | "--update")
    Update
    ;;

  "-s" | "--stop")
    Stop
    ;;

  *)
    Help
esac

exit 0

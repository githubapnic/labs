#!/bin/bash
# https://linuxhint.com/30_bash_script_examples/

CURRENT_DIR=$(pwd)
function hello_world()
{
  clear
  for (( counter=100; counter>0; counter-- ))
  do
    echo -n "Hello World "
  done
  echo ""
  echo ""
}

function display_password_file()
{
  #clear
  cat /etc/passwd
}

function account_hacked()
{
  echo ""
  echo ""
  mkdir This
  cd This
  mkdir Account
  cd Account
  mkdir has
  cd has
  mkdir been
  cd been
  mkdir hacked
  cd hacked
  pwd

  cd $CURRENT_DIR
  rm -R This/
}

account_hacked
hello_world
display_password_file
account_hacked
account_hacked
account_hacked
account_hacked
account_hacked

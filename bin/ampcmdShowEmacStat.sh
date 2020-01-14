#! /bin/sh

help_msg()
{
   echo  "------------amp show emac stat------------" 
   echo  " Param < 1 >"
   echo  "  0: emac message queue"
   echo  "  1: emac up traffic"
   echo  "  2: emac down traffic"
   echo  "  3: kernel oam"
   echo  "  4: config"

}

if [ "$1" = "-h" ];then
  help_msg
  return $?
elif [ 1 -ne $# ];then
    echo "ERROR::input para is not right!"
    return 1;
else
  if [ "$1" != "0" ] && [ "$1" != "1" ] && [ "$1" != "2" ] && [ "$1" != "3" ] && [ "$1" != "4" ];then
    echo "ERROR::input para is not right!"
    return 1;
  else
    ampcmd show emac stat $1
    return $?
  fi
fi
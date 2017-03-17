#!/bin/sh

#### The help/usage message.

usage() {
	printf "usage: %s [-h] -c processor_number
	-h: prints this message
	-c processor_number: the number of the processor to switch on/off \n" $(basename $0) >&2
}

#### Parse options

if [ $# -lt 1 ] ; then
   usage
   exit 1
fi

while getopts ":c:h" opt; do
  case $opt in
    c)
      PROCESSOR_NO=$OPTARG ;;
    h)
	  usage
	  exit 1 ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1 ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1 ;;
  esac
done

####

echo $(( $(cat /sys/devices/system/cpu/cpu$PROCESSOR_NO/online) ^ 1 )) > /sys/devices/system/cpu/cpu$PROCESSOR_NO/online
#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "usage: stop_button.bash <name_of_crazyflie>"
    echo "example: ./stop_button.bash crazym05"
    exit -1
fi

export ROS_MASTER_URI=http://demo-nuc:11311
python stop_button.py $1

#!/usr/bin/env python
import rospy
import sys
import Tkinter
import std_srvs

from std_msgs.msg import Float32
from std_srvs.srv import Trigger

top = Tkinter.Tk()

labeltext = Tkinter.StringVar()
label = Tkinter.Label(top, textvariable=labeltext)
robot_name = "unknown_robot"
estop = 0
killmatlab = 0

def batteryCallback(data):
    global label
    global labeltext
    bat = data.data
    labeltext.set('battery: %.2f' % bat)
    label.configure(bg=('green' if bat > 3.4 else 'red'))
    
def stopCallback():
    killmatlab()
    estop()
    print "robot {} stopped!!!".format(robot_name)

def setup_service():
    global estop, killmatlab
    svcname = '/{}/mav_services/estop'.format(robot_name)
    msvcname = '/kill_matlab_{}'.format(robot_name)
    rospy.wait_for_service(svcname);
    try:
        estop = rospy.ServiceProxy(svcname, std_srvs.srv.Trigger)
        killmatlab = rospy.ServiceProxy(msvcname, std_srvs.srv.Trigger)
    except rospy.ServiceException, e:
        rospy.logerror('service call to {} or {} failed'.format(svcname,
                                                                msvcname))

def setup_battery_listener():
    rospy.init_node('stop_button', anonymous=True)
    rospy.Subscriber(robot_name + "/battery", Float32, batteryCallback)

if __name__ == '__main__':
    robot_name = sys.argv[1];
    setup_battery_listener()
    setup_service()
    padding = 50
    robot_label = Tkinter.Label(top, text=robot_name)
    robot_label.pack()

    b = Tkinter.Button(top, text="STOP", padx=padding, pady=padding,
                       command=stopCallback)
    buttoncolor = 'yellow'
    b.configure(bg=buttoncolor,activebackground='red')
    b.pack()
    label.pack()
    top.mainloop()

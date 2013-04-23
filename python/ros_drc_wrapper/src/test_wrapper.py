#!/usr/bin/env python
import roslib; roslib.load_manifest('ros_drc_wrapper')
import rospy, sys

from std_msgs.msg import String

from ros_drc_wrapper.srv import *


rospy.wait_for_service('run_simulation')
run_simulation = rospy.ServiceProxy('run_simulation', RunSimulation)

try:
  resp1 = run_simulation('test')
  print resp1
except rospy.ServiceException, e:
  print "Service did not process request: %s"%str(e)


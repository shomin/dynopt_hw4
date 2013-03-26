#!/usr/bin/env python
import roslib; roslib.load_manifest('dynopt_hw4')
import rospy
from atlas_msgs.msg import AtlasState
import pickle
import numpy as np
import scipy.io

f = open('walking_capture.dat');
print "Reading Pickle"
p = pickle.load(f)
print "Done, making numpy array"

pos = p[0].joint_states.position
vel = p[0].joint_states.velocity
eff = p[0].joint_states.effort
#lf_wr = np.hstack((p[0].force_torque_sensors.l_foot.force,p[0].force_torque_sensors.l_foot.torque))
#rf_wr = np.hstack((p[0].force_torque_sensors.r_foot.force,p[0].force_torque_sensors.r_foot.torque))
#imu = np.hstack((p[0].imu.orientation,p[0].imu.angular_velocity,p[0].imu.linear_acceleration))

last_per = 0
l = len(p)

for idx,el in enumerate(p):
  per = (100*idx)/l
  if per > last_per:
    print "%d%%" % per
    last_per = per
  pos = np.vstack((pos,el.joint_states.position))
  vel = np.vstack((vel,el.joint_states.velocity))
  eff = np.vstack((eff,el.joint_states.effort))
  '''lf_wr = np.vstack((lf_wr,
                    np.hstack((el.force_torque_sensors.l_foot.force,el.force_torque_sensors.l_foot.torque))))
  rf_wr = np.vstack((rf_wr,
                    np.hstack((el.force_torque_sensors.r_foot.force,el.force_torque_sensors.r_foot.torque))))
  imu = np.vstack((imu, np.hstack((el.imu.orientation,el.imu.angular_velocity,el.imu.linear_acceleration))))'''

scipy.io.savemat('walking_no_ground.mat',dict(pos=pos,vel=vel,eff=eff))
#scipy.io.savemat('walking_no_ground.mat',dict(pos=pos,vel=vel,eff=eff,lf_wr=lf_wr,rf_wr=rf_wr,imu=imu))

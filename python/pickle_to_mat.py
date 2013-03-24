#!/usr/bin/env python
import roslib; roslib.load_manifest('dynopt_hw4')
import rospy
from atlas_msgs.msg import AtlasState
import pickle
import numpy as np
import scipy.io

f = open('walking_capture.dat');
p = pickle.load(f)

pos = p[0].joint_states.position
vel = p[0].joint_states.velocity
eff = p[0].joint_states.effort

for el in p:
  pos = np.vstack((pos,el.joint_states.position))
  vel = np.vstack((vel,el.joint_states.velocity))
  eff = np.vstack((eff,el.joint_states.effort))

scipy.io.savemat('walking.mat',dict(pos=pos,vel=vel,eff=eff))

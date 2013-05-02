#!/usr/bin/env python
import roslib; roslib.load_manifest('ros_drc_wrapper')
import rospy, sys
#from osrf_msgs.msg import JointCommands
from sensor_msgs.msg import JointState
#from atlas_msgs.msg import AtlasState
from std_msgs.msg import String

from ros_drc_wrapper.srv import *

from process import Process
import time



  
def launch(world_loc_='/home/ben/atlas_cga.world', 
           model_loc_='/home/ben/Desktop/gz_walk_dynopt/gz_walking/models/atlas_cga/model2.urdf'):
    rospy.init_node('ros_drc_wrapper_node')
    
    global world_loc, model_loc
    world_loc, model_loc = world_loc_, model_loc_

    s = rospy.Service('run_simulation', RunSimulation, run_simulation)
    
    print 'Simulation wrapper service started'
    rospy.spin()
    
def run_simulation(req):
    ''' launch the ros node that calls gazebo using the appropriate world and urdf model 

    on the commandline, this command would look like this:

    roslaunch atlas_utils atlas_cga.launch gzworld:=/home/ben/atlas_cga.world gzrobot:=/home/ben/Desktop/gz_walk_dynopt/gz_walking/models/atlas_cga/model2.urdf 

    we grab the output of this node from stdout and analyze it

    '''

    # req may contain a preset non-clashing gazebo simulation ID for parallel execution
    
    trqTotal = 0

    global world_loc, model_loc
    cmd = "roslaunch atlas_utils atlas_cga.launch gzworld:=%s gzrobot:=%s" % (world_loc, model_loc)

    proc = Process(cmd.split(), stdout=True)
    while True:
        try:
            line = proc.readline('stdout', block=True)
        except KeyboardInterrupt, rospy.ROSInterruptException:
            proc.kill()
            break
            
        if line and line.startswith('~~~'):
            trq = float(line.split()[4])
            trqTotal += trq*trq
            
        if line and line.startswith('=== END '): 
            print line
            print 'Total Torque Squared', trqTotal
            break
        
    print 'killing gazebo!'
    proc.kill()    
    
    return RunSimulationResponse(str(trqTotal))


if __name__ == '__main__': 
    if len(sys.argv) > 2:
        launch(sys.argv[1], sys.argv[2])
    else:
        print 'usage rosrun ros_drc_wrapper wrapper.py <world_file> <model_file>'
        print 'running with default arguments... if you aren\'t Ben this won\'t work!'
        launch()
    
    
    
  


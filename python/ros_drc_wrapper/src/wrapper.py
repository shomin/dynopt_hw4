#!/usr/bin/env python
import roslib; roslib.load_manifest('ros_drc_wrapper')
import rospy, sys
#from osrf_msgs.msg import JointCommands
from sensor_msgs.msg import JointState
#from atlas_msgs.msg import AtlasState
from std_msgs.msg import String

from process import Process
import time

  
def launch(world_loc='/home/ben/atlas_cga.world', 
           model_loc='/home/ben/Desktop/gz_walk_dynopt/gz_walking/models/atlas_cga/model2.urdf'):
    ''' launch the ros node that calls gazebo using the appropriate world and urdf model 

    on the commandline, this command would look like this:

    roslaunch atlas_utils atlas_cga.launch gzworld:=/home/ben/atlas_cga.world gzrobot:=/home/ben/Desktop/gz_walk_dynopt/gz_walking/models/atlas_cga/model2.urdf 

    we grab the output of this node from stdout and analyze it

    '''
    
    pub = rospy.Publisher('final_torque_squared', String)
    rospy.init_node('ros_drc_wrapper_node')

    
    trqTotal = 0

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
            pub.publish(String(str(trqTotal)))
            break
        
    print 'killing gazebo!'
    proc.kill()

if __name__ == '__main__': 
    if len(sys.argv) > 2:
        launch(sys.argv[1], sys.argv[2])
    else:
        print 'usage rosrun ros_drc_wrapper wrapper.py <world_file> <model_file>'
        print 'running with default arguments... if you aren\'t Ben this won\'t work!'
        launch()
    
    
    
  


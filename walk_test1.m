% Setup classpath
jmb_init();

% Init_Node
MASTER_URI='http://localhost:11311';
NODE_NAME='walktest1';
node=jmb_init_node(NODE_NAME, MASTER_URI);

NODE2_NAME='statelistener';
node2=jmb_init_node(NODE2_NAME, MASTER_URI);

% Create a Subscriber
sub=edu.ucsd.SubscriberAdapter(node2,'/atlas/imu','sensor_msgs/Imu');
% sub=edu.ucsd.SubscriberAdapter(node2,'/atlas/atlas_state','atlas_msgs/AtlasState');

% timeout=5;

% logger=node2.getLog()

% Create Publisher
% pub=node.newPublisher('/chatter','std_msgs/String');
pub=node.newPublisher('/atlas/joint_commands', 'osrf_msgs/JointCommands');

% 1-4 body
% 5-10 left leg
% 11-16 right leg
% 17-22 left arm
% 23-28 right arm
atlasJointNames = {'atlas::back_lbz', 'atlas::back_mby', 'atlas::back_ubx', 'atlas::neck_ay', ...
    'atlas::l_leg_uhz', 'atlas::l_leg_mhx', 'atlas::l_leg_lhy', 'atlas::l_leg_kny', 'atlas::l_leg_uay', 'atlas::l_leg_lax', ...
    'atlas::r_leg_uhz', 'atlas::r_leg_mhx', 'atlas::r_leg_lhy', 'atlas::r_leg_kny', 'atlas::r_leg_uay', 'atlas::r_leg_lax', ...
    'atlas::l_arm_usy', 'atlas::l_arm_shx', 'atlas::l_arm_ely', 'atlas::l_arm_elx', 'atlas::l_arm_uwy', 'atlas::l_arm_mwx', ...
    'atlas::r_arm_usy', 'atlas::r_arm_shx', 'atlas::r_arm_ely', 'atlas::r_arm_elx', 'atlas::r_arm_uwy', 'atlas::r_arm_mwx'};

% New a message, setup fields
msg=org.ros.message.osrf_msgs.JointCommands();
% msg.name = list(atlasJointNames); % apparently this field isn't actually used..
n = length(atlasJointNames);
msg.position     = zeros(1,n);
msg.velocity     = zeros(1,n);
msg.effort       = zeros(1,n);
msg.kp_position  = zeros(1,n);
msg.ki_position  = zeros(1,n);
msg.kd_position  = zeros(1,n);
msg.kp_velocity  = zeros(1,n);
msg.i_effort_min = zeros(1,n);
msg.i_effort_max = zeros(1,n);

params = node.newParameterTree();
for ii=1:length(atlasJointNames)
    msg.kp_position(ii) = 100*params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/p']);
    msg.ki_position(ii) = 10*params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/i']);
    msg.kd_position(ii) = 20*params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/d']);
    msg.i_effort_max(ii) = 50*params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/i_clamp']);
end

% load robot1;
% walking = load('python/walking.mat');
load('mrdplot/d00010.mat');
walking = mrd;

msg.position = walking.pos(1,:);
msg.velocity = zeros(1,length(msg.position));
msg.effort = zeros(1,length(msg.position));
pub.publish(msg);

% vx = 0;
% vy = 0;
% rot = [0;0;0];

% for jj = 1:4
tic
t=0;
% rot = [0;0;0];
% while t<.5*4
%     msg2=sub.takeMessage(.001);
%     if ~isempty(msg2)
%         q0 = msg2.orientation.w;
%         q1 = msg2.orientation.x;
%         q2 = msg2.orientation.y;
%         q3 = msg2.orientation.z;
%         rot = [atan2(2*(q0*q1+q2*q3),1-2*(q1^2+q2^2))
%             asin(2*(q0*q2-q3*q1))
%             atan2(2*(q0*q3+q1*q2),1-2*(q2^2+q3^2))];
%     end
%     
%     t = toc;
%     for ii=1:length(atlasJointNames)
% %         msg.position(ii) = polyval(robot1.j(ii+1).spline,min([t/4 .5]));
%     end
%     
%     pub.publish(msg);
%     pause(.2);
% end

for ii=1:length(walking.pos)
    msg.position = walking.pos(ii,:);
    msg.position(7) = msg.position(7)-pi/7;
    msg.position(13) = msg.position(13)-pi/7;
    msg.position(6) = msg.position(6)+pi/30;
    msg.position(12) = msg.position(12)-pi/30;
    msg.velocity = walking.vel(ii,:);
    msg.effort = walking.eff(ii,:);
    pub.publish(msg);
    pause(.001)
end

pause(.1)
msg.position = walking.pos(1,:);
msg.velocity = zeros(1,length(msg.position));
msg.effort = zeros(1,length(msg.position));
pub.publish(msg);
pause(1);
disp('finished');

% Shutdown this node, unregister
node.shutdown()
node2.shutdown()
% Setup classpath 
jmb_init();

% Init_Node
MASTER_URI='http://localhost:11311';
NODE_NAME='hoptest';
node=jmb_init_node(NODE_NAME, MASTER_URI);

% Create Publisher
% pub=node.newPublisher('/chatter','std_msgs/String');
pub=node.newPublisher('/atlas/joint_commands', 'osrf_msgs/JointCommands');

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
    msg.kp_position(ii) = params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/p']);
    msg.ki_position(ii) = params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/i']);
    msg.kd_position(ii) = params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/d']);
    msg.i_effort_max(ii) = params.getDouble(['atlas_controller/gains/',atlasJointNames{ii}(8:end),'/i_clamp']);
end

tic
t=0;
while t<2*pi
    t = toc
    msg.position(18) = -sin(t)*pi/4;
    msg.position(24) = sin(t)*pi/4;
    

%     msg.position(8) = -(1-cos(t))*pi/20;
%     msg.position(14) = (1-cos(t))*pi/20;
%     
%     msg.position(9) = -(1-cos(t))*pi/6;
%     msg.position(15) = -(1-cos(t))*pi/6;
%     
    % Publish
    pub.publish(msg);

	% ROS_INFO(msg)
% 	node.getLog().info(['I talked - ' char(msg.data)]);
	pause(.01);
end
for ii=1:length(atlasJointNames)
    msg.position(ii) = 0;
end
pub.publish(msg);
pause(1);
disp('finished');

% Shutdown this node, unregister
node.shutdown()
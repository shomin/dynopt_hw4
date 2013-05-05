function fmintest()
tic
AA =diagmx([eye(4) zeros(4,1)] - [zeros(4,1) eye(4)], [eye(4) zeros(4,1)] - [zeros(4,1) eye(4)]);
AA(end+1,[1 6])=[1; -1];
A = [eye(10);-eye(10); AA];
b = [.5; 2*ones(4,1); .5; 2*ones(4,1); zeros(10,1); zeros(9,1)];
load('steps.txt');
x0 = [steps([1 3 5 7 9],3); steps([2 4 6 8 9],6)];
[x fval] = fmincon(@drc_fun, x0, A, b)
toc


function f = drc_fun(x)
goalpos = [1.35 1.35];

footsteps.support = [0 2 1 2 1 2 1 2 0 0];
t = [0 1:.6:5.8]';
xL = [x(1) x(1) x(2) x(2) x(3) x(3) x(4) x(4) x(5) x(5)];
xR = [x(1) x(6) x(6) x(7) x(7) x(8) x(8) x(9) x(10) x(10)];
pos = [t xL' 0.089*ones(10,1) zeros(10,1) xR' -0.089*ones(10,1) zeros(10,1)]
footsteps.pos = pos;
writeFootstepFile('steps.txt',footsteps);

[~,result] = system('python /home/vdesaraj/ros/dynopt_hw4/python/ros_drc_wrapper/src/test_wrapper.py');

totaltorque = sscanf(result,'resp: str: %f');
if isempty(totaltorque)
    totaltorque = 1e10;
end
dist2goal = norm(x([5,10])-goalpos');
f = dist2goal*1000+totaltorque*1e-6


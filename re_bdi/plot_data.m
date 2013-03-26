load('../python/walking.mat');
fbeff = eff;
fbpos = pos;
fbvel = vel;

load('../python/walking_no_ground.mat');

jnames = {'back-lbz', 'back-mby', 'back-ubx', 'neck-ay', ...
  'l-leg-uhz', 'l-leg-mhx', 'l-leg-lhy', 'l-leg-kny', 'l-leg-uay', 'l-leg-lax', ...
  'r-leg-uhz', 'r-leg-mhx', 'r-leg-lhy', 'r-leg-kny', 'r-leg-uay', 'r-leg-lax', ...
  'l-arm-usy', 'l-arm-shx', 'l-arm-ely', 'l-arm-elx', 'l-arm-uwy', 'l-arm-mwx', ...
  'r-arm-usy', 'r-arm-shx', 'r-arm-ely', 'r-arm-elx', 'r-arm-uwy', 'r-arm-mwx'};

fbopts = {'LineWidth',3};
opts = {'--','LineWidth',3};

t = (1:size(pos,1)) + 2200; 
% I think this is about the right time offset between the two different
% tests to get the data to mathc up.  Could be wrong though.

%%
figure(1);clf;

subplot 311
plot(fbpos(:,1:4),fbopts{:});hold on;
plot(t,pos(:,1:4),opts{:});
legend(jnames{1:4});
title('Head/Back and Arm Positions, dashed = w/0 gravity')

subplot 312
plot(fbpos(:,17:22),fbopts{:});hold on;
plot(t,pos(:,17:22),opts{:});
legend(jnames{17:22});
ylabel('Joint Angle (rad)');

subplot 313
plot(fbpos(:,23:28),fbopts{:});hold on;
plot(t,pos(:,23:28),opts{:});
legend(jnames{23:28});
xlabel('Timesteps');

set(gcf,'Color','w')

%%
figure(2);clf;

subplot 211
plot(fbpos(:,5:10),fbopts{:});hold on;
plot(t,pos(:,5:10),opts{:});
legend(jnames{5:10});
ylabel('Left Leg Angles (rad)');
title('Leg Joint Positions, dashed = w/0 gravity')

subplot 212
plot(fbpos(:,11:16),fbopts{:});hold on;
plot(t,pos(:,11:16),opts{:});
legend(jnames{11:16});
ylabel('Right Leg Angles (rad)');
xlabel('Timesteps');

set(gcf,'Color','w')

%%
figure(3);clf;

subplot 411
plot(fbpos(:,[5 11]),fbopts{:});hold on;
plot(t,pos(:,[5 11]),opts{:});
legend(jnames{[5 11]});
ylabel('Angles (rad)');
title('Leg Joint Positions, dashed = w/0 gravity')

for i=1:3
    subplot(4,1,i+1)
    plot(fbpos(:,[5+i 11+i]),fbopts{:});hold on;
    plot(t,pos(:,[5+i 11+i]),opts{:});
    legend(jnames{[5+i 11+i]});
    ylabel('Angles (rad)');
end
xlabel('Timesteps');

set(gcf,'Color','w')

%%
figure(4);clf;

subplot 211
plot(fbpos(:,[9 15]),fbopts{:});hold on;
plot(t,pos(:,[9 15]),opts{:});
legend(jnames{[9 15]});
ylabel('Angles (rad)');
title('Leg Joint Positions, dashed = w/0 gravity')

subplot 212
plot(fbpos(:,[10 16]),fbopts{:});hold on;
plot(t,pos(:,[10 16]),opts{:});
legend(jnames{[10 16]});
ylabel('Angles (rad)');


xlabel('Timesteps');

% set(gcf,'Color','w')
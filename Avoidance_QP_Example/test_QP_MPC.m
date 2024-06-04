clear
clc
% System Parameters
Tstep = 0.3; % step time is 0.5, fixed for now
dt = 0.1; % MPC sample Time, 
Npred = 4; % Number of steps
z0 = .9; % walking height
g = 9.81; % gravity term;
Nodes = Npred * round(Tstep / dt) + 1;

% MPC Parameters
q_init = [0;0.4;0;0.0]; % intial robot state
q_ref = [0;0.6;0;0.0];  % robot state ref
f_length = [.8;.4];     % foot length limit
f_init = [0;0.07];      % foot initial state
f_param = [0;0;.6 * .4;0;0;0.14]; % foot parameters
Weights = [0;2500;0;2500;10000;10000;100;6000;15000]; % MPC weights
r = [0.2;0.4];          % obstacle radius
qo_ic = [1.4;0.1];      % obstacle position
qo_tan = [q_init(1);q_init(3)] - qo_ic; % obstacle tangent vector
qo_tan = qo_tan/norm(qo_tan);

traj_x = zeros(2*Nodes,1);
ux = zeros(Nodes,1);
dPx = zeros(Npred,1);
traj_y = zeros(2*Nodes,1);
uy = zeros(Nodes,1);
dPy = zeros(Npred,1);
s = zeros(Nodes,1);
s2 = zeros(Nodes,1);

tic
[traj_x,ux,dPx,traj_y,uy,dPy,s,s2] = LeftStartQP_Step0(traj_x,ux,dPx,traj_y,uy,dPy,s,s2,q_init,q_ref,f_length,f_init,f_param,...
    Weights,r,qo_ic,qo_tan);
toc
tic
[traj_x,ux,dPx,traj_y,uy,dPy,s,s2] = LeftStartQP_Step0(traj_x,ux,dPx,traj_y,uy,dPy,s,s2,q_init,q_ref,f_length,f_init,f_param,...
    Weights,r,qo_ic,qo_tan);
toc

actual_foot_x = [f_init(1);f_init(1) + cumsum(dPx)];
actual_foot_y = [f_init(2);f_init(2) + cumsum(dPy)];

angle = 0:0.1:2*pi;
xoff = sin(angle);
yoff = cos(angle);

close all
figure
plot(traj_x(1:2:end),traj_y(1:2:end))
hold on
plot(qo_ic(1) + xoff *.2,qo_ic(2) + yoff *.2)
plot(qo_ic(1) + xoff *.4,qo_ic(2) + yoff *.4)

plot(actual_foot_x(1),actual_foot_y(1),'o','MarkerSize',5,    'MarkerEdgeColor','b',...
    'MarkerFaceColor','r')
plot(actual_foot_x(2),actual_foot_y(2),'o','MarkerSize',10,    'MarkerEdgeColor','b',...
    'MarkerFaceColor','g')
plot(actual_foot_x(3),actual_foot_y(3),'o','MarkerSize',15,    'MarkerEdgeColor','b',...
    'MarkerFaceColor','r')
plot(actual_foot_x(4),actual_foot_y(4),'o','MarkerSize',20,    'MarkerEdgeColor','b',...
    'MarkerFaceColor','g')
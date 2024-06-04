%%
clear
clc
% System Parameters
Tstep = 0.4; % step time is 0.5, fixed for now
dt = 0.1; % MPC sample Time, 
Npred = 4; % Number of steps
z0 = .9; % walking height
g = 9.81; % gravity term;
Nodes = Npred * round(Tstep / dt) + 1;

q_init = [0;0.0;0;0.0]; % intial robot state
q_ref = [0;0.5;0;0.0];  % robot state ref
f_length = [.8;.4];     % foot length limit
f_init = [0;-0.07];      % foot initial state
f_param = [0;0;.6 * .2;0;0;0.14]; % foot parameters
Weights = [0;2500;0;2500;10000;10000;100;6000;15000]; % MPC weights
r = [0.2;0.4];          % obstacle radius
qo_ic = [1.4;0.1];      % obstacle position
qo_tan = [q_init(1);q_init(3)] - qo_ic; % obstacle tangent vector
qo_tan = qo_tan/norm(qo_tan);

Input = [q_init;q_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.0;0.0];

[a,b,c,d,e,f] = RightStart_Step0(Input,0*rand(144,1));

[a1,b1,c1,d1,e1,f1] = RightStart_Step0(Input,2.5*rand(144,1));

ea = norm(full(a1) - full(a))
eb = norm(full(b1) - full(b))
ec = norm(full(c1) - full(c))
ed = norm(full(d1) - full(d))
ee = norm(full(e1) - full(e))
ef = norm(full(f1) - full(f))

Aeq_dense = full(a);
beq_dense = -full(b);
Aiq_dense = full(c);
biq_dense = -full(d);
H_dense = full(e);
f_dense = full(f);

% Variable = [x;ux;dPx;y;uy;dPy;s;s2];
% Input = [q_init;qo_ic;q_ref;f_length;f_init;f_param;Weights;r];
prob = osqp;
setup(prob,H_dense, f_dense, [Aiq_dense;Aeq_dense], [-inf*ones(size(Aiq_dense,1),1);beq_dense], [biq_dense;beq_dense]);
[result] = prob.solve();

design_vector = result.x;
traj_x = design_vector(1:Nodes * 2);
traj_y = design_vector(3*Nodes + Npred + 1:5*Nodes + Npred);

dPx = design_vector(3*Nodes + 1:3*Nodes + 4);
dPy = design_vector(6*Nodes + Npred + 1:6*Nodes + Npred + 4);

angle = 0:0.1:2*pi;
xoff = sin(angle);
yoff = cos(angle);

actual_foot_x = [f_init(1);f_init(1) + cumsum(dPx)];
actual_foot_y = [f_init(2);f_init(2) + cumsum(dPy)];

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

dPx
dPy
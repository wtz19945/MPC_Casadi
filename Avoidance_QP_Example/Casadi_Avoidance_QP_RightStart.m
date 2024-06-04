function [] = Casadi_Avoidance_QP_RightStart(step_index)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   This function generates a QRQP MPC solver for bipedal stepping

import casadi.*
MPC_opti = casadi.Opti(); % Create 

% System Parameters
Tstep = 0.3; % step time is 0.5, fixed for now
dt = 0.1; % MPC sample Time, 
Npred = 4; % Number of steps
z0 = .9; % walking height
g = 9.81; % gravity term;
Nodes = Npred * round(Tstep / dt) + 1;

% Define Dynamics Matrix
A = [0 1;g/z0 0];
B = [0;-g/z0];
nx = size(A,2);
nu = size(B,2);

% Define Variables
x = MPC_opti.variable(nx * Nodes);
ux = MPC_opti.variable(Nodes);
dPx = MPC_opti.variable(Npred);

y = MPC_opti.variable(nx * Nodes);
uy = MPC_opti.variable(Nodes);
dPy = MPC_opti.variable(Npred);

s = MPC_opti.variable(Nodes);
s2 = MPC_opti.variable(Nodes);

% Define Parameters
q_init = MPC_opti.parameter(nx * 2);
qo_ic = MPC_opti.parameter(2);
qo_tan = MPC_opti.parameter(2);     % norm vector of the obstacle point
q_ref = MPC_opti.parameter(nx * 2);
f_length = MPC_opti.parameter(2); % Foot Length
f_init = MPC_opti.parameter(2); % Initial Foot Position
f_param = MPC_opti.parameter(6); % MPC Foot Related Parameters
Weights = MPC_opti.parameter(9);
r = MPC_opti.parameter(2);       % Obstacle Radius

% Define Dynamics Constraint
for n = 1:Nodes
    ux_n = ux(nu*(n-1)+1:nu*n);
    x_n = x(nx*(n-1)+1:nx*n);
    uy_n = uy(nu*(n-1)+1:nu*n);
    y_n = y(nx*(n-1)+1:nx*n);
    if n == 1
        MPC_opti.subject_to(q_init(1:2,1) - x(1:nx,1) == 0); % Initial states
        MPC_opti.subject_to(q_init(3:4,1) - y(1:nx,1) == 0); % Initial states
    else
        x_n1 = x(nx*(n-2)+1:nx*(n-1));
        y_n1 = y(nx*(n-2)+1:nx*(n-1));
        MPC_opti.subject_to(x_n == x_n1 + dt * (A*x_n1 + B*ux_n));
        MPC_opti.subject_to(y_n == y_n1 + dt * (A*y_n1 + B*uy_n));
    end
end

% Define Reachability Constraint
MPC_opti.subject_to(-f_length(1) <= x(1:2:end) - ux);
MPC_opti.subject_to(-f_length(2) <= y(1:2:end) - uy);
MPC_opti.subject_to(x(1:2:end) - ux <= f_length(1));
MPC_opti.subject_to(y(1:2:end) - uy <= f_length(2));

% Define Avoidance Constraint
for n = 1:Nodes
    % TODO: make qo_ic a trajectory
    qn = [x(nx*(n-1)+1);y(nx*(n-1)+1)];
    % inner constraint
    inter = qo_ic + r(1) * qo_tan;
    % outer constraint
    outer = qo_ic + r(2) * qo_tan;
    MPC_opti.subject_to(-dot(qn - outer,qo_tan) - s(n) <= 0);
    MPC_opti.subject_to(-dot(qn - inter,qo_tan) <= 0);
    MPC_opti.subject_to(s(n) >= 0);
end

% Define Tracking Cost
cost = 0;
Qx = [Weights(1) 0;0 Weights(2)];
Qy = [Weights(3) 0;0 Weights(4)];
for n = 1:Nodes
    x_e = x(nx*(n-1)+1:nx*n) - q_ref(1:2,1);
    y_e = y(nx*(n-1)+1:nx*n) - q_ref(3:4,1);
    cost = cost + x_e.' * Qx * x_e + y_e.' * Qy * y_e;
end

% Define Foot Placement Tracking Cost and Constraint, Start with a simple
% case
L = tril(ones(Npred)) - eye(Npred);
temp = [kron(L,ones(round(Tstep/dt),1));ones(1,Npred)];
temp = [temp(1 + step_index:end,:);ones(step_index,Npred)];

Ux_ref = ones(Nodes,1) * f_init(1) + temp * dPx;
Uy_ref = ones(Nodes,1) * f_init(2) + temp * dPy;

for n = 1:Nodes
    ux_e = Ux_ref(n) - ux(n);
    uy_e = Uy_ref(n) - uy(n);
    cost = cost + ux_e * Weights(5) * ux_e + uy_e * Weights(6) * uy_e;
end

% Define Foot Change Cost
dix = f_param(3);
diy = f_param(6);

y_pos = y(1:2:end);
for n = 1:Npred
    dP_ex = dPx(n) - dix;
    if n < Npred
        start_ind = n*round(Tstep/dt) + 1-step_index;
        end_ind = (n+1)*round(Tstep/dt)-step_index;
    else
        start_ind = n*round(Tstep/dt) + 1-step_index;
        end_ind = Nodes;
    end
    FB_dis = Uy_ref(start_ind:end_ind,1) - y_pos(start_ind:end_ind,1);
    s2_n = s2(start_ind:end_ind,1);
    MPC_opti.subject_to( (-1)^(n) * (FB_dis - s2_n) + diy <= 0);
    cost = cost + dP_ex * Weights(7) * dP_ex;
end

for n = 1:Nodes
    cost = cost + s2(n) * Weights(8) * s2(n);
end

% Obstacle Slack Cost
for n = 1:Nodes
    cost = cost + s(n) * Weights(9) * s(n);
end

MPC_opti.minimize(cost);
% Set QP Options
MPC_opts  = struct('qpsol','qrqp','print_iteration',false,'print_header',false,'print_time',true);
MPC_opts .qpsol_options = struct('print_iter',false,'print_header',false,'print_info',false);
MPC_opti.solver('sqpmethod',MPC_opts); % Avaiable Solvers are qpoases and qrqp

disp('generating casadi function')

tic
f_MPC_opti = MPC_opti.to_function(char('RightStartQP_Step' + string(step_index)),{x,ux,dPx,y,uy,dPy,s,s2,q_init,q_ref,f_length,f_init,f_param,...
    Weights,r,qo_ic,qo_tan},{x,ux,dPx,y,uy,dPy,s,s2});
toc

%cg_options = struct('mex', true,'cpp',true,'main',true,'with_header',true);
cg_options = struct();
cg = CodeGenerator(char('RightStartQP_Step' + string(step_index)),cg_options);
cg.add(f_MPC_opti);

disp('generating c file')
tic
cg.generate() 
toc

end


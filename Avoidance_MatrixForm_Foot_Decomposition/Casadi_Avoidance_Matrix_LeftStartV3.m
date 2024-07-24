function [] = Casadi_Avoidance_Matrix_LeftStartV3(step_index)
import casadi.*
% System Parameters
Tstep = 0.4; % step time is 0.4, fixed for now
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

% Define MPC Variables
x = MX.sym('x',nx * Nodes); % x com traj
ux = MX.sym('ux',Nodes);   % x center of pressure traj
dPx = MX.sym('dPx',Npred); % x foot change
y = MX.sym('y',nx * Nodes); % y com traj
uy = MX.sym('uy',Nodes);   % y center of pressure traj
dPy = MX.sym('dPy',Npred); % y foot change
s = MX.sym('s',Nodes);     % slack variable
swf_q = MX.sym('swf_q', (round(Tstep / dt) + 1) * 3); % swing foot var: x, y, z
swf_s = MX.sym('swf_s', round(Tstep / dt) + 1);        % swinf foot slack variable
Variable = [x;ux;dPx;y;uy;dPy;s;swf_q;swf_s];

% Define MPC Parameters
q_init = MX.sym('q_init',nx * 2); % com current position
qo_ic = MX.sym('qo_ic',2);        % obstacle position that is cloeset to robot
qo_tan = MX.sym('qo_tan',2);      % norm vector of the obstacle point
x_ref = MX.sym('x_ref',Npred + 1);   % x reference
y_ref = MX.sym('y_ref',Npred + 1);   % y reference
f_length = MX.sym('f_length',2);  % Foot Length
f_init = MX.sym('f_init',2);      % Initial Foot Position
f_param = MX.sym('f_param',6);    % MPC Foot Related Parameters
Weights = MX.sym('Weights',9);    % MPC Weights
r = MX.sym('r',2);                % Obstacle Radius
rt = MX.sym('rt', 1);             % Remaining time of current trajectory
foff = MX.sym('foff', 2);         % Offset parameter for model gap
height = MX.sym('height', 1);     % Walking height
swf_cq = MX.sym('swf_cq', 3);     % Current swing foot state, x
swf_rq = MX.sym('swf_rq', (round(Tstep / dt) + 1) * 3);      % Reference swing foot state
swf_Q = MX.sym('swf_Q', 3);       % Swing foot position tracking
swf_obs = MX.sym('swf_obs', 12);    % Obstacle x,y,z, radius, weights, z fraction

Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;rt;foff;height...
    ;swf_cq;swf_rq;swf_Q;swf_obs];

A = [0 1;g/height 0];
B = [0;-g/height];

% Define Dynamics Constraint
eq_con = [];
for n = 1:Nodes
    %
    ux_n = ux(nu*(n-1)+1:nu*n) + foff(1);
    x_n = x(nx*(n-1)+1:nx*n);
    uy_n = uy(nu*(n-1)+1:nu*n) + foff(2);
    y_n = y(nx*(n-1)+1:nx*n);
    if n == 1
        eq_con = [eq_con;q_init(1:2,1) - x(1:nx,1);q_init(3:4,1) - y(1:nx,1)]; % Initial states
    else
        x_n1 = x(nx*(n-2)+1:nx*(n-1));
        y_n1 = y(nx*(n-2)+1:nx*(n-1));
        ux_n1 = ux(nu*(n-2)+1:nu*(n-1)) + foff(1);
        uy_n1 = uy(nu*(n-2)+1:nu*(n-1)) + foff(2);
        xdt = .5 * (A*x_n + B*ux_n) + .5 * (A*x_n1 + B*ux_n1);
        ydt = .5 * (A*y_n + B*uy_n) + .5 * (A*y_n1 + B*uy_n1);
        if n == 2
            eq_con = [eq_con;x_n - x_n1 - rt * xdt;y_n - y_n1 - rt * ydt];
        else
            eq_con = [eq_con;x_n - x_n1 - dt * xdt;y_n - y_n1 - dt * ydt];
        end
    end
end

% Define Reachability Constraint
ieq_con = [];
% TODO: make f_length based on foot velocity and stepping time
ieq_con = [ieq_con;-f_length(1) - x(1:2:end) + ux;x(1:2:end) - ux - f_length(1)];
ieq_con = [ieq_con;-f_length(2) - y(1:2:end) + uy;y(1:2:end) - uy - f_length(2)];

% Define Avoidance Constraint
for n = 1:Nodes
    % TODO: make qo_ic a trajectory
    qn = [x(nx*(n-1)+1);y(nx*(n-1)+1)];
    % inner constraint
    inter = qo_ic + r(1) * qo_tan;
    ieq_in = -dot(qn - inter,qo_tan);
    % outer constraint
    outer = qo_ic + r(2) * qo_tan;
    ieq_out = -dot(qn - outer,qo_tan) - s(n);
    ieq_con = [ieq_con;ieq_in;ieq_out; -s(n)];
end

% Define Tracking Cost
cost = 0;
Qx = [Weights(1) 0;0 Weights(2)];
Qy = [Weights(3) 0;0 Weights(4)];
% Define position tracking during standing phase
x_c = (x_ref(1) - x(1:2:end)).' * Qx(1,1) * (x_ref(1) - x(1:2:end));
y_c = (y_ref(1) - y(1:2:end)).' * Qy(1,1) * (y_ref(1) - y(1:2:end));
cost = cost + x_c + y_c;

% Define velocity tracking for stepping phase
x_vel = x(2:2:end);
y_vel = y(2:2:end);
dx_e = x_vel(round(Tstep / dt)+1 - step_index:round(Tstep / dt):end) - x_ref(2:5);
dy_e = y_vel(round(Tstep / dt)+1 - step_index:round(Tstep / dt):end) - y_ref(2:5);

% Penalize initial velocity as well
if step_index < 3
    dx_e = [dx_e; x_vel(2) - x_ref(2)];
    % dy_e = [dy_e; y_vel(2) - y_ref(2)];
end
dx_e = [dx_e; x_vel(end) - x_ref(2)];
% dy_e = [dy_e; y_vel(end) - y_ref(2)];

cost = cost + dx_e.' * Qx(2,2) * dx_e + dy_e.' * Qy(2,2) * dy_e;

% Define Foot Placement Tracking Cost and Constraint
% TODO: Add slack variables
L = tril(ones(Npred)) - eye(Npred);
temp = [kron(L,ones(round(Tstep / dt),1));ones(1,Npred)];
temp = [temp(1 + step_index:end,:);ones(step_index,Npred)];

Ux_ref = ones(Nodes,1) * f_init(1) + temp * dPx;
Uy_ref = ones(Nodes,1) * f_init(2) + temp * dPy;

% for n = 1:Nodes
%     ux_e = Ux_ref(n) - ux(n);
%     uy_e = Uy_ref(n) - uy(n);
%     cost = cost + ux_e * Weights(5) * ux_e + uy_e * Weights(6) * uy_e;
% end
eq_con = [eq_con;Ux_ref(:) - ux(:);Uy_ref(:) - uy(:)];
ieq_con = [ieq_con;(-1).^(2:Npred+1)' .* dPy + 0.05];

% Define Foot Change Cost
dix = f_param(3); % foot change ref in x direction
diy = f_param(6); % foot chagne ref in y

x_pos = x(1:2:end);
y_pos = y(1:2:end);
key_footy_pos = Uy_ref(round(Tstep/dt) + 1 -step_index:round(Tstep/dt):end,1);
key_y_pos = y_pos(round(Tstep/dt) + 1 -step_index:round(Tstep/dt):end,1);
key_footx_pos = Ux_ref(round(Tstep/dt) + 1 - step_index:round(Tstep/dt):end,1);
key_x_pos = x_pos(round(Tstep/dt) + 1 -step_index:round(Tstep/dt):end,1);

key_x_err = key_footx_pos - key_x_pos - dix;
key_y_err = key_footy_pos - key_y_pos - diy * (-1).^(1:Npred)';

cost = cost + key_x_err.' * Weights(7) * key_x_err + key_y_err.' * Weights(8) * key_y_err;


% Obstacle Slack Cost
for n = 1:Nodes
    cost = cost + s(n) * Weights(9) * s(n);
end

%% Additional costs and constraints for swing foot avoidance
% Swing Foot Trajectroy
dN = round(Tstep / dt) + 1;
swf_x = swf_q(1:dN);
swf_y = swf_q(dN + 1:2*dN);
swf_z = swf_q(2*dN+1:end);

% Reference Foot Trajectory
swf_rx = swf_rq(1:dN);
swf_ry = swf_rq(dN + 1:2*dN);
swf_rz = swf_rq(2*dN+1:end);

for n = step_index + 1 : round(Tstep / dt) + 1
    if n == step_index + 1
        % Initial State, Hard Constraint
        eq_con = [eq_con;swf_x(n) - swf_cq(1)...
            ;swf_y(n) - swf_cq(2)...
            ;swf_z(n) - swf_cq(3)];
    else
        % Final State, Hard Constraint
        if n == round(Tstep / dt) + 1
            eq_con = [eq_con;swf_x(n) - f_init(1) - dPx(1)...
                ;swf_y(n) - f_init(2) - dPy(1)...
                ;swf_z(n)];
        end
        % Internal State, Soft Constraint
        cost = cost + swf_Q(1) * (swf_x(n) - swf_rx(n)).^2 +...
            swf_Q(2) * (swf_y(n) - swf_ry(n)).^2 +...
            swf_Q(3) * (swf_z(n) - swf_rz(n)).^2;
    end
end

% Foot Avoidance part
swf_obs_pos = swf_obs(1:3,1);
swf_obs_r1 = swf_obs(4);
swf_obs_r2 = swf_obs(5);
swf_obs_r3 = swf_obs(6);
swf_obs_r4 = swf_obs(7);
swf_obs_Qxy = swf_obs(8);
swf_obs_Qz = swf_obs(9);
frac_z = swf_obs(10);
min_z = swf_obs(11);
max_z = swf_obs(12);
for n = step_index + 1 : round(Tstep / dt) + 1
    % swing foot traj variable
    cur_p = [swf_x(n);swf_y(n);swf_z(n)];
    if n == step_index + 1
        ; % Can not change current position for avoidance
    elseif n == round(Tstep / dt) + 1
        % 2D avoidance for touchdown position
        ref_p = [swf_rx(n);swf_ry(n)];
        vec = (ref_p - swf_obs_pos(1:2)) / sqrt((ref_p - swf_obs_pos(1:2)).' * (ref_p - swf_obs_pos(1:2)));
        inter1 = swf_obs_pos(1:2) + swf_obs_r1 * vec;
        inter2 = swf_obs_pos(1:2) + swf_obs_r2 * vec;
        ieq_con = [ieq_con;-dot(cur_p(1:2) - inter2,vec) - swf_s(n);-dot(cur_p (1:2)- inter1,vec)];
        cost = cost + swf_obs_Qxy * swf_s(n) * swf_s(n);
    else
        % Linearize the constraint
        ref_p = [swf_rx(n);swf_ry(n);swf_rz(n)];
        vec = (ref_p - swf_obs_pos) / sqrt((ref_p - swf_obs_pos).' * (ref_p - swf_obs_pos));
        %vec = (ref_p - swf_obs_pos) / norm_2(ref_p - swf_obs_pos);
        inter1 = swf_obs_pos + swf_obs_r3 * vec;
        inter2 = swf_obs_pos + swf_obs_r4 * vec;
        z1 = inter1(3);
        z2 = inter2(3);
        ieq_con = [ieq_con;-swf_z(n) + z2 - swf_s(n);-swf_z(n) + z1];
        cost = cost + swf_obs_Qz * swf_s(n) * swf_s(n);
    end
end
ieq_con = [ieq_con;-swf_s];

% symmetrical vertical trajectory
eq_con = [eq_con;swf_z(2) - swf_z(4)];
ieq_con = [ieq_con;swf_z(2) - frac_z * swf_z(3)];
ieq_con = [ieq_con;swf_z(3) - max_z];
if step_index < 2
    ieq_con = [ieq_con;-swf_z(3) + min_z];
end

% Get the jacobian and Hessian Information
Aeq = jacobian(eq_con,Variable);
beq = eq_con - Aeq * Variable;
Aiq = jacobian(ieq_con,Variable);
biq = ieq_con - Aiq * Variable;
H = hessian(cost,Variable);
f = jacobian(cost - .5 * Variable.' * H * Variable,Variable);

disp('generating c code')
fff = Function(char('LeftStart_Step' + string(step_index) + 'V3'),{Input,Variable},{Aeq,beq,Aiq,biq,H,f});
% opts = struct('mex',false,'main',false,'cpp',false,'with_header',false);
% func_name = char('RightStart_Step' + string(step_index));
% fff.generate(func_name,opts);
cg_options = struct('mex',true,'main',false,'cpp',false,'with_header',false);
cg = CodeGenerator(char('LeftStart_Step' + string(step_index) + 'V3'),cg_options);
cg.add(fff);
tic
cg.generate() 
toc

end


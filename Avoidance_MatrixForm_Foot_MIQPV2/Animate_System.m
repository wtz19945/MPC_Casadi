%%
clear
clc
close all
% System Parameters
Tstep = 0.4; % step time is 0.4, fixed for now
dt = 0.1; % MPC sample Time, 
Npred = 4; % Number of steps
z0 = .9; % walking height
g = 9.81; % gravity term;
Nodes = Npred * round(Tstep / dt) + 1;


sim_step = 100;
stance_leg = 1;
n = 1;

q_init = [3;0.0;0;-0.06]; % intial robot state
dx_des = 0.3;
w = sqrt(9.81 / 0.9);
x0_ref = dx_des / w * (2 - exp(w * Tstep) - exp(-w * Tstep)) / (exp(w * Tstep) - exp(-w * Tstep));
dy_des = sqrt(w) * 0.11 * tanh(sqrt(w) * Tstep/2);
dy_off = 0.0;
x_ref = dx_des * ones(5,1);
f_length = [.8;.15];     % foot length limit
f_param = [0;0;x0_ref;0;0;0.1]; % foot parameters
Weights = [0;1000;0;5000;10000;10000;500;50000;5000]; % MPC weights
r = [0.1;0.5];          % obstacle radius
qo_ic = [-10.5;0.0];      % obstacle position
qo_tan = [q_init(1);q_init(3)] - qo_ic; % obstacle tangent vector

[sx,sy,sz] = sphere;

qo_tan = qo_tan/norm(qo_tan);
du_ref = 0.9;
swf_Q = 10*[10;10;100];
swf_obs_pos = [1.35;0.1;0.0];
swf_xy_r = [0.2;0.3];
swf_xy_z = [0.0;0.3];
swf_Q_soft = [8000;8000];
frac_z = 0.5;
M = 10000;

swf_obs = [swf_obs_pos;swf_xy_r;swf_xy_z;swf_Q_soft;frac_z;0.2;0.6;M;25 * pi/180];
swf_obs_info = [swf_obs(1:3);0.2];
x_goal = 0.0 + 0.5 * 0.4;
y_goal = 0.11;
z_goal = [0.0;0.1;0.2;0.1;0.0];

fx_start = 0;
fy_start = 0.11;
swf_cq = [0;0.11;0.0];
swf_rq = [linspace(fx_start, x_goal, 5)'; linspace(fy_start, y_goal, 5)'; z_goal];

q_init = [0;0.0;0;-0.06]; % intial robot state
y_ref = [0;dy_off + dy_des * (-1).^(2:5).'];
f_init = [0;-0.11];      % foot initial state

var_num = 174;
% Obstacle
angle = 0:0.1:2*pi;
xoff = sin(angle);
yoff = cos(angle);

view_opt = 1;
if view_opt == 1
    filename = 'Walking0.gif'; % Name of the GIF file
elseif view_opt == 2
    filename = 'Walking1.gif'; % Name of the GIF file
else
    filename = 'no_avoidance.gif'; % Name of the GIF file
end

h = figure;
delayTime = 0.1;


z_traj = [];
solve_time = [];
% Initialize QP
for i = 1:sim_step
    if stance_leg == 1
        y_ref = [0;dy_off + dy_des * (-1).^(2:5).'];
        switch n
            case 1
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = RightStart_Step0V3(Input,0*rand(var_num,1));
            case 2
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = RightStart_Step1V3(Input,0*rand(var_num,1));
            case 3
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = RightStart_Step2V3(Input,0*rand(var_num,1));
            case 4
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = RightStart_Step3V3(Input,0*rand(var_num,1));
            otherwise
                pause;
        end
    else
        y_ref = [0;dy_off + dy_des * (-1).^(1:4).'];
        switch n
            case 1
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = LeftStart_Step0V3(Input,0*rand(var_num,1));
            case 2
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = LeftStart_Step1V3(Input,0*rand(var_num,1));
            case 3
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = LeftStart_Step2V3(Input,0*rand(var_num,1));
            case 4
                Input = [q_init;x_ref;y_ref;f_length;f_init;f_param;Weights;r;qo_ic;qo_tan;0.1;0;0;du_ref;swf_cq;swf_rq;swf_Q;swf_obs];
                [a,b,c,d,e,f] = LeftStart_Step3V3(Input,0*rand(var_num,1));
            otherwise
                pause;
        end
        
    end

    Aeq_dense = full(a);
    beq_dense = -full(b);
    Aiq_dense = full(c);
    biq_dense = -full(d);
    H_dense = full(e);
    f_dense = full(f);
    
    var_num = size(Aeq_dense,2);
    Aiq_num = size(Aiq_dense,1);
    Aeq_num = size(Aeq_dense,1);
    
    var_num
    Aiq_num + Aeq_num
    vartype = [repmat('C',var_num - 17, 1); repmat('B', 17, 1)];
    lb = -Inf * ones(var_num, 1);
    ub = Inf * ones(var_num, 1);
    model.Q = sparse(.5*H_dense);
    model.obj = f_dense;
    model.A = sparse([Aiq_dense;Aeq_dense]);
    model.rhs = [biq_dense;beq_dense];
    model.sense = [repmat('<',Aiq_num,1); repmat('=',Aeq_num,1)];
    model.vtype = vartype;
    model.lb = lb;
    model.ub = ub;
    model.modelsense = 'min';
    if i > 1
        % warm start
        model.start = initial_guess;
    end
    gurobiParams = struct();
    gurobiParams.TimeLimit = 3600;        % Time limit of 1 hour
    %gurobiParams.MIPGap = 1e-4;           % 1% MIP gap
    %gurobiParams.Presolve = 2;            % Aggressive presolve
    %gurobiParams.Cuts = 2;                % Aggressive cut generation
    %gurobiParams.Threads = 16;             % Use 4 threads
    %gurobiParams.MIPFocus = 1;            % Focus on finding feasible solutions
    %gurobiParams.Heuristics = 0.05;        % Increase heuristics effort
    %gurobiParams.FeasibilityTol = 1e-5;
    %gurobiParams.OptimalityTol = 1e-5;
    % Set Gurobi parameters (optional)
    gurobiParams.outputflag = 0; % Display output
    
    % Solve the MIQP problem
    result = gurobi(model, gurobiParams);
    design_vector = result.x;
    initial_guess = design_vector;
    solve_time = [solve_time;result.runtime];
    fprintf('Gurobi run time is: %f seconds\n', result.runtime);

    traj_x = design_vector(1:Nodes * 2);
    traj_y = design_vector(3*Nodes + Npred + 1:5*Nodes + Npred);
    
    dPx = design_vector(3*Nodes + 1:3*Nodes + 4);
    dPy = design_vector(6*Nodes + Npred + 1:6*Nodes + Npred + 4);
    
    
    actual_foot_x = [f_init(1);f_init(1) + cumsum(dPx)];
    actual_foot_y = [f_init(2);f_init(2) + cumsum(dPy)];
    
    swing_foot = design_vector(7*Nodes + Npred + 5 : 7*Nodes + Npred + 19);
    swing_foot_x = swing_foot(1:5);
    swing_foot_y = swing_foot(6:10);
    swing_foot_z = swing_foot(11:15);
    
    % Plot Data
    plot3(traj_x(1:2:end),traj_y(1:2:end),ones(size(traj_x(1:2:end))))
    if view_opt == 1
        view(15,90);
    elseif view_opt == 2
        view(45,135);
    else
        view(15,90);
    end
    hold on
    plot3(traj_x(1),traj_y(1), 1,'o','MarkerSize',5,    'MarkerEdgeColor','b',...
        'MarkerFaceColor','y')
    plot(actual_foot_x(1),actual_foot_y(1),'o','MarkerSize',5,    'MarkerEdgeColor','b',...
        'MarkerFaceColor','r')
    plot(actual_foot_x(2),actual_foot_y(2),'o','MarkerSize',5,    'MarkerEdgeColor','b',...
        'MarkerFaceColor','g')
    plot3(swf_cq(1),swf_cq(2), swf_cq(3),'o','MarkerSize',5,    'MarkerEdgeColor','b',...
        'MarkerFaceColor','b')
    plot3([traj_x(1) actual_foot_x(1)],[traj_y(1) actual_foot_y(1)], [1 0])
    plot3([traj_x(1) swf_cq(1)],[traj_y(1) swf_cq(2)], [1 swf_cq(3)])

        plot(actual_foot_x(3),actual_foot_y(3),'o','MarkerSize',5,    'MarkerEdgeColor','b',...
        'MarkerFaceColor','g')
            plot(actual_foot_x(4),actual_foot_y(4),'o','MarkerSize',5,    'MarkerEdgeColor','b',...
        'MarkerFaceColor','g')
    hSurface = surf(swf_obs_info(4) * sx + swf_obs(1), swf_obs_info(4) * sy + swf_obs(2), swf_obs_info(4) * sz + swf_obs(3), 'FaceColor', 'red');
    set(hSurface,'FaceColor',[0 0 1], ...
      'FaceAlpha',1,'FaceLighting','gouraud')
    design_vector(end - 16)
    bin = design_vector(end-15:end-12);
    index = find(bin > 0.5);
    ox = swf_obs(1);
    width = 2;
    oy = swf_obs(2);
    height = 2;
    switch index
        case 3
            fill([ox + height, ox, ox, ox + height], [oy, oy, oy + width, oy + width], 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
        case 4
            fill([ox + height, ox, ox, ox + height], [oy, oy, oy - width, oy - width], 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
        case 1
            fill([ox - height, ox, ox, ox - height], [oy, oy, oy + width, oy + width], 'b', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
        case 2
            fill([ox - height, ox, ox, ox - height], [oy, oy, oy - width, oy - width], 'y', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
    end

    title(n)
    hold off

    xlim([-0.1 3])
    ylim([-.8 0.8])
    zlim([0 1.2])
    legend('Traj Ref', 'Base', 'St Foot', 'Sw Foot Des', 'Sw Foot Cur', 'St Leg', 'Sw Leg')
    xlabel('x')
    ylabel('y')
    % Capture the plot as an image
    frame = getframe(h);
    im = frame2im(frame);
    [imind, cm] = rgb2ind(im, 256);

    % Write to the GIF file
    if i == 1
        imwrite(imind, cm, filename, 'gif', 'Loopcount', inf, 'DelayTime', delayTime);
    else
        imwrite(imind, cm, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end

    % Reset State
    q_init = [traj_x(3:4);traj_y(3:4)];
    x_goal = actual_foot_x(2);
    y_goal = actual_foot_y(2);
    z_goal = [z_goal(1:n);swing_foot_z(n+1:end)];

    n = n+1;
    z_traj = [z_traj;swf_cq(3)];
    swf_cq = [swing_foot_x(n); swing_foot_y(n); swing_foot_z(n)];
    swf_rq = [linspace(fx_start, x_goal, 5)'; linspace(fy_start, y_goal, 5)'; z_goal];

    if n > 4
        fx_start = f_init(1);
        fy_start = f_init(2);
        z_goal = [0.0;0.1;0.2;0.1;0.0];
        swf_rq = [linspace(fx_start, actual_foot_x(3), 5)'; linspace(fy_start, actual_foot_y(3), 5)'; z_goal];
        swf_cq = [fx_start; fy_start; 0];
        f_init = [actual_foot_x(2);actual_foot_y(2)];
        stance_leg = stance_leg * -1;
        n = 1;
    end
    
end

figure
plot(z_traj)
title('swing z traj')

figure
plot(solve_time)
title('solve time')
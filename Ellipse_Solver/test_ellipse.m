%% A single test case for ellipse avoidance
close all

% Velocity of the obstacle
v = [-0.7;-1];
phi = atan2(v(2),v(1));
R = [cos(phi) -sin(phi); sin(phi) cos(phi)];

% Axis length in x-axis and y-axis
a_x = 1;
a_y = 0.4;
% Obstacle position
xo = 2;
yo = 2.5;
% Robot position
xr = 0.5;
yr = 0.3;
% Generate ellipse shape
theta = 0 : 0.1 : 2*pi;
vec = R*[a_x * cos(theta);a_y * sin(theta)];
x = xo + vec(1,:);
y = yo + vec(2,:);
% Choose initial guess of the ellipse solver
error = [xr;yr] - [xo;yo]; % should be based on 
error = R' * error;
if error(1) >= 0 && error(2) >= 0
    x0 = 0.25 * pi;
elseif error(1) < 0 && error(2) >= 0
    x0 = 0.75 * pi;
elseif error(1) < 0 && error(2) < 0
    x0 = -0.75 * pi;
else
    x0 = -0.25 * pi;
end

xn = xo + a_x*cos(x0)*cos(phi) - a_y*sin(x0)*sin(phi);
yn = yo + a_x*cos(x0)*sin(phi) + a_y*sin(x0)*cos(phi);

[f,Jf] = ComputeEllipseInfo(xn,xr,xo,yn,yr,yo,phi,0,a_x,a_y);

% Solve for the closet point on ellepse          
[xn,yn,tn] = ellipse_solverV2(a_x,a_y,xo,yo,xr,yr,1e-6,2,xn,yn,phi);
norm_vec = [xr-xn;yr-yn]/norm([xr-xn;yr-yn],2);

% make sure the checking point is always along the moving direction
cutoff_angle = 10 * pi / 180;
xn1 = xo + a_x*cos(cutoff_angle)*cos(phi) - a_y*sin(cutoff_angle)*sin(phi);
yn1 = yo + a_x*cos(cutoff_angle)*sin(phi) + a_y*sin(cutoff_angle)*cos(phi);

xn2 = xo + a_x*cos(2*pi-cutoff_angle)*cos(phi) - a_y*sin(2*pi-cutoff_angle)*sin(phi);
yn2 = yo + a_x*cos(2*pi-cutoff_angle)*sin(phi) + a_y*sin(2*pi-cutoff_angle)*cos(phi);

norm_vec1 = [a_y*cos(cutoff_angle)*cos(phi)-a_x*sin(cutoff_angle)*sin(phi);...
    a_y*cos(cutoff_angle)*sin(phi)+a_x*sin(cutoff_angle)*cos(phi)]; 
norm_vec2 = [a_y*cos(2*pi-cutoff_angle)*cos(phi)-a_x*sin(2*pi-cutoff_angle)*sin(phi);...
    a_y*cos(2*pi-cutoff_angle)*sin(phi)+a_x*sin(2*pi-cutoff_angle)*cos(phi)]; 

figure
plot(x,y)
hold
plot([xo,xo+v(1)],[yo,yo+v(2)])
plot([xn,xn+norm_vec(1)],[yn,yn+norm_vec(2)])
plot([xn1,xn1+norm_vec1(1)],[yn1,yn1+norm_vec1(2)])
plot([xn2,xn2+norm_vec2(1)],[yn2,yn2+norm_vec2(2)])

plot(xn,yn,'.','MarkerSize',15)
plot(xn1,yn1,'.','MarkerSize',15)
plot(xn2,yn2,'.','MarkerSize',15)
plot(xr,yr,'.','MarkerSize',15)
axis equal
xlim([-3 3])
ylim([-3 3])

legend('obstacle', 'velocity', 'norm vector', 'norm vector cutoff left', 'norm vector cutoff right')

%% This part visualize a trajectory of a moving obstacle
% Velocity of the obstacle
v = [.7;.7];
phi = atan2(v(2),v(1));
R = [cos(phi) -sin(phi); sin(phi) cos(phi)];

% Axis length in x-axis and y-axis
a_x = 2;
a_y = .1;
theta = 0 : 0.1 : 2*pi;

% Robot Position
xr = 0;
yr = 0;
CoM_x = xr;
CoM_y = yr;
cutoff_angle = 45 * pi / 180;

figure(1)
filename = 'second_version.gif';
for n = 1:60
    % Obstacle position
    xo = -3.8 + (n-1)*v(1)*0.1;
    yo = -3.5 + (n-1)*v(2)*0.1;

    % Initialize solver with initial guess
    if n == 1
        error = [xr;yr] - [xo;yo]; % should be based on 
        error = R' * error;
        if error(1) >= 0 && error(2) >= 0
            x0 = 0.25 * pi;
        elseif error(1) < 0 && error(2) >= 0
            x0 = 0.75 * pi;
        elseif error(1) < 0 && error(2) < 0
            x0 = -0.75 * pi;
        else
            x0 = -0.25 * pi;
        end
        xn = xo + a_x*cos(x0)*cos(phi) - a_y*sin(x0)*sin(phi)
        yn = yo + a_y*cos(x0)*sin(phi) + a_y*sin(x0)*cos(phi)
    end

    % Solver for cloest point on the ellipse
    [xn,yn,tn] = ellipse_solverV2(a_x,a_y,xo,yo,xr,yr,1e-3,2,xn,yn,phi);
    norm_vec = [CoM_x(1)-xn;CoM_y(1)-yn]/norm([CoM_x(1)-xn;CoM_y(1)-yn],2);
%     
    vec = R*[a_x * cos(theta);a_y * sin(theta)];
    x = xo + vec(1,:);
    y = yo + vec(2,:);
    y_cir = yo + a_x * sin(theta);

    % Information of the ellepse
    subplot(1,2,1)
    plot(x,y)
    hold on
%     if xn<= xc + a *cos(cutoff_angle)
%         vec = [b*cos(cutoff_angle);a*sin(cutoff_angle)];
%         vec = vec/norm(vec,2);
%         plot([xn,xn+vec(1)],[yn,yn+vec(2)])
%     else
%         vec = [xr - xn; yr - yn];
%         vec = vec/norm(vec,2);
%         plot([xn,xn+vec(1)],[yn,yn+vec(2)])
%     end
    plot([xn,xn+norm_vec(1)],[yn,yn+norm_vec(2)])
    plot(xo,yo,'.','MarkerSize',15)
    plot(xr,yr,'.','MarkerSize',15)
    xlim([-8 8])
    ylim([-8 8])
    hold off
    
    % Information of the circle
    subplot(1,2,2)
    plot(x,y_cir)
    hold on
    plot([xo,xr],[yo,yr])
    plot(xo,yo,'.','MarkerSize',15)
    plot(xr,yr,'.','MarkerSize',15)
    
    xlim([-3 3])
    ylim([-3 3])
    hold off
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    if n == 1;
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',.2);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.2);
    end
end
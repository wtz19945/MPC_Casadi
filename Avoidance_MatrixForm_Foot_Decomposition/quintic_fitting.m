close all

x = linspace(0,0.4,5);
t = 0.1;
[a,A] = generate_traj(x,t);

t_vec = linspace(0,0.4,5);

x_traj = [];
dx_traj = [];
ddx_traj = [];

a = [1.32445e-12;
8.04438e-13;
6.76522e-12;
    325.504;
   -3077.71;
    8226.76;
        0.1;
    1.56764;
   -4.74408;
   -82.9055;
    1035.67;
   -2998.43;
        0.2;
   0.775112;
       2.54;
    31.5182;
   -463.549;
    1192.56;
        0.3;
    0.97074;
   -3.89191;
   -34.6456;
     132.73;
    632.177];

for i = 1:4
    a_vec = a(i*6-5:6*i);
    a_vec
    for t=0:0.001:0.099
        x_traj = [x_traj; a_vec.' * [1 t t^2 t^3 t^4 t^5].'];
        dx_traj = [dx_traj; a_vec.' * [0 1 2*t 3*t^2 4*t^3 5*t^4].'];
        ddx_traj = [ddx_traj; a_vec.' * [0 0 2   6*t  12*t^2 20*t^3].'];
    end
end

t = linspace(0, 0.4, length(x_traj));
subplot(3,1,1)
plot(t, x_traj)
hold on
plot(t_vec, x, 'o', 'MarkerFaceColor', 'r');

subplot(3,1,2)
plot(t, dx_traj)

subplot(3,1,3)
plot(t, ddx_traj)

function [a,A] = generate_traj(x, t)
    A = zeros(24,24);
    b = zeros(24,1);

    A(1,1) = 1;
    A(2,2) = 1;
    A(3,3) = 2;
    b(1) = x(1);
    b(4:6:end) = x(2:5);

    temp = zeros(6,12);
    temp(2,1:6) = [1 t t^2 t^3 t^4 t^5];
    temp(3,1:6) = [0 1 2*t 3*t^2 4*t^3 5*t^4];
    temp(4,1:6) = [0 0 2   6*t  12*t^2 20*t^3];
    temp(5,1:6) = [0 0 0   6  24*t 60*t^2];
    temp(6,1:6) = [0 0 0   0  24 120*t];

    temp(1,7)   = 1;
    temp(2,7)   = -1;
    temp(3,8)   = -1;
    temp(4,9)   = -2;
    temp(5,10)   = -6;
    temp(6,11)   = -24;
    b
    temp
    
    for i = 1:3
        A(4 + (i - 1) * 6:4 + (i - 1) * 6 + 5, (i-1)*6 + 1:(i-1)*6 + 12) = temp;
    end
    A(22,19:24) = [1 t t^2 t^3 t^4 t^5];
    A(23,19:24) = [0 1 2*t 3*t^2 4*t^3 5*t^4];
    A(24,19:24) = [0 0 2   6*t  12*t^2 20*t^3];
    A(end-2:end,:)
    a = A \ b;
end
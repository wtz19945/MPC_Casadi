op = swf_obs_pos(1:2);
cp = [actual_foot_x(1);actual_foot_y(1)];

disp('section1')
vec = [-1;1]/norm([-1;1]);
inter = op + swf_xy_r(1) * vec;
cp(1) - op(1)
-cp(2) + op(2)
-dot(vec, cp - inter)

disp('section2')
vec = [-1;-1]/norm([-1;-1]);
inter = op + swf_xy_r(1) * vec;
cp(1) - op(1)
cp(2) - op(2)
-dot(vec, cp - inter)

disp('section3')
vec = [1;1]/norm([1;1]);
inter = op + swf_xy_r(1) * vec;
-cp(1) + op(1)
-cp(2) + op(2) 
-dot(vec, cp - inter) 

disp('section4')
vec = [1;-1]/norm([1;-1]);
inter = op + swf_xy_r(1) * vec;
-cp(1) + op(1)
cp(2) - op(2)
-dot(vec, cp - inter)



%%
th = 15 * 3.14 / 180;
rotA = [cos(th) -sin(th);sin(th) cos(th)];
rotB = [cos(th) sin(th);-sin(th) cos(th)];

vec = [-1;1]/norm([-1;1]);
rotB * vec
vec = [-1;-1]/norm([-1;-1]);
rotA * vec
vec = [1;1]/norm([1;1]);
rotA * vec
vec = [1;-1]/norm([1;-1]);
rotB * vec

%%
close all
swf_obs_pos = [0.0;0.0;0.0];
ox = swf_obs_pos(1);
width = 2;
oy = swf_obs_pos(2);
height = 2;
swf_xy_r = [0.25;0.45];

figure
fill([ox - swf_xy_r(1) - height, ox - swf_xy_r(1), ox - swf_xy_r(1), ox - swf_xy_r(1) - height],...
     [oy + swf_xy_r(1) , oy + swf_xy_r(1), oy + width + swf_xy_r(1), oy + width + swf_xy_r(1)], 'r', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on
fill([ox - swf_xy_r(1) - height, ox - swf_xy_r(1), ox - swf_xy_r(1), ox - swf_xy_r(1) - height],...
     [oy - swf_xy_r(1) , oy - swf_xy_r(1), oy + swf_xy_r(1), oy + swf_xy_r(1)], 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

fill([ox - swf_xy_r(1) - height, ox - swf_xy_r(1), ox - swf_xy_r(1), ox - swf_xy_r(1) - height],...
     [oy - swf_xy_r(1) - height, oy - swf_xy_r(1) - height, oy - swf_xy_r(1), oy - swf_xy_r(1)], 'b', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

fill([ox - swf_xy_r(1), ox + swf_xy_r(1), ox + swf_xy_r(1), ox - swf_xy_r(1)],...
     [oy - swf_xy_r(1) - height, oy - swf_xy_r(1) - height, oy - swf_xy_r(1), oy - swf_xy_r(1)], 'c', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

fill([ox + swf_xy_r(1), ox + swf_xy_r(1) + width, ox + swf_xy_r(1) + width, ox + swf_xy_r(1)],...
     [oy - swf_xy_r(1) - height, oy - swf_xy_r(1) - height, oy - swf_xy_r(1), oy - swf_xy_r(1)], 'm', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

fill([ox + swf_xy_r(1), ox + swf_xy_r(1) + width, ox + swf_xy_r(1) + width, ox + swf_xy_r(1)],...
     [oy - swf_xy_r(1), oy - swf_xy_r(1), oy + swf_xy_r(1), oy + swf_xy_r(1)], 'y', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

fill([ox + swf_xy_r(1), ox + swf_xy_r(1) + width, ox + swf_xy_r(1) + width, ox + swf_xy_r(1)],...
     [oy + swf_xy_r(1), oy + swf_xy_r(1), oy + swf_xy_r(1) + height, oy + swf_xy_r(1) + height], 'k', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

fill([ox - swf_xy_r(1), ox + swf_xy_r(1), ox + swf_xy_r(1), ox - swf_xy_r(1)],...
     [oy + swf_xy_r(1), oy + swf_xy_r(1), oy + swf_xy_r(1) + height, oy + swf_xy_r(1) + height], .5 * [1 1 0], 'FaceAlpha', 0.5, 'EdgeColor', 'none');

xlim([-3 3])
ylim([-3 3])
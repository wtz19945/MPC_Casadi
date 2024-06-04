clear 
clc 

import casadi.*

for n = 0:2
    step_index = n;
    Casadi_Avoidance_QP_LeftStart(step_index)
    Casadi_Avoidance_QP_RightStart(step_index)
end

% Note: This part can be 

disp('mpc code generation done')
disp('check test_QP_MPC.m to test generated codes')
movefile('LeftStartQP_Step0.c','Generated_Function/LeftStartQP_Step0.c')
movefile('LeftStartQP_Step1.c','Generated_Function/LeftStartQP_Step1.c')
movefile('LeftStartQP_Step2.c','Generated_Function/LeftStartQP_Step2.c')
movefile('RightStartQP_Step0.c','Generated_Function/RightStartQP_Step0.c')
movefile('RightStartQP_Step1.c','Generated_Function/RightStartQP_Step1.c')
movefile('RightStartQP_Step2.c','Generated_Function/RightStartQP_Step2.c')

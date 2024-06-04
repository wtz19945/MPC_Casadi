clear 
clc 

import casadi.*

for n = 0:2
    step_index = n;
    Casadi_Avoidance_Matrix_LeftStart(step_index)
    Casadi_Avoidance_Matrix_RightStart(step_index)
end
%%
movefile('LeftStart_Step0.c','Generated_Function/LeftStart_Step0.c')
movefile('LeftStart_Step1.c','Generated_Function/LeftStart_Step1.c')
movefile('LeftStart_Step2.c','Generated_Function/LeftStart_Step2.c')
movefile('RightStart_Step0.c','Generated_Function/RightStart_Step0.c')
movefile('RightStart_Step1.c','Generated_Function/RightStart_Step1.c')
movefile('RightStart_Step2.c','Generated_Function/RightStart_Step2.c')

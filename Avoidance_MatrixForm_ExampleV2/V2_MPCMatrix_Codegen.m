clear 
clc 

import casadi.*

for n = 0:3
    step_index = n;
    Casadi_Avoidance_Matrix_LeftStartV2(step_index)
    Casadi_Avoidance_Matrix_RightStartV2(step_index)
end

%%
mex LeftStart_Step0V2.c -largeArrayDims
mex LeftStart_Step1V2.c -largeArrayDims
mex LeftStart_Step2V2.c -largeArrayDims
mex LeftStart_Step3V2.c -largeArrayDims

mex RightStart_Step0V2.c -largeArrayDims
mex RightStart_Step1V2.c -largeArrayDims
mex RightStart_Step2V2.c -largeArrayDims
mex RightStart_Step3V2.c -largeArrayDims

%%
movefile('LeftStart_Step0V2.c','Generated_Function/LeftStart_Step0V2.c')
movefile('LeftStart_Step1V2.c','Generated_Function/LeftStart_Step1V2.c')
movefile('LeftStart_Step2V2.c','Generated_Function/LeftStart_Step2V2.c')
movefile('LeftStart_Step3V2.c','Generated_Function/LeftStart_Step3V2.c')
movefile('RightStart_Step0V2.c','Generated_Function/RightStart_Step0V2.c')
movefile('RightStart_Step1V2.c','Generated_Function/RightStart_Step1V2.c')
movefile('RightStart_Step2V2.c','Generated_Function/RightStart_Step2V2.c')
movefile('RightStart_Step3V2.c','Generated_Function/RightStart_Step3V2.c')

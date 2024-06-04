clear 
clc 

import casadi.*

for n = 0:3
    step_index = n;
    Casadi_Avoidance_Matrix_LeftStart(step_index)
    Casadi_Avoidance_Matrix_RightStart(step_index)
end

%% Generate mex files
mex LeftStart_Step0.c -largeArrayDims
mex LeftStart_Step1.c -largeArrayDims
mex LeftStart_Step2.c -largeArrayDims
mex LeftStart_Step3.c -largeArrayDims

mex RightStart_Step0.c -largeArrayDims
mex RightStart_Step1.c -largeArrayDims
mex RightStart_Step2.c -largeArrayDims
mex RightStart_Step3.c -largeArrayDims

%% Move Files To Folder
movefile('LeftStart_Step0.c','Generated_Function/LeftStart_Step0.c')
movefile('LeftStart_Step1.c','Generated_Function/LeftStart_Step1.c')
movefile('LeftStart_Step2.c','Generated_Function/LeftStart_Step2.c')
movefile('LeftStart_Step3.c','Generated_Function/LeftStart_Step3.c')
movefile('RightStart_Step0.c','Generated_Function/RightStart_Step0.c')
movefile('RightStart_Step1.c','Generated_Function/RightStart_Step1.c')
movefile('RightStart_Step2.c','Generated_Function/RightStart_Step2.c')
movefile('RightStart_Step3.c','Generated_Function/RightStart_Step3.c')
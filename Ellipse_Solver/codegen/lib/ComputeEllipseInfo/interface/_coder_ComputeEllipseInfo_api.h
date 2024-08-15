//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_ComputeEllipseInfo_api.h
//
// Code generation for function 'ComputeEllipseInfo'
//

#ifndef _CODER_COMPUTEELLIPSEINFO_API_H
#define _CODER_COMPUTEELLIPSEINFO_API_H

// Include files
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <algorithm>
#include <cstring>

// Variable Declarations
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

// Function Declarations
void ComputeEllipseInfo(real_T xe, real_T xr, real_T xc, real_T ye, real_T yr,
                        real_T yc, real_T t, real_T lambda, real_T a, real_T b,
                        real_T f[3], real_T Jf[9]);

void ComputeEllipseInfo_api(const mxArray *const prhs[10], int32_T nlhs,
                            const mxArray *plhs[2]);

void ComputeEllipseInfo_atexit();

void ComputeEllipseInfo_initialize();

void ComputeEllipseInfo_terminate();

void ComputeEllipseInfo_xil_shutdown();

void ComputeEllipseInfo_xil_terminate();

#endif
// End of code generation (_coder_ComputeEllipseInfo_api.h)

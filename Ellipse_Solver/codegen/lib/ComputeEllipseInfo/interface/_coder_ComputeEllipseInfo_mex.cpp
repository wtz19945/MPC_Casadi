//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_ComputeEllipseInfo_mex.cpp
//
// Code generation for function 'ComputeEllipseInfo'
//

// Include files
#include "_coder_ComputeEllipseInfo_mex.h"
#include "_coder_ComputeEllipseInfo_api.h"

// Function Definitions
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&ComputeEllipseInfo_atexit);
  // Module initialization.
  ComputeEllipseInfo_initialize();
  // Dispatch the entry-point.
  unsafe_ComputeEllipseInfo_mexFunction(nlhs, plhs, nrhs, prhs);
  // Module termination.
  ComputeEllipseInfo_terminate();
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           nullptr, "UTF-8", true);
  return emlrtRootTLSGlobal;
}

void unsafe_ComputeEllipseInfo_mexFunction(int32_T nlhs, mxArray *plhs[2],
                                           int32_T nrhs,
                                           const mxArray *prhs[10])
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  const mxArray *b_prhs[10];
  const mxArray *outputs[2];
  int32_T i1;
  st.tls = emlrtRootTLSGlobal;
  // Check for proper number of arguments.
  if (nrhs != 10) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 10, 4,
                        18, "ComputeEllipseInfo");
  }
  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 18,
                        "ComputeEllipseInfo");
  }
  // Call the function.
  for (int32_T i{0}; i < 10; i++) {
    b_prhs[i] = prhs[i];
  }
  ComputeEllipseInfo_api(b_prhs, nlhs, outputs);
  // Copy over outputs to the caller.
  if (nlhs < 1) {
    i1 = 1;
  } else {
    i1 = nlhs;
  }
  emlrtReturnArrays(i1, &plhs[0], &outputs[0]);
}

// End of code generation (_coder_ComputeEllipseInfo_mex.cpp)

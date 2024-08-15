//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_ComputeEllipseInfo_api.cpp
//
// Code generation for function 'ComputeEllipseInfo'
//

// Include files
#include "_coder_ComputeEllipseInfo_api.h"
#include "_coder_ComputeEllipseInfo_mex.h"

// Variable Definitions
emlrtCTX emlrtRootTLSGlobal{nullptr};

emlrtContext emlrtContextGlobal{
    true,                                                 // bFirstTime
    false,                                                // bInitialized
    131643U,                                              // fVersionInfo
    nullptr,                                              // fErrorFunction
    "ComputeEllipseInfo",                                 // fFunctionName
    nullptr,                                              // fRTCallStack
    false,                                                // bDebugMode
    {2045744189U, 2170104910U, 2743257031U, 4284093946U}, // fSigWrd
    nullptr                                               // fSigMem
};

// Function Declarations
static real_T b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

static const mxArray *b_emlrt_marshallOut(const real_T u[9]);

static void emlrtExitTimeCleanupDtorFcn(const void *r);

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                               const char_T *identifier);

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId);

static const mxArray *emlrt_marshallOut(const real_T u[3]);

// Function Definitions
static real_T b_emlrt_marshallIn(const emlrtStack &sp, const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims{0};
  real_T ret;
  emlrtCheckBuiltInR2012b((emlrtConstCTX)&sp, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *static_cast<real_T *>(emlrtMxGetData(src));
  emlrtDestroyArray(&src);
  return ret;
}

static const mxArray *b_emlrt_marshallOut(const real_T u[9])
{
  static const int32_T iv[2]{0, 0};
  static const int32_T iv1[2]{3, 3};
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateNumericArray(2, (const void *)&iv[0], mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &iv1[0], 2);
  emlrtAssign(&y, m);
  return y;
}

static void emlrtExitTimeCleanupDtorFcn(const void *r)
{
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *b_nullptr,
                               const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(sp, emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static real_T emlrt_marshallIn(const emlrtStack &sp, const mxArray *u,
                               const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = b_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u[3])
{
  static const int32_T i{0};
  static const int32_T i1{3};
  const mxArray *m;
  const mxArray *y;
  y = nullptr;
  m = emlrtCreateNumericArray(1, (const void *)&i, mxDOUBLE_CLASS, mxREAL);
  emlrtMxSetData((mxArray *)m, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)m, &i1, 1);
  emlrtAssign(&y, m);
  return y;
}

void ComputeEllipseInfo_api(const mxArray *const prhs[10], int32_T nlhs,
                            const mxArray *plhs[2])
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  real_T(*Jf)[9];
  real_T(*f)[3];
  real_T a;
  real_T b;
  real_T lambda;
  real_T t;
  real_T xc;
  real_T xe;
  real_T xr;
  real_T yc;
  real_T ye;
  real_T yr;
  st.tls = emlrtRootTLSGlobal;
  f = (real_T(*)[3])mxMalloc(sizeof(real_T[3]));
  Jf = (real_T(*)[9])mxMalloc(sizeof(real_T[9]));
  // Marshall function inputs
  xe = emlrt_marshallIn(st, emlrtAliasP(prhs[0]), "xe");
  xr = emlrt_marshallIn(st, emlrtAliasP(prhs[1]), "xr");
  xc = emlrt_marshallIn(st, emlrtAliasP(prhs[2]), "xc");
  ye = emlrt_marshallIn(st, emlrtAliasP(prhs[3]), "ye");
  yr = emlrt_marshallIn(st, emlrtAliasP(prhs[4]), "yr");
  yc = emlrt_marshallIn(st, emlrtAliasP(prhs[5]), "yc");
  t = emlrt_marshallIn(st, emlrtAliasP(prhs[6]), "t");
  lambda = emlrt_marshallIn(st, emlrtAliasP(prhs[7]), "lambda");
  a = emlrt_marshallIn(st, emlrtAliasP(prhs[8]), "a");
  b = emlrt_marshallIn(st, emlrtAliasP(prhs[9]), "b");
  // Invoke the target function
  ComputeEllipseInfo(xe, xr, xc, ye, yr, yc, t, lambda, a, b, *f, *Jf);
  // Marshall function outputs
  plhs[0] = emlrt_marshallOut(*f);
  if (nlhs > 1) {
    plhs[1] = b_emlrt_marshallOut(*Jf);
  }
}

void ComputeEllipseInfo_atexit()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtPushHeapReferenceStackR2021a(&st, false, nullptr,
                                    (void *)&emlrtExitTimeCleanupDtorFcn,
                                    nullptr, nullptr, nullptr);
  emlrtEnterRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  ComputeEllipseInfo_xil_terminate();
  ComputeEllipseInfo_xil_shutdown();
  emlrtExitTimeCleanup(&emlrtContextGlobal);
}

void ComputeEllipseInfo_initialize()
{
  emlrtStack st{
      nullptr, // site
      nullptr, // tls
      nullptr  // prev
  };
  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(&st);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

void ComputeEllipseInfo_terminate()
{
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

// End of code generation (_coder_ComputeEllipseInfo_api.cpp)

function [f,Jf] = ComputeEllipseInfo(xe,xr,xc,ye,yr,yc,t,lambda,a,b)
%ComputeEllipseInfo
%    [F,Jf] = ComputeEllipseInfo(XE,XR,XC,YE,YR,YC,T,LAMBDA,A,B)

%    This function was generated by the Symbolic Math Toolbox version 24.1.
%    14-Aug-2024 15:03:53

t2 = cos(t);
t3 = sin(t);
t6 = 1.0./a.^2;
t7 = 1.0./b.^2;
t8 = -xe;
t9 = -ye;
t4 = t2.^2;
t5 = t3.^2;
t10 = t8+xc;
t11 = t9+yc;
t16 = t2.*t3.*t6.*2.0;
t17 = t2.*t3.*t7.*2.0;
t12 = t2.*t10;
t13 = t2.*t11;
t14 = t3.*t10;
t15 = t3.*t11;
t18 = -t17;
t19 = -t14;
t20 = t12+t15;
t22 = t16+t18;
t21 = t13+t19;
t23 = lambda.*t22;
t24 = t2.*t6.*t20.*2.0;
t25 = t3.*t6.*t20.*2.0;
t26 = -t24;
t27 = -t25;
t28 = t2.*t7.*t21.*2.0;
t29 = t3.*t7.*t21.*2.0;
f = [xe.*2.0-xr.*2.0-lambda.*(t24-t29);ye.*2.0-yr.*2.0-lambda.*(t25+t28);t6.*t20.^2+t7.*t21.^2-1.0];
if nargout > 1
    t30 = -t28;
    t31 = t26+t29;
    t32 = t27+t30;
    Jf = reshape([lambda.*(t4.*t6.*2.0+t5.*t7.*2.0)+2.0,t23,t31,t23,lambda.*(t4.*t7.*2.0+t5.*t6.*2.0)+2.0,t32,t31,t32,0.0],[3,3]);
end
end
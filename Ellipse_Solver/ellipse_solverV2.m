function [xn,yn,tn] = ellipse_solverV2(a,b,xc,yc,xr,yr,tor,method,xn,yn,phi)
%ELLIPSE_SOLVER Summary of this function goes here
%   Detailed explanation goes here
%   a,b: axis length of ellipse; xc,yc: center of ellipse
%   x,y: point outside of ellipse
%   return: xn,yn. Point on ellipse that is closet to

if method == 1
    tn = x0;
    % Newton-Raphson
    f = (xr-xc)*a*sin(tn) - (yr-yc)*b*cos(tn) + (b^2-a^2)*cos(tn)*sin(tn);
    df = (xr-xc)*a*cos(tn) + (yr-yc)*b*sin(tn)+ (b^2-a^2)*(cos(tn)^2 - sin(tn)^2);
    iter = 1;
    while abs(f) >= tor || df <0
        tn = tn - f/df;
        if tn > 2*pi
            tn = tn - 2*pi;
        end
        f = (xr-xc)*a*sin(tn) - (yr-yc)*b*cos(tn) + (b^2-a^2)*cos(tn)*sin(tn);
        df = (xr-xc)*a*cos(tn) + (yr-yc)*b*sin(tn)+ (b^2-a^2)*(cos(tn)^2 - sin(tn)^2);
        iter = iter + 1;
    end

    xn = xc + a*cos(tn);
    yn = yc + b*sin(tn);

elseif method == 2
    tn = 0;
    %     xn = xc + a*cos(tn);
    %     yn = yc + b*sin(tn);
    lambda = 0;

    [f,Jf] = ComputeEllipseInfo(xn,xr,xc,yn,yr,yc,phi,lambda,a,b);
    iter = 1;
    while norm(f) > tor
        sol = Jf\f;
        %         sol = ellipse_inverse(Jf(1,1),Jf(1,3),Jf(2,2),Jf(2,3)) * f;
        xn = xn - sol(1);
        yn = yn - sol(2);
        lambda = lambda - sol(3);
        [f,Jf] = ComputeEllipseInfo(xn,xr,xc,yn,yr,yc,phi,lambda,a,b);
        iter = iter + 1;
    end
    iter
else
    tn = x0;
    lambda = 1;
    x = 0.3;
    y = 0.3;
    f = [(a+lambda*b)*cos(tn)-xr+xc;(b+lambda*a)*sin(tn)-yr+yc];

    %     iter = 1;
    %     while norm(f)>tor && iter <= 30
    %         Jf = [-(a+lambda*b)*sin(tn) b*cos(tn);(b+lambda*a)*cos(tn) a*sin(tn)];
    %         sol = Jf\f;
    %         tn = tn - sol(1);
    %         lambda = lambda - sol(2);
    %         f = [(a+lambda*b)*cos(tn)-xr+xc;(b+lambda*a)*sin(tn)-yr+yc];
    %         iter = iter + 1;
    %     end
    f = [(a+lambda*b)*x-xr+xc;(b+lambda*a)*y-yr+yc;x^2+y^2-1];
    iter = 1;
    while norm(f)>tor && iter <= 30
        Jf = [a+lambda*b 0 b*x;0 b+lambda*a a*y;2*x 2*y 0];
        sol = Jf\f;
        x = x - sol(1);
        y = y - sol(2);
        lambda = lambda - sol(3);
        f = [(a+lambda*b)*x-xr+xc;(b+lambda*a)*y-yr+yc;x^2+y^2-1];
        iter = iter + 1;
    end
    iter
    xn = xc + a*x;
    yn = yc + b*y;
    %     c = (xr-xc)^2 + (yr-yc)^2;
    %     lambda = (-4*a*b + sqrt(16*a^2*b^2 - 4 * (a^2+b^2)*(a^2+b^2-c)))/(2*a^2 + 2*b^2);
    %     tn = asin((yr-yc)/(b+lambda*a));
    %     xn = xc + a*cos(tn);
    %     yn = yc + b*sin(tn);
end
end


syms xe xr xc ye yr yc t lambda a b;

A = (xe - xc) * cos(t) + (ye - yc) * sin(t);
B = (xe - xc) * sin(t) - (ye - yc) * cos(t);

L = (xe-xr)^2 + (ye-yr)^2 + lambda * (A^2/a^2 +  B^2/b^2 - 1);

f = jacobian(L,[xe;ye;lambda]).';
Jf = jacobian(f,[xe;ye;lambda]);

matlabFunction(f,Jf,'File',[pwd '/ComputeEllipseInfo'],'vars',{xe xr xc ye yr yc t lambda a b},'Outputs',{'f','Jf'}); 



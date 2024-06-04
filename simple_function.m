
import casadi.*

x = MX.sym('x',2);
y = MX.sym('y');

gen = Function('gen',{x},{[sin(x(1));sin(x(2))]});
cg_options = struct();
C = CodeGenerator('gen.c',cg_options);
C.add(gen);
C.generate();
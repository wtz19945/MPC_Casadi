P = sparse([4, 1; 1, 2]);
q = [1; 1];
A = sparse([1, 1; 1, 0; 0, 1]);
l = [1; 0; 0];
u = [1; 0.7; 0.7];

% Create an OSQP object
prob = osqp;

% Setup workspace and change alpha parameter
prob.setup(P, q, A, l, u, 'alpha', 1);

% Solve problem
res = prob.solve();
res.x

P = sparse([5, 2; 2, 1]);
q = [1; 1];
A = sparse([.1, 2; 1, 0; 0, 1]);
l = [-1; -1; -2];
u = [1; 1.7; 2.7];
% Create an OSQP object
prob = osqp;
% Setup workspace and change alpha parameter
prob.setup(P, q, A, l, u, 'alpha', 1);
% Solve problem
res = prob.solve();
res.x

P = sparse([1, 2; 2, 10]);
q = [1; 1];
A = sparse([.5, 1.2; 1, 0; 0, 1]);
l = [-1; -1; -2];
u = [1; 1.7; 2.7];
% Create an OSQP object
prob = osqp;
% Setup workspace and change alpha parameter
prob.setup(P, q, A, l, u, 'alpha', 1);
% Solve problem
res = prob.solve();
res.x
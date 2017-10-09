function [e,gamma] = sinkhorn(M,varargin)
opts.epsilon = 1e-3;
opts.N_iter = 2;
opts = vl_argparse(opts,varargin);

b = ones(size(M,2),1);

% call this gamma and clear M for mem efficiency
gamma = exp(-M/opts.epsilon);
clear('M');

b = cast(b,'like',gamma);
for iter = 1:opts.N_iter
    a = 1./(gamma*b);
    b = 1./(gamma'*a);    
end

e = 0;
% e = ((K.*M)*b)'*a;

%form transport with bsxfun for memory efficiency
gamma = bsxfun(@times,gamma,a);
gamma = bsxfun(@times,gamma,b');




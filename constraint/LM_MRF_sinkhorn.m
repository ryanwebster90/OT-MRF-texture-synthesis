function y = LM_MRF_sinkhorn(y,x,dataratio,patchsize,varargin)
% M = maximum size of matrix product of the form
% (n1 x p) * (p x n2)
% where n1 and n2 are very large

% Slices computation of l2 distances
% at the cost of redundant computation
% Then computes a single sinkhorn iteration
% on the slices

opts.M = 5e7;
opts.epsilon = 1e-3;
opts = vl_argparse(opts,varargin);

x_sz = size(x);
x_patch_inds =create_patch_sample(x_sz,patchsize,dataratio);
y_patch_inds =create_patch_sample(x_sz,patchsize,dataratio);


M = opts.M;
Y = im2col_patch_sample(y,y_patch_inds);
a = ones(size(Y,2),1,'like',Y);
m = floor(M/size(Y,2));
K = ceil(size(Y,2)/m);
disp(['Number of slices = ',num2str(K)])
Y = [ Y ; -1/2 * sum( Y.^2 ,1) ; ones( 1 , size(Y,2) ) ];
%compute sliced row scaling of C
for k = 1:K
    inds = (k-1)*m+1:min(k*m,size(Y,2));
    X = im2col_patch_sample(x,x_patch_inds(:,inds));
    X = (-2)*[ X ;ones( 1 , size(X,2) ); -1/2 * sum( X.^2,1 )  ];

    gamma = X'*Y;
    gamma = gamma/(size(X,1)-2);
    gamma = exp(-gamma/opts.epsilon);
    a(inds) = 1./sum(gamma,2);
end

X = im2col_patch_sample(x,x_patch_inds);
clear('x_patch_inds');
P = ones(size(Y,2),1,'like',Y);
X = [ X ; -1/2 * sum( X.^2 ,1) ; ones( 1 , size(X,2) ) ];

%compute sliced col scaling of C
%then compute transport plan
for k = 1:K
    inds = (k-1)*m+1:min(k*m,size(X,2));
    
   Y = im2col_patch_sample(y,y_patch_inds(:,inds));
   Y = (-2)*[ Y ;ones( 1 , size(Y,2) ); -1/2 * sum( Y.^2,1 )  ];

    gamma = Y'*X;
    gamma = gamma/(size(X,1)-2);
    gamma = exp(-gamma/opts.epsilon);
    b = 1./(gamma*a);
    gamma = gamma.*bsxfun(@times,a',b);
    [~,P(inds)] = max(gamma,[],2);
end

clear('gamma');
X = X(1:end-2,:);
fprintf('injective ratio: %10.3e\n',numel(unique(P(:)))/numel(P));
Y = X(:,P(:));
clear('X');
clear('P');
y = col2im_patch_sample(y,Y,y_patch_inds,'M',M);




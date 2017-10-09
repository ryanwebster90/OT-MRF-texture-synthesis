function C = l2_dist_mat(X,Y)
X_l2 = (-2)*[ X ;ones( 1 , size(X,2) ); -1/2 * sum( X.^2,1 )  ];

Y_l2 = [ Y ; -1/2 * sum( Y.^2 ,1) ; ones( 1 , size(Y,2) ) ];

C = X_l2'*Y_l2;
C = C/size(X,1);
end
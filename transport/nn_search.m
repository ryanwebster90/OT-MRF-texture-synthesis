function [Y,NN_ids,E] = nn_search(Y,X)
    X_l2 = (-2)*[ X ;ones( 1 , size(X,2) ); -1/2 * sum( X.^2 )  ];

    Y_l2 = [ Y ; -1/2 * sum( Y.^2 ) ; ones( 1 , size(Y,2) ) ];
    
    % memory parameter
    M = 2e3;

    N = ceil(size(Y_l2,2)/M);
    Y_l2 = [Y_l2,zeros(size(Y_l2,1),N*M-size(Y_l2,2))];%pad Y_l2
    NN_ids = zeros(M,N);
    E = 0;

    for k =1:N
        r = (k-1)*M+1:k*M;
        D = X_l2'*Y_l2(:,r);
        [e_k,ids_k] = min(D,[],1);
        NN_ids(:,k) = ids_k(:);
        E = E + sum(e_k(:));
    end
        NN_ids = NN_ids(1:size(Y,2));
        Y = X(:,NN_ids);

end
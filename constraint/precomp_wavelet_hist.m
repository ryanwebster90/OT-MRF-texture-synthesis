function [x_basis,x_udwt_sorted] = precomp_wavelet_hist(x,L)

[x_pca,x_basis] = pca_2D(x);
x_udwt = haar_udwt_2D(x_pca,L);
x_udwt = reshape(x_udwt,[],size(x_udwt,3));
x_udwt_sorted = sort(x_udwt,1);
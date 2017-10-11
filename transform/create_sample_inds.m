function sample_inds = create_sample_inds(x_sz,dataratio)
% Returns linear indices from a 2D grid sized x_sz, sorted.
% Dataratio specifies the percentage of indices taken, with
% dataratio = 1 taking every location (i.e. (1:x_sz(1)*x_sz(2))')
%
% Ryan Webster, 2017

N = x_sz(1)*x_sz(2);
sample_inds = randperm(N);
sample_inds = sort(sample_inds(1:floor(numel(sample_inds)*dataratio)))';
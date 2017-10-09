addpath('./../simoncelli textures');
addpath('./../arbyreed textures');
addpath('./../misc textures');
run setup.m

% x0 = single(imread('raddish.jpg'))/255;
x0 = single(imread('cambodia_cg.jpg'))/255;
% x0 = single(imread('oriental_cg.jpg'))/255;
% x0 = single(imread('packaged_candy.png'))/255;


x0 = resize_image_2D(x0,.5);
x0 = Spectrum.periodic(x0);
x0 = gpuArray(x0);


N_scales = 4;
N_iter = 8;
patchsize = 8;
dataratio = .15;
MRF_constraint = 'OT';
epsilon = 1e-3;

wavelet_OT_1D = 1;
L = 3;
rng(13);

y = MRF_synthesis(x0,'MRF_constraint',MRF_constraint,'N_scales',N_scales,...
    'N_iter',N_iter,'patchsize',patchsize,'dataratio',dataratio,...
    'wavelet_OT_1D', wavelet_OT_1D,'L',L,'epsilon',epsilon);
function y = MRF_synthesis(x0,varargin)
% MRF_SYNTHESIS
% synthesizes an image y given exemplar texture x0
% At each iteration, the optimal transport distance
% between patches in x0 and y is computed using the entropic
% regularization method from [1]. The transport plan gamma
% transports patches from x0 to y which are then re averaged.
%
% [1] Lightspeed computation of Optimal Transport, Marco Cuturi (2013)
%
% Ryan Webster, 2017


% MRF options
opts.N_iter = 4; %num iter at each scale
opts.patchsize = 14;
opts.dataratio = .04; % percentage of patches randomly sampled
opts.MRF_constraint = 'OT';
opts.epsilon = 3e-3; % entropic regularization

% post processing options
% matching wavelet subbands helps deblur averaged patches
opts.wavelet_OT_1D = false; % 1D OT of wavelet subbands (heeger bergen)
opts.wavelet_ = 3; % num scales in wavelet transform
opts = vl_argparse(opts,varargin);

isgpu = isa(x0,'gpuArray');
if isgpu;gd = gpuDevice;end;

figure
t0 = tic;
  % run synthesis over pyramid with N_scales
for scale = 1:opts.N_scales
  x = resize_image_2D(x0, 1/2^(opts.N_scales-scale));
  
  if opts.wavelet_OT_1D
    if isgpu;x = gather(x);end
    % precompute subband histograms for speed
    [x_basis,x_udwt_sorted] = precompute_wavelet_OT_1D(x,opts.L);
    if isgpu;x = gpuArray(x);end
  end
  
  if scale >1
    y = resize_image_2D(y,size(x));
  else
    y = cast(rand(size(x)),'like',x);
  end
  
  for iter = 1:opts.N_iter
    if strcmp(opts.MRF_constraint,'OT');
      % transport patches from x0 to y
      
      % this file is more intuitive but can easily run out of memory
      %y = MRF_OT_constraint(y,x,opts.dataratio,opts.patchsize,'epsilon',opts.epsilon);
      
      % avoid running out of memory by slicing the cost matrix
      y = LM_MRF_sinkhorn(y,x,opts.dataratio,opts.patchsize,...
        'epsilon',opts.epsilon,'M',5e7);
      
    else
    end
    
    if opts.wavelet_OT_1D
      % do 1D OT on wavelet subbands.
      
      %this constraint runs faster on cpu
      if isgpu;y = gather(y);end
      y = wavelet_OT_1D_constraint(y,opts.L,x_basis,x_udwt_sorted);
      if isgpu;y = gpuArray(y);end
    end
    
    % display current synthesis
    % TODO: display OT distance C.*gamma
    % add option for turning off display
    imshow(y);
    title(['synthesis iter: ',num2str(iter),...
      ' synthesis scale: ',num2str( 1/2^(opts.N_scales-scale))])
    drawnow
  end
  
end
if isa(x0,'gpuArray');wait(gd);end;
disp(['Algorithm time: ',num2str(toc(t0))]);
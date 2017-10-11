# OT-MRF-texture-synthesis
Texture synthesis combining the methods from [1] and [2].
The algorithm iteratively matches patches from an exemplar image 
and the current synthesis and reaverges them back into the image
domain. [1] often verbatim copies large portions of the image
[3] and struggles with textures that have fine grained local
and global statistical qualities (e.g. fur, grass). 


[1] Texture Optimization, Vivek Kwatra, 2005

[2] [Sinkhorn Distances: Lightspeed Computation of Optimal Transportation Distances](https://arxiv.org/abs/1306.0895)

[3] Variational Texture Synthesis with Sparsity and Spectrum Constraints Tartevel et al, 2013

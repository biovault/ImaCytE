# Efficient Wasserstein barycenter in MATLAB

*Author's updated version at https://github.com/bobye/WBC_Matlab* 

This package includes the propotype codes for computing the Wasserstein barycenter.
The codes are released to reproduce parts of the experiments reported in the following journal paper:

- Jianbo Ye, Panruo Wu, James Z. Wang and Jia Li, "Fast Discrete Distribution Clustering Using Wasserstein Barycenter with Sparse Support", *IEEE Transactions on Signal Processing*, 2017 ([arXiv:1510.00012](http://arxiv.org/abs/1510.00012) [stat.CO], September 2015), to appear.

A more efficient and scalable implementation in MPI and C is [available](https://github.com/bobye/d2_kmeans).

The codes also implements algorithms in the following papers:

- Jean-David Benamou, Guillaume Carlier, Marco Cuturi, Luca Nenna, and Gabriel Peyré, "Iterative Bregman projections for regularized transportation problems." *SIAM Journal on Scientific Computing* 37.2 (2015): A1111-A1138.

- Jianbo Ye and Jia Li, "Scaling Up Discrete Distribution Clustering Using ADMM", *IEEE International Conference on Image Processing*, Paris, France, October 2014.

- Marco Cuturi and Arnaud Doucet. "Fast Computation of Wasserstein Barycenters.", *International Conference on Machine Learning*, Atlanta, USA, June 2013.

- Jia Li and James Z. Wang. "Real-time computerized annotation of pictures." *IEEE Transactions on Pattern Analysis and Machine Intelligence* 30.6 (2008): 985-1002.




## Algorithm Prototypes

Directory `matlab` contains prototype version in Matlab R2015b.
  
- `profile_centroid.m` --- profiling the convergence of centroid updates
- `Wasserstein_Barycenter.m` --- main function
- `profile_kantorovich.m` --- profiling LP solution of transportation problem
- `centroid_sph*.m` --- computing centroid of a single phase

## Get started

***The code is tested in Matlab 2015a***

Try to run `profile_centroid.m` from the project directory. Checkout the data structure used in the example. 

This code also can be tailored to work with histogram data, but the coordinates of bins should also be supplied as support points in the data structure. Meanwhile, set the option for fixing the support points of WBC:

```matlab
%% comment out this line to use fixed support points of barycenter
options.support_points= 'fixed';
```

## FAQ

- How BADMM works for MNIST dataset?
 I was able to generate BADMM barycenter from 100 MNIST images (sparse representation). At Intel i7 3.4GHz PC, the pre-converged results at 200 seconds and 1000 seconds are depicted as follows respectively:
 
 <img src="https://github.com/bobye/WBC_Matlab/raw/master/BADMM-200.png" width="200"> <img src="https://github.com/bobye/WBC_Matlab/raw/master/BADMM-1000.png" width="200">
 
----
Copyright (C) 2017 The Pennsylvania State University, USA - All Rights Reserved 

Installation and use of this software for academic, non-profit, or government-sponsored research purposes is hereby granted. Use of the software under this license is restricted to non-commercial purposes. COMMERCIAL USE OF THE SOFTWARE REQUIRES A SEPARATELY EXECUTED WRITTEN LICENSE AGREEMENT with the copyright holder.

Any use of the software, and any modifications, improvements, or derivatives to the software the user(s) may create (collectively, “Improvements”) must be solely for internal, non-commercial purposes. A user of the software shall not distribute or transfer the software or Improvements to any person or third parties without prior written permission from copyright holder.

Any publication of results obtained with the software must acknowledge its use by an appropriate citation to the article titled "Fast Discrete Distribution Clustering Using Wasserstein Barycenter with Sparse Support" published in the IEEE Transactions on Signal Processing in 2017.

ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. THE COPYRIGHT HOLDER MAKES NO REPRESENTATION OR WARRANTY THAT THE SOFTWARE WILL NOT INFRINGE ANY PATENT OR OTHER PROPRIETARY RIGHT. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Jianbo Ye, College of Information Sciences and Technology, yelpoo@gmail.com

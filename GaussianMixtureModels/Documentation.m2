
-*
doc ///
Key
Headline
Usage
Inputs
Outputs
Consequences
  Item
Description
  Text
  Example
  CannedExample
  Code
  Pre
ExampleFiles
Contributors
References
Caveat
SeeAlso
///
*-

doc ///
  Key
   GaussianMixtureModels
  Headline
     A Macaulay2 package to work with Gaussian mixture models.
  Description
   Text
    {\em GaussianMixtureModels} is a package that can solve the parameters of Gaussian mixture model.
  Caveat
    Only solves models with fixed, equal variance.
  Subnodes
    produceMomentSystemMatrices
///

doc ///
  Key
   produceMomentSystemMatrices
   (produceMomentSystemMatrices,ZZ,QQ)
  Headline
   A function that creates the constant and nonconstant coefficient matrices from the moment equations
  Usage
   produceMomentSystemMatrices(k,variance)
  Inputs
   k:ZZ
     An integer representing the number of Gaussians.
   variance:QQ
     A rational number representing the variance.
  Outputs
   A:Matrix
    An $k \times k$ matrix representing the nonconstant coefficient matrix
   B:Matrix
    An $k$-dimensional column matrix representing the constant terms in the moment equations.
  Description
   Text
    Let $p_i = (\mu_1,\cdots,\mu_k) = \mu_1^i+\cdots+\mu_k^i$ be $i$-th power sum of the means. for the case $k=4$ and $\sigma = 1$, the moment equations are
    
    $$\begin{aligned} & \bar{m}_1=\frac{1}{4}p_1  \\ & \bar{m}_2=\frac{1}{4}p_2+1 \\ & \bar{m}_3=\frac{3}{4}p_1+\frac{1}{4}p_3 \\ & \bar{m}_4=\frac{3}{2}p_2+\frac{1}{4}p_4+3\end{aligned}$$

    which can be written in the matrix form if we denote $\mathbf{m} = [\bar{m}_1\;\cdots\;\bar{m}_k]^T$ and $\mathbf{p} = [p_1\;\cdots\;p_k]^T$:

    $$\begin{aligned} & \mathbf{m} = A\mathbf{p}+B\end{aligned}$$

    where the matrices $A$ and $B$ can be computed by the following command.
    
   Example
    produceMomentSystemMatrices(4,1/1)
///

doc ///
  Key
    solvePowerSystem
    (solvePowerSystem, Matrix, List)
    (solvePowerSystem, List)
  Headline
    Computes the unique solution to a square linear system of power sum equations.
  Usage
    solvePowerSystem(A,m)
    solvePowerSystem(m)
  Inputs
    A: Matrix
      A square matrix describing the linear system of power sum equations.
    m: List
      A list of solutions to $Ap = m$.
  Outputs
    sols: List
      The unique solution to the system of equations up to permutation.
  Description
    Text
      Let $p_i(x_1,\dots, x_n)$ denote the $i^{\text{th}}$ power sum polynomial in $n$ variables, i.e. $p_2(x,y,z) = x^2 + y^2 + z^2$. The square matrix $A$ describes a linear system of equations in the $p_i$'s. For example,
      $$ A = \begin{pmatrix} 
      9 & 0 & 0 & 0 & 0\\
      0 & 8 & 0 & 0 & 0\\
      6 & 0 & 7 & 0 & 0\\
      0 & 4 & 0 & 5 & 0\\
      1 & 0 & 2 & 0 & 3
       \end{pmatrix}$$ 
      describes the system of equations 
      $$
      \begin{equation*}
      
      \end{equation*}
      $$
    Example
      A = matrix {{9,0,0,0,0}, {0,8,0,0,0}, {6,0,7,0,0},{0,4,0,5,0},{1,0,2,0,3}}
  SeeAlso
///

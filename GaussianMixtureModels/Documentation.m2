
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
   Creates the constant and nonconstant coefficient matrices from the moment equations
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
      a square matrix describing the linear system of power sum equations.
    m: List
      a list of solutions to $Ap = m$.
  Outputs
    sols: List
      the unique solution to the system of equations up to permutation.
  Description
    Text
      Let $p_i(x_1,\dots, x_n)$ denote the $i^{\text{th}}$ power sum polynomial in $n$ variables, i.e. $p_2(x,y,z) = x^2 + y^2 + z^2$. The square matrix $A$ describes a linear system of equations in the $p_i$'s. For example,
    Example
      A = matrix {{9,0,0,0,0}, {0,8,0,0,0}, {6,0,7,0,0},{0,4,0,5,0},{1,0,2,0,3}}
    Text
      describes the system of equations 
    Example
      use QQ[p_1..p_5];
      A*matrix{{p_1},{p_2},{p_3},{p_4},{p_5}} 
    Text
      The function solvePowerSystem takes in a matrix $A$ and a list of solutions $m$ to the system of equations $Ap = m$, and it returns the unique solution to $x_1,\dots, x_n$ up to permutation. If no $A$ is provided, it is assumed that A is the identity.
    Example
      m = {1,2,3,4,5};
      solvePowerSystem(A,m)
  SeeAlso
///

doc ///
  Key
    nextStep
    (nextStep, HillClimber)
  Headline
    Perform one next step of the hill-climbing algorithm.
  Usage
    nextStep(hC)
  Inputs
    hC: @TO2(GaussianMixtureModels,HillClimber)
      a HashTable including the configurations of the hill-climbing algorithm.
  Outputs
    nextPoint: List
      the next point as the starting points when continuing performing the hill-climbing algorithm.
  Description
    Text
      Let's define a hill climber with the loss function, stop condition, and starting point defined below:
    Example
      lossFunction = method()
      lossFunction List := x -> norm_2 transpose matrix{x}
      stopCondition = method()
      stopCondition RR := x -> if x < 0.001 then true else false
      startingPoint = {1,2}
      hC = hillClimber(lossFunction, stopCondition,startingPoint)
      peek hC
    Text
      The following code porforms one step of hill climbing from the starting point and returns the new point it predicts
    Example
      nextStep(hC)
    Text
      The hill climber is also updated simultaneously if one checks the new CurrentPoint and CurrentStep in hC
    Example
      peek hC
  SeeAlso
///

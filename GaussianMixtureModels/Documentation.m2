
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

undocumented {
  (fabricateMoments, List)
}

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
    HillClimber
  Headline
    A general datatype for hill climbing algorithms
  Description
    Text
      The HillClimber datatype is a general framework for hill climbing algorithms. After inputting a starting point, a loss function, and a stopping condition, HillClimber has methods to perform the hill climbing algorithm and keeps track of how many steps it has taken and the current point. The hill climbing algorithm starts at the starting point, generates some number of random directions (NumDirections, which defaults at 10), and then takes a step in that direction of size StepSize (which defaults at size 0.2) until some stopping condition is met.
  SeeAlso
    hillClimber
    (nextStep, HillClimber)
    (track, HillClimber)
///

doc ///
  Key
    hillClimber
    (hillClimber, FunctionClosure, FunctionClosure, List)
  Headline
    Constructs a HillClimber object
  Usage
    hillClimber(lossFunction, stopCondition, startingPoint)
  Inputs
    lossFunction: FunctionClosure
      a function that takes in a list of points and returns a real number.
    stopCondition: FunctionClosure
      a function that takes in a list of points and returns a boolean.
    startingPoint: List
      a point to start the hill climbing algorithm at.
  Outputs
    hC: HillClimber
      a HillClimber object.
  Description
    Text
      The hillClimber function constructs a @TO2(HillClimber, "HillClimber")@ object. The lossFunction and stopCondition are both functions that take in a point (represented as a list). The lossFunction should return a real number that represents the "loss" at that point, and the stopCondition should return a boolean that indicates whether the hill climbing algorithm should stop. The startingPoint is the point at which the hill climbing algorithm will start. For example, suppose that we start with a point $(4,8)$ in $\mathbb{R}^2$ and we wish to find a point on the curve $y = x^2 + 1$ via hill climb. Then we can construct the HillClimber object as follows:
    Example
      lossFunction = L -> abs(L_1 - ((L_0)^2 + 1));
      stopFunction = L -> lossFunction(L) < 0.001;
      startingPoint = {4,8};
      hC = hillClimber(lossFunction, stopFunction, startingPoint)
    Text
      We can then call the nextStep method to take a step in the hill climbing algorithm:
    Example
      nextStep(hC)
      hC#CurrentStep
    Text
      So our new point has moved a little bit towards the curve, and we are on the next step. If we wished to continue until our stopping condition is met, we call track:
    Example
      track(hC, Quiet => true)
    Text
      Now we have a point very close to the curve after many steps.
  SeeAlso
    HillClimber
    (nextStep, HillClimber)
    (track, HillClimber)
///
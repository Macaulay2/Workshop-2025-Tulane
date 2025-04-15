
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
     an example Macaulay2 package
  Description
   Text
    {\em GaussianMixtureModels} is a basic package to be used as an example.
  Caveat
    Still trying to figure this out.
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
   variance:QQ
  Outputs
   :
    Two matrices, one $k \times k$ matrix representing the nonconstant coefficient matrix and one $k$-dimensional column matrix representing the constant terms in the moment equations.
  Description
   Text
    Here we show an example.
   Example
    produceMomentSystemMatrices(3,1/1)
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

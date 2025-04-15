
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


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

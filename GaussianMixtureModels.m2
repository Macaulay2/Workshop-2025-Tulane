-- -*- coding: utf-8 -*-
newPackage(
    "GaussianMixtureModels",
    Version => "0.1",
    Date => "April 14, 2025",
    Authors => {
	{Name => "Gaussian Mixture Models Group", Email => "doe@math.uiuc.edu", HomePage => "http://www.math.uiuc.edu/~doe/"}},
    Headline => "Gaussian Mixture Models Package",
    Keywords => {"Gaussian Mixture Models"},
    DebuggingMode => false
    )

export {"produceMomentSystemMatrices"}

produceMomentSystemMatrices = method()
-*
The function produces the matrix being multiplied to [1,P,P^2,...,P^k]^T
Input: k - number of P's of ZZ
       variance - sigma^2 of QQ
Output: k by (k+1) matrix
*-
produceMomentSystemMatrices (ZZ,QQ) := (k,variance) -> (
    if not k > 0 then error "k should be a positive integer";
    if k == 1 then return matrix{{0,1}};
    if k == 2 then return matrix{{0,1,0},{variance,0,1}};
    M := new MutableMatrix from map(QQ^(k),QQ^(k+1),0);
    M0 := produceMomentSystemMatrices(2,variance);
    scan(2,i -> (scan(3, j -> M_(i,j) = M0_(i,j))));
    scan(toList (2..(k-1)),i -> (
	    shiftedRow := shiftingRow (matrix M)^{i-1};
	    newRow := shiftedRow + i*variance*((matrix M)^{i-2});
	    newRow = flatten entries newRow;
	    scan(k+1,j ->(
		    M_(i,j) = newRow_j;
		    )))
	);
    M
    )

shiftingRow = method()
shiftingRow Matrix := M -> (
    n := numColumns M;
    (matrix{{0} | flatten entries M})_{0..(n-1)}
    )


beginDocumentation()

doc ///
 Node
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
 Node
  Key
   (produceMomentSystemMatrices,ZZ,QQ)
   produceMomentSystemMatrices
  Headline
   a silly first function
  Usage
   produceMomentSystemMatrices(numberOfGaussians,variance)
  Inputs
   k:
   variance:
  Outputs
   :
    a silly string, depending on the value of {\tt n}
  Description
   Text
    Here we show an example.
   Example
    produceMomentSystemMatrices(3,1/1)
///

TEST ///
    assert (  0 == 0 )
///

end--

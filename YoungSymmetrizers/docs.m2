doc ///
  Key
    "YoungSymmetrizers"
  Headline
    a package which implements Young Symmetrizers
  Description
    Text
      This package defines functions called Young symmetrizers that take a list of fillings 
      of Young diagrams (Young tableaux), and produces a polynomial on multi-indexed variables.
      An overview of the package's can be found in the @TO "Young Symmetrizers Guide"@.

///

doc ///
 Key
  "Young Symmetrizers Guide"
 Headline
  a detailed overview of young symmetrizers in Macaulay2
 Description
  Text
   This page gives an overview of the use of young symmetrizers.

   The sections of the overview are, in order:
   
   {\bf Schur-Weyl Duality.} @BR{}@
   {\bf Miscellaneous.}
      
   {\bf Creating Young symmetrizers.}
   ---- keep going here:
   Young symmetrizers are constructed from lists of tableaux (fillings of Young diagrams)
   To create a {\bf youngSymmetrizer}, use the {\tt youngSymmetrizer} method:
  Example
   p = permutation {3,1,2,4,5}
  Text
   Permutations must be constructed from lists consisting of only the integers
   $1 \textemdash n$. If a list contains any other elements or does not consist of the entire
   range, then an error is thrown.
   The method @TO matrix@ can be used to get the matrix representation of the
   permutation. In this representation, for a permutation $p$, if $p(i)=j$, then
   then the $(i,j)$th entry is $1$.
  Example
    youngSymmetrizer({{1,2,3},{4}}, {{1,2,4},{3}}, {{1,3,4},{2}}, myPoint)
  Text
   This function evaluates the Young symmetrizer on the point {\texttt myPoint}. 
  Example
    highestWeightPolynomial({{1,2,3},{4}}, {{1,2,4},{3}}, {{1,3,4},{2}})    
  Text
    This function evaluates the Young symmetrizer on a vector of variables (hidden). 

  --
  Text

   {\bf Foata's fundamental bijection.}

   Foata's fundamental bijection is a bijection between a permutation's standard 
   cycle decomposition and another permutation read the same (in one-line notation)
   as the decomposition with its parentheses removed. For example, if $p = (3 \, 2 \, 1)(5 \, 4)$
   (written in cycle notation), then its corresponding permutation (written in one-line 
   notation) is $\hat{p} = (3 \, 2 \, 1 \, 5 \, 4)$.
  Example
   p = permutation {3,1,2,5,4};
   foataBijection p

  --
  Text

   {\bf Miscellaneous.}

 SeeAlso
  (symbol _, Permutation, ZZ)
  (symbol _, Permutation, List)
  (symbol _, Permutation, Sequence)
  (symbol _, VisibleList, Permutation)
  (symbol ==, Permutation, Permutation)
  (symbol *, Permutation, VisibleList)
  (symbol *, Permutation, Matrix)
  (symbol *, Matrix, Permutation)
  (symbol _, Matrix, Permutation)
  (symbol ^, Matrix, Permutation)
  (symbol *, Permutation, Permutation)
  (symbol ^, Permutation, ZZ)
  ascendingRuns
  ascents
  avoidsPattern
  avoidsPatterns
  cycleDecomposition
  cycleType
  descendingRuns
  descents
  exceedances
  extend
  fixedPoints
  foataBijection
  inverse
  inversions
  isCartwrightSturmfels
  isCDG
  isDerangement
  isEven
  isOdd
  isWellDefined
  isVexillary
  ord
  records
  trim
  saliances
  sign
  (matrix, Permutation)
///

-- Permutation
-- (permutation, VisibleList)
doc ///
  Key
    Permutation
    (permutation, VisibleList)
  Headline
    the Permutation type
  Description
    Text
      Permutations are constructed from lists. To create a permutation, 
      use the {\tt permutation} method.
    Example
      p = permutation {3,1,2,4,5}
    Text
      Permutations must be constructed from lists consisting of only the integers
      $1 \dots n$. If a list contains any other elements or does not consist of 
      the entire range, then an error is thrown.
///

-- (symbol _, Permutation, ZZ)
doc ///
  Key
    (symbol _, Permutation, ZZ)
  Headline
    selects an element from the permutation when regarded as a list
  Usage
    w_n
  Inputs
    w:Permutation
    n:ZZ
  Outputs
    :ZZ
  Description
    Text
      Selects an element from the permutation when it is regarded as a list.
      The index should be 1-indexed.

      Given a permutation $p$ and index $i$, this is the same as $p(i)$.
    Example
      p = permutation {3,1,2,5,4}
      p_1
///
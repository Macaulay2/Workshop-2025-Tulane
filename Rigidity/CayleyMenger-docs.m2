doc ///
Node
  Key 
    getAllTrees
    (getAllTrees,ZZ)
    (getAllTrees,List)
  Headline 
    Get all Cayley-Menger trees on n vertices
  Usage
    L = getAllTrees n
    L = getAllTrees variableNames
  Inputs
    n : ZZ 
      a positive integer
    variableNames : List
      the list of variables to use
  Outputs
    L :
      a list of polynomials, each representing a rooted tree leaves given by the argument list
  Description
    Text
      This function generates all rooted trees on n leaves, 
      represented as polynomials in which each monomial corresponds 
      to a clade (a subset of leaves descending from a common internal node). 
      The leaves are labeled by variables x_1 to x_n (or the ones provided explicitly).
    Example
      getAllTrees 3
      QQ[a,b,c]
      getAllTrees {a,b,c}   
  SeeAlso
    maximalTreePairs 
///

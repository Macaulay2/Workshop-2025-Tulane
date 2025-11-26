doc ///
Node
  Key 
    tropicalCayleyMenger
    (tropicalCayleyMenger,ZZ)
    (tropicalCayleyMenger,List)
    [tropicalCayleyMenger,Type]
  Headline 
    Get maximal cones of the tropicalization of Cayley-Menger variety
  Usage
    L = tropicalCayleyMenger n
    L = tropicalCayleyMenger G
  Inputs
    n : ZZ 
      a positive integer
    G : List
      the list of pairs of integers representing the edges of a graph on vertices 1 to n
  Outputs
    L :
      a list of @TO Cone@s 
  Description
    Text
      This function generates all maximal cones of the tropicalization of the Cayley-Menger variety on n vertices. 
    Example
      T = tropicalCayleyMenger 4;
      #T
      C = first T;
      rays C
      linSpace C
    Text 
      If a graph G is provided, it generates the maximal cones of the tropicalization of the Cayley-Menger variety restricted to the edges of G.
    Example
      G = {{1,2},{2,3},{3,4},{1,4}};
      T = tropicalCayleyMenger G;
      #T
      C = last T;
      rays C
      linSpace C
    Text
      For faster operation, the optional argument
      @TO [tropicalCayleyMenger, Type]@ can be set to @TO List@,
      in which case the generators of the maximal cones are returned as lists of coordinates.  
  Caveat
    If @TT "Type===List"@ then
    not all of the cones returned by @TT "tropicalCayleyMenger G"@
    are guaranteed to be maximal.   
  SeeAlso
    "Working with cones"
///

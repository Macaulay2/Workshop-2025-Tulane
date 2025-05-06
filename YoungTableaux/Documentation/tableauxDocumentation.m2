doc ///
  Key
    YoungTableau
    youngTableau
    (youngTableau, List)
    (youngTableau, HashTable)
  Headline
    constructs a Young tableau
  Usage
    youngTableau lambda
  Inputs
    diagramShape:List
  Outputs
    :YoungTableau
  Description
    Text
      A Young tableau can be constructed from a list of lists specifying the 
      fillings of the cells of the tableau.
    Example
      lambda = youngTableau {{1,2,3},{4,5},{6}}
    Text
      Alternatively, a Young tableau can be construced from a hash table whose
      keys are the coordinates of the cells and whose values are the fillings
      of the cells.
    Example
      lambda = youngTableau hashTable {(1,1) => 1, (1,2) => 2, (1,3) => 3, 
                                       (2,1) => 4, (2,2) => 5, 
                                       (3,1) => 6}
  SeeAlso
    canonicalFilling
    rowsFirstFilling
    columnsFirstFilling
    highestWeightFilling
    randomFilling
///

doc ///
  Key
    isStandard
    (isStandard, YoungTableau)
  Headline
    whether a Young tableau is standard
  Usage
    isStandard T
  Inputs
    T:YoungTableau
  Outputs
    :Boolean
  Description
    Text
      A Young tableau is {\em standard} if the contents of the cells are strictly 
      increasing in both the rows and columns.
    Example
      T = youngTableau {{1,2,3},
                             {2}}
      isStandard T
  SeeAlso
    isSemiStandard
///

doc ///
  Key
    isSemiStandard
    (isSemiStandard, YoungTableau)
  Headline
    whether a Young tableau is standard
  Usage
    isSemiStandard T
  Inputs
    T:YoungTableau
  Outputs
    :Boolean
  Description
    Text
      A Young tableau is {\em semi-standard} if the contents of the cells are weakly
      increasing in the rows and strictly increasing in the columns.
    Example
      T = youngTableau {{1,1,3},
                        {1,2}}
      isSemiStandard T
  SeeAlso
    isStandard
///

doc ///
  Key
    (toString, YoungTableau)
  Headline
    produces a string representation of a Young tableau
  Usage
    toString lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :String
  Description
    Text
      The string representation encodes a Young diagram by its rows and contents.
    Example
      lambda = youngTableau {{1,2,3},{4,5},{6}}
      toString lambda
  SeeAlso
    (net, YoungDiagram)
///

doc ///
  Key
    (symbol ==, YoungTableau, YoungTableau)
  Headline
    whether two Young tableaux are equal
  Usage
    lambda == mu
  Inputs
    lambda:YoungTableau
    mu:YoungTableau
  Outputs
    :Boolean
  Description
    Text
      Since Young tableaux are implemented as hash tables, two Young tableaux
      are considered equal if they have the same set of of (key, value) pairs.
    Example
      lambda = canonicalFilling youngDiagram {3,2,1}
      mu = rowsFirstFilling youngDiagram {3,2,1}
      lambda == mu
    Text
      This implementation means that if two Young tableaux are shifted versions
      of each other, they are not considered equal.
    Example
      lambda = youngDiagram hashTable {(1,1) => 1, (1,2) => 2,
                                       (2,1) => 3}
      -- mu is lambda shifted to the right by one.
      mu = youngDiagram hashTable {(1,2) => 1, (1,3) => 2,
                                   (2,2) => 3}
      lambda == mu
  SeeAlso
    (symbol ==, YoungDiagram, YoungDiagram)
///

doc ///
  Key
    rowInsertion
    (rowInsertion, YoungTableau, ZZ)
    [rowInsertion, RowIndex]
  Headline
    performs row insertion on a tableau
  Usage
    rowInsertion(lambda, k)
  Inputs
    lambda:YoungTableau
  Outputs
    :YoungTableau
  Description
    Text
      Row insertion is a method of inserting a new cell into a Young tableau
      while preserving the tableau's properties. The new cell is inserted
      into the first row if possible, and if not, it pushes another cell from
      the first row down to the second row, and so on.
    Example
      lambda = youngTableau {{1,4,6},
                             {2}}
      rowInsertion(lambda, 3)
    Text
      Optionally, {\tt RowIndex} can be passed as an argument to specify the 
      starting row for the row-insertion algorithm. The default is the first row.
  SeeAlso
    robinsonSchenstedCorrespondence
///

doc ///
  Key
    RowIndex
  Headline
    what row to start on for the row-insertion algorithm on Young tableaux
  Description
    Text
      Determines which row to start on for the row-insertion algorithm on Young tableaux.
  SeeAlso
    rowInsertion
///

doc ///
  Key
    benderKnuthInvolution
    (benderKnuthInvolution, YoungTableau, ZZ)
  Headline
    computes a Bender-Knuth involution on a semi-standard Young tabelau tableau
  Usage
    benderKnuthInvolution(lambda, k)
  Inputs
    lambda:YoungTableau
    k:ZZ
  Outputs
    :YoungTableau
  Description
    Text
      The Bender-Knuth operation $BK_k$ is an involution on the set of semi-standard
      Young tableaux of weight $w$. The operation is defined as follows:
      
      @UL {
        LI{ "Ignore any cells whose content is not $k$ or $k+1$." },
        LI{ "Ignore any columns whose content contains $k$ and $k+1$." },
        LI{ "For each (disjoint) row in the remaining tableau, swap the number of times $k$ and $k+1$ appear, maintaining the semi-standard property." }
      }@

    Example
      lambda = youngTableau {{1,1,1,1,1,1,2,2,2,2,3},
                             {2,2,2,2,2,2,3},
                             {3,4,4,4,4}}
      benderKnuthInvolution(lambda, 2)
  Caveat
    For a tableau of shape $\lambda$, this is only defined for $1 \keq k \leq \lambda - 1$.
  SeeAlso
    promotion
    evacuation
///

doc ///
  Key
    promotion
    (promotion, YoungTableau)
  Headline
    computes the promotion of a standard Young tableau
  Usage
    promotion lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :YoungTableau
  Description
    Text
      For a standard Young tableau $T$ of shape $\lambda$ with $\vert \lambda \vert = n$,
      the promotion of $T$ is defined as the composition $(\circ BK_{n-1} \circ \ldots \circ BK_1)(T)$,
      where $BK_k$ is a Bender-Knuth involution.
    Example
      lambda = youngTableau {{1,3,4,5},
                             {2,6,8},
                             {7,9}}
      promotion lambda
  Caveat
    Promotion is only defined for standard Young tableaux.
  SeeAlso
    benderKnuthInvolution
    evacuation
///

doc ///
  Key
    evacuation
    (evacuation, YoungTableau)
  Headline
    computes the evacuation of a semi-standard Young tableau
  Usage
    evacuation lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :YoungTableau
  Description
    Text
      For a semi-standard Young tableau $T$ of shape $\lambda$ with $\vert \lambda \vert = n$,
      the promotion of $T$ is defined as the composition 
      $((BK_1) \circ (BK_2 \circ BK_1) \circ \ldots \circ (\circ BK_{n-1} \circ \ldots \circ BK_1))(T)$,
      where $BK_k$ is a Bender-Knuth involution.
    Example
      lambda = youngTableau {{1,3,4,8},
                             {2,5,6},
                             {7,9}}
      evacuation lambda
    Example
      lambda = youngTableau {{1,3,8},
                             {2,4},
                             {5,9},
                             {6,10},
                             {7}}
      evacuation lambda
  Caveat
    Evacuation is only defined for semi-standard Young tableaux.
  SeeAlso
    benderKnuthInvolution
    dualEvacuation
///

doc ///
  Key
    dualEvacuation
    (dualEvacuation, YoungTableau)
  Headline
    computes the dual evacuation of a semi-standard Young tableau
  Usage
    dualEvacuation lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :YoungTableau
  Description
    Text
      For a semi-standard Young tableau $T$ of shape $\lambda$ with $\vert \lambda \vert = n$,
      the promotion of $T$ is defined as the composition 
      $((BK_{n-1}) \circ (BK_{n-2} \circ BK_{n-1}) \circ \ldots \circ (\circ BK_1 \circ \ldots \circ BK_{n-1}))(T)$,
      where $BK_k$ is a Bender-Knuth involution.
    Example
      lambda = youngTableau {{1,3,4,8},
                             {2,5,6},
                             {7,9}}
      dualEvacuation lambda
    Example
      lambda = youngTableau {{1,3,8},
                             {2,4},
                             {5,9},
                             {6,10},
                             {7}}
      dualEvacuation lambda
  Caveat
    Dual evacuation is only defined for semi-standard Young tableaux.
  SeeAlso
    benderKnuthInvolution
    evacuation
///

doc ///
  Key
    robinsonSchenstedCorrespondence
    (robinsonSchenstedCorrespondence, Permutation)
    (RSKCorrespondence, Permutation)
    (robinsonSchenstedCorrespondence, YoungTableau, YoungTableau)
  Headline
    computes the image of a permutation or a pair of Young tableaux under the Robinson-Schensted correspondence
  Usage
    robinsonSchenstedCorrespondence perm
  Inputs
    perm:Permutation
  Outputs
    :Sequence
  Description
    Text
      The {\em Robinson-Schensted correspondence} is a bijection between permutations
      and pairs of standard Young tableaux of the same shape. For a permutation 
      $p$ with corresponding tableaux $(P,Q)$, the tableau $P$ is called the 
      {\em insertion tableau} and $Q$ is called the {\em recording tableau}.
    Example
      p = permutation {2,4,6,1,3,5}
      robinsonSchenstedCorrespondence p
    Text
      The inverse image takes the pair $(P,Q)$ to the corresponding permutation $p$.
    Example 
      P = youngTableau {{1,3,5},
                        {2,4,6}}
      Q = youngTableau {{1,2,3},
                        {4,5,6}}
      robinsonSchenstedCorrespondence(P, Q)
  Caveat
    This is only a correspondence between permutations and standard Young tableaux.
  SeeAlso
    rowInsertion
    RSKCorrespondence
///

doc ///
  Key
    biword
    (biword, Matrix)
  Headline
    computes the biword of a matrix
  Usage
    biword M
  Inputs
    M:Matrix
  Outputs
    :Matrix
  Description
    Text
      Given a matrix $M$ whose entries are non-negative integers, the {\em biword}
      is a $2 \times k$ matrix ($k$ is the sum of all the entries of $M$) whose
      columns record the entries of $M$ via multiplicity of columns in the biword.
      More precisely, the biword of $M$ has $M_(i,j)$ columns whose entries are
      $(i,j)$, and the columns of the biword are lexicographically sorted.
    Example
      M = matrix {{1,0,2},
                  {0,2,0},
                  {1,1,0}}
      biword M
  Caveat
    This method requires that the input matrix only has non-negative integer 
    entries.
  SeeAlso
    RSKCorrespondence
///

doc ///
  Key
    RSKCorrespondence
    (RSKCorrespondence, Matrix)
    (RSKCorrespondence, YoungTableau, YoungTableau)
  Headline
    computes the image of a matrix or a pair of Young tableaux under the RSK correspondence
  Usage
    RSKCorrespondence M
  Inputs
    M:Matrix
  Outputs
    :Sequence
  Description
    Text
      The {\em Robinson-Schensted-Knuth (RSK) correspondence} is a bijection 
      between matrices with non-negative integer entries and pairs of semi-standard 
      Young tableaux. For a permutation $M$ with corresponding tableaux $(P,Q)$, 
      the tableau $P$ is called the {\em insertion tableau} and $Q$ is called the 
      {\em recording tableau}.

      If $R_i$ denotes the sum of the $i$-th row of $M$, then $P$ has shape 
      $\lambda = (R_1, R_2, \ldots, R_k)$. Similarly, if $C_i$ denotes the sum
      of the $i$-th column of $M$, then $Q$ has shape $\mu = (C_1, C_2, \ldots, C_k)$.
    Example
      M = matrix {{1,0,2},{0,2,0},{1,1,0}}
      RSKCorrespondence M
    Text
      Given the tableau $P$ of shape $\lambda$ and the tableau $Q$ of shape $\mu$,
      the inverse image takes the pair $(P,Q)$ to the corresponding
      $\vert \lambda \vert \times \vert \mu \vert$ matrix $M$ whose entries are
      non-negative integers.
    Example 
      P = youngTableau {{1,1,2,2},
                        {2,3},
                        {3}}
      Q = youngTableau {{1,1,1,3},
                        {2,2},
                        {3}}
      RSKCorrespondence(P, Q)
    Text
      If the input to {\tt RSKCorrespondence} is a permutation, this method
      defaults to using the @TO robinsonSchenstedCorrespondence@ method.
      Similarly, if the input pair of matrices are both standard Young tableaux,
      then this method defaults to using the @TO robinsonSchenstedCorrespondence@ 
      method.
  Caveat
    This is only a correspondence between matrices with non-negative integer 
    entries and pairs of semi-standard Young tableaux.
  SeeAlso
    rowInsertion
    biword
    robinsonSchenstedCorrespondence
///

doc ///
  Key
    yamanouchiWord
    (yamanouchiWord, YoungTableau)
  Headline
    computes the Yamanouchi word associated to a standard Young tableau
  Usage
    yamanouchiWord lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :List
  Description
    Text
      The {\em Yamanouchi word} associated to a standard Young tableau is an 
      ordered list $w$ such that $w_i = j$ if $i$ appears in row $j$ of the
      tableau.
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      yamanouchiWord lambda
  Caveat
    In this package, the Yamanouchi word is only defined for standard Young 
    tableaux.
  SeeAlso
    companionMap
///

doc ///
  Key
    companionMap
    (companionMap, YoungTableau)
    (companionMap, List)
  Headline
    computes the image of a standard Young tableau under the companion map
  Usage
    yamanouchiWord lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :List
  Description
    Text
      The {\em companion map} is a bijection between standard Young tableaux
      of shape $\lambda$ and Yamanouchi words of weight $\lambda$. The image 
      of a standard Young tableau under the companion map is the ordered list
      $w$ such that $w_i = j$ if $i$ appears in row $j$ of the tableau.
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      companionMap lambda
    Text
      The image of a Yamanouchi word $w$ under the companion map is the standard
      Young tableau $\lambda$ where the $i$-th row of $\lambda$ has fillings
      $j_1 <= j_2 <= \ldots <= j_k$ where $w_{j_l} = i$.
    Example
      w = {1,1,1,1,2,2,2,3}
      companionMap w
  SeeAlso
    yamanouchiWord
///

doc ///
  Key
    (content, YoungTableau)
    (content, YoungTableau, Sequence)
    (content, YoungTableau, ZZ, ZZ)
  Headline
    computes the content of a Young tableau
  Usage
    content lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :List
  Description
    Text
      The {\em content} of a cell $(i,j)$ of a Young tableau is the filling of
      that cell. The {\em content} of a Young tableau is a multiset whose elements 
      of the contents of the cells of the tableau.
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      content lambda
///

doc ///
  Key
    weight
    (weight, YoungTableau)
  Headline
    computes the weight of a Young tableau
  Usage
    weight lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :List
  Description
    Text
      If $\lambda$ is a Young taleau with its content taking values in $[n]$, 
      then the {\em weight} of $\lambda$ is the ordered list $w$ of lenght $n$
      where $w_i$ is the number of times $i$ appears in $lambda$.
    Example
      lambda = highestWeightFilling youngDiagram {4,3,1}
      weight lambda
  SeeAlso
    (content, YoungTableau)
///

doc ///
  Key
    (sign, YoungTableau)
  Headline
    computes the sign of a Young tableau
  Usage
    sign T
  Inputs
    T:YoungTableau
  Outputs
    :ZZ
  Description
    Text
      For a standard Young tableau $T$, its reading word $w$ is a permutation. The
      sign of $T$, denoted $\text{sign}(T)$, is defined as
      $\text{sign}(T) = (-1)^{\text{inv}(w)}$, where $\text{inv}(w)$ is the number 
      of inversions.
    Example
      T = youngTableau {{1,2,3},{4,5}}
      sign T
  References
    @UL {
          LI{ "[R04] Astrid Reifegerste, ",
              HREF("https://link.springer.com/article/10.1007/s00026-004-0208-4", EM "Permutation sign under the Robinson-Schensted-Knuth correspondence"),
              ", Ann. Comb. 8 (2004), no. 1, 103–112."}
    }@
  SeeAlso
    isStandard
    readingWord
    inversions
///

doc ///
  Key
    (descents, YoungTableau)
  Headline
    computes the descents of a Young tableau
  Usage
    descents lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :Set
  Description
    Text
      The descent set of a Young tableau is the set  of integers $k$ such that 
      $k+1$ appears in a row strictly below $k$. The elements of the descent set
      are called {\em descents}.
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      descents lambda
  SeeAlso
    majorIndex
///

doc ///
  Key
    majorIndex
    (majorIndex, YoungTableau)
  Headline
    computes the major Index of a Young tableau
  Usage
    majorIndex lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :ZZ
  Description
    Text
      The {\em major index} of a Young tableau is the sum of the descents of the 
      tableau.
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      majorIndex lambda
  SeeAlso
    (descents, YoungTableau)
///

doc ///
  Key
    readingWord
    (readingWord, YoungTableau)
  Headline
    computes the reading word of a Young tableau
  Usage
    readingWord lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :List
  Description
    Text
      The {\em reading word} of a Young tableau is the list of integers obtained 
      by reading the tableau from left to right, bottom to top (in English notation).
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      readingWord lambda
///

doc ///
  Key
    rowStabilizers
    (rowStabilizers, YoungTableau)
    columnStabilizers
    (columnStabilizers, YoungTableau)
  Headline
    computes the permutations which fixes the rows (or columns) of a Young tableau
  Usage
    rowStabilizers lambda
  Inputs
    lambda:YoungTableau
  Outputs
    :List
  Description
    Text
      A row (or column) is preserved by a permutation if and only if the 
      permutation only permutes the fillings present in that row (or column).
    Example
      lambda = canonicalFilling youngDiagram {4,3,1}
      rowStabilizers lambda
///

doc ///
  Key
    highestWeightFilling
    (highestWeightFilling, YoungDiagram)
  Headline
    constructs a Young tableau by filling the cells according to their rows
  Usage
    highestWeightFilling lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :YoungTableau
  Description
    Text
      If $\lambda$ is a Young diagram representing a parition of $n$, then the
      {\em highest weight filling} of $\lambda$ is the Young tableau obtained by
      filling the cells of $\lambda$ with the index of the row the cell is in;
      i.e., cell $(i,j)$ is filled with $i$.
    Example
      lambda = youngDiagram {4,3,1}
      highestWeightFilling lambda
  SeeAlso
    canonicalFilling
    rowsFirstFilling
    columnsFirstFilling
    randomFilling
///

doc ///
  Key
    canonicalFilling
    (canonicalFilling, YoungDiagram)
    rowsFirstFilling
    (rowsFirstFilling, YoungDiagram)
    columnsFirstFilling
    (columnsFirstFilling, YoungDiagram)
  Headline
    constructs a Young tableau by filling the cells with $1,2,\ldots,n$
  Usage
    canonicalFilling lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :YoungTableau
  Description
    Text
      If $\lambda$ is a Young diagram representing a parition of $n$, then the
      {\em canonical filling} of $\lambda$ is the Young tableau obtained by
      filling the cells of $\lambda$ with the integers $1,2,\ldots,n$ from
      left to right, top to bottom (in English notation). This filling can be 
      obtained by either the {\tt canonicalFilling} or {\tt rowsFirstFilling}
      methods.
    Example
      lambda = youngDiagram {4,3,1}
      canonicalFilling lambda
    Text
      The {\tt columnsFirstFilling} method does the same thing as the 
      {\tt canonicalFilling} method, but fills the cells from top to bottom,
      left to right (in English notation).
    Example
      lambda = youngDiagram {4,3,1}
      columnsFirstFilling lambda
  SeeAlso
    highestWeightFilling
    randomFilling
///

doc ///
  Key
    randomFilling
    (randomFilling, YoungDiagram)
  Headline
    constructs a Young tableau with a random filling
  Usage
    randomFilling lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :YoungTableau
  Description
    Text
      Regarding a Young diagram $\lambda$ as a partition of $n$, the 
      {\tt randomFilling} method constructs a Young tableau by filling the cells 
      of $\lambda$ with the integers $1,2,\ldots,n$ in a random order.
    Example
      lambda = youngDiagram {4,3,1}
      randomFilling lambda
  Caveat
    The resulting tableau is not guaranteed to be standard (nor semi-standard).
  SeeAlso
    canonicalFilling
    rowsFirstFilling
    columnsFirstFilling
    highestWeightFilling
///
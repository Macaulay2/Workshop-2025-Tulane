doc /// 
  Key
    "YoungTableaux"
  Headline
    a package which implements Young diagrams and tableaux
  Description
    Text
      This package defines the @TO YoungDiagram@ and @TO YoungTableau@ types. 
      An overview of the package's can be found in the @TO "All Things Young Guide"@.
///

doc ///
  Key
    "All Things Young Guide"
  Headline
    a detailed overview of Young diagrams and tableaux in Macaulay2
  Description
    Text
      This page gives an overview of the use of Young diagrams and tableaux.

      The sections of the overview are, in order:

      {\bf Young diagrams.} @BR{}@
      {\bf Young tableaux.} @BR{}@
      {\bf Miscellaneous.} @BR{}@

      Links to individual documentation pages for the functions 
      described in this article are collected in an alphabetized list 
      at the very end of the page.


      {\bf Young diagrams.}

      Young diagrams are constructed from lists. To create a {\bf Young diagram}, 
      use the {\tt youngDiagram} method:
    Example
      lambda = youngDiagram {5,4,1}
    Text
      Young diagrams must be constructed from lists consisting of only non-increasing positive integers. 
      If a list contains any other elements or does not consist of the entire range, then an error is thrown.

    --
    Text

     {\bf Young tableaux.}

      Young tableaux correspond to Young diagrams with boxes filled in.
      In {\tt Macaulay2}, this implemented as a list of lists of integers.
      To create a {\bf Young tableau}, use the {\tt youngTableau} method:
    Example
      lambda = youngTableau {{1,2,4,7,8},{3,5,6,9},{10}};

    --
    Text

      {\bf Miscellaneous.}

      We can compute the {\em conjugate} (or {\em transpose} of a Young diagram/tableau.
      This corresponds to reading the diagram/tableau along the columns instead of the rows.
    Example
      lambda = youngDiagram {5,4,1};
      conjugate lambda
  SeeAlso
    (conjugate, YoungDiagram)
///

doc ///
  Key
    YoungDiagram
    youngDiagram
    (youngDiagram, VisibleList)
  Headline
    the youngDiagram type
  Description
    Text
      Young diagrams are constructed from lists. To create a {\bf Young diagram}, 
      use the {\tt youngDiagram} method:
    Example
      lambda = youngDiagram {5,4,1}
    Text
      Young diagrams must be constructed from lists consisting of only non-increasing positive integers. 
      If a list contains any other elements or does not consist of the entire range, then an error is thrown.
///

doc ///
  Key
    shape
    (shape, YoungDiagram)
  Headline
    computes shape of a Young diagram (or tableau)
  Usage
    shape lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :List
  Description
    Text
      The shape of a Young diagram is an ordered list of the lengths of its rows.
    Example
      lambda = youngDiagram {4,3,1}
      shape lambda
    Text
      The shape of a tableau is the shape of its underlying diagram.
  SeeAlso
    (shape, SkewDiagram)
///

doc ///
  Key
    conjugate
    (conjugate, YoungDiagram)
    transpose
    (transpose, YoungDiagram)
  Headline
    computes the conjugate (or transpose) of a Young diagram
  Usage
    conjugate lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :YoungDiagram
  Description
    Text
      Computes the {\em conjugate} (or {\em transpose}) of a Young diagram.
      The conjugate is obtained by reading the diagram along the columns instead of the rows.

    Example
      lambda = youngDiagram {5,4,1}
      conjugate lambda
///

doc ///
  Key
    armLength
    (armLength, YoungDiagram, ZZ, ZZ)
    (armLength, YoungDiagram, Sequence)
  Headline
    computes the arm length the box at $(i,j)$ of a Young diagram
  Usage
    armLength(lambda, i, j)
  Inputs
    lambda:YoungDiagram
    i:ZZ
    j:ZZ
  Outputs
    :ZZ
  Description
    Text
      The {\em arm length} of the box at $(i,j)$ of a Young diagram is defined
      as the number of boxes to the right of it.
    Example
      lambda = youngDiagram {4,3,1}
      armLength(lambda, 1, 2)
  SeeAlso
    legLength
    hookLength
///

doc ///
  Key
    legLength
    (legLength, YoungDiagram, ZZ, ZZ)
    (legLength, YoungDiagram, Sequence)
  Headline
    computes the leg length the box at $(i,j)$ of a Young diagram
  Usage
    legLength(lambda, i, j)
  Inputs
    lambda:YoungDiagram
    i:ZZ
    j:ZZ
  Outputs
    :ZZ
  Description
    Text
      The {\em leg length} of the box at $(i,j)$ of a Young diagram is defined
      as the number of boxes to below it.
    Example
      lambda = youngDiagram {4,3,1}
      legLength(lambda, 1, 2)
  SeeAlso
    armLength
    hookLength
///

doc ///
  Key
    hookLength
    (hookLength, YoungDiagram, ZZ, ZZ)
    (hookLength, YoungDiagram, Sequence)
  Headline
    computes the hook length the box at (i,j) of a Young diagram
  Usage
    hookLength(lambda, i, j)
  Inputs
    lambda:YoungDiagram
    i:ZZ
    j:ZZ
  Outputs
    :ZZ
  Description
    Text
      The {\em hook length} of the box at $(i,j)$ is the number of boxes to 
      the right and below it, plus one for the box itself. Alternatively, it 
      is the sum of the arm length and leg length of the box, plus one.
    Example
      lambda = youngDiagram {4,3,1}
      hookLength(lambda, 1, 2)
  SeeAlso
    armLength
    legLength
///

doc ///
  Key
    (content, YoungDiagram, Sequence)
    (content, YoungDiagram, ZZ, ZZ)
  Headline
    computes the content of a Young diagram
  Usage
    content lambda
  Inputs
    lambda:YoungDiagram
    coords:Sequence
  Outputs
    :ZZ
  Description
    Text
      The {\em content} of a cell $(i,j)$ of a Young diagram is $j-i$.
    Example
      lambda = youngDiagram {4,3,1}
      content(lambda, (1,2))
  SeeAlso
    (content, YoungTableau)
///



doc ///
  Key
    SkewDiagram
    skewDiagram
    (skewDiagram, List, List)
    (skewDiagram, YoungDiagram, YoungDiagram)
  Headline
    constructs the skew diagram defined by two Young diagrams
  Usage
    skewDiagram(lambda, mu)
  Inputs
    lambda:List
    mu:List
  Outputs
    :ZZ
  Description
    Text
      If $\lambda$ and $\mu$ are two Young diagrams, then the skew diagram, 
      denoted $\lambda/\mu$, is a diagram obtained by removing the boxes of 
      $\mu$ from $\lambda$.
    Example
      lambda = youngDiagram {4,3,1}
      mu = youngDiagram {2,1}
      skewDiagram(lambda, mu)
  SeeAlso
    youngDiagram
///

doc ///
  Key
    (shape, SkewDiagram)
  Headline
    computes shape of a skew diagram
  Usage
    shape lambda
  Inputs
    :SkewDiagram
  Outputs
    :Sequence
  Description
    Text
      The shape of a skew diagram $(\lambda, \mu)$, denoted by $\lambda/\mu$,
      is the ordered pair of the shapes of $\lambda$ and $\mu$, respectively.
    Example
      lambda = youngDiagram {4,3,1}
      mu = youngDiagram {2,1}
      rho = skewDiagram(lambda, mu)
      shape rho
  SeeAlso
    shape
    (shape, YoungDiagram)
///



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
    numberStandardYoungTableaux
    (numberStandardYoungTableaux, YoungDiagram)
    (numberStandardYoungTableaux, List)
  Headline
    computes the number of standard Young tableaux of a given shape
  Usage
    numberStandardYoungTableaux diagramShape
  Inputs
    diagramShape:List
  Outputs
    :ZZ
  Description
    Text
      Given a Young diagram $\lambda$, the number of standard Young tableaux of
      shape $\lambda$ (denoted $f^\lambda$) can be computed with the hook-length 
      formula. Regarding $\lambda$ as a partition of $n$ (so that $n = \sum_i \lambda_i$),
      and letting $h_{\lambda}(i,j)$ be the hook length of the box at $(i,j)$, 
      we have
      $$f^\lambda = \frac{n!}{\prod_{(i,j) \in \lambda} h_{\lambda}(i,j)}$$
      where the product is taken over all the boxes of $\lambda$.
    Example
      lambda = youngDiagram {4,3,1}
      numberStandardYoungTableaux lambda
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
doc ///
  Key
    YoungDiagram
    youngDiagram
    (youngDiagram, VisibleList)
    (youngDiagram, HashTable)
  Headline
    the youngDiagram type
  Description
    Text
      Young diagrams are constructed from lists. To create a {\bf Young diagram}, 
      use the {\tt youngDiagram} method.
    Example
      lambda = youngDiagram {5,4,1}
    Text
      Young diagrams can also be constructed from hash tables where the keys are
      the coordinates of the cells in the diagram. Since Young diagrams are just
      boxes, the values of the hash table are forgotten and replaced with whitespace.
    Example
      lambda = youngTableau {{1,2,3},{4,5}}
      youngDiagram lambda
  Caveat
    Young diagrams must be constructed from lists consisting of only non-increasing positive integers. 
    If a list contains any other elements or does not consist of the entire range, then an error is thrown.
///

doc ///
  Key
    (toString, YoungDiagram)
    (toExternalString, YoungDiagram)
  Headline
    produces a string representation of a Young diagram
  Usage
    toString lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :String
  Description
    Text
      The string representation encodes a Young diagram by its shape.
    Example
      lambda = youngDiagram {4,3,1}
      toString lambda
  SeeAlso
    (net, YoungDiagram)
///

doc ///
  Key
    (net, YoungDiagram)
  Headline
    display a Young diagram
  Usage
    net lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :Net
  Description
    Text
      The net of a Young diagram is a graphical representation of the diagram
      as boxes in a grid.
    Example
      lambda = youngDiagram {4,3,1}
      net lambda
    Text
      The net of a Young tableau is the net of its underlying diagram with the
      boxes filled in according to the content of the tableau.
    Example
      lambda = youngTableau {{1,2,3},{4,5},{6}}
      net lambda
///

doc ///
  Key
    (symbol _, YoungDiagram, ZZ)
  Headline
    selects the $n$-th row of a Young diagram
  Usage
    lambda_n
  Inputs
    lambda:YoungDiagram
    n:ZZ
  Outputs
    :YoungDiagram
  Description
    Text
      Returns the $n$-th row of a Young diagram.
    Example
      lambda = youngDiagram {4,3,1}
      lambda_2
  Caveat
    To be consistent with the rest of the package, the first row is indexed by 1.
  SeeAlso
    (symbol _, YoungDiagram, List)
    (symbol _, YoungDiagram, Sequence)
///

doc ///
  Key
    (symbol _, YoungDiagram, List)
    (symbol _, YoungDiagram, Sequence)
  Headline
    selects a subset of rows of a Young diagram
  Usage
    lambda_l
  Inputs
    lambda:YoungDiagram
    l:List
  Outputs
    :YoungDiagram
  Description
    Text
      Returns the subset of rows indexed by the given list.
    Example
      lambda = youngDiagram {4,3,1}
      lambda_{1,3}
  Caveat
    To be consistent with the rest of the package, the first row is indexed by 1.
  SeeAlso
    (symbol _, YoungDiagram, ZZ)
///

doc ///
  Key
    (symbol ^, YoungDiagram, ZZ)
  Headline
    selects the $n$-th column of a Young diagram
  Usage
    lambda_n
  Inputs
    lambda:YoungDiagram
    n:ZZ
  Outputs
    :YoungDiagram
  Description
    Text
      Returns the $n$-th column of a Young diagram.
    Example
      lambda = youngDiagram {4,3,1}
      lambda^1
  Caveat
    To be consistent with the rest of the package, the first column is indexed by 1.
  SeeAlso
    (symbol ^, YoungDiagram, List)
    (symbol ^, YoungDiagram, Sequence)
///

doc ///
  Key
    (symbol ^, YoungDiagram, List)
    (symbol ^, YoungDiagram, Sequence)
  Headline
    selects a subset of rows of a Young diagram
  Usage
    lambda^l
  Inputs
    lambda:YoungDiagram
    l:List
  Outputs
    :YoungDiagram
  Description
    Text
      Returns the subset of rows indexed by the given list.
    Example
      lambda = youngDiagram {4,3,1}
      lambda^{1,4}
  Caveat
    To be consistent with the rest of the package, the first row is indexed by 1.
  SeeAlso
    (symbol ^, YoungDiagram, ZZ)
///


doc ///
  Key
    (numRows, YoungDiagram)
  Headline
    computes the number of rows in a Young diagram
  Usage
    numRows lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :ZZ
  Description
    Example
      lambda = youngDiagram {4,3,1}
      numRows lambda
  SeeAlso
    (numColumns, YoungDiagram)
    shape
///

doc ///
  Key
    (numColumns, YoungDiagram)
  Headline
    computes the number of columns in a Young diagram
  Usage
    numColumns lambda
  Inputs
    lambda:YoungDiagram
  Outputs
    :ZZ
  Description
    Example
      lambda = youngDiagram {4,3,1}
      numColumns lambda
  SeeAlso
    (numRows, YoungDiagram)
    shape
///

doc ///
  Key
    (symbol ==, YoungDiagram, YoungDiagram)
  Headline
    whether two Young diagrams are equal
  Usage
    lambda == mu
  Inputs
    lambda:YoungDiagram
    mu:YoungDiagram
  Outputs
    :Boolean
  Description
    Text
      Since Young diagrams are implemented as hash tables, two Young diagrams
      are considered equal if they have the same set of keys.
    Example
      lambda = youngDiagram {4,3,1}
      mu = youngDiagram {3,2,1}
      lambda == mu
    Text
      This implementation means that if two Young diagrams are shifted versions
      of each other, they are not considered equal.
    Example
      lambda = youngDiagram hashTable {(1,1) => " ", (1,2) => " ",
                                       (2,1) => " "}
      -- mu is lambda shifted to the right by one.
      mu = youngDiagram hashTable {(1,2) => " ", (1,3) => " ",
                                   (2,2) => " "}
      lambda == mu
  SeeAlso
    (symbol ==, YoungTableau, YoungTableau)
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
    (conjugate, YoungTableau)
    transpose
    (transpose, YoungDiagram)
    (transpose, YoungTableau)
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
    (toString, SkewDiagram)
    (toExternalString, SkewDiagram)
  Headline
    produces a string representation of a skew diagram
  Usage
    toString lambda
    toExternalString lambda
  Inputs
    lambda:SkewDiagram
  Outputs
    :String
  Description
    Text
      The string representation encodes a skew diagram by its shape.
    Example
      lambda = youngDiagram {4,3,1}
      mu = youngDiagram {2,1}
      rho = skewDiagram(lambda, mu)
      toString rho
  SeeAlso
    (net, YoungDiagram)
///
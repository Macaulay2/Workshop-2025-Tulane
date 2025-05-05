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
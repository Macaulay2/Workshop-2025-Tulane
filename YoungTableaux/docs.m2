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

-- YoungDiagram
-- (youngDiagram, VisibleList)
doc ///
  Key
    YoungDiagram
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

-- (conjugate, YoungDiagram)
-- (transpose, YoungDiagram)
doc ///
  Key
    (conjugate, YoungDiagram)
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
      Computes the conjugate (or transpose) of a Young diagram.
      The conjugate is obtained by reading the diagram along the columns instead of the rows.

    Example
      lambda = youngDiagram {5,4,1}
      conjugate lambda
///


-- (armLength, YoungDiagram, ZZ, ZZ)
doc ///
  Key
    (armLength, YoungDiagram, ZZ, ZZ)
  Headline
    computes the arm length the box at (i,j) of a Young diagram
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
      SOME FILLER TEXT.

    Example
      lambda = youngDiagram {4,3,1}
      armLength(lambda, 1, 2)
  SeeAlso
    (legLength, YoungDiagram, ZZ, ZZ)
    (hookLength, YoungDiagram, ZZ, ZZ)
///

-- (legLength, YoungDiagram, ZZ, ZZ)
doc ///
  Key
    (legLength, YoungDiagram, ZZ, ZZ)
  Headline
    computes the leg length the box at (i,j) of a Young diagram
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
      SOME FILLER TEXT.

    Example
      lambda = youngDiagram {4,3,1}
      legLength(lambda, 1, 2)
  SeeAlso
    (armLength, YoungDiagram, ZZ, ZZ)
    (hookLength, YoungDiagram, ZZ, ZZ)
///

-- (hookLength, YoungDiagram, ZZ, ZZ)
doc ///
  Key
    (hookLength, YoungDiagram, ZZ, ZZ)
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
      SOME FILLER TEXT.

    Example
      lambda = youngDiagram {4,3,1}
      hookLength(lambda, 1, 2)
  SeeAlso
    (armLength, YoungDiagram, ZZ, ZZ)
    (legLength, YoungDiagram, ZZ, ZZ)
///

doc ///
  Key
    numberStandardYoungTableaux
    (numberStandardYoungTableaux, YoungDiagram)
    (numberStandardYoungTableaux, List)
  Headline
    computes the number of standard Young tableaux of a given shape
  Usage
    numberStandardYoungTableaux lambda
  Inputs
    lambda:YoungDiagram
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
      lambda = youngDiagram {3,2,1}
      numberStandardYoungTableaux lambda
  SeeAlso
    isStandard
    filledSYT
///

doc ///
  Key
    filledSYT
    (filledSYT, List)
  Headline
    produces a list of all standard Young tableaux of a given shape
  Usage
    filledSYT shape
  Inputs
    shape:List
  Outputs
    :List
  Description
    Text
      Given a list representing the shape of a Young diagram, this method 
      produces a list of all standard Young tableaux (with content $1 \ldots n$)
      of that shape.
    Example
      filledSYT {3,2,1}
  SeeAlso
    numberStandardYoungTableaux
    filledSemiSYT
///

doc ///
  Key
    filledSemiSYT
    (filledSemiSYT, List, List)
  Headline
    produces a list of all semi-standard Young tableaux of a given shape with given content
  Usage
    filledSYT(shape, nums)
  Inputs
    shape:List
    nums:List
  Outputs
    :List
  Description
    Text
      Given a list representing the shape of a Young diagram and the allowable 
      content for filling cells, this method produces a list of all semi-standard 
      Young tableaux with that shape and content.
    Example
      filledSemiSYT({3,2,1}, {1,1,2,2,3,3})
    Text
      When the elements of the list of allowable content are unique and take 
      values $1 \ldots n$, this method produces a list of all standard Young tableaux.
    Example
      filledSemiSYT({3,2,1}, {1,2,3,4,5,6})
  SeeAlso
    filledSYT
///
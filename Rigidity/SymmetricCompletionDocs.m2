doc ///
    Key
        getSymmetricCompletionMatrix
	    (getSymmetricCompletionMatrix, ZZ, Graph)
        (getSymmetricCompletionMatrix, ZZ, ZZ, List)
        (getSymmetricCompletionMatrix, ZZ, ZZ)
    Headline
        Constructs the symmetric completion matrix for given parameters.
    Usage
        getSymmetricCompletionMatrix(r, G)
        getSymmetricCompletionMatrix(r, n, L)
        getSymmetricCompletionMatrix(r, n)
    Inputs
        r : ZZ
            corresponding to the rank
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices
        Variable => Thing
            symbol to use for the ring variables; defaults to a generated symbol
    Description
    	Text
            Given rank r and graph G, constructs the symmetric completion matrix.
            The matrix is the Jacobian of the edge polynomials of G, where the polynomial
            for each edge (i,j) is the (i,j) entry of A^T*A for a generic r by n matrix A.
            If the graph or edge set is not specified, defaults to the complete graph.
        Example
            r=2;
            G = completeGraph 4;
            getSymmetricCompletionMatrix(r, G)
            r=2; n=3;
            L= {{0,1},{1,2},{2,0}}
            getSymmetricCompletionMatrix(r, n, L)
///

doc ///
    Key
        isSpanningInSymmetricCompletionMatroid
        (isSpanningInSymmetricCompletionMatroid, ZZ, Graph)
        (isSpanningInSymmetricCompletionMatroid, ZZ, ZZ, List)
        (isSpanningInSymmetricCompletionMatroid, ZZ, ZZ)
        (isSpanningInSymmetricCompletionMatroid, ZZ, ZZ, Graph)
    Headline
        Tests whether a graph is spanning in the symmetric completion matroid.
    Usage
        isSpanningInSymmetricCompletionMatroid(r, G)
        isSpanningInSymmetricCompletionMatroid(r, n, L)
        isSpanningInSymmetricCompletionMatroid(r, n)
        isSpanningInSymmetricCompletionMatroid(r, n, G)
    Inputs
        r : ZZ
            corresponding to the rank
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices
        Numerical => Boolean
            if true, evaluates at random rational values to compute rank numerically; defaults to false
        FiniteField => ZZ
            if nonzero, evaluates at random elements of GF(q) to compute rank; defaults to 0
    Description
    	Text
            Tests whether a graph or edge set spans the symmetric completion matroid.
            Equivalently, checks whether the symmetric completion matrix has full rank r*n - r*(r-1)/2.
            If the graph or edge set is not specified, defaults to the complete graph.
        Example
            G = completeMultipartiteGraph({3,3})
            isSpanningInSymmetricCompletionMatroid(2, G)
            G = completeGraph 4
            isSpanningInSymmetricCompletionMatroid(4, G)
            L= {{0,1},{1,2},{2,0}}
            r=4; n=3
            isSpanningInSymmetricCompletionMatroid(r, n, L)
///

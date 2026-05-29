doc ///
    Key
        getSkewSymmetricCompletionMatrix
	    (getSkewSymmetricCompletionMatrix, ZZ, Graph)
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ, List)
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ)
    Headline
        Constructs the skew-symmetric completion matrix for given parameters.
    Usage
        getSkewSymmetricCompletionMatrix(r, G)
        getSkewSymmetricCompletionMatrix(r, n, L)
        getSkewSymmetricCompletionMatrix(r, n)
    Inputs
        r : ZZ
            an even integer corresponding to the rank
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices
    Outputs
        : Matrix
            the skew-symmetric completion matrix
    Description
    	Text
            Given an even rank r and graph G, constructs the skew-symmetric completion matrix.
            The matrix is the Jacobian of the edge polynomials of G, where the polynomial
            for each edge (i,j) is the (i,j) entry of A^T*J*A for a generic r by n matrix A
            and the r by r skew matrix J = {{0, I}, {-I, 0}}.
            An error is thrown if r is not even.
            If the graph or edge set is not specified, defaults to the complete graph.
        Example
            r=2;
            G = completeGraph 4;
            getSkewSymmetricCompletionMatrix(r, G)
            r=2; n=3;
            L= {{0,1},{1,2},{2,0}}
            getSkewSymmetricCompletionMatrix(r, n, L)
///

doc ///
    Key
        isSpanningInSkewSymmetricCompletionMatroid
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, Graph)
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, ZZ, List)
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, ZZ)
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, ZZ, Graph)
        [isSpanningInSkewSymmetricCompletionMatroid, Numerical]
        [isSpanningInSkewSymmetricCompletionMatroid, FiniteField]
    Headline
        Tests whether a graph is spanning in the skew-symmetric completion matroid.
    Usage
        isSpanningInSkewSymmetricCompletionMatroid(r, G)
        isSpanningInSkewSymmetricCompletionMatroid(r, n, L)
        isSpanningInSkewSymmetricCompletionMatroid(r, n)
        isSpanningInSkewSymmetricCompletionMatroid(r, n, G)
    Inputs
        r : ZZ
            an even integer corresponding to the rank
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices
        Numerical => Boolean
            if true, evaluates at random rational values to compute rank numerically; defaults to false
        FiniteField => ZZ
            if nonzero, evaluates at random elements of GF(q) to compute rank; defaults to 0
    Outputs
        : Boolean
            true if the graph spans the skew-symmetric completion matroid
    Description
    	Text
            Tests whether a graph or edge set spans the skew-symmetric completion matroid.
            Equivalently, checks whether the skew-symmetric completion matrix has full rank r*n - r*(r+1)/2.
            When n-1 < r, spanning is equivalent to the graph being the complete graph on n vertices.
            If the graph or edge set is not specified, defaults to the complete graph.
        Example
            G = completeMultipartiteGraph({3,3})
            isSpanningInSkewSymmetricCompletionMatroid(2, G)
            G = completeGraph 4
            isSpanningInSkewSymmetricCompletionMatroid(4, G)
            L= {{0,1},{1,2},{2,0}}
            r=4; n=3
            isSpanningInSkewSymmetricCompletionMatroid(r, n, L)
///

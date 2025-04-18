doc ///
    Key
        getSkewSymmetricCompletionMatrix
	(getSkewSymmetricCompletionMatrix, ZZ, Graph)
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ, List)
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ)
    Headline
        Constructs the skew-symmetric completion matrix for given parameters.
    Usage
        getSkewSymmetricCompletionMatrix(d, G)
        getRigidityMatrix(d, n, L)
        getRigidityMatrix(d, n)
    Inputs
        d : ZZ
            corresponding to the dimension of the embedding space
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices 
    Description
    	Text
            Given rank r and graph G it constructs the completion matrix for G.
        Example
            d=2;
            G = completeGraph 4;
            getSkewSymmetricCompletionMatrix(d, G)
            d=2; n=3;
            L= {{0,1},{1,2},{2,0}}
            getSkewSymmetricCompletionMatrix(d, n, L}
///

doc ///
    Key
        isSpanningInSkewSymmetricCompletionMatroid
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, ZZ, Graph)
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, Graph)
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, ZZ, List)
        (isSpanningInSkewSymmetricCompletionMatroid, ZZ, ZZ)
    Headline
        Tests whether a graph is spanning in the skew-symmetric completion matroid.
    Usage
        isSpanningInSkewSymmetricCompletionMatroid(d, n, G)
        isSpanningInSkewSymmetricCompletionMatroid(d, G)
        isSpanningInSkewSymmetricCompletionMatroid(d, n, L)
    Inputs
        d : ZZ
            corresponding to the dimension of the embedding space
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices
    Description
    	Text
            Tests whether a graph or edge set is spanning the skew-symmetric completion matroid.
            Given an even integer r for rank and number of vertices n of graph, it returns whether the complete graph on n vertices is spanning.
        Example
            G = completeMultipartiteGraph({3,3})
            isSpanningInSkewSymmetricCompletionMatroid(2, G)
            G = completeGraph 4
            isSpanningInSkewSymmetricCompletionMatroid(4, G)
            L= {{0,1},{1,2},{2,0}}
            d=4, n=3
            isSpanningInSkewSymmetricCompletionMatroid(4, 3, G)
///


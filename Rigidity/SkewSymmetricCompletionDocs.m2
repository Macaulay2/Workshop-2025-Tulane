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
            corresponding to the rank
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices 
    Description
    	Text
            Given rank r and graph G it constructs the completion matrix for G.
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
    Headline
        Tests whether a graph is spanning in the skew-symmetric completion matroid.
    Usage
        isSpanningInSkewSymmetricCompletionMatroid(r, G)
        isSpanningInSkewSymmetricCompletionMatroid(r, n, L)
        isSpanningInSkewSymmetricCompletionMatroid(r, n)
    Inputs
        r : ZZ
            corresponding to the rank
        G : Graph
        L : List
            of pairs of adjacent vertices
    Description
    	Text
            Tests whether a graph or edge set is spanning the skew-symmetric completion matroid.
            Given an even integer r for rank and number of vertices n of graph, it returns whether the graph is spanning.
            If the graph or edge set is not specified, defaults to the complete graph.
        Example
            G = completeMultipartiteGraph({3,3})
            isSpanningInSkewSymmetricCompletionMatroid(2, G)
            G = completeGraph 4
            isSpanningInSkewSymmetricCompletionMatroid(4, G)
            L= {{0,1},{1,2},{2,0}}
            r=4, n=3
            isSpanningInSkewSymmetricCompletionMatroid(r, n, L)
///


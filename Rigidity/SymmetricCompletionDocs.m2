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
    Description
    	Text
            Given rank r and graph G it constructs the completion matrix for G.
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
    Headline
        Tests whether a graph is spanning in the symmetric completion matroid.
    Usage
        isSpanningInSymmetricCompletionMatroid(r, G)
        isSpanningInSymmetricCompletionMatroid(r, n, L)
        isSpanningInSymmetricCompletionMatroid(r, n)
    Inputs
        r : ZZ
            corresponding to the rank
        G : Graph
        L : List
            of pairs of adjacent vertices
    Description
    	Text
            Tests whether a graph or edge set is spanning the symmetric completion matroid.
            Given an even integer r for rank and number of vertices n of graph, it returns whether the graph is spanning.
            If the graph or edge set is not specified, defaults to the complete graph.
        Example
            G = completeMultipartiteGraph({3,3})
            isSpanningInSymmetricCompletionMatroid(2, G)
            G = completeGraph 4
            --isSpanningInSymmetricCompletionMatroid(4, G)
            L= {{0,1},{1,2},{2,0}}
            r=4, n=3
            isSpanningInSymmetricCompletionMatroid(r, n, L)
///


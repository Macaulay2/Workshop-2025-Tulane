doc ///
    Key
        getSkewSymmetricCompletionMatrix
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ, Graph)
        (getSkewSymmetricCompletionMatrix, ZZ, Graph)
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ, List)
        (getSkewSymmetricCompletionMatrix, ZZ, ZZ)
    Headline
        Constructs the Skew Symmetric Completion matrix of a d-framework
    Usage
        getSkewSymmetricCompletionMatrix(d, n, G)
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
            Computes the skew symmetric completionn matrix for a d-framework (i.e. a graph G with an embedding map in R^d).
            "The rigidity matrix is 1/2 times the Jacobian of the distance map evaluated at p, the choice of embedding map."
            
            If provided, expects the vertices of G to be 0 through n-1.
        Example
            d=2
            G = completeGraph 4;
            n=#G
            getSkewSymmetricCompletionMatrix(d, G)
            getSkewSymmetricCompletionMatrix(d, n, G)
            d=2 , n=3
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
        Returns a boolean indicating whether "??????"
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
            Tests for "???" by checking "??" matrix.
        Example
            G = completeMultipartiteGraph({3,3})
            isSpanningInSkewSymmetricCompletionMatroid(2, G)
            G = completeGraph 4
            isSpanningInSkewSymmetricCompletionMatroid(4, G)
            L= {{0,1},{1,2},{2,0}}
            d=4, n=3
            isSpanningInSkewSymmetricCompletionMatroid(4, 3, G)
///


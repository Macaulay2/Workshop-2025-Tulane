doc ///
    Key
        getStressMatrix
        (getStressMatrix, ZZ, ZZ, Graph)
        (getStressMatrix, ZZ, Graph)
        (getStressMatrix, ZZ, ZZ, List)
        (getStressMatrix, ZZ, ZZ)
    Headline
        Constructs the symbolic stress matrix of a d-framework
    Usage
        getStressMatrix(d, n, G)
        getStressMatrix(d, G)
        getStressMatrix(d, n, L)
        getStressMatrix(d, n)
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
            Computes the stress matrix for a d-framework.
            The stress matrix is the symmetric matrix consisting of the equilibrium stress of a d-framework.
            The diagonal elements are assigned such that all row sums and column sums are zero.
            
            If provided, expects the vertices of G to be 0 through n-1.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            getStressMatrix(d, n, L)
            getStressMatrix(d, n, subsets(toList(0..(n-1)), 2))
            G = completeGraph(n);
            getStressMatrix(d, n, G)
            getStressMatrix(d, G)
///

doc ///
    Key
        isGloballyRigid
        (isGloballyRigid, ZZ, ZZ, Graph)
        (isGloballyRigid, ZZ, Graph)
        (isGloballyRigid, ZZ, ZZ, List)
        (isGloballyRigid, ZZ, ZZ)
    Headline
        Returns a boolean indicating whether the given framework is globally rigid
    Usage
        isGloballyRigid(d, n, G)
        isGloballyRigid(d, G)
        isGloballyRigid(d, n, L)
        isGloballyRigid(d, n)
    Inputs
        d : ZZ
            corresponding to the dimension of the embedding space
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices 
        FiniteField => ZZ
            The field that computation is done in. 
            If not 1, takes random values from the corresponding field and computes the rank of the numerical matrix, and repeats this for a certain number of iterations. If 1, computes the rank of the matrix with symbols. Defaults to 1.
            0 - Real numbers
            1 - Symbolic computation (slow)
            Prime power q - Finite field F_q
        Iterations => ZZ
            Number of iterations when computing numerically.
            If the resulting booleans are equal for each iteration, returns the boolean. Otherwise, shows an error message. When computing symbolically, this option is ignored. Defaults to 3.
    Description
    	Text
            Tests for global rigidity by checking the rank of the stress matrix.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            isGloballyRigid(d, n, L)
            isGloballyRigid(d, n, subsets(toList(0..(n-1)), 2))
            G = completeGraph(n);
            isGloballyRigid(d, n, G)
            isGloballyRigid(d, G)
            isGloballyRigid(d, G, FiniteField => 0)
            isGloballyRigid(d, G, FiniteField => 19937)
            isGloballyRigid(d, G, FiniteField => 19937, Iterations => 10)
///
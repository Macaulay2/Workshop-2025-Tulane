doc ///
    Key
        getStressMatrix
        (getStressMatrix, ZZ, Graph)
        (getStressMatrix, ZZ, List)
        (getStressMatrix, ZZ, ZZ)
    Headline
        Constructs the symbolic stress matrix of a d-framework
    Usage
        getStressMatrix(d, L)
        getStressMatrix(d, G)
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
        Example
            (d,n) = (2,4)
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            getStressMatrix(d, L)
            getStressMatrix(d, n)
            G = completeGraph(n);
            getStressMatrix(d, G)
///

doc ///
    Key
        isGloballyRigid
        (isGloballyRigid, ZZ, Graph)
        (isGloballyRigid, ZZ, List)
        (isGloballyRigid, ZZ, ZZ)
        [isGloballyRigid, Field]
        [isGloballyRigid, Iterations]
    Headline
        Returns a boolean indicating whether the given framework is globally rigid
    Usage
        isGloballyRigid(d, L)
        isGloballyRigid(d, G)
        isGloballyRigid(d, n)
    Inputs
        d : ZZ
            corresponding to the dimension of the embedding space
        G : Graph
            a simple connected graph
        L : List
            of pairs of adjacent vertices of a simple connected graph
        n : ZZ
            corresponding to the number of vertices
        Field => Ring
            computes the rank of the rigidity matrix numerically over this field. Defaults to ZZ, which computes the rank symbolically.
        Iterations => ZZ
            runs the computation this many times and returns true if ever true; defaults to three
    Description
    	Text
            Tests for global rigidity by checking the rank of the stress matrix. If the finite field is too small, it may error as it attempts to divide by zero.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            isGloballyRigid(d, L)
            isGloballyRigid(d, n)
            G = completeGraph(n);
            isGloballyRigid(d, G)
            isGloballyRigid(d, G, Field => RR_100)
///
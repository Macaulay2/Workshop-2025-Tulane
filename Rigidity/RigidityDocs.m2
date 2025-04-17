doc ///
    Key
        getRigidityMatrix
        (getRigidityMatrix, ZZ, ZZ, Graph)
        (getRigidityMatrix, ZZ, Graph)
        (getRigidityMatrix, ZZ, ZZ, List)
        (getRigidityMatrix, ZZ, ZZ)
    Headline
        Constructs the rigidity matrix of a d-framework
    Usage
        getRigidityMatrix(d, n, G)
        getRigidityMatrix(d, G)
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
            Computes the rigidity matrix for a d-framework (i.e. a graph G with an embedding map in R^d).
            The rigidity matrix is 1/2 times the Jacobian of the distance map evaluated at p, the choice of embedding map.
            
            If provided, expects the vertices of G to be 0 through n-1.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            getRigidityMatrix(d, n, L)
            getRigidityMatrix(d, n, subsets(toList(0..(n-1)), 2))
            G = completeGraph(n);
            getRigidityMatrix(d, n, G)
            getRigidityMatrix(d, G)
///

doc ///
    Key
        isLocallyRigid
        (isLocallyRigid, ZZ, ZZ, Graph)
        (isLocallyRigid, ZZ, Graph)
        (isLocallyRigid, ZZ, ZZ, List)
        (isLocallyRigid, ZZ, ZZ)
    Headline
        Returns a boolean indicating whether the given framework is locally rigid
    Usage
        isLocallyRigid(d, n, G)
        isLocallyRigid(d, G)
        isLocallyRigid(d, n, L)
        isLocallyRigid(d, n)
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
            Tests for local rigidity by checking the rank of the rigidity matrix.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            isLocallyRigid(d, n, L)
            isLocallyRigid(d, n, subsets(toList(0..(n-1)), 2))
            G = completeGraph(n);
            isLocallyRigid(d, n, G)
            isLocallyRigid(d, G)
///

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
///

-*
-- Example documentation
doc ///
    Key
        toricLinearSeries
        (toricLinearSeries, List)
    Headline
        constructor for toric linear series
    Usage
        toricLinearSeries L
    Inputs
        L : List
            of monomials of the Cox ring    
    Description
    	Text
            Constructs a toric linear series from a list of monomials from the Cox ring of a toric variety.
            It checks that all monomials are of the same degree.
            It expects the monomials to be in ring(X) where X is a normal toric variety.
        Example
            P2 = toricProjectiveSpace 2;
            coxRing = ring P2;
            mons = {x_0^2, x_0*x_1, x_1^2};
            toricLinearSeries mons
///
*-

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
    Optional Inputs
        Variable => a symbol, default value ???
    Description
    	Text
            Computes the rigidity matrix for a d-framework (i.e. a graph G with an embedding map in R^d).
            The rigidity matrix is 1/2 times the Jacobian of the distance map evaluated at generic p, the choice of embedding map.
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
    Optional Inputs
        Iterations => an integer, default 3
        Field => a field, default ZZ for symbolic computation
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

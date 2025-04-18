doc ///
    Key
        getRigidityMatrix
        (getRigidityMatrix, ZZ, Graph)
        (getRigidityMatrix, ZZ, List)
        (getRigidityMatrix, ZZ, ZZ)
        [getRigidityMatrix, Variable]
    Headline
        Constructs the rigidity matrix of a d-framework
    Usage
        getRigidityMatrix(d, G)
        getRigidityMatrix(d, L)
        getRigidityMatrix(d, n)
    Inputs
        d : ZZ
            corresponding to the dimension of the embedding space
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices 
        Variable => Symbol
            that determines the symbol of the variables in the matrix
    Description
    	Text
            Computes the rigidity matrix for a d-framework (i.e. a graph G with an embedding map in R^d). 
            If no list is provided, computes it for the complete graph
            The rigidity matrix is 1/2 times the Jacobian of the distance map evaluated at generic p, the choice of embedding map.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            getRigidityMatrix(d, L)
            getRigidityMatrix(d, subsets(toList(0..(n-1)), 2))
            G = completeGraph(n);
            getRigidityMatrix(d, G)
///

doc ///
    Key
        isLocallyRigid
        (isLocallyRigid, ZZ, Graph)
        (isLocallyRigid, ZZ, List)
        (isLocallyRigid, ZZ, ZZ)
        [isLocallyRigid, Iterations]
        [isLocallyRigid, Field]
    Headline
        Returns a boolean indicating whether the given framework is locally rigid
    Usage
        isLocallyRigid(d, G)
        isLocallyRigid(d, L)
        isLocallyRigid(d, n)
    Inputs
        d : ZZ
            corresponding to the dimension of the embedding space
        n : ZZ
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices 
        Iterations => ZZ
            of iterations
        Field => Ring
            that instantiates the variables 
    Description
    	Text
            Tests for local rigidity by checking the rank of the rigidity matrix.
        Example
            n = 4; d = 2;
            L = {{0,1}, {0,2}, {1,2}, {1,3}, {2,3}};
            isLocallyRigid(d, L)
            isLocallyRigid(d, subsets(toList(0..(n-1)), 2))
            G = completeGraph(n);
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

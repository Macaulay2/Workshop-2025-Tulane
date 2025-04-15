doc ///
    Key
        getRigidityMatrix
        (Integer, Integer, Graph)
        (Integer, Graph)
        (Integer, Integer, List)
        (Integer, Integer)
    Headline
        Constructs the rigidity matrix of a d-framework
    Usage
        getRigidityMatrix(d, n, G)
        getRigidityMatrix(d, G)
        getRigidityMatrix(d, n, L)
        getRigidityMatrix(d, n)
    Inputs
        d : Integer
            corresponding to the dimension of the embedding space
        n : Integer
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
            n = 4;
            d = 2;

            L = {0,1}, {0,2}, {1,2}, {1,3}, {2,3};
            getRigidityMatrix(d, n, L)

            getRigidityMatrix(d, n, subsets(toList(0..(n-1)), 2))

            G = completeGraph(n);
            getRigidityMatrix(d, n, G)
            getRigidityMatrix(d, G)
///

doc ///
    Key
        isLocallyRigid
        (Integer, Integer, Graph)
        (Integer, Graph)
        (Integer, Integer, List)
        (Integer, Integer)
    Headline
        Returns a 
    Usage
        isLocallyRigid(d, n, G)
        isLocallyRigid(d, G)
        isLocallyRigid(d, n, L)
        isLocallyRigid(d, n)
    Inputs
        d : Integer
            corresponding to the dimension of the embedding space
        n : Integer
            corresponding to the number of vertices
        G : Graph
        L : List
            of pairs of adjacent vertices 
    Description
    	Text
            Tests for local rigidity by checking the rank of the rigidity matrix.
        Example
            example needed
///

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
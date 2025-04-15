doc ///
    Key
        getRigidityMatrix
        (Integer, Integer, List)
    Headline
        Constructs the rigidity matrix
    Usage
        getRigidityMatrix(d, n)
        getRigidityMatrix(d, n, G)
    Inputs
        d : Integer
        n : Integer
        G : List
            of pairs of adjacent vertices 
    Description
    	Text
            Computes the rigidty matrix. Returns the jacobian of the composition of a projection ???

            Expects the vertices of G to be 0 through n-1
        Example
            example needed
///

doc ///
    Key
        isLocallyRigid
        (Integer, Integer, List,)
    Headline
        Returns a 
    Usage
        isRigid(d, n, G)
    Inputs
        d : Integer
        n : Integer
        G : List
            of pairs of adjacent vertices 
    Description
    	Text
            Constructs a toric linear series from a list of monomials from the Cox ring of a toric variety.
            It checks that all monomials are of the same degree.
            It expects the monomials to be in ring(X) where X is a normal toric variety.
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
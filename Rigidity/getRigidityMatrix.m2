
getRigidityMatrix = method(Options => {Variable => null}, TypicalValue => Matrix)


-- Core function
getRigidityMatrix(ZZ, ZZ, List) := Matrix => opts -> (d, n, G) -> (
    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(d*n)]); -- Create a ring with d*n variables
    M := genericMatrix(R, d, n); -- Return a generic d by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G/toList, pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) ); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2 * transpose fold((a,b) -> a|b, jacobianList)
);

-- List of edges not given -> use complete graph
getRigidityMatrix(ZZ,ZZ) := Matrix => opts -> (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2), opts)
);

-- Input a Graph instead of edge set without number of vertices -> get number of vertices from graph
getRigidityMatrix(ZZ, Graph) := Matrix => opts -> (d, G) -> (
    getRigidityMatrix(d, length vertexSet G, edges G, opts)
);

-- Input a Graph instead of edge set with number of vertices -> check if number of vertices is correct
getRigidityMatrix(ZZ, ZZ, Graph) := Matrix => opts -> (d, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    getRigidityMatrix(d, n, edges G, opts)
);

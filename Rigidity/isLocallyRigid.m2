isLocallyRigid = method(Options => {Iterations => 3, Field => ZZ}, TypicalValue => Boolean)


isLocallyRigid(ZZ, ZZ, List) := Boolean => opts -> (d, n, E) -> (
    if n-1 < d then return length E == (n-1)*n/2;
    M := getRigidityMatrix(d, n, E);
    C := opts.Field; -- coefficientRing R; -- evaluate over an arbitrary field (e.g. given as an option)? 
    -- If given ZZ (or nothing) do it symbolically
    if C === ZZ then return rank M == d*n - (d+1)*d/2; 

    R := ring M;  
    isExact := not instance(C, InexactField);
    localRankFunction := if isExact then rank else numericalRank;
    checkFunction := (i) -> (
        randomValues := random(C^1,C^(d*n));
        fromRtoC := map(C,R,randomValues);
        d*n - (d+1)*d/2 == localRankFunction fromRtoC M
    );
    numOfTests := opts.Iterations;
    if isExact then any(numOfTests, checkFunction)
    else (
        truthList := apply(numOfTests, checkFunction);
        length (truthList -set{false})> length (truthList -set{true}) 
    )
);

-- local rigidity test on the complete graph
isLocallyRigid(ZZ,ZZ) := Boolean => opts -> (d,n) -> (
    isLocallyRigid(d,n, subsets(toList(0..(n-1)), 2), Numerical => opts.Numerical)
);

-- local rigidity test taking in a Graph object
isLocallyRigid(ZZ, Graph) := Boolean => opts -> (d, G) -> (
    isLocallyRigid(d, length vertexSet G, edges G, opts)
);

-- local rigidity test taking in a Graph object but also specifying number of vertices
isLocallyRigid(ZZ, ZZ, Graph) := Boolean => opts -> (d, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    isLocallyRigid(d, n, edges G, opts)
);
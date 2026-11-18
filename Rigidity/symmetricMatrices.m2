getSymmetricCompletionMatrix = method(Options => {Variable => null}, TypicalValue => Matrix);

-- input r - rank, n - number of vertices, G - list of set of edges eg {set {1, 2}, {2, 4}}
getSymmetricCompletionMatrix(ZZ, ZZ, List) := Matrix => opts -> (r, n, G) -> (

    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(r*n)]); -- Create a ring with r*n variables

    M := genericMatrix(R, r, n); -- Return a generic r by n matrix over R

    -- convert sets to lists
    Glist := G / (pair -> 
        if #pair == 2 then toSequence sort toList pair
        else toSequence (toList pair | toList pair));

    -- polynomialList obtained from A -> A^T*A
    polynomialLists := apply(Glist, pair -> (transpose(M)*M)_(pair));

    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

getSymmetricCompletionMatrix(ZZ,ZZ) := Matrix => opts -> (r,n) -> (
    getSymmetricCompletionMatrix(r,n, subsets(toList(0..(n-1)), 2), opts)
);

getSymmetricCompletionMatrix(ZZ, Graph) := Matrix => opts -> (r, G) -> (
    getSymmetricCompletionMatrix(r, length vertexSet G, edges G, opts)
);

isSpanningInSymmetricCompletionMatroid = method(Options => {Numerical => false, FiniteField => 0, Iterations => 3}, TypicalValue => Boolean);

-- Old verions we don't understand
-- isSpanningInSymmetricCompletionMatroid(ZZ, ZZ, List) := Boolean => opts -> (r, n, E) -> (
--     if r > n then return false;
--     M := getSymmetricCompletionMatrix(r, n, E);
--     R := ring M;
--     C := coefficientRing R; -- evaluate over an arbitrary field (e.g. given as an option)?   
--     crds := gens R;
--     if opts.Numerical 
--     then (
--         listOfTruthValues := apply(
--             toList(0..1), -- number of confidence runs?
--             k -> (
--         		randomValues := random(C^1,C^(r*n));
--         		fromRtoC := map(C,R,randomValues);
--         		r*n - (r-1)*r/2 == rank fromRtoC M
--             ) 
--         );
--         if # set(listOfTruthValues) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
--         all listOfTruthValues
--     )
--     else if opts.FiniteField =!= 0
--     then (
--         listOfTruthValuesFiniteFields := apply(
--             toList(0..1),
--             n -> r*n - (r-1)*r/2 == rank(
--                 a := symbol a; 
--                 GF(opts.FiniteField, Variable => a);
--                 sub(
--                     getSymmetricCompletionMatrix(r, n, E), 
--                     apply(
--                         toList(1..r*n), 
--                         i -> crds_i => (
--                             randIndex := random(1,opts.FiniteField);
--                             if randIndex == opts.FiniteField
--                             then 0
--                             else a^randIndex
--                         )
--                     )
--                 ) 
--             );
--             if # set(listOfTruthValuesFiniteFields) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
--             all listOfTruthValuesFiniteFields
--         )
--     )
--     else rank getSymmetricCompletionMatrix(r, n, E) == r*n - (r-1)*r/2
-- );

-- dimension of Sym(n, r); the formula rn - r(r-1)/2 is only valid for r <= n

symmetricCompletionDimension = (r, n) -> (
    s := min(r, n);
    s*n - s*(s-1)//2
);

-- New version we sorta understand
isSpanningInSymmetricCompletionMatroid(ZZ, ZZ, List) := Boolean => opts -> (r, n, E) -> (
    if any(flatten (E / toList), v -> v < 0 or v >= n)
    then error("vertices must be labelled 0, ..., ", n-1);
    target := symmetricCompletionDimension(r, n);
    if #E < target then return false;   -- too few entries (also covers E = {})
    M := getSymmetricCompletionMatrix(r, n, E);
    -- field for random evaluation; null means "compute the rank symbolically"
    K := if opts.FiniteField =!= 0 then GF(opts.FiniteField)
         else if opts.Numerical then QQ
         else null;
    if K === null then return rank M == target;
    -- rank at a point never exceeds the generic rank, so one trial that reaches

    -- the target proves "true"; "false" is correct with high probability
    R := ring M;
    any(opts.Iterations, i -> (
        point := random(K^1, K^(numgens R));
        rank (map(K, R, point)) M == target
    ))
);

-- spanning test on the complete graph
isSpanningInSymmetricCompletionMatroid(ZZ,ZZ) := Boolean => opts -> (r,n) -> (
    isSpanningInSymmetricCompletionMatroid(r,n, subsets(toList(0..(n-1)), 2), opts)
);


-- spanning test taking in a Graph object
isSpanningInSymmetricCompletionMatroid(ZZ, Graph) := Boolean => opts -> (r, G) -> (
    isSpanningInSymmetricCompletionMatroid(r, length vertexSet G, edges G, opts)
);


-- spanning test taking in a Graph object but also specifying number of vertices
isSpanningInSymmetricCompletionMatroid(ZZ, ZZ, Graph) := Boolean => opts -> (r, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    isSpanningInSymmetricCompletionMatroid(r, n, edges G, opts)
);
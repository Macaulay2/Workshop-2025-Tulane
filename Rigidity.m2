newPackage(
    "Rigidity",
    Version => "0.1",
    Authors => {{
            Name => "Kalina Mincheva",
            Email => "kmincheva@tulane.edu",
            HomePage => "www.math.tulane.edu/~kmincheva"
        },
        {
            Name => "Daniel Irving Bernstein",
            Email => "dbernstein1@tulane.edu",
            HomePage => "dibernstein.github.io"
        },
        {
            Name => "Griffin Edwards",
            Email => "griffinedwards@gatech.edu"
        },
        {
            Name => "Jianuo Zhou",
            Email => "jzhou632@gatech.edu"
        },
        {
            Name => "Ryan A. Anderson",
            Email => "raanderson@g.ucla.edu",
            HomePage => "ryan-a-anderson.github.io"
        },
        {
            Name => "Hannah Mahon",
            Email => "hannah.mahon@gtri.gatech.edu"
        }
    },
    Headline => "rigidity theory tools",
    Keywords => {},
    PackageExports => {"Graphs"},
    PackageImports => {},
    DebuggingMode => true
)

export {
    "getRigidityMatrix",
    "isLocallyRigid",
    "getStressMatrix",
    "isGloballyRigid",
    "Numerical",
    "FiniteField",
    "getSkewSymmetricCompletionMatrix",
    "isSpanningInSkewSymmetricCompletionMatroid",
    "Field",
    "Iterations"
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------

getRigidityMatrix = method(Options => {Variable => null}, TypicalValue => Matrix)

isLocallyRigid = method(Options => {Iterations => 3, Field => ZZ}, TypicalValue => Boolean)

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

isLocallyRigid(ZZ, ZZ, List) := Boolean => opts -> (d, n, E) -> (
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
        tallyCount := tally apply(numOfTests, checkFunction);
        tallyCount#true > tallyCount#false
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

getStressMatrix = method(Options => {Variable => null}, TypicalValue => Matrix)

-- Option FiniteFields: 0 for numeric, 1 for symbolic, prime power for finite field
isGloballyRigid = method(Options => {FiniteField => 1}, TypicalValue => Boolean)

-- Core function
getStressMatrix(ZZ, ZZ, List) := Matrix => opts -> (d, n, G) -> (

    x := getSymbol toString(opts.Variable);

    -- Left kernel of the rigidity matrix
    tRigidityMatrix := transpose getRigidityMatrix(d, n, G, opts);
    R := ring tRigidityMatrix;
    tRigidityMatrixRational := sub(tRigidityMatrix, frac R);
    stressBasis := mingens ker tRigidityMatrixRational;

    -- New symbolic variables for each element in the basis of the left kernel
    auxiliaryVarCount := numgens source stressBasis;
    y := symbol y;
    auxiliaryRing := frac(QQ[gens R, y_1..y_auxiliaryVarCount]);

    -- Symbolic linear combination of elements in the basis of the left kernel
    stressBasisLinearSum := 0;
    for i from 1 to auxiliaryVarCount do (
        stressBasisLinearSum = stressBasisLinearSum + y_i * sub(submatrix(stressBasis, {i - 1}), auxiliaryRing);
    );
    
    -- Build the symbolic stress matrix from the symbolic linear combination
    stressMatrix := mutableMatrix(auxiliaryRing, n, n);
    for i from 0 to (#G - 1) do (
        edge := G#i;
        stressMatrix_(edge#0, edge#1) = stressBasisLinearSum_(i, 0);
    );
    stressMatrixEntries := entries stressMatrix;
    for i from 0 to (n - 1) do (
        stressMatrix_(i, i) = -sum(stressMatrixEntries#i);
    );

    matrix(stressMatrix)

);

-- List of edges not given -> use complete graph
getStressMatrix(ZZ, ZZ) := Matrix => opts -> (d, n) -> (
    getStressMatrix(d, n, subsets(toList(0..(n-1)), 2), opts)
);

-- Input a Graph instead of edge set without number of vertices -> get number of vertices from graph
getStressMatrix(ZZ, Graph) := Matrix => opts -> (d, G) -> (
    getStressMatrix(d, length vertexSet G, edges G, opts)
);

-- Input a Graph instead of edge set with number of vertices -> check if number of vertices is correct
getStressMatrix(ZZ, ZZ, Graph) := Matrix => opts -> (d, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ", G);
    getStressMatrix(d, n, edges G, opts)
);

-- Core function
isGloballyRigid(ZZ, ZZ, List) := Boolean => opts -> (d, n, G) -> (

    M := getStressMatrix(d, n, G, opts);
    
    if opts.FiniteField == 1 then rank M == n - d - 1
    else (
        variableNum := numgens ring M;
        results := apply(
            toList(0..1), -- change this later
            () -> (
                randomValues := randomNumber(opts.FiniteField, variableNum);
                randomMap := map(ring randomValues, ring M, randomValues);
                rank randomMap M == n - d - 1
            )
        )
        if #set(results) =!= 1 then error("Try again bro");
        else results#0
    )

);

-- List of edges not given -> use complete graph
isGloballyRigid(ZZ, ZZ) := Boolean => opts -> (d,n) -> (
    isGloballyRigid(d, n, subsets(toList(0..(n-1)), 2), Numerical => opts.Numerical)
);

-- Input a Graph instead of edge set without number of vertices -> get number of vertices from graph
isGloballyRigid(ZZ, Graph) := Boolean => opts -> (d, G) -> (
    isGloballyRigid(d, length vertexSet G, edges G, opts)
);

-- Input a Graph instead of edge set with number of vertices -> check if number of vertices is correct
isGloballyRigid(ZZ, ZZ, Graph) := Boolean => opts -> (d, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    isGloballyRigid(d, n, edges G, opts)
);

-- Random number generator: q = 0 for numeric, q = prime power for finite field
randomNumber(ZZ, ZZ) := List => (q, d) -> (
    if q == 0 then F := RR;
    else F := GF(q, n);
    random(F^1, F^d)
);

getSkewSymmetricCompletionMatrix = method(Options => {Variable => null}, TypicalValue => Matrix);

getSkewSymmetricCompletionMatrix(ZZ, ZZ, List) := Matrix => opts -> (r, n, G) -> (
    if r % 2 =!= 0 then error("expected rank to be an even integer");
    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(r*n)]); -- Create a ring with r*n variables
    M := genericMatrix(R, r, n); -- Return a generic r by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> (transpose(M) * matrix{{map(R^(r//2),R^(r//2),0),id_(R^(r//2))},{-id_(R^(r//2)),map(R^(r//2),R^(r//2),0)}} * M)_(toSequence(pair))); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

getSkewSymmetricCompletionMatrix(ZZ,ZZ) := Matrix => opts -> (r,n) -> (
    getSkewSymmetricCompletionMatrix(r,n, subsets(toList(0..(n-1)), 2), opts)
);

getSkewSymmetricCompletionMatrix(ZZ, Graph) := Matrix => opts -> (r, G) -> (
    getSkewSymmetricCompletionMatrix(r, length vertexSet G, edges G)
);

getSkewSymmetricCompletionMatrix(ZZ, ZZ, Graph) := Matrix => opts -> (r, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    getSkewSymmetricCompletionMatrix(r, n, edges G)
);

isSpanningInSkewSymmetricCompletionMatroid = method(Options => {Numerical => false, FiniteField => 0}, TypicalValue => Boolean);

isSpanningInSkewSymmetricCompletionMatroid(ZZ, ZZ, List) := Boolean => opts -> (r, n, E) -> (
    M := getSkewSymmetricCompletionMatrix(r, n, E);
    R := ring M;
    C := coefficientRing R; -- evaluate over an arbitrary field (e.g. given as an option)?   
    crds := gens R;
    if opts.Numerical 
    then (
        listOfTruthValues := apply(
            toList(0..1), -- number of confidence runs?
            k -> (
        		randomValues := random(C^1,C^(r*n));
        		fromRtoC := map(C,R,randomValues);
        		r*n - (r+1)*r/2 == rank fromRtoC M
            ) 
        );
        if # set(listOfTruthValues) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
        all listOfTruthValues
    )
    else if opts.FiniteField =!= 0
    then (
        listOfTruthValuesFiniteFields := apply(
            toList(0..1),
            n -> r*n - (r+1)*r/2 == rank(
                a := symbol a; 
                GF(opts.FiniteField, Variable => a);
                sub(
                    getSkewSymmetricCompletionMatrix(r, n, E), 
                    apply(
                        toList(1..r*n), 
                        i -> crds_i => (
                            randIndex := random(1,opts.FiniteField);
                            if randIndex = opts.FiniteField
                            then 0
                            else a^randIndex
                        )
                    )
                ) 
            );
            if # set(listOfTruthValuesFiniteFields) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
            all listOfTruthValuesFiniteFields
        )
    )
    else rank getSkewSymmetricCompletionMatrix(r, n, E) == r*n - (r+1)*r/2
);


-- skew spanning test on the complete graph
isSpanningInSkewSymmetricCompletionMatroid(ZZ,ZZ) := Boolean => opts -> (r,n) -> (
    isSpanningInSkewSymmetricCompletionMatroid(r,n, subsets(toList(0..(n-1)), 2), Numerical => opts.Numerical)
);


-- skew spanning test taking in a Graph object
isSpanningInSkewSymmetricCompletionMatroid(ZZ, Graph) := Boolean => opts -> (r, G) -> (
    isSpanningInSkewSymmetricCompletionMatroid(r, length vertexSet G, edges G, opts)
);


-- skew spanning test taking in a Graph object but also specifying number of vertices
isSpanningInSkewSymmetricCompletionMatroid(ZZ, ZZ, Graph) := Boolean => opts -> (r, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    isSpanningInSkewSymmetricCompletionMatroid(r, n, edges G, opts)
);
------------------------------------------------------------------------------
-- DOCUMENTATION
------------------------------------------------------------------------------
beginDocumentation ()
doc ///
    Key
        Rigidity
    Headline
        Add headline description
    Description
      Text
    	Add package description
///

load "./RigidityDocs.m2"

------------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------------

load "./RigidityTests.m2"

end

restart
needsPackage "Rigidity"
check "Rigidity"
installPackage "Rigidity"
uninstallAllPackages()

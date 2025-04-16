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
    "Field",
    "FiniteField"
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------

getRigidityMatrix = method(Options => {Variable => null}, TypicalValue => Matrix)

isLocallyRigid = method(Options => {Numerical=> false, Field => ZZ}, TypicalValue => Boolean)

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
    R := ring M;
    C := opts.Field; -- coefficientRing R; -- evaluate over an arbitrary field (e.g. given as an option)?   
    crds := gens R;
    if opts.Field =!= ZZ 
    then (
        listOfTruthValues := apply(
            toList(0..1), -- number of confidence runs?
            k -> (
		randomValues := random(C^1,C^(d*n));
		fromRtoC := map(C,R,randomValues);
		d*n - (d+1)*d/2 == rank fromRtoC M
            ) 
        );
        if # set(listOfTruthValues) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
        all listOfTruthValues
    )
    else if opts.Numerical -- We need to fix this case
    then (
        listOfTruthValuesFiniteFields := apply(
            toList(0..1),
            n -> d*n - (d+1)*d/2 == rank(
		a := symbol a;
                GF(opts.Field, Variable => a);
                sub(
                    getRigidityMatrix(d, n, E), 
                    apply(
                        toList(1..d*n), 
                        i -> crds_i => (
                            randIndex := random(1,opts.Field);
                            if randIndex = opts.Field
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
    else rank getRigidityMatrix(d, n, E) == d*n - (d+1)*d/2
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

isGloballyRigid = method(Options => {Numerical => false, FiniteField => 0}, TypicalValue => Boolean)

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
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    getStressMatrix(d, n, edges G, opts)
);

-- Core function
isGloballyRigid(ZZ, ZZ, List) := Boolean => opts -> (d,n,G) -> (

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

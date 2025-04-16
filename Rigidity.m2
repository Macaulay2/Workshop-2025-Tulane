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
    "FiniteField"
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------

getRigidityMatrix = method(Options => {Variable => null}, TypicalValue => Matrix)

isLocallyRigid = method(Options => {Numerical => false, FiniteField => 0}, TypicalValue => Boolean)

getStressMatrix = method(TypicalValue => Matrix)

getRigidityMatrix(ZZ, ZZ, List) := Matrix => opts -> (d, n, G) -> (
    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(d*n)]); -- Create a ring with d*n variables
    M := genericMatrix(R, d, n); -- Return a generic d by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) ); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2 * transpose fold((a,b) -> a|b, jacobianList)
);

getRigidityMatrix(ZZ,ZZ) := Matrix => opts -> (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2), opts)
);

getRigidityMatrix(ZZ, Graph) := Matrix => opts -> (d, G) -> (
    getRigidityMatrix(d, length vertexSet G, edges G)
);

getRigidityMatrix(ZZ, ZZ, Graph) := Matrix => opts -> (d, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    getRigidityMatrix(d, n, edges G)
);

isLocallyRigid(ZZ, ZZ, List) := Boolean => opts -> (d, n, E) -> (
    M := getRigidityMatrix(d, n, E);
    R := ring M;
    C := coefficientRing R; -- evaluate over an arbitrary field (e.g. given as an option)?   
    crds := gens R;
    if opts.Numerical 
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
    else if opts.FiniteField =!= 0
    then (
        listOfTruthValuesFiniteFields := apply(
            toList(0..1),
            n -> d*n - (d+1)*d/2 == rank(
		a := symbol a;
                GF(opts.FiniteField, Variable => a);
                sub(
                    getRigidityMatrix(d, n, E), 
                    apply(
                        toList(1..d*n), 
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

getStressMatrix(ZZ, ZZ, List) := Matrix => (d, n, G) -> (

    -- Left kernel of the rigidity matrix
    tRigidityMatrix := transpose getRigidityMatrix(d, n, G);
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
        stressBasisLinearSum += y_i * sub(submatrix(stressBasis, {i - 1}), auxiliaryRing);
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

isGloballyRigid = method(Options => {Numerical => false}, TypicalValue => Boolean)

isGloballyRigid(ZZ, ZZ, List) := Boolean => opts -> (d,n,G) -> (

);

-*
isGloballyRigid(

);
*-

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

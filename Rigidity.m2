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
        },
	{
            Name => "Julian Huddell",
            Email => "jhuddell@tulane.edu"
	}
    
    },
    Headline => "rigidity theory tools",
    Keywords => {},
    PackageExports => {"Graphs", "NumericalLinearAlgebra"},
    PackageImports => {},
    AuxiliaryFiles => true,
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
    "getSymmetricCompletionMatrix",
    "isSpanningInSymmetricCompletionMatroid",
    "Field",
    "Iterations"
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------
load "./Rigidity/CayleyMenger.m2"

load "./Rigidity/getRigidityMatrix.m2"
load "./Rigidity/getStressMatrix.m2"


getSkewSymmetricCompletionMatrix = method(Options => {Variable => null}, TypicalValue => Matrix);

getSkewSymmetricCompletionMatrix(ZZ, ZZ, List) := Matrix => opts -> (r, n, G) -> (
    if r % 2 =!= 0 then error("expected rank to be an even integer");
    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(r*n)]); -- Create a ring with r*n variables
    M := genericMatrix(R, r, n); -- Return a generic r by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> (transpose(M) * matrix{{map(R^(r//2),R^(r//2),0),id_(R^(r//2))},{-id_(R^(r//2)),map(R^(r//2),R^(r//2),0)}} * M)_(toSequence(sort(toList(pair))))); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

getSkewSymmetricCompletionMatrix(ZZ,ZZ) := Matrix => opts -> (r,n) -> (
    getSkewSymmetricCompletionMatrix(r,n, subsets(toList(0..(n-1)), 2), opts)
);

getSkewSymmetricCompletionMatrix(ZZ, Graph) := Matrix => opts -> (r, G) -> (
    getSkewSymmetricCompletionMatrix(r, length vertexSet G, edges G, opts)
);

getSkewSymmetricCompletionMatrix(ZZ, ZZ, Graph) := Matrix => opts -> (r, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    getSkewSymmetricCompletionMatrix(r, n, edges G, opts)
);

isSpanningInSkewSymmetricCompletionMatroid = method(Options => {Numerical => false, FiniteField => 0}, TypicalValue => Boolean);

isSpanningInSkewSymmetricCompletionMatroid(ZZ, ZZ, List) := Boolean => opts -> (r, n, E) -> (
    if n-1 < r then return length E == (n-1)*n/2;
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

getSymmetricCompletionMatrix = method(Options => {Variable => null}, TypicalValue => Matrix);

-- input r - rank, n - number of vertices, G - list of set of edges eg {set {1, 2}, {2, 4}}
getSymmetricCompletionMatrix(ZZ, ZZ, List) := Matrix => opts -> (r, n, G) -> (

    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(r*n)]); -- Create a ring with r*n variables

    M := genericMatrix(R, r, n); -- Return a generic r by n matrix over R

    -- convert sets to lists
    Glist := G / (pair -> toSequence sort toList pair);
    -- fix indexing
    Glist = Glist / (pair -> (pair#0 -1, pair#1 - 1));

    -- polynomialList obtained from A -> A^T*A
    polynomialLists := apply(Glist, pair -> (transpose(M)*M)_(pair));

    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

getSymmetricCompletionMatrix(ZZ,ZZ) := Matrix => opts -> (r,n) -> (
    getSymmetricCompletionMatrix(r,n, subsets(toList(0..(n-1)), 2), opts)
);

isSpanningInSymmetricCompletionMatroid = method(Options => {Numerical => false, FiniteField => 0}, TypicalValue => Boolean);

isSpanningInSymmetricCompletionMatroid(ZZ, ZZ, List) := Boolean => opts -> (r, n, E) -> (
    M := getSymmetricCompletionMatrix(r, n, E);
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
                    getSymmetricCompletionMatrix(r, n, E), 
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
    else rank getSymmetricCompletionMatrix(r, n, E) == r*n - (r-1)*r/2
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

load "./Rigidity/isLocallyRigid.m2"
load "./Rigidity/isGloballyRigid.m2"
load "./Rigidity/RigidityDocs.m2"
load "./Rigidity/GlobalRigidityDocs.m2"
load "./Rigidity/MatrixCompletionNonSymmetric.m2"

------------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------------

load "./Rigidity/RigidityTests.m2"
load "./Rigidity/isSpanningInSkewtests.m2"
load "./Rigidity/locallyRigidTests.m2"
load "./Rigidity/CayleyMenger-tests.m2"
end

restart
needsPackage "Rigidity"
check "Rigidity"
installPackage "Rigidity"
uninstallAllPackages()

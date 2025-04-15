newPackage(
    "Rigidity",
    Version => "0.1",
    Authors => {{
            Name => "Kalina Mincheva"
            Email => "kmincheva@tulane.edu"
            HomePage => "www.math.tulane.edu/~kmincheva"
        },
        {
            Name => "Daniel Irving Bernstein"
            Email => "dbernstein1@tulane.edu"
            HomePage => "dibernstein.github.io"
        },
        {
            Name => "Griffin Edwards"
            Email => "griffinedwards@gatech.edu"
        },
        {
            Name => "Jianuo Zhou"
            Email => "jzhou632@gatech.edu"
        },
        {
            Name => "Ryan A. Anderson"
            Email => "raanderson@g.ucla.edu"
            HomePage => "ryan-a-anderson.github.io"
        }
    },
    Headline => "",
    Keywords => {},
    PackageExports => {},
    PackageImports => {},
    DebuggingMode => true
)

export {
    "getRigidityMatrix",
    "isLocallyRigid"
    "isGloballyRigid"
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------

getRigidityMatrix = method(TypicalValue => Matrix)

isLocallyRigid = method(Options => {Numerical => false, FiniteField => 0}, TypicalValue => Boolean)

getRigidityMatrix(ZZ, ZZ, List) := Matrix => (d, n, G) -> (
    R := QQ(monoid[x_(1) .. x_(d*n)]); -- Create a ring with d*n variables
    M := genericMatrix(R, d, n); -- Return a generic d by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) ); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2 * transpose fold((a,b) -> a|b, jacobianList)
);

getRigidityMatrix(ZZ,ZZ) := Matrix => (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2), opts)
);

getRigidityMatrix(ZZ, Graph) := Matrix => (d, G) -> (
    getRigidityMatrix(d, length vertexSet G, edges G)
);

getRigidityMatrix(ZZ, ZZ, Graph) := Matrix => (d, n, G) -> (
    if n =!= length vertexSet G then error("Expected ", n, " to be the number of vertices in ",G);
    getRigidityMatrix(d, n, edges G)
);

isLocallyRigid(ZZ, ZZ, List) := Boolean => opts -> (d, n, E) -> (
    if opts.Numerical 
    then (
        listOfTruthValues := apply(
            toList(0..1),
            n -> d*n - (d+1)*d/2 == rank(
                sub(
                    getRigidityMatrix(d, n, E), 
                    apply(toList(1..d*n), i -> x_i => random(-1.,1.))
                )
            ) 
        );
        if # set(listOfTruthValues) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
        all listOfTruthValues
    )
    else if opts.FiniteField =!= 0
    then (
        listOfTruthValues := apply(
            toList(0..1),
            n -> d*n - (d+1)*d/2 == rank(
                GF(opts.FiniteField, Variable => a);
                sub(
                    getRigidityMatrix(d, n, E), 
                    apply(
                        toList(1..d*n), 
                        i -> x_i => (
                            randIndex := random(1,opts.FiniteField);
                            if randIndex = opts.FiniteField
                            then 0
                            else a^randIndex
                        )
                    )
                ) 
            );
            if # set(listOfTruthValues) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
            all listOfTruthValues
        )
    )
    else rank getRigidityMatrix(d, n, G) == d*n - (d+1)*d/2
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

isGloballyRigid = method(Options => {Numerical => false}, TypicalValue => Boolean)

isGloballyRigid(ZZ, ZZ, List) := Boolean => opts -> (d,n,G) -> (

);

isGloballyRigid(

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
    	Add package description
///

load "./RigidityDocs.m2"

------------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------------

load "./RigidityTests.m2"
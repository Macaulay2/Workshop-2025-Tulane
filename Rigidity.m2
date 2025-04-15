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
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------

getRigidityMatrix = method(TypicalValue => Matrix)

isLocallyRigid = method(Options => {Numerical => false}, TypicalValue => Boolean)

getRigidityMatrix(ZZ, ZZ, List) := Matrix => (d, n, G) -> (
    R := QQ[x_1 .. x_(d*n)]; -- Create a ring with d*n variables
    M := genericMatrix(R, x_1, d, n); -- Return a generic d by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) ); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2 * transpose fold((a,b) -> a|b, jacobianList)
);

getRigidityMatrix(ZZ,ZZ) := Matrix => (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2), opts)
);

isLocallyRigid(ZZ, ZZ, G) := Boolean => opts -> (d, n, G) -> (
    if opts.Numerical 
    then (
        listOfTruthValues := apply(
            toList(0..1),
            n -> d*n - (d+1)*d/2 == rank(
                sub(
                    getRigidityMatrix(d, n, G), 
                    apply(toList(1..d*n), i -> x_i => random(-1.,1))
                )
            ) 
        );
        if # set(listOfTruthValues) =!= 1 then error("Expected all the numerical attempts to give the same result. Try again.");
        all listOfTruthValues
    )
    else rank getRigidityMatrix(d, n, G) == d*n - (d+1)*d/2
);

isLocallyRigid(ZZ,ZZ) := Boolean => opts -> (d,n) -> (
    isLocallyRigid(d,n, subsets(toList(0..(n-1)), 2), Numerical => opts.Numerical)
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
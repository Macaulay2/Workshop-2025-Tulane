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
            Name =>
            Email =>
            HomePage => 
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

getRigidityMatrix = method(Options => {Numerical => false}, TypicalValue => Matrix)

isLocallyRigid = method(TypicalValue => Boolean)

getRigidityMatrix(ZZ, ZZ, List) := Matrix => opts -> (d, n, G) -> (
    R := QQ[x_1 .. x_(d*n)]; -- Create a ring with d*n variables
    M := genericMatrix(R, x_1, d, n); -- Return a generic d by n matrix over R
    -- Here is the polynomial we might want to switch in the future
    polynomialLists := apply(G, pair -> transpose(M_{pair#0} - M_{pair#1}) * (M_{pair#0} - M_{pair#1}) ); 
    jacobianList := polynomialLists / jacobian;
    -- Folding horizontal concatination of the jacobian of each polynomial (from each edge)
    1/2 * transpose fold((a,b) -> a|b, jacobianList)
);

getRigidityMatrix(ZZ,ZZ) := Matrix => opts -> (d,n) -> (
    getRigidityMatrix(d,n, subsets(toList(0..(n-1)), 2))
);

isLocallyRigid(ZZ, ZZ, G) := (d, n, G) -> (
    M := getRigidityMatrix(d,n,G);
    rank M == d*n - (d+1)*d/2
;)

isLocallyRigid(ZZ,ZZ) := (d,n) -> (
    isRigid(d,n, subsets(toList(0..(n-1)), 2))
);


------------------------------------------------------------------------------
-- DOCUMENTATION
------------------------------------------------------------------------------
beginDocumentation ()
doc ///
    Key
        ToricExtras
    Headline
        new features for normal toric varieties
    Description
    	Text
	    This temporary package implements several new features that will
	    be incorporated into the existing NormalToricVarieties package.
///

load "./RigidityDocs.m2"

------------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------------

load "./RigidityTests.m2"
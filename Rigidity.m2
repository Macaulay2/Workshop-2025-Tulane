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
            Email => "griffinedwards@gatech.edu",
            HomePage => "griffin-has-questions.github.io"
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
            Name => "Mifron Fernandes",
            Email => "mfpvt@umsystem.edu"
        },
		{
            Name => "Julian Huddell",
            Email => "jhuddell@tulane.edu"
		},
		{
            Name => "Aolong Li",
            Email => "lial0921.miu@gmail.com"
		}
    
    },
    Headline => "rigidity theory tools",
    Keywords => {"Graph Theory"},
    PackageExports => {"Graphs", "NumericalLinearAlgebra","Polyhedra"},
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
    "getFiniteCompletabilityMatrix",
    "isFinitelyCompletable",
    "Field",
    "Iterations",
    "getCayleyMengerMatrix",
    "cayleyMengerIdeal",
}


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------
load "./Rigidity/CayleyMenger.m2"
load "./Rigidity/getRigidityMatrix.m2"
load "./Rigidity/getStressMatrix.m2"
load "./Rigidity/isLocallyRigid.m2"
load "./Rigidity/isGloballyRigid.m2"
load "./Rigidity/MatrixCompletionNonSymmetric.m2"
load "./Rigidity/symmetricMatrices.m2"
load "./Rigidity/skewSymmetricMatrices.m2"
load "./Rigidity/getCayleyMengerMatrix.m2"
load "./Rigidity/cayleyMengerIdeal.m2"



------------------------------------------------------------------------------
-- DOCUMENTATION
------------------------------------------------------------------------------
beginDocumentation ()
doc ///
Node
    Key
        Rigidity
    Headline
        for computing local and global rigidity of graphs
    Description
      Text
        Rigidity is a Macaulay2 package that has the following functionality: decide generic local and global rigidity of graphs in any dimension; decide whether a set of observed entries spans the algebraic matroid of the variety of rectangular, symmetric, or skew-symmetric matrices of bounded rank; produce Cayley–Menger ideals; and compute the tropicalization of coordinate projections of the Cayley–Menger variety of points in the plane.
      Tree
	:List of featured functions
        "isLocallyRigid"
        "isGloballyRigid"
        "tropicalCayleyMenger"
///

load "./Rigidity/RigidityDocs.m2"
load "./Rigidity/GlobalRigidityDocs.m2"
load "./Rigidity/SymmetricCompletionDocs.m2"
load "./Rigidity/SkewSymmetricCompletionDocs.m2"
load "./Rigidity/CayleyMenger-docs.m2"
load "./Rigidity/MatrixCompletionNonSymmetricDocs.m2"
load "./Rigidity/cayleyMengerIdealDocs.m2"

------------------------------------------------------------------------------
-- Tests
------------------------------------------------------------------------------

load "./Rigidity/RigidityTests.m2"
load "./Rigidity/isSpanningInSkewtests.m2"
load "./Rigidity/locallyRigidTests.m2"
load "./Rigidity/CayleyMenger-tests.m2"
load "./Rigidity/MatrixCompletionNonSymmetricTests.m2"
load "./Rigidity/globallyRigidTests.m2"
load "./Rigidity/symmetricMatricesTest.m2"
load "./Rigidity/skewSymmetricMatricesTest.m2"
load "./Rigidity/cayleyMengerIdealTest.m2"
end

restart
uninstallPackage "Rigidity"
restart
installPackage "Rigidity"
installPackage "TestAudit"
uninstallAllPackages
restart
needsPackage "Rigidity"
check "Rigidity"



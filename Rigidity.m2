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
            Name => "Mifron Fernandes",
            Email => "mfpvt@umsystem.edu"
        },
	{
            Name => "Julian Huddell",
            Email => "jhuddell@tulane.edu"
	}
    
    },
    Headline => "rigidity theory tools",
    Keywords => {},
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
    "Iterations"
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

load "./Rigidity/RigidityDocs.m2"
load "./Rigidity/GlobalRigidityDocs.m2"
load "./Rigidity/SymmetricCompletionDocs.m2"
load "./Rigidity/SkewSymmetricCompletionDocs.m2"
load "./Rigidity/CayleyMenger-docs.m2"

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
end

restart
needsPackage "Rigidity"
check "Rigidity"
installPackage "Rigidity"
uninstallAllPackages()

-- -*- coding: utf-8 -*-
newPackage("GaussianMixtureModels",
    AuxiliaryFiles => true, 
    Version => "0.1",
    Date => "April 14, 2025",
    Authors => {
	{Name => "Gaussian Mixture Models Group", Email => "doe@math.uiuc.edu", HomePage => "http://www.math.uiuc.edu/~doe/"}},
    Headline => "Gaussian Mixture Models Package",
    Keywords => {"Gaussian Mixture Models"},
    PackageImports => {"Elimination"},
    DebuggingMode => true
    )

export {
    "produceMomentSystemMatrices",
    "newtonIdentitySums",
    "newtonIdentitySymmetry",
    "solvePowerSystem",
    "getPowerSystem", 
    "getSymmetricPolynomialEvals",
    "getPowerSystemDiscriminant",
    "getStartingSystem",
    -- Hill Climbing Functions
    "hillClimber",
    "HillClimber",
    "nextStep",
    "track",
    -- Symbols
    "Quiet",
    "StartingPoint",
    "StopCondition",
    "LossFunction",
    "NumDirections",
    "StepSize",
    "CurrentPoint",
    "CurrentStep"
}

baseDirectory = GaussianMixtureModels#"source directory"
--------------------------------------------------------------------
----- CODE
--------------------------------------------------------------------
load(baseDirectory | "GaussianMixtureModels/Code.m2")
--- THINGS TO IMPLEMENT? -- 
-*

*-

--------------------------------------------------------------------
----- DOCUMENTATION
--------------------------------------------------------------------
beginDocumentation()
load(baseDirectory | "GaussianMixtureModels/Documentation.m2")

--------------------------------------------------------------------
----- TESTS
--------------------------------------------------------------------
load(baseDirectory | "GaussianMixtureModels/Tests.m2")
end

--------------------------------------------------------------------
----- SCRATCH SPACE
--------------------------------------------------------------------
uninstallPackage "GaussianMixtureModels";
restart
installPackage "GaussianMixtureModels"
--check GaussianMixtureModels
debug needsPackage "GaussianMixtureModels";


A= matrix{{9,0,0,0},{8,7,0,3},{2,3,4,2},{1,0,2,3}}
m = {1,2,3,4}
L = solvePowerSystem(A,m)
--getPowerSystemDiscriminant(A)

lossFunction = method(
    Options => {
        ComplexConstant => 0.5,
        DistanceConstant => 0.5,
        Tolerance => 0.001,
    }
)
lossFunction(List) := RR => opts -> L -> (
    sol := solvePowerSystem(A,L);
    rootsPartition := partition( z -> abs(imaginaryPart(z))< opts#Tolerance , sol);
    complexRoots := rootsPartition#false;
    realRoots := rootsPartition#true;
    complexLoss := sqrt(sum(for val in (complexRoots / imaginaryPart) list val^2));
    sortedRealRoots := sort(realRoots);
    minPairwiseDistance := min flatten for i from 1 to length(sortedRealRoots) - 1 list (
        sortedRealRoots_{i} - sortedRealRoots_{i-1}
    );
    realLoss := 1_QQ/minPairwiseDistance;
    opts#DistanceConstant*realLoss + opts#ComplexConstant*complexLoss
)

stopCondition = method(
    Options => {
        Tolerance => 0.001
    }
)
stopCondition(List) := Boolean => opts -> (L,A) -> (
    if lossFunction(L,A) < opts#Tolerance then true else false
)

hC = hillClimber(lossFunction, stopCondition, m)
nextStep(hC)
track hC


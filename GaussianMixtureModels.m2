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
    "fabricateMoments",
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
--check GaussianMixtureMode
debug needsPackage "GaussianMixtureModels";


A= matrix{{9,0,0,0},{8,7,0,3},{2,3,4,2},{1,0,2,3}}
m = {4,8,10,50}

actualm = fabricateMoments({3/5,2/9,8/3,30/14})**RR
(A,B) = produceMomentSystemMatrices(4, 1/1)

noise = transpose matrix{for i from 1 to numRows actualm list random(-15.0,15.0)}
observedm = actualm + noise

--L = solvePowerSystem(A,m)
--getPowerSystemDiscriminant(A)

lossFunction = method(
    Options => {
        ComplexConstant => 0.5,
        DistanceConstant => 0.01,
        Tolerance => 0.001,
    }
)
lossFunction(List) := RR => opts -> L -> (
    sol := solvePowerSystem(A,L);
    rootsPartition := partition( z -> abs(imaginaryPart(z))< 0.001,  sol);
    complexRoots := if rootsPartition#?false then rootsPartition#false else {};
    realRoots := if rootsPartition#?true then rootsPartition#true else {};
    complexLoss := sum(for val in (complexRoots / imaginaryPart) list val^2);
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
stopCondition(List) := Boolean => opts -> (L) -> (
    sol := solvePowerSystem(A,L);
    allRealRoots := all(sol, z -> abs(imaginaryPart(z))< opts#Tolerance);
    if (lossFunction(L) < opts#Tolerance) or (allRealRoots) then true else false
)

hC = hillClimber(lossFunction, stopCondition, flatten entries(observedm - B**RR))

nextStep(hC)
solvePowerSystem(A,hC#CurrentPoint)

track hC
actualm - B**RR
observedm = actualm + noise
solvePowerSystem(A,hC#CurrentPoint)
solvePowerSystem(A, hC#StartingPoint)


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
    -- Symbols
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


A= matrix{{1,0},{0,1}}
getPowerSystemDiscriminant(A)

obj = f -> abs((f_0^2 + 1) - f_1)
stop = g -> if obj(g_0) == g_1 then true else false
hC = hillClimber(obj, stop, {1,3})
nextStep hC

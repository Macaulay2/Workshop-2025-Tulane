-- -*- coding: utf-8 -*-
newPackage("GaussianMixtureModels",
    AuxiliaryFiles => true, 
    Version => "0.1",
    Date => "April 14, 2025",
    Authors => {
	{Name => "John Cobb", Email => "jdcobb3@gmail.com", HomePage => "https://johndcobb.github.io"},
    {Name => "Julia Lindberg", Email => "julia.lindberg@math.utexas.edu", HomePage => "https://sites.google.com/view/julialindberg/home"}
    },
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
load(baseDirectory | "GaussianMixtureModels/PowerSystems.m2")
load(baseDirectory | "GaussianMixtureModels/RootCorrecting.m2")
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
-- check GaussianMixtureModels
debug needsPackage "GaussianMixtureModels";
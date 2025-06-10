-- -*- coding: utf-8 -*-
newPackage("PowerSums",
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

baseDirectory = PowerSums#"source directory"
--------------------------------------------------------------------
----- CODE
--------------------------------------------------------------------
load(baseDirectory | "PowerSums/PowerSystems.m2")
load(baseDirectory | "PowerSums/RootCorrecting.m2")
--- THINGS TO IMPLEMENT? -- 
-*

*-

--------------------------------------------------------------------
----- DOCUMENTATION
--------------------------------------------------------------------
beginDocumentation()
load(baseDirectory | "PowerSums/Documentation.m2")

--------------------------------------------------------------------
----- TESTS
--------------------------------------------------------------------
load(baseDirectory | "PowerSums/Tests.m2")
end

--------------------------------------------------------------------
----- SCRATCH SPACE
--------------------------------------------------------------------
uninstallPackage "PowerSums";
restart
installPackage "PowerSums"
-- check PowerSums
debug needsPackage "PowerSums";
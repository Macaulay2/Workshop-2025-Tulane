-- -*- coding: utf-8 -*-
newPackage("GaussianMixtureModels",
    AuxiliaryFiles => true, 
    Version => "0.1",
    Date => "April 14, 2025",
    Authors => {
	{Name => "Gaussian Mixture Models Group", Email => "doe@math.uiuc.edu", HomePage => "http://www.math.uiuc.edu/~doe/"}},
    Headline => "Gaussian Mixture Models Package",
    Keywords => {"Gaussian Mixture Models"},
    DebuggingMode => false
    )

export {
    "produceMomentSystemMatrices",
    "newtonIdentitySums",
    "newtonIdentitySymmetry",
    "solvePowerSystem",
    "getPowerSystem",
    "getStartingSystem"
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
debug installPackage "GaussianMixtureModels"
--check GaussianMixtureModels
debug needsPackage "GaussianMixtureModels";

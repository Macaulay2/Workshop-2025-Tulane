-- -*- coding: utf-8 -*-
-- licensed under GPL v2 or any later version
newPackage(
    "LieAlgebraRepresentations",
    Version => "0.97",
    Date => "May 18, 2025",
    AuxiliaryFiles=>true,
    Headline => "Lie algebra representations and characters",
    Authors => {
	  {   Name => "Dave Swinarski",
	      Email => "dswinarski@fordham.edu",
	      HomePage => "https://faculty.fordham.edu/dswinarski/"
	  },
	  {
	      Name => "Paul Zinn-Justin", -- starting with version 0.6
	      Email => "pzinn@unimelb.edu.au",
	      HomePage => "http://blogs.unimelb.edu.au/paul-zinn-justin/"}
	  },
    Keywords => {"Lie Groups and Lie Algebras"},
    PackageImports => {"ReesAlgebra"},
    PackageExports => {"SparseMatrices","SpechtModule","Polyhedra","Isomorphism","AssociativeAlgebras"},
    DebuggingMode => true
    )


-- See version history in "./LieAlgebraRepresentations/versionhistory.txt"

needs "./LieAlgebraRepresentations/importsandexports.m2"
needs "./LieAlgebraRepresentations/lieAlgebras.m2"
needs "./LieAlgebraRepresentations/lieAlgebraModules.m2"
needs "./LieAlgebraRepresentations/lieAlgebraBases.m2"
needs "./LieAlgebraRepresentations/representationsCasimirReynolds.m2"
needs "./LieAlgebraRepresentations/basesAsWords.m2"
needs "./LieAlgebraRepresentations/deGraafAlgorithm.m2"
needs "./LieAlgebraRepresentations/gelfandTsetlinTypeA.m2"
needs "./LieAlgebraRepresentations/symWedgeTensor.m2"
needs "./LieAlgebraRepresentations/highestWeightVectorsAndSubmodules.m2"

beginDocumentation()
needs "./LieAlgebraRepresentations/documentation.m2"


endPackage "LieAlgebraRepresentations" 

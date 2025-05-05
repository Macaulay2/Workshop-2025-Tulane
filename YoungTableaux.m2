newPackage(
    "YoungTableaux",
    AuxiliaryFiles => true,
    Version => "1.0", 
    Date => "April 18, 2025",
    Keywords => {"Combinatorics"},
    Authors => {
        {Name => "Sean Grate", 
         Email => "sean.grate@auburn.edu", 
         HomePage => "https://seangrate.com/"},
        {Name => "Andrew Karsten",
         Email => "akk0071@auburn.edu"},
        {Name => "Pedro Ramírez-Moreno",
         Email => "pedro.ramirez@cimat.mx",
         HomePage => "https://sites.google.com/cimat.mx/pedroramirezmoreno"},
         {Name => "Stephen Stern",
         Email => "sstern2@unl.edu",
         HomePage => "https://sterns.github.io/"}
    },
    Headline => "functions for working with Young diagrams and tableaux",
    PackageExports => {
        "Permutations"
    }
)

export {
    -- types
    "YoungDiagram",
    "YoungTableau",
    "SkewDiagram",
    -- methods
    "youngDiagram",
    "youngTableau",
    "skewDiagram",
    "armLength",
    "legLength",
    "hookLength",
    "shape",
    "rowStabilizers",
    "columnStabilizers",
    "youngSymmetrizer",
    "numberStandardYoungTableaux",
    "highestWeightFilling",
    "rowsFirstFilling",
    "columnsFirstFilling",
    "canonicalFilling",
    "randomFilling",
    "isStandard",
    "isSemiStandard",
    "isCorner",
    "getCandidateFillings",
    "filledSYT",
    "filledSemiSYT",
    "rowInsertion",
    "benderKnuthInvolution",
    "promotion",
    "evacuation",
    "dualEvacuation",
    "robinsonSchenstedCorrespondence",
    "biword",
    "RSKCorrespondence",
    "readingWord",
    "majorIndex",
    "yamanouchiWord",
    "companionMap",
    "weight",
    -- symbols
    "RowIndex"
}

-- WISHLIST
-- Lie algebra action on tableaux
-- Gelfand-Tsetlin symmetrizers/basis
-- Pieri maps => formal linear combinations of tableaux (hash table)
-- straightening laws/multi-straightening laws of tensor products of tableaux (see https://arxiv.org/pdf/1710.05214v2 for some ideas)
-- tensor product/Kronecker product => list of tableaux
-- shuffling laws (for tableaux with repeated entries)
-- plethysm
-- contragradient vs conjugate
-- Schur modules notation, etc.
-- refinements of diagrams/Young's lattice/Partition lattice
-- straightening for STANDARD Young tableaux (see Sagan's book for Garnir elements and the SpechtModule package)
-- RSK correspondence between tableaux and permutations
-- promotion and evacuation

-----------------------------------------------------------------------------
-- **CODE** --
-----------------------------------------------------------------------------
load "./YoungTableaux/Code/diagrams.m2"
load "./YoungTableaux/Code/tableaux.m2"
load "./YoungTableaux/Code/enumeration.m2"

-----------------------------------------------------------------------------
-- **DOCUMENTATION** --
-----------------------------------------------------------------------------
beginDocumentation()
load "./YoungTableaux/Documentation/packageDocumentation.m2"
load "./YoungTableaux/Documentation/diagramsDocumentation.m2"
load "./YoungTableaux/Documentation/tableauxDocumentation.m2"
load "./YoungTableaux/Documentation/enumerationDocumentation.m2"

-----------------------------------------------------------------------------
-- **TESTS** --
-----------------------------------------------------------------------------
load "./YoungTableaux/Tests/diagramsTests.m2"
load "./YoungTableaux/Tests/tableauxTests.m2"
load "./YoungTableaux/Tests/enumerationTests.m2"
end

-----------------------------------------------------------------------------
--Development Section
-----------------------------------------------------------------------------
restart
uninstallPackage "YoungTableaux"
restart
installPackage "YoungTableaux"
restart
needsPackage "YoungTableaux"
elapsedTime check "YoungTableaux"
viewHelp "YoungTableaux"

--------------------------
-- Andrew's scratch space
--------------------------

YD = youngDiagram {4,3,3,2,1,1,0,0}
YT = youngTableau {{1,2,3},{4,5},{6}}
shape = {4,2,1}
fill = {1,2,3,4,5,6,7}
listToTableauxList(fill,shape)
getCandidateFillings {4,2,1}

shape = {4,2,1}
FSYT = #(filledSYT shape)
NSYT = numberStandardYoungTableaux shape
CSYT = #(getCandidateFillings(shape,{1,2,3,4,5,6,7}))
filledSYT shape
tempTableau = youngTableau {{1,4,5,6},{2,7},{3}}
isStandard tempTableau 
semiShape = {4,3,2}
stuff = {1,1,2,2,3,3,3,4,4}
filledSemiSYT(semiShape,stuff)

YT#(2,2)

--------------------------
-- Sean's scratch space
--------------------------
restart
uninstallPackage "YoungTableaux"
restart
installPackage "YoungTableaux"
restart
needsPackage "YoungTableaux"
elapsedTime check "YoungTableaux"

restart
needsPackage "Permutations"
myd = youngDiagram {4,2,1}
lambda = youngTableau {{1,2,3},{4,5},{6}}

tempCand = getCandidateFillings {4,2,1}

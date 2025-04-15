newPackage(
    "YoungTableaux",
    AuxiliaryFiles => true,
    Version => "1.0", 
    Date => "April 18, 2025",
    Keywords => {"Combinatorics"},
    Authors => {
        {Name => "Sean Grate", 
         Email => "sean.grate@auburn.edu", 
         HomePage => "https://seangrate.com/"}
    },
    Headline => "functions for working with Young diagrams and tableaux"
)

export {
    -- types
    "YoungDiagram",
    "YoungTableau",
    -- methods
    "youngDiagram",
    "youngTableau"
    -- symbols
    -- "Weak"
}

-- TODO
-- Lie algebra action on tableaux
-- Young symmetrizers
-- semistandard/standard tableaux
-- Gelfand-Tsetlin symmetrizers/basis
-- Pieri maps => formal linear combinations of tableaux (hash table)
-- straightening laws/multi-straightening laws of tensor products of tableaux
-- tensor product/Kronecker product => list of tableaux
-- shuffling laws (for tableaux with repeated entries)
-- plethysm
-- contragradient vs conjugate
-- Schur modules notation, etc.
-- refinements of diagrams/Young's lattice/Partition lattice

-----------------------------------------------------------------------------
-- **CODE** --
-----------------------------------------------------------------------------
------------------------------------
-- Local utilities
------------------------------------
-- some helper functions go here

------------------------------------
-- YoungDiagram type declarations and basic constructors
------------------------------------
YoungDiagram = new Type of VisibleList
YoungDiagram.synonym = "youngDiagram"

new YoungDiagram from VisibleList := (typeofYoungDiagram, lambda) -> lambda

youngDiagram = method()
youngDiagram VisibleList := YoungDiagram => lambda -> new YoungDiagram from lambda

isWellDefined YoungDiagram := Boolean => lambda -> (
    -- A Young diagram is well-defined if it is a sequence of non-increasing positive integers.
    return
)


------------------------------------
-- YoungTableau type declarations and basic constructors
------------------------------------
YoungTableau = new Type of VisibleList
YoungTableau.synonym = "youngTableau"

new YoungTableau from VisibleList := (typeofYoungTableau, lambda) -> lambda

youngTableau = method()
youngTableau VisibleList := YoungTableau => lambda -> new YoungTableau from lambda

isWellDefined YoungTableau := Boolean => lambda -> (
    -- A Young diagram is well-defined if it is a sequence of non-increasing positive integers.
    return
)

------------------------------------
-- Young diagram string representations
------------------------------------
expression YoungDiagram := lambda -> expression toList lambda
toString YoungDiagram := lambda -> toString expression toList lambda
tex YoungDiagram := lambda -> tex expression toSequence lambda
html YoungDiagram := lambda -> html expression toList lambda

------------------------------------
-- Indexing Young diagrams as lists
------------------------------------
YoungDiagram _ ZZ := ZZ => (lambda, n) -> ((toList lambda)_(n-1))
YoungDiagram _ List := List => (lambda, l) -> ((toList lambda)_l)
YoungDiagram _ Sequence := List => (lambda, s) -> ((toList lambda)_(toList s))

------------------------------------
-- Basic Young diagram operations
------------------------------------
YoungDiagram == YoungDiagram := Boolean => (lambda, mu) -> (
    toList(lambda) == toList(mu)
)


------------------------------------
-- Miscellaneous
------------------------------------
conjugate YoungDiagram := YoungDiagram => lambda -> (
    -- for each lambda#k, form the all-ones vector of length lambda#k, and then add these all-ones vectors together
    numConjugateCols := lambda#0;
    youngDiagram sum(for part in lambda list (toList(part:1) | toList((numConjugateCols - part):0)))
)


-----------------------------------------------------------------------------
-- **DOCUMENTATION** --
-----------------------------------------------------------------------------
beginDocumentation()
load "./YoungTableaux/docs.m2"

-----------------------------------------------------------------------------
-- **TESTS** --
-----------------------------------------------------------------------------
load "./YoungTableaux/tests.m2"
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
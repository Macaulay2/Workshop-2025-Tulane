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
    "armLength",
    "legLength",
    "hookLength",
    "youngTableau",
    "numberStandardYoungTableaux"
    -- symbols
    -- "Weak"
}

-- test
-- WISHLIST
-- Lie algebra action on tableaux
-- Young symmetrizers
-- semistandard/standard tableaux
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

-----------------------------------------------------------------------------
-- **CODE** --
-----------------------------------------------------------------------------
------------------------------------
-- Local utilities
------------------------------------
-- Some helper functions go here.

------------------------------------
-- YoungDiagram type declarations and basic constructors
------------------------------------
-- Basically, a Young diagram is a nested hash table, just like you would think
-- of for a matrix. This allows indexing rows agnostic to their relative position
-- to the origin. The second index then allows indexing the columns without need
-- for continuity (same as the first).
-- Matt: encode as list of lists, but start of rows have an offset if the diagram is not left-justified
YoungDiagram = new Type of HashTable
YoungDiagram.synonym = "youngDiagram"

-- This creates a left-justified Young diagram
new YoungDiagram from VisibleList := (typeofYoungDiagram, lambda) -> (
    new HashTable from flatten for i to #lambda-1 list (for j to (lambda_i)-1 list (i+1,j+1)=>true)
)
-- This creates any variation of a Young diagram
new YoungDiagram from HashTable := (typeofYoungDiagram, lambda) -> (
    new HashTable from lambda
)

youngDiagram = method()
youngDiagram VisibleList := YoungDiagram => lambda -> (new YoungDiagram from lambda)
youngDiagram HashTable := YoungDiagram => lambda -> (new YoungDiagram from lambda)

isWellDefined YoungDiagram := Boolean => lambda -> (return)

------------------------------------
-- Young diagram string representations
------------------------------------
net YoungDiagram := String => lambda -> (
    boxes := apply(toList(1..numRows lambda)**toList(1..numColumns lambda), (i, j) -> if lambda#?(i,j) then "☐" else " ");
    stack flatten(pack(numColumns lambda, boxes / toString) / concatenate)
    -- boxes := apply(toList(1..numRows lambda)**toList(1..numColumns lambda), (i, j) -> if lambda#?(i,j) then netList({""}, Alignment=>Center, HorizontalSpace=>3, VerticalSpace=>1) 
    --                                                                                                    else netList({""}, Alignment=>Center, HorizontalSpace=>3, VerticalSpace=>1, Boxes=>false));
    -- stack apply(pack(numColumns lambda, boxes), boxList -> fold(boxList, (i,j) -> i | j))
)

------------------------------------
-- Indexing into Young diagrams
------------------------------------
-- select the i-th row(s) of the Young diagram
YoungDiagram _ ZZ := ZZ => (lambda, n) -> (selectKeys(lambda, coords -> coords#0 == n))
YoungDiagram _ List := List => (lambda, l) -> (selectKeys(lambda, coords -> member(coords#0, l)))
YoungDiagram _ Sequence := List => (lambda, s) -> (selectKeys(lambda, coords -> member(coords#0, s)))

YoungDiagram ^ ZZ := ZZ => (lambda, n) -> (selectKeys(lambda, coords -> coords#1 == n))
YoungDiagram ^ List := List => (lambda, l) -> (selectKeys(lambda, coords -> member(coords#1, l)))
YoungDiagram ^ Sequence := List => (lambda, s) -> (selectKeys(lambda, coords -> member(coords#1, s)))

numRows YoungDiagram := ZZ => lambda -> (max apply(keys lambda, coords -> coords#0))
numColumns YoungDiagram := ZZ => lambda -> (max apply(keys lambda, coords -> coords#1))

------------------------------------
-- Basic Young diagram operations
------------------------------------
YoungDiagram == YoungDiagram := Boolean => (lambda, mu) -> (pairs lambda == pairs mu)

conjugate YoungDiagram := YoungDiagram => lambda -> (youngDiagram applyKeys(lambda, key -> reverse key))
transpose YoungDiagram := YoungDiagram => lambda -> (conjugate lambda)

------------------------------------
-- Statistics on Young diagrams
------------------------------------
armLength = method()
armLength (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (#(lambda_i) - j)
armLength (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (armLength(lambda, coords#0, coords#1))

legLength = method()
legLength (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (#(lambda^j) - i)
legLength (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (legLength(lambda, coords#0, coords#1))

hookLength = method()
hookLength (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (
    armLength(lambda, i, j) + legLength(lambda, i, j) + 1
)
hookLength (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (hookLength(lambda, coords#0, coords#1))


------------------------------------
-- Miscellaneous
------------------------------------



------------------------------------
-- YoungTableau type declarations and basic constructors
------------------------------------
YoungTableau = new Type of YoungDiagram
YoungTableau.synonym = "youngTableau"

-- This constructs a left-aligned Young tableau
new YoungTableau from List := (typeofYoungTableau, lambda) -> (
    new HashTable from flatten for i to #lambda-1 list (for j to #(lambda_i)-1 list (i+1,j+1)=>lambda_i_j)
)

youngTableau = method()
youngTableau List := YoungTableau => lambda -> new YoungTableau from lambda

isWellDefined YoungTableau := Boolean => lambda -> (return)

------------------------------------
-- Young tableaux string representations
------------------------------------
net YoungTableau := String => lambda -> (
    boxes := apply(toList(1..numRows lambda)**toList(1..numColumns lambda), (i, j) -> if lambda#?(i,j) then lambda#(i,j) else " ");
    stack flatten(pack(numColumns lambda, boxes / toString) / concatenate)
)


------------------------------------
-- Basic Young tableau operations
------------------------------------
YoungTableau == YoungTableau := Boolean => (lambda, mu) -> (pairs lambda == pairs mu)


------------------------------------
-- Miscellaneous
------------------------------------
numberStandardYoungTableaux = method()
numberStandardYoungTableaux List := ZZ => shape -> (
    -- Theorem of Frame-Robinson-Thrall (1954)
    -- Do I need to be careful using // if I know the result is an integer?
    num := (sum shape)!;
    lambda := youngDiagram shape;
    den := product for coords in keys lambda list hookLength(lambda, coords);
    return num // den
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
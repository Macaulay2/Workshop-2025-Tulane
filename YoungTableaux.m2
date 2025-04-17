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
    "youngSymmetrizer",
    "numberStandardYoungTableaux",
    "highestWeightFilling",
    "rowsFirstFilling"
    -- symbols
    -- "Weak"
}

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
new YoungDiagram from HashTable := (typeofYoungDiagram, lambda) -> (new HashTable from lambda)

youngDiagram = method()
youngDiagram VisibleList := YoungDiagram => lambda -> (new YoungDiagram from lambda)
youngDiagram HashTable := YoungDiagram => lambda -> (new YoungDiagram from lambda)

-- Checks if a Young diagram is well defined
isWellDefined YoungDiagram := Boolean => diagram -> (
    aux := true;
    for i from 1 to (numRows diagram) - 1 do if #(diagram_i) < #(diagram_(i+1)) then break aux = false;
    aux
) 

------------------------------------
-- Young diagram string representations
------------------------------------
toString YoungDiagram := String => lambda -> ("YoungDiagram " | toString(shape lambda))
toExternalString YoungDiagram := String => lambda -> (toString lambda)

net YoungDiagram := Net => lambda -> (
    boxes := apply(toList(1..numRows lambda)**toList(1..numColumns lambda), (i, j) -> if lambda#?(i,j) then netList({" "}, Alignment=>Center, HorizontalSpace=>1, VerticalSpace=>0) 
                                                                                                       else netList({" "}, Alignment=>Center, HorizontalSpace=>1, VerticalSpace=>0, Boxes=>false));
    stack apply(pack(numColumns lambda, boxes), boxList -> fold(boxList, (i,j) -> i | j))
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

conjugate YoungDiagram := YoungDiagram => lambda -> (applyKeys(lambda, key -> reverse key))
transpose YoungDiagram := YoungDiagram => lambda -> (conjugate lambda)

------------------------------------
-- Statistics on Young diagrams
------------------------------------
shape = method()
shape YoungDiagram := List => (lambda) -> (
    -- -- Custom Counter implementation (will work for non-left-justified diagrams)
    -- rowIndices := unique(for coords in keys lambda list coords#0);
    -- counts := new MutableHashTable from (for rowIndex in rowIndices list (rowIndex, 0));
    -- for coords in keys lambda do (counts#(coords#0) = counts#(coords#0) + 1);
    -- toList ((sort pairs counts) / (countPair -> countPair#1))

    -- This assumes the diagrams are left-justified, but should be easy to extend to non-left-justified
    -- by changing the last argument in `armLength` to be the minimum nonzero column index.
    for i to (numRows lambda)-1 list armLength(lambda, i+1, 0)
)

armLength = method()
armLength (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (#(lambda_i) - j)
armLength (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (armLength(lambda, coords#0, coords#1))

legLength = method()
legLength (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (#(lambda^j) - i)
legLength (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (legLength(lambda, coords#0, coords#1))

hookLength = method()
hookLength (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (armLength(lambda, i, j) + legLength(lambda, i, j) + 1)
hookLength (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (hookLength(lambda, coords#0, coords#1))


------------------------------------
-- Miscellaneous
------------------------------------


------------------------------------
-- SkewDiagram type declarations and basic constructors
------------------------------------
SkewDiagram = new Type of YoungDiagram
SkewDiagram.synonym = "skewDiagram"

new SkewDiagram from YoungDiagram := (typeofSkewDiagram, lambda) -> (new HashTable from lambda)

skewDiagram = method()
skewDiagram (List, List) := SkewDiagram => (lambdaShape, muShape) -> new SkewDiagram from (youngDiagram((set keys youngDiagram lambdaShape) - (set keys youngDiagram muShape)))

isWellDefined SkewDiagram := Boolean => lambda -> (return)


------------------------------------
-- YoungTableau type declarations and basic constructors
------------------------------------
YoungTableau = new Type of YoungDiagram
YoungTableau.synonym = "youngTableau"

-- This constructs a left-aligned Young tableau given a list of lists 
-- containing each filled entry
new YoungTableau from List := (typeofYoungTableau, lambda) -> (
    new HashTable from flatten for i to #lambda-1 list (for j to #(lambda_i)-1 list (i+1,j+1)=>lambda_i_j)
)
-- This creates any variation of a Young tableau
new YoungDiagram from HashTable := (typeofYoungDiagram, lambda) -> (new HashTable from lambda)

youngTableau = method()
youngTableau List := YoungTableau => lambda -> new YoungTableau from lambda
youngTableau HashTable := YoungDiagram => lambda -> (new YoungTableau from lambda)

isWellDefined YoungTableau := Boolean => lambda -> (return)

------------------------------------
-- Young tableaux string representations
------------------------------------
toString YoungTableau := String => lambda -> (
    maxHeight := max(apply(keys lambda, coords -> coords#0));
    boxesToFill := new MutableList from (for i in 1..maxHeight list new MutableList from {});
    for coordsFillingPair in sort pairs lambda do (
        coords := coordsFillingPair#0;
        filling := coordsFillingPair#1;
        boxesToFill#(coords#0-1) = append(boxesToFill#(coords#0-1), filling);
    );
    "YoungTableau " | toString(new List from (for row in boxesToFill list new List from row))
)

net YoungTableau := Net => lambda -> (
    maxBoxWidth := max((values lambda) / (val -> #toString(val)));
    emptyBox := pad("", maxBoxWidth); 
    customPad := (s) -> (pad("", floor((maxBoxWidth-#s)/2)) | s | pad("", ceiling((maxBoxWidth-#s)/2)));
    boxes := apply(toList(1..numRows lambda)**toList(1..numColumns lambda), (i, j) -> if lambda#?(i,j) then netList({customPad toString(lambda#(i,j))}, Alignment=>Center, HorizontalSpace=>1, VerticalSpace=>0) 
                                                                                                       else netList({emptyBox}, Alignment=>Center, HorizontalSpace=>1, VerticalSpace=>0, Boxes=>false));
    stack apply(pack(numColumns lambda, boxes), boxList -> fold(boxList, (i,j) -> i | j))
)

------------------------------------
-- Basic Young tableau operations
------------------------------------
YoungTableau == YoungTableau := Boolean => (lambda, mu) -> (pairs lambda == pairs mu)

conjugate YoungTableau := YoungTableau => lambda -> (applyKeys(lambda, key -> reverse key))
transpose YoungTableau := YoungTableau => lambda -> (conjugate lambda)

-- takes a YoungTableau and outputs its corresponding YoungDiagram
toDiagram = method();
toDiagram YoungTableau := YoungDiagram => T -> youngDiagram applyValues(T, v -> true)
toDiagram T

------------------------------------
-- Miscellaneous
------------------------------------
rowStabilizers = method()
rowStabilizers YoungTableau := List => lambda -> (
    -- A row/column is 'preserved' by a permutation if and only if the permutation
    -- only permutes the fillings present in that row/column.
    Sn := apply(permutations(sum shape lambda), p -> permutation(p / (i -> i+1)));
    -- Check that all of the nonfixed points of the permutation are a subset of the
    -- filling labels for the first row.
    stabilizers := select(Sn, perm -> isSubset(toList select(1..#perm, i -> perm_i != i), values lambda_1));
    for rowIndex in 2..numRows lambda do (
        -- Among the permutations which fix the previous rows, check if they fix the current row.
        stabilizers = select(stabilizers, perm -> isSubset(toList select(1..#perm, i -> perm_i != i), values lambda_rowIndex));
    );
    stabilizers
)

columnStabilizers = method()
columnStabilizers YoungTableau := List => lambda -> (rowStabilizers conjugate lambda)

youngSymmetrizer = method()
youngSymmetrizer YoungTableau := YoungTableau => lambda -> (    
    -- The group algebra CC[Sn]
    n := sum shape lambda;
    Sn := toSequence apply(permutations n, p -> permutation(p / (i -> i+1)));
    x := getSymbol "x";
    R := CC(monoid[toSequence(for perm in Sn list x_perm)]);
    xHashed := hashTable apply(R_*, v -> last baseName v => v);

    -- The Young symmetrizer is a sum over all row and column stabilizers where
    -- the summands take the form sign(h) e_(gh), where sign(h) is the sign of 
    -- the permutation h and e_i a basis vector for the group algebra group 
    -- algebra of CC[Sn].
    sum(for rowStab in rowStabilizers lambda list 
        sum(for columnStab in columnStabilizers lambda list 
            ((sign columnStab) * xHashed#(extend(rowStab * columnStab, n)))))
)

numberStandardYoungTableaux = method()
numberStandardYoungTableaux List := ZZ => shape -> (
    -- Theorem of Frame-Robinson-Thrall (1954)
    -- Do I need to be careful using // if I know the result is an integer?
    num := (sum shape)!;
    lambda := youngDiagram shape;
    den := product for coords in keys lambda list hookLength(lambda, coords);
    return num // den
)


----------------------------------


--- Trying to list all fillings of standard tableaux of a given shape
getThe'i'thSequence = method()
getThe'i'thSequence (ZZ, ZZ, ZZ) := List => (i, givenLength, possibilitiesForEach) -> (
    
)

--- Given a list (shape) of a diagram, find all the standard fillings
-- getCandidateFillings = methods()
-- getCandidateFillings (List) := YoungTableau => (shape) -> (
--     -- sizeOfTableau := (
--     --     --- get the size by adding the number of boxes in each row
--     --     tempSize := 0;
--     --     for i to #shape-1 do (
--     --         tempSize = tempSize + shape#i;
--     --     );
--     --     tempSize
--     -- );
--     -- tempPlacements := for i to ?????? list (
--     --     -- Range over all possible sequences 

--     -- );
-- )



-- Given a Young diagram, fills each box with the row it is in
-- assumes given diagram is left justified
highestWeightFilling = method()
highestWeightFilling YoungDiagram := YoungTableau => diagram ->(
    return youngTableau (for i to #diagram^1-1 list (for j to #diagram_(i+1)-1 list i+1 ))
)

-- Given a Young diagram, fills each box 1->n row by row
-- assumes given diagram is left justified
rowsFirstFilling = method()
rowsFirstFilling YoungDiagram := YoungTableau => diagram ->(
    count := 1;
    return( youngTableau(for i to #diagram^1-1 list (for j to #diagram_(i+1)-1 list(count) do count = count +1) ))
) 


-- Given a Young diagram, fills each box 1->n column by column
-- assumes given diagram is left justified
columnsFirstFilling = method()
columnsFirstFilling YoungDiagram := YoungTableau => diagram ->( return transpose (rowsFirstFilling(transpose(diagram)))
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

YD = youngDiagram {4,3,3,2,1,1,0,0}
YT = youngTableau {{1,2,3},{4,5},{6}}

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
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
    "insertionStep",
    "schenstedCorrespondence",
    "readingWord"
    -- symbols
    -- "Weak"
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
    new HashTable from flatten for i to #lambda-1 list (for j to (lambda_i)-1 list (i+1,j+1)=>" ")
)
-- This creates any variation of a Young diagram
new YoungDiagram from HashTable := (typeofYoungDiagram, lambda) -> (new HashTable from lambda)

youngDiagram = method()
youngDiagram VisibleList := YoungDiagram => lambda -> (new YoungDiagram from lambda)
youngDiagram HashTable := YoungDiagram => lambda -> (new YoungDiagram from applyValues(lambda, v -> " "))

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
    -- Calculate boundary of diagram
    iVals := apply(keys lambda, coords -> coords_0);
    jVals := apply(keys lambda, coords -> coords_1);
    
    -- one "|" character is roughly equivalent to three "-" characters
    valueStringLengths := applyValues(lambda, val -> length toString val);
    maxValWidth := max values valueStringLengths;
    numDashChars := max(3, maxValWidth + 2);
    numPipeChars := round(numDashChars / 3);
    printingLineIdx := (numPipeChars + 2) // 2;

    -- Go through each line of the diagram and print according to adjacencies.
    -- Build the string and then trim according to the gluing conditions.
    templateTopBottomEdge := "+" | concatenate(numDashChars:"-") | "+";
    templateEmptyRow := "|" | concatenate(numDashChars:" ") | "|";
    templateValRow := "| REPLACEME |";
    templateBox := new MutableList from flatten {templateTopBottomEdge,
                                                 for i from 1 to numPipeChars list if (i == printingLineIdx) then templateValRow else templateEmptyRow,
                                                 templateTopBottomEdge};
    
    fullGridOfBoxes := new MutableHashTable from apply(toList(min(iVals)..max(iVals))**toList(min(jVals)..max(jVals)), coords -> (coords, copy templateBox));
    for rowIdx from min(iVals) to max(iVals) do (
        for colIdx from min(jVals) to max(jVals) do (
            -- Draw box if box is actually there; otherwise, fill with emptiness.
            if lambda#?(rowIdx, colIdx) then (
                -- Fill in REPLACEME with the value of the box.
                -- Ensure all boxes have the same width with appropriate padding
                -- based on the maximum width of the contents of the boxes.
                padSize := maxValWidth - #(toString(lambda#(rowIdx, colIdx)));
                replacementString := pad("", floor(padSize/2)) | toString(lambda#(rowIdx, colIdx)) | pad("", ceiling(padSize/2));
                fullGridOfBoxes#(rowIdx, colIdx)#(printingLineIdx) = 
                    replace("REPLACEME", replacementString, fullGridOfBoxes#(rowIdx, colIdx)#(printingLineIdx));
                -- Only draw north/west edges if on the boundary of the diagram.
                if (fullGridOfBoxes#?(rowIdx-1, colIdx)) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = drop(fullGridOfBoxes#(rowIdx, colIdx), 1);
                );
                if (fullGridOfBoxes#?(rowIdx, colIdx-1) and lambda#?(rowIdx, colIdx-1)) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = apply(fullGridOfBoxes#(rowIdx, colIdx), boxRow -> concatenate drop(toList boxRow, 1))
                );
            ) else (                
                fullGridOfBoxes#(rowIdx, colIdx)#(printingLineIdx) = templateEmptyRow;
                -- Trim top if there are any boxes in the row above.
                if any(apply(keys(lambda_rowIdx), coords -> lambda#?(rowIdx-1, coords#1)), i -> i == true) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = drop(fullGridOfBoxes#(rowIdx, colIdx), 1);
                );
                -- Trim bottom if there are any boxes in the row below.
                if any(apply(keys(lambda_rowIdx), coords -> lambda#?(rowIdx+1, coords#1)), i -> i == true) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = drop(fullGridOfBoxes#(rowIdx, colIdx), 1);
                );
                -- Trim left if there is a box to the left.
                if (lambda#?(rowIdx, colIdx-1)) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = apply(fullGridOfBoxes#(rowIdx, colIdx), boxRow -> concatenate drop(toList boxRow, 1));
                );
                -- Trim right.
                fullGridOfBoxes#(rowIdx, colIdx) = apply(fullGridOfBoxes#(rowIdx, colIdx), boxRow -> concatenate drop(toList boxRow, -1));
                -- Replace box with empty space.
                fullGridOfBoxes#(rowIdx, colIdx) = apply(fullGridOfBoxes#(rowIdx, colIdx), boxRow -> concatenate((#boxRow):" "));

                -- Keep borders if there is a box below, but trim corners if boxes are drawn there.
                if (lambda#?(rowIdx+1, colIdx)) then (
                    fullGridOfBoxes#(rowIdx, colIdx)#(-1) = templateTopBottomEdge;
                    if (lambda#?(rowIdx+1, colIdx-1)) then (
                        fullGridOfBoxes#(rowIdx, colIdx)#(-1) = concatenate drop(toList templateTopBottomEdge, 1);
                    );
                    if (lambda#?(rowIdx, colIdx+1)) then (
                        fullGridOfBoxes#(rowIdx, colIdx)#(-1) = concatenate drop(toList templateTopBottomEdge, -1);
                    );
                    fullGridOfBoxes#(rowIdx, colIdx) = prepend(concatenate(#fullGridOfBoxes#(rowIdx, colIdx)#(-1):" "), fullGridOfBoxes#(rowIdx, colIdx));
                );
            );
            -- form the box at (i,j) into one string
            fullGridOfBoxes#(rowIdx, colIdx) = stack fullGridOfBoxes#(rowIdx, colIdx);
        );
    );
    -- join the strings together meaningfully
    maxWidth := max(jVals) - min(jVals) + 1;
    groupByRow := pack((sort pairs fullGridOfBoxes) / (rowPair -> rowPair#1), maxWidth);
    stack(groupByRow / horizontalJoin)
)

------------------------------------
-- Indexing into Young diagrams
------------------------------------
-- select the i-th row(s) of the Young diagram
YoungDiagram _ ZZ := ZZ => (lambda, n) -> (selectKeys(lambda, coords -> coords#0 == n))
YoungDiagram _ List := List => (lambda, l) -> (selectKeys(lambda, coords -> member(coords#0, l)))
YoungDiagram _ Sequence := List => (lambda, s) -> (selectKeys(lambda, coords -> member(coords#0, s)))

-- select the j-th column(s) of the Young diagram
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

-- Checks if a Young tableau is well defined
isWellDefined YoungTableau := Boolean => T -> (
    D := youngDiagram T;
    if isWellDefined D == false then return false;
    if set values T != set toList (1 .. #D) then return false;
    true
)

-- checks if a tableau is a standard tableau
isStandard = method()
isStandard YoungTableau := Boolean => T -> (
    D := youngDiagram T;
    if isWellDefined T == false then return false;
    if T#(1,1) != 1 then return false;
    --if T#(numRows D, #(D_(numRows D))) != #D then return false;
    for j from 1 to #(D_1) - 1 do if T#(1,j) >= T#(1,j+1) then return false;
    if (numRows D) == 1 then return true;
    for i from 2 to (numRows D) do for j from 1 to #(D_i) - 1 do if T#(i,j) >= T#(i,j+1) then return false;
    for i from 2 to (numRows D) do for j from 1 to #(D_i) do if T#(i - 1,j) >= T#(i,j) then return false;
    true
)

-- checks if a tableau is a semistandard tableau
isSemiStandard = method()
isSemiStandard YoungTableau := Boolean => T -> (
    D := youngDiagram T;
    if isWellDefined D == false then return false;
    aux := values T;
    M := max aux;
    if set (1 .. M) != set aux then return false;
    for j from 1 to #(D_1) - 1 do if T#(1,j) > T#(1,j+1) then return false;  
    if (numRows D) == 1 then return true;
    for i from 2 to (numRows D) do for j from 1 to #(D_i) - 1 do if T#(i,j) > T#(i,j+1) then return false;
    for i from 2 to (numRows D) do for j from 1 to #(D_i) do if T#(i - 1,j) >= T#(i,j) then return false;
    true
)

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

------------------------------------
-- Basic Young tableau operations
------------------------------------
YoungTableau == YoungTableau := Boolean => (lambda, mu) -> (pairs lambda == pairs mu)

conjugate YoungTableau := YoungTableau => lambda -> (applyKeys(lambda, key -> reverse key))
transpose YoungTableau := YoungTableau => lambda -> (conjugate lambda)

------------------------------------
-- Schensted correspondence and more
------------------------------------
-- permutation -> pair of tableaux
insertionStep = method()
insertionStep (Sequence, ZZ, Sequence) := MutableHashTable => (partialTableauPair, rowIdx, permIdxValPair) -> (
    -- Unpacking arguments: (insertionTableau, recordingTableau), rowIdx, (permIdx, permVal)
    insertionTableau := partialTableauPair#0;
    recordingTableau := partialTableauPair#1;
    permIdx := permIdxValPair#0;
    permVal := permIdxValPair#1;
    
    -- Check if current row exists.
    if not insertionTableau#?(rowIdx, 1) then (
        insertionTableau#(rowIdx, 1) = permVal;
        recordingTableau#(rowIdx, 1) = permIdx;
    ) else (
        -- Try to insert the val at the end of the rowIdx row.
        maxColumnIdx := max((select(keys insertionTableau, coords -> (coords#0) == rowIdx) / (coords -> coords#1)));
        if (permVal > insertionTableau#(rowIdx, maxColumnIdx)) then (
            insertionTableau#(rowIdx, maxColumnIdx+1) = permVal;
            recordingTableau#(rowIdx, maxColumnIdx+1) = permIdx;
        ) else (
            -- If val can't be inserted, find the leftmost y such that y > x.
            -- Replace y with x, and try to insert y into the next row.
            row := select(pairs insertionTableau, coords -> ((coords#0)#0 == rowIdx) and ((coords#1)> permVal));
            yIdx := position(sort row, posFillingPair -> posFillingPair#1 > permVal) + 1;
            yPos := (row#(yIdx-1))#0;
            yVal := (row#(yIdx-1))#1;
            yPermIdx := recordingTableau#yPos;
            
            insertionTableau#yPos = permVal;
            recordingTableau#yPos = permIdx;

            partialTableauPair = insertionStep((insertionTableau, recordingTableau), rowIdx+1, (yPermIdx, yVal));
            insertionTableau = partialTableauPair#0;
            recordingTableau = partialTableauPair#1;
        );
    );
    (insertionTableau, recordingTableau)
)

schenstedCorrespondence = method()
schenstedCorrespondence Permutation := Sequence => (perm) -> (
    insertionTableau := new MutableHashTable from {(1,1) => perm_1};
    recordingTableau := new MutableHashTable from {(1,1) => 1};
    tableauPair := (insertionTableau, recordingTableau);
    for i in 2..#perm do (tableauPair = insertionStep(tableauPair, 1, (i, perm_i)););
    (youngTableau tableauPair#0, youngTableau tableauPair#1)
)

-- pair of tableaux -> permutation
reverseInsertionStep = method()
reverseInsertionStep (YoungTableau, YoungTableau) := Permutation => (insertionTableau, recordingTableau) -> (
    -- Basically, follow the insertion step backward to figure out where the last insertion happened.
)

schenstedCorrespondence (YoungTableau, YoungTableau) := Permutation => (insertionTableau, recordingTableau) -> (
    lastRowIdx := (shape insertionTableau)#(-1);
    lastColumnIdx := max(apply(keys insertionTableau_lastRowIdx, coords -> coords#1));
    perm := new MutableList from {insertionTableau#(lastRowIdx, lastColumnIdx)};
    for i in 2..(sum shape insertionTableau) do (perm = reverseInsertionStep(insertionTableau, recordingTableau, 1, perm););
    permutation perm
)


------------------------------------
-- Miscellaneous
------------------------------------
readingWord = method()
readingWord YoungTableau := List => (lambda) -> (
    rowsData := reverse apply(1..numRows lambda, i -> sort pairs lambda_i);
    rowsValues := apply(rowsData, row -> row / (rowEntry -> rowEntry#1));
    fold(rowsValues, (i, j) -> i | j)
)

rowStabilizers = method()
rowStabilizers YoungTableau := List => lambda -> (
    -- A row/column is 'preserved' by a permutation if and only if the permutation
    -- only permutes the fillings present in that row/column.
    Sn := apply(permutations(sum shape lambda), p -> permutation(p / (i -> i+1)));
    -- Check that all of the nonfixed points of the permutation are a subset of the
    -- filling labels for the first row.
    stabilizers := select(Sn, perm -> isSubset(toList select(1..#perm, i -> perm_i != i), values lambda_1));
    print(toString(lambda_1) | "     " | toString(stabilizers));
    for rowIndex in 2..numRows lambda do (
        -- Among the permutations which fix the previous rows, check if they fix the current row.
        stabilizers = select(stabilizers, perm -> isSubset(toList select(1..#perm, i -> perm_i != i), values lambda_rowIndex));
        print(toString(lambda_rowIndex) | "     " | toString(stabilizers));
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
    x := local x;
    R := CC[toSequence(for perm in Sn list x_perm)];

    -- The Young symmetrizer is a sum over all row and column stabilizers where
    -- the summands take the form sign(h) e_(gh), where sign(h) is the sign of 
    -- the permutation h and e_i a basis vector for the group algebra group 
    -- algebra of CC[Sn].
    sum(for rowStab in rowStabilizers lambda list 
        sum(for columnStab in columnStabilizers lambda list 
            ((sign columnStab) * x_(extend(rowStab * columnStab, n)))))
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


---- Given a list (shape) of a diagram, find all the standard fillings
getCandidateFillings = method()
getCandidateFillings(List,List) := List => (shape,nums) -> (
    numberRows := #shape;
    --- get the size by adding the number of boxes in each row
    tempSize := 0;
    for i to numberRows-1 do (
        tempSize = tempSize + shape#i;
    );
    --- tempSize is the size of the tableau. We can think of each row the number i
    --- goes in to, and once we know the rows every number goes in we automatically
    --- know the filling on that row. This doesn't guarantee a valid filling though.

    --- Make a vector that will keep track and make sure we don't put too many things
    --- in a row
    
    openBoxesVec := new MutableList from shape;
    gotTempList := true;
    --- want a list of all the possible maps from {1,...,n} -> numRows
    for i from 1 to numberRows ^ tempSize list (
        gotTempList = true;
        for i to #shape-1 do (
            openBoxesVec#i = shape#i;
        );
        --- We want the output to be a list of lists, since each sublist is the map
        tempList := for j to tempSize - 1 list (
            if not gotTempList then continue;
            tempQuotient := i // (numberRows ^ j);
            tempOut := tempQuotient % numberRows;
            --- decrement the number of available boxes left in that row and if we
            --- have put more numbers than boxes we  have gotten something invalid
            openBoxesVec#tempOut = openBoxesVec#tempOut - 1;
            if openBoxesVec#tempOut < 0 then (
                gotTempList = false;
            );
            tempOut
        );
        if not gotTempList then continue;
        --- tempList is a candidate map right now. We turn this in to a tableau list
        --- to then feed to the tableau method
        tempTList := new MutableList from for j to numberRows - 1 list (new MutableList from {});
        for j to tempSize - 1 do (
            tempTList#(tempList#j) = append(tempTList#(tempList#j),nums#j);
        );
        tableauList := for i to #tempTList - 1 list (
            tempInner := for j to #(tempTList#i) - 1 list (tempTList#i)#j;
            tempInner
        );
        youngTableau tableauList
    )
)
getCandidateFillings(List, Sequence) := List => (shape, nums) -> (getCandidateFillings(shape, toList nums))
getCandidateFillings(Sequence, Sequence) := List => (shape, nums) -> (getCandidateFillings(toList shape, toList nums))

--- Still need to write this
filledSYT = method()
filledSYT List := List => shape -> (
    sizeOfTableau := 0;
    for i to #shape-1 do (
        sizeOfTableau = sizeOfTableau + shape#i;
    );
    nums := for i to sizeOfTableau - 1 list (i+1);
    select(getCandidateFillings(shape,nums), i -> isStandard(i))
)

filledSemiSYT = method()
filledSemiSYT(List,List) := List => (shape,nums) -> (
    nums = sort nums;
    sizeOfTableau := 0;
    for i to #shape-1 do (
        sizeOfTableau = sizeOfTableau + shape#i;
    );
    if sizeOfTableau != #nums then (
        print "Cannot create a semi-standard tableau with i different number of entries than boxes";
        return
    );
    unique select(getCandidateFillings(shape,nums), i -> isSemiStandard(i))
)

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

canonicalFilling = method()
canonicalFilling YoungDiagram := YoungTableau => diagram -> (rowsFirstFilling diagram)

-- Given a Young diagram, fills each box 1->n column by column
-- assumes given diagram is left justified
columnsFirstFilling = method()
columnsFirstFilling YoungDiagram := YoungTableau => diagram ->( return transpose (rowsFirstFilling(transpose(diagram)))
) 

-- given a Young diagram D, it gives a random tableau using the alphabet 1, 2, ..., #D
randomFilling = method()
randomFilling YoungDiagram := YoungTableau => D -> (
    L := random toList (1 .. #D);
    aux := 0;
    youngTableau hashTable flatten for i from 1 to numRows D list(
    for j from 1 to #(D_i) list(
        aux = aux + 1;
        {(i, j), L#(aux - 1)} 
        )
    )
)

-- given a Young diagram, checks if a given key of the form (a,b) is a corner of the diagram
isCorner = method()
isCorner (YoungDiagram, Sequence) := Boolean => (diagram, key) -> (
    if diagram #? key == false then return false;
    a := key_0;
    b := key_1;
    if diagram #? (a, b + 1) then return false;
    if diagram #? (a + 1, b) then return false;
    true 
)

-- given a Young diagram, outputs a random corner (a,b) of the diagram 
-- the corner is taken randomly according to Greene, Nijenhuis, and S Wilf
trial = method()
trial YoungDiagram := Sequence => diagram -> (
    pivot := first random keys diagram;
    while not isCorner(diagram, pivot) do (
        a := pivot_0;
        b := pivot_1;
        legBoxes := for i from 1 to legLength(diagram, pivot) list (a + i, b);
        armBoxes := for j from 1 to armLength(diagram, pivot) list (a, b + j);
        pivotCandidates := armBoxes | legBoxes;
        pivot = first random pivotCandidates
    );
    pivot
)

-- given a Young diagram, outpus a uniformly random Standard tableau,
-- according to the algorithm in Greene, Nijenhuis, and S Wilf
randomStandardTableau = method()
randomStandardTableau YoungDiagram := YoungTableau => diagram -> (
    n := #diagram;
    youngTableau hashTable for i from 0 to n - 1 list (
        cornerKey := trial diagram;
        if i < n - 1 then diagram = youngDiagram hashTable apply(delete(cornerKey, keys diagram), k -> (k, true));
        {cornerKey, n - i}
    )
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

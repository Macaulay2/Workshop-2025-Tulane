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
    if (#lambda == 0) then return "";

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
                rowOfGrid := selectKeys(new HashTable from fullGridOfBoxes, coords -> coords#0 == rowIdx);

                fullGridOfBoxes#(rowIdx, colIdx)#(printingLineIdx) = templateEmptyRow;
                -- Trim top if there are any boxes in the row above.
                if any(apply(keys rowOfGrid, coords -> lambda#?(rowIdx-1, coords#1)), i -> i == true) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = drop(fullGridOfBoxes#(rowIdx, colIdx), 1);
                );
                -- Trim bottom if there are any boxes in the row below.
                if any(apply(keys rowOfGrid, coords -> lambda#?(rowIdx+1, coords#1)), i -> i == true) then (
                    fullGridOfBoxes#(rowIdx, colIdx) = drop(fullGridOfBoxes#(rowIdx, colIdx), -1);
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
YoungDiagram _ List := List => (lambda, l) -> (selectKeys(lambda, coords -> isMember(coords#0, l)))
YoungDiagram _ Sequence := List => (lambda, s) -> (selectKeys(lambda, coords -> isMember(coords#0, s)))

-- select the j-th column(s) of the Young diagram
YoungDiagram ^ ZZ := ZZ => (lambda, n) -> (selectKeys(lambda, coords -> coords#1 == n))
YoungDiagram ^ List := List => (lambda, l) -> (selectKeys(lambda, coords -> isMember(coords#1, l)))
YoungDiagram ^ Sequence := List => (lambda, s) -> (selectKeys(lambda, coords -> isMember(coords#1, s)))

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
content (YoungDiagram, Sequence) := ZZ => (lambda, coords) -> (coords#1 - coords#0)
content (YoungDiagram, ZZ, ZZ) := ZZ => (lambda, i, j) -> (j - i)


------------------------------------
-- SkewDiagram type declarations and basic constructors
------------------------------------
SkewDiagram = new Type of YoungDiagram
SkewDiagram.synonym = "skewDiagram"

new SkewDiagram from YoungDiagram := (typeofSkewDiagram, lambda) -> (new HashTable from lambda)

skewDiagram = method()
skewDiagram (YoungDiagram, YoungDiagram) := SkewDiagram => (lambda, mu) -> new SkewDiagram from (youngDiagram((set keys lambda) - (set keys mu)))
skewDiagram (List, List) := SkewDiagram => (lambdaShape, muShape) -> skewDiagram(youngDiagram lambdaShape, youngDiagram muShape)

isWellDefined SkewDiagram := Boolean => lambda -> (return)

shape SkewDiagram := Sequence => diagram -> (
    rowIndices := unique apply(keys diagram, coords -> coords#0);
    groupByRow := new HashTable from apply(rowIndices, 
                                           rowIdx -> rowIdx => keys applyKeys(diagram_rowIdx, coords -> coords#1));
    minIdx := min rowIndices;
    maxIdx := max rowIndices;
    lambdaShape := for rowIdx from minIdx to maxIdx list (if groupByRow#?rowIdx then max(groupByRow#rowIdx) else 0);
    muShape := for rowIdx from minIdx to maxIdx list (if groupByRow#?rowIdx then min(groupByRow#rowIdx)-1 else 0);
    -- trim unncecessary zeros from mu (lambda might have more rows than mu)
    muShape = muShape_(select(#muShape, i -> muShape_{i ..< #muShape} != toList((#muShape - i):0)));
    (lambdaShape, muShape)
)

------------------------------------
-- Skew diagram string representations
------------------------------------
toString YoungDiagram := String => lambda -> ("SkewDiagram" | toString(shape lambda))
toExternalString YoungDiagram := String => lambda -> (toString lambda)
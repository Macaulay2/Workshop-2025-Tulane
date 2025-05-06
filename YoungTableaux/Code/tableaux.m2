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
YoungTableau == YoungTableau := Boolean => (lambda, mu) -> (set pairs lambda == set pairs mu)

conjugate YoungTableau := YoungTableau => lambda -> (applyKeys(lambda, key -> reverse key))
transpose YoungTableau := YoungTableau => lambda -> (conjugate lambda)

rowInsertion = method(Options => {RowIndex => 1})
rowInsertion (YoungTableau, ZZ) := YoungTableau => opts -> (lambda, val) -> (
    -- If the tableau is empty, just insert val.
    if lambda == youngTableau {} then lambda = youngTableau hashTable({(opts.RowIndex, 1) => val})
    -- Otherwise, if val is >= the entries in the first row, append it to the end of that row.
    else (if all(values lambda_(opts.RowIndex), filling -> val >= filling) then (
        lambda = youngTableau merge(lambda, hashTable({(opts.RowIndex, #lambda_(opts.RowIndex)+1) => val}),
                                    (i,j) -> j);
    )
    -- If this is not possible, find the leftmost entry y such that y > val.
    -- Replace y with val, and repeat the process on the next row with y.
    else (
        yIdx := (first sort keys selectValues(lambda_(opts.RowIndex), filling -> filling > val))#1;
        y := lambda#(opts.RowIndex, yIdx);
        newBox := hashTable({(opts.RowIndex, yIdx) => val});
        lambda = youngTableau merge(lambda, newBox, (i,j) -> j);
        lambda = rowInsertion(lambda, y, RowIndex => opts.RowIndex+1);
    );
    );
    lambda
)

benderKnuthInvolution = method()
benderKnuthInvolution (YoungTableau, ZZ) := YoungTableau => (lambda, k) -> (
    if not isMember(k, toList(1 ..< (max content lambda))) then error(toString(k) | " must be in the range 1.." | toString((max content lambda) - 1));
    if not isSemiStandard lambda then error("benderKnuthInvolution is only valid when the tableau is semistandard.");

    -- Only keep the cells which contain k or k+1.
    -- Remove columns which contain k and k+1, too.
    -- For each (disjoint) row, swap the lengths of the runs of k and k+1 entries.
    filteredTableau := selectValues(lambda, filling -> isMember(filling, (k, k+1)));
    filteredTableau = filteredTableau^(select(1..numColumns lambda, colIdx -> not isSubset({k, k+1}, content lambda^colIdx)));
    rowIndices := unique(keys filteredTableau / (coords -> coords#0));
    swappedTableau := youngTableau hashTable flatten for rowIdx in rowIndices list (
        row := filteredTableau_rowIdx;
        -- Swap the lengths of the runs of k and k+1.
        colIndices := sort(keys row / (coords -> coords#1));
        kPlusOneRunLength := #(positions(colIndices, colIdx -> row#(rowIdx, colIdx) == k+1));
        -- Swap the lengths of the runs of k and k+1.
        kPlusOneCounter := 0;
        pairs hashTable for colIdx in colIndices list (
            if kPlusOneCounter < kPlusOneRunLength then (
                kPlusOneCounter += 1;
                (rowIdx, colIdx) => k
            )
            else ((rowIdx, colIdx) => k+1)
        )
    );
    merge(lambda, swappedTableau, (i,j) -> j)
)

promotion = method()
promotion YoungTableau := YoungTableau => (lambda) -> (
    if not isStandard lambda then error("promotion is only valid when the tableau is standard.");
    
    fold((tableau, k) -> benderKnuthInvolution(tableau, k), lambda, 1 ..< (max content lambda))
)

evacuation = method()
evacuation YoungTableau := YoungTableau => (lambda) -> (
    if not isSemiStandard lambda then error("evacuation is only valid when the tableau is semi-standard.");
    intermediateInvolution := (initialTableau, m) -> fold((tableau, k) -> benderKnuthInvolution(tableau, k), initialTableau, 1 .. m); 
    fold((tableau, m) -> intermediateInvolution(tableau, m), lambda, reverse(1 ..< (max content lambda)))
)

dualEvacuation = method()
dualEvacuation YoungTableau := YoungTableau => (lambda) -> (
    if not isSemiStandard lambda then error("dualEvacuation is only valid when the tableau is semi-standard.");
    n := max content lambda;
    intermediateInvolution := (initialTableau, m) -> fold((tableau, k) -> benderKnuthInvolution(tableau, n-k), initialTableau, 1 .. m); 
    fold((tableau, m) -> intermediateInvolution(tableau, m), lambda, reverse(1 ..< (max content lambda)))
)


------------------------------------
-- Robinson-Schensted correspondence
------------------------------------
robinsonSchenstedCorrespondence = method()
robinsonSchenstedCorrespondence Permutation := Sequence => (perm) -> (
    insertionTableau := youngTableau youngDiagram {};
    recordingTableau := new MutableHashTable from {};
    for idxValPair in pairs perm do (
        (idx, val) := idxValPair;
        insertionTableau = rowInsertion(insertionTableau, val);

        -- Add a new box to the recording tableau so that its shape matches the 
        -- insertion tableau's.
        missingBoxIdx := first elements((set keys insertionTableau) - (set keys recordingTableau));
        recordingTableau#missingBoxIdx = idx+1; -- 1-indexing correction
    );
    (insertionTableau, youngTableau recordingTableau)
)
robinsonSchenstedCorrespondence (YoungTableau, YoungTableau) := Permutation => (insertionTableau, recordingTableau) -> (
    n := #insertionTableau;
    permutation reverse for idx in reverse(1..n) list (
        -- Move the last-moved box from the forward pass of the algorithm 
        -- back up the insertion tableau until no longer possible.
        boxIdx := first keys selectValues(recordingTableau, val -> val == idx);
        rowIdx := boxIdx#0;

        -- Get rid of the box in the insertion tableau and move the value to 
        -- the queue.
        val := insertionTableau#(boxIdx);
        insertionTableau = youngTableau merge(insertionTableau, hashTable({boxIdx => null}), 
                                              (i,j) -> continue);
        if #insertionTableau == 0 then (val)
        else (
            -- Push the value up the tableau until the top is reached, replacing 
            -- with new values as necessary.
            while rowIdx != 1 do (
                rowIdx -= 1;
                -- Find rightmost entry y in row such that y < val.
                yIdx := (last sort keys selectValues(insertionTableau_rowIdx, filling -> filling < val))#1;
                y := insertionTableau#(rowIdx, yIdx);
                -- Replace y with val, and repeat the process on the next row with y.
                insertionTableau = youngTableau merge(insertionTableau, hashTable({(rowIdx, yIdx) => val}), 
                                                      (i,j) -> j);
                val = y;
            )
        );
        val
    )
)

------------------------------------
-- RSK correspondence
------------------------------------
biword = method()
biword Matrix := Matrix => (M) -> (
        -- Ensure that the entries of the matrix are all non-negative
    if not all (apply(flatten entries M, m -> m >= 0)) then error("The biword of a matrix requires the matrix to only have non-negative entries.");

    -- So, extract the (coordinate, value) pairs of the matrix.
    -- For each coordinate (i,j), the corresponding biword is the matrix 
    -- consisting of the columns (i,j) repeated M_(i,j) times.
    -- Concatenate these sub-biwords together, and then sort the columns lexicographically.
    -- The result is the biword associated with the matrix.
    coordsVals := new HashTable from flatten for rowIdxColumnsPair in pairs entries M list (
        (rowIdx, column) := rowIdxColumnsPair;
        rowIdx += 1;
        for colIdxValPair in pairs column list (
            (colIdx, val) := colIdxValPair;
            colIdx += 1;
            if val != 0 then (((rowIdx, colIdx), val)) else continue
        )
    );
    repeatCoords := (coords, val) -> transpose matrix toList((val:coords) / toList);
    coordsValPairs := pairs coordsVals;
    biword := fold((word, nextEntry) -> word | (repeatCoords(nextEntry#0, nextEntry#1)), 
                   repeatCoords(coordsValPairs#0#0, coordsValPairs#0#1), 
                   coordsValPairs_{1 ..< #coordsValPairs});
    -- There is no built-way to sort a matrix of numbers lexicographically...?
    transpose matrix sort entries transpose biword
)

RSKCorrespondence = method()
-- It is faster to use robinsonSchenstedCorrespondence than to convert the 
-- permutation to a matrix and apply RSKCorrespondence. This is probably due
-- to the computation of the biword in RSKCorrespondence.
RSKCorrespondence Permutation := Sequence => (perm) -> (robinsonSchenstedCorrespondence perm)
RSKCorrespondence Matrix := Sequence => (M) -> (
    -- Set up the algorithm
    biwordM := biword M;
    insertionTableau := youngTableau youngDiagram {};
    recordingTableau := new MutableHashTable from {};
    -- Perform row-insertion using the bottom row of the biword; record new boxes.
    for idxValPair in entries transpose biwordM do (
        (idx, val) := toSequence idxValPair;
        insertionTableau = rowInsertion(insertionTableau, val);

        -- Add a new box to the recording tableau so that its shape matches the 
        -- insertion tableau's.
        missingBoxIdx := first elements((set keys insertionTableau) - (set keys recordingTableau));
        recordingTableau#missingBoxIdx = idx;
    );
    (insertionTableau, youngTableau recordingTableau)
)
RSKCorrespondence (YoungTableau, YoungTableau) := Matrix => (insertionTableau, recordingTableau) -> (
    -- If the tableaux are both standard, this is simply the Robinson-Schensted correspondence.
    if isStandard insertionTableau and isStandard recordingTableau then (
        return robinsonSchenstedCorrespondence(insertionTableau, recordingTableau);
    );
    
    -- Recover the biword from the pair of tableaux.
    groupRecordByVal := new HashTable from for val in unique values recordingTableau list (
        (val, keys selectValues(recordingTableau, filling -> filling == val))
    );
    biwordM := matrix flatten for idx in rsort keys groupRecordByVal list (
        for boxIdx in sort groupRecordByVal#idx list (
            -- Move the last-moved box from the forward pass of the algorithm 
            -- back up the insertion tableau until no longer possible.
            rowIdx := boxIdx#0;

            -- Get rid of the box in the insertion tableau and move the value to 
            -- the queue.
            val := insertionTableau#(boxIdx);
            insertionTableau = youngTableau merge(insertionTableau, hashTable({boxIdx => null}), 
                                                (i,j) -> continue);
            if #insertionTableau == 0 then {idx, val}
            else (
                -- Push the value up the tableau until the top is reached, replacing 
                -- with new values as necessary.
                while rowIdx != 1 do (
                    rowIdx -= 1;
                    -- Find rightmost entry y in row such that y < val.
                    yIdx := (last sort keys selectValues(insertionTableau_rowIdx, filling -> filling < val))#1;
                    y := insertionTableau#(rowIdx, yIdx);
                    -- Replace y with val, and repeat the process on the next row with y.
                    insertionTableau = youngTableau merge(insertionTableau, hashTable({(rowIdx, yIdx) => val}), 
                                                        (i,j) -> j);
                    val = y;
                );
                {idx, val}
            )
        )
    );
    -- Go through the columns of the biword and count how many times (i,j) appears.
    -- This is equal to the entry at position (i,j) in the corresponding matrix.
    counts := tally entries biwordM;
    nrows := max(keys counts / (key -> key#0));
    ncols := max(keys counts / (key -> key#1));
    M := mutableMatrix(ZZ, nrows, ncols);
    for idxValPair in pairs counts do (
        (idx, val) := idxValPair;
        M_(toSequence(idx - {1,1})) = val;
    );
    matrix M
)

------------------------------------
-- Yamanouchi words/Companion map
------------------------------------
yamanouchiWord = method()
yamanouchiWord YoungTableau := List => (lambda) -> (
    -- lambda must be a standard Young tableau
    -- w_i = j if i occurs in the j-th row of lambda
    transposedHashTable := applyPairs(new HashTable from lambda, (coords, val) -> val => coords#0);
    for val in sort keys transposedHashTable list transposedHashTable#val
)

companionMap = method()
companionMap YoungTableau := List => (lambda) -> (
    if not isStandard lambda then (error("companionMap requires a standard Young tableau."););
    yamanouchiWord lambda
)
companionMap List := YoungTableau => (word) -> (
    lambda := new MutableHashTable;
    for rowIdx in unique word do (
        fillings := positions(word, j -> j == rowIdx) / (idx -> idx+1);
        for colIdxFillingPair in pairs fillings do (
            colIdx := colIdxFillingPair#0 + 1;
            filling := colIdxFillingPair#1;
            lambda#(rowIdx, colIdx) = filling;
        )
    );
    lambda = youngTableau lambda;
    if not isWellDefined lambda then (error("companionMap(" | toString(word) | ") does not yield a well-defined Young tableau."););
    if not isStandard lambda then (error(toString(word) | " does not define a standard Young tableau."););
    lambda
)

------------------------------------
-- Miscellaneous
------------------------------------
content YoungTableau := List => (lambda) -> (values lambda)
content (YoungTableau, Sequence) := ZZ => (lambda, coords) -> (lambda#coords)
content (YoungTableau, ZZ, ZZ) := ZZ => (lambda, i, j) -> (lambda#(i,j))

weight = method()
weight YoungTableau := List => (lambda) -> (
    paddedCounts := hashTable toList apply(1..(max content lambda), i -> i => 0);
    paddedCounts = merge(tally content lambda, paddedCounts, (i, j) -> i);
    (sort pairs paddedCounts) / (keyValPair -> keyValPair#1)
)

inversions YoungTableau := List => (T) -> (
    if not isStandard T then error("inversions is only valid when the tableau is standard.");

    rowIndices := sort unique apply(keys T, coords -> coords#0);
    previousContents := set content T_(rowIndices#0);
    flatten for rowIdx in drop(rowIndices, 1) list (
        rowContent := set content T_rowIdx;
        -- for each entry i in the current row, record any pairs where j < i for all the contents in the previous rows
        newInversions := toList select(previousContents**rowContent, (i, j) -> j < i);
        previousContents = union(previousContents, rowContent);
        newInversions
    )
)

sign YoungTableau := ZZ => (T) -> (
    if not isStandard T then error("sign is only valid when the tableau is standard.");

    -- The sign of a standard Young tableau is equal to (-1)^(numInversions readingWord T).
    -- Equivalently, it is equal to (-1)^(numInversions T). However, the latter 
    -- formula seems to be faster to compute on average.
    (-1)^(#(inversions T))
)

descents YoungTableau := Set => (lambda) -> (
    rowIndices := unique apply(keys lambda, coords -> coords#0);
    groupByRow := new HashTable from apply(rowIndices, 
                                           rowIdx -> rowIdx => new HashTable from applyKeys(lambda_rowIdx, coords -> coords#1));
    valuesByRow := applyValues(groupByRow, row -> set values row);
    minIdx := min rowIndices;
    maxIdx := max rowIndices;
    union for rowIdx from minIdx to maxIdx-1 list (
        select(valuesByRow#rowIdx, val -> any(rowIdx+1..maxIdx, otherRowIdx -> isMember(val+1, valuesByRow#otherRowIdx)))
    )
)

majorIndex = method()
majorIndex YoungTableau := ZZ => (lambda) -> (sum descents lambda)

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
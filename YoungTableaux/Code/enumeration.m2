numberStandardYoungTableaux = method()
numberStandardYoungTableaux YoungDiagram := ZZ => lambda -> (
    -- Theorem of Frame-Robinson-Thrall (1954)
    -- Do I need to be careful using // if I know the result is an integer?
    num := (sum shape lambda)!;
    den := product for coords in keys lambda list hookLength(lambda, coords);
    return num // den
)
numberStandardYoungTableaux List := ZZ => lambda -> numberStandardYoungTableaux youngDiagram lambda


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
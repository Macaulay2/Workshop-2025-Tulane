
getFiniteCompletabilityMatrix = method(TypicalValue => Matrix)

isFinitelyCompletable = method(TypicalValue => Boolean)

getFiniteCompletabilityMatrix(ZZ, ZZ, ZZ) := Matrix => (completionRank, rowDim, colDim) ->
getFiniteCompletabilityMatrix(
    completionRank, rowDim, colDim,
    flatten apply(rowDim,x->apply(colDim,y->{x,y}))
    )
getFiniteCompletabilityMatrix(ZZ, ZZ, ZZ, List) := Matrix => (completionRank, rowDim, colDim, edgeList) -> (
    x := getSymbol "x";
    y := getSymbol "y";
    R := QQ(monoid[
        x_(1,1)..x_(rowDim,completionRank),
        y_(1,1)..y_(completionRank,colDim)
    ]); -- Create a ring with (rowDim+colDim)*completionRank variables
    
    A := transpose genericMatrix(R, R_0, completionRank, rowDim);
    B := transpose genericMatrix(R, R_(rowDim*completionRank), colDim, completionRank);

    -- polynomialLists obtained from A, B -> A*B
    polynomialLists := apply(edgeList / toList, pair -> (A * B)_(pair#0, pair#1));
    jacobianList := polynomialLists / jacobian;

    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

isFinitelyCompletable(ZZ, ZZ, ZZ, List) := Boolean => (completionRank, rowDim, colDim, edgeList) -> (
    rank getFiniteCompletabilityMatrix(completionRank, rowDim, colDim, edgeList) == completionRank*(rowDim + colDim - completionRank)
);

getFiniteCompletion = method(Options => {Variable => null}, TypicalValue => Matrix)

isFinitelyCompletable = method(TypicalValue => Boolean)

getFiniteCompletion(ZZ, ZZ, ZZ, List) := Matrix => opts -> (completionRank, rowDim, colDim, edgeList) -> (
    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_((rowDim+colDim)*completionRank)]); -- Create a ring with (rowDim+colDim)*completionRank variables

    -- Return a generic n by r matrix over R, fill with x_1 to x_(n*r)
    A := genericMatrix(R, (gens R)_(0), rowDim, completionRank);
    -- Return a generic r by m matrix over R, fill with x_(n*r+1) to x_(n*m)
    B := genericMatrix(R, (gens R)_((rowDim*completionRank)), completionRank, colDim);

    -- polynomialLists obtained from A, B -> A*B
    polynomialLists := apply(edgeList / toList, pair -> (A * B)_{pair#0, pair#1});
    jacobianList := polynomialLists / jacobian;

    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

isFinitelyCompletable(ZZ, ZZ, ZZ, List) := Boolean => (completionRank, rowDim, colDim, edgeList) -> (
    rank getFiniteCompletion(completionRank, rowDim, colDim, edgeList) == completionRank*(rowDim + colDim - completionRank)
);

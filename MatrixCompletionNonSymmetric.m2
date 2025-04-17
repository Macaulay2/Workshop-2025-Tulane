newPackage(
    "MatrixCompletionNonSymmetric",
    Version => "0.1",
    Authors => {
        {
            Name => "Ryan A. Anderson",
            Email => "raanderson@g.ucla.edu",
            HomePage => "ryan-a-anderson.github.io"
        }
    },
    Headline => "tests finite completability at specified ranks for nonsymmetric incomplete matrices",
    Keywords => {},
    PackageExports => {},
    PackageImports => {},
    DebuggingMode => true
)


------------------------------------------------------------------------------
-- Code
------------------------------------------------------------------------------

getFiniteCompletion = method(Options => {Variable => null}, TypicalValue => Matrix)

isFinitelyCompletable = method(TypicalValue => Boolean)

getFiniteCompletion(ZZ, ZZ, ZZ, List) := Matrix => opts -> (completionRank, rowDim, colDim, edgeList) -> (
    crds := getSymbol toString(opts.Variable);
    R := QQ(monoid[crds_(1) .. crds_(rowDim*colDim)]); -- Create a ring with rowDim * colDim variables

    A := genericMatrix(R, rowDim, completionRank); -- Return a generic n by r matrix over R
    B := genericMatrix(R, completionRank, colDim); -- Return a generic r by m matrix over R

    -- polynomialLists obtained from A, B -> A*B
    polynomialLists := apply(edgeList / toList, pair -> (A * B)_{pair#0, pair#1}); 
    jacobianList := polynomialLists / jacobian;

    -- Folding horizontal concatenation of the jacobian of each polynomial (from each edge)
    transpose fold((a,b) -> a|b, jacobianList)
);

isFinitelyCompletable(ZZ, ZZ, ZZ, List) := Boolean => (completionRank, rowDim, colDim, edgeList) -> (
    rank getFiniteCompletion(completionRank, rowDim, colDim, edgeList) == completionRank*(rowDim + colDim - completionRank)
);

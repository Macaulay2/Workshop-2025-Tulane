TEST ///
    -- (isWellDefined, YoungTableau)
    assert(isWellDefined youngTableau {{1,3,7},{2,4,6},{9,8,5}} == true)
    assert(isWellDefined youngTableau {{1,1,1},{2,2},{3}} == false)
    assert(isWellDefined youngTableau {{1,2,3},{4,5},{6,7},{8,1}} == false)
    assert(isWellDefined youngTableau {{1,2,3},{4,5},{6,7},{8}} == true)
    assert(isWellDefined youngTableau {{1,1,1}} == false)
    assert(isWellDefined youngTableau {{1},{2,3},{4}} == false)
    assert(isWellDefined youngTableau {{9}} == false)
    assert(isWellDefined youngTableau {{1,2,3,7},{4,5,6}} == true)
    assert(isWellDefined youngTableau {{1,2,3},{4,6},{5}} == true)
    assert(isWellDefined youngTableau {{1,2,3},{2,3},{6}} == false)
    assert(isWellDefined youngTableau {{1,1,1,2,3,9},{3,3,3,3,4},{5,7,8},{6},{7}} == false)
///

TEST ///
    -- (isStandard, YoungTableau)
    assert(isStandard youngTableau {{1,3,7},{2,4,6},{9,8,5}} == false)
    assert(isStandard youngTableau {{1,1,1},{2,2},{3}} == false)
    assert(isStandard youngTableau {{1,2,3},{4,5},{6,7},{8,1}} == false)
    assert(isStandard youngTableau {{1,2,3},{4,5},{6,7},{8}} == true)
    assert(isStandard youngTableau {{1,1,1}} == false)
    assert(isStandard youngTableau {{1},{2,3},{4}} == false)
    assert(isStandard youngTableau {{9}} == false)
    assert(isStandard youngTableau {{1,2,3,7},{4,5,6}} == true)
    assert(isStandard youngTableau {{1,2,3},{4,6},{5}} == true)
    assert(isStandard youngTableau {{1,2,3},{2,3},{6}} == false)
    assert(isStandard youngTableau {{1,1,1,2,3,9},{3,3,3,3,4},{5,7,8},{6},{7}} == false)
///

TEST ///
    -- (isSemiStandard, YoungTableau)
    assert(isSemiStandard youngTableau {{1,3,7},{2,4,6},{9,8,5}} == false)
    assert(isSemiStandard youngTableau {{1,1,1},{2,2},{3}} == true)
    assert(isSemiStandard youngTableau {{1,2,3},{4,5},{6,7},{8,1}} == false)
    assert(isSemiStandard youngTableau {{1,2,3},{4,5},{6,7},{8}} == true)
    assert(isSemiStandard youngTableau {{1,1,1}} == true)
    assert(isSemiStandard youngTableau {{1},{2,3},{4}} == false)
    assert(isSemiStandard youngTableau {{9}} == false)
    assert(isSemiStandard youngTableau {{1,2,3,7},{4,5,6}} == true)
    assert(isSemiStandard youngTableau {{1,2,3},{4,6},{5}} == true)
    assert(isSemiStandard youngTableau {{1,2,3},{2,3},{6}} == false)
    assert(isSemiStandard youngTableau {{1,1,1,2,3,9},{3,3,3,3,4},{5,7,8},{6},{7}} == true)
///

TEST ///
    -- rowInsertion
    -- Example taken from https://en.wikipedia.org/wiki/Robinson%E2%80%93Schensted%E2%80%93Knuth_correspondence
    actualTableaux = {youngTableau {{4}},
                      youngTableau {{4,6}},
                      youngTableau {{4,4},
                                    {6}},
                      youngTableau {{4,4,7},
                                    {6}},
                      youngTableau {{4,4,5},
                                    {6,7}},
                      youngTableau {{3,4,5},
                                    {4,7},
                                    {6}},
                      youngTableau {{3,4,4},
                                    {4,5},
                                    {6,7}},
                      youngTableau {{1,4,4},
                                    {3,5},
                                    {4,7},
                                    {6}}}
    runningTableau = youngTableau {{}}
    for idxValPair in pairs {4,6,4,7,5,3,4,1} do (
        (idx, val) = idxValPair;
        runningTableau = rowInsertion(runningTableau, val);
        assert(runningTableau == (actualTableaux#idx))
    )
///

TEST ///
    -- biword
    -- Example taken from https://en.wikipedia.org/wiki/Robinson%E2%80%93Schensted%E2%80%93Knuth_correspondence
    A = matrix {{1,0,2},{0,2,0},{1,1,0}}
    actualBiword = matrix {{1,1,1,2,2,3,3},
                           {1,3,3,2,2,1,2}}
    assert((biword A) == actualBiword)

    -- Another example taken from https://en.wikipedia.org/wiki/Robinson%E2%80%93Schensted%E2%80%93Knuth_correspondence
    A = matrix {{0,0,0,0,0,0,0},
                {0,0,0,1,0,1,0},
                {0,0,0,1,0,0,0},
                {0,0,0,0,0,0,1},
                {0,0,0,0,1,0,0},
                {0,0,1,1,0,0,0},
                {0,0,0,0,0,0,0},
                {1,0,0,0,0,0,0}}
    actualBiword = matrix {{2,2,3,4,5,6,6,8},
                           {4,6,4,7,5,3,4,1}}
    assert((biword A) == actualBiword)
///

TEST ///
    -- RSK Correspondence
    -- The facts taken in this test are from https://www.symmetricfunctions.com/rsk.htm
    -- and https://en.wikipedia.org/wiki/Robinson%E2%80%93Schensted%E2%80%93Knuth_correspondence

    -- Example taken from https://en.wikipedia.org/wiki/Robinson%E2%80%93Schensted%E2%80%93Knuth_correspondence
    A = matrix {{1,0,2},{0,2,0},{1,1,0}}
    actualP = youngTableau {{1,1,2,2},
                            {2,3},
                            {3}}
    actualQ = youngTableau {{1,1,1,3},
                            {2,2},
                            {3}}
    assert((RSKCorrespondence A) === (actualP, actualQ))
    assert((RSKCorrespondence(actualP, actualQ)) == A)


    -- Another example taken from https://en.wikipedia.org/wiki/Robinson%E2%80%93Schensted%E2%80%93Knuth_correspondence
    A = matrix {{0,0,0,0,0,0,0},
                {0,0,0,1,0,1,0},
                {0,0,0,1,0,0,0},
                {0,0,0,0,0,0,1},
                {0,0,0,0,1,0,0},
                {0,0,1,1,0,0,0},
                {0,0,0,0,0,0,0},
                {1,0,0,0,0,0,0}}
    actualP = youngTableau {{1,4,4},
                            {3,5},
                            {4,7},
                            {6}}
    actualQ = youngTableau {{2,2,4},
                            {3,5},
                            {6,6},
                            {8}}
    assert((RSKCorrespondence A) === (actualP, actualQ))
    -- assert((RSKCorrespondence(actualP, actualQ)) == A)

    -- FACT: RSK is a bijection
    M = random(ZZ^4, ZZ^5)
    -- assert((RSKCorrespondence RSKCorrespondence M) == M)

    -- FACT: For a matrix M, RSK(M) = (P,Q)   <=>   RSK(M^T) = (Q,P).
    (P, Q) = RSKCorrespondence M
    assert((RSKCorrespondence transpose M) === (Q, P))

    -- Suppose p is a permutation.
    p = permutation random toList(1..6)
    (P, Q) = RSKCorrespondence p
    
    -- FACT: RSK(p) = (P,Q), then RSK(p^-1) = (Q,P).
    assert((RSKCorrespondence inverse p) === (Q, P))
    
    -- FACT: RSK(rev(p)) = (P^T, evacuation(Q)^T).
    assert((RSKCorrespondence reverse p) === (transpose P, transpose evacuation Q))
    
    -- Theorem 4.3 of [R04]: sign(rw(T)) = sign(P) * sign(Q) * (-1)^e, where e is the sum of
    -- the even-indexed rows of P.
    evenIndices = select(1..(#(shape P)+1), even)
    assert((sign p) == ((sign P) * (sign Q) * (-1)^(#(P_evenIndices))))

    -- Example 4.4 from [R04]
    p = permutation {2,9,1,5,6,4,8,3,7}
    actualP = youngTableau {{1,3,6,7},
                            {2,4,8},
                            {5},
                            {9}}
    actualQ = youngTableau {{1,2,5,7},
                            {3,4,9},
                            {6},
                            {8}}
    (P, Q) = RSKCorrespondence p
    assert((P == actualP) and (Q == actualQ))
    evenIndices = select(1..(#(shape P)+1), even)
    assert((sign p) == ((sign P) * (sign Q) * (-1)^(#(P_evenIndices))))
///

TEST ///
    -- inversions
    -- FACT: For a standard Young tableau, the inversion set of its row word is
    -- the same as the inversion set of the tableau.
    T = youngTableau {{1,3,6,7},
                      {2,4,8},
                      {5},
                      {9}}
    p = permutation rowWord T
    inversionsOfRowWord = set (apply(inversions p, idxPair -> rsort (p_(idxPair / (i -> i-1)))) / toSequence)
    assert((set inversions T) == inversionsOfRowWord)

    -- Example 4.4 of [R04]
    P = youngTableau {{1,3,6,7},
                      {2,4,8},
                      {5},
                      {9}}
    computedInversions = inversions P
    assert(#computedInversions == 8)
    actualInversions = {(6,2), (7,2), (6,4), (7,4), (3,2), (6,5), (7,5), (8,5)}
    assert(set computedInversions == set actualInversions)

    Q = youngTableau {{1,2,5,7},
                      {3,4,9},
                      {6},
                      {8}}
    computedInversions = inversions Q
    assert(#computedInversions == 7)
    actualInversions = {(5,3), (5,4), (7,3), (7,4), (9,6), (7,6), (9,8)}
    assert(set computedInversions == set actualInversions)
///

TEST ///
    -- sign
    -- Example 4.4 of [R04]
    P = youngTableau {{1,3,6,7},
                      {2,4,8},
                      {5},
                      {9}}
    assert((sign P) == 1)

    Q = youngTableau {{1,2,5,7},
                      {3,4,9},
                      {6},
                      {8}}
    assert((sign Q) == -1)
///
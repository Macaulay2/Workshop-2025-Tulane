-- Test: rank of full-observation matrix matches formula r*(n+m-r)
TEST ///
    assert(rank getFiniteCompletabilityMatrix(2, 5, 4) == 2*(5 + 4 - 2))
    assert(rank getFiniteCompletabilityMatrix(1, 3, 3) == 1*(3 + 3 - 1))
///

-- Test: twoGlueK33 is finitely completable for r=1
TEST ///
    twoGlueK33 = {
        {0,0},{0,1},{0,2},
        {1,0},{1,1},{1,2},
        {2,0},{2,1},{2,3},{2,4},
        {3,2},{3,3},{3,4},
        {4,2},{4,3},{4,4}};
    assert(isFinitelyCompletable(1, 5, 5, twoGlueK33) === true)
///

-- Test: output matrix has correct dimensions
TEST ///
    E = {{0,0},{0,1},{1,0},{1,1}};
    r = 1; n = 2; m = 2;
    M = getFiniteCompletabilityMatrix(r, n, m, E);
    assert(numrows M == #E)
    assert(numcols M == r*(n + m))
///

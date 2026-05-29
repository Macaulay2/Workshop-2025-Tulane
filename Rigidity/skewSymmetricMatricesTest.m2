-- Test: matrix dimensions and rank for a triangle with r=2
TEST ///
    r = 2; n = 3;
    L = {{0,1},{1,2},{2,0}};
    M = getSkewSymmetricCompletionMatrix(r, n, L);
    assert(numrows M == #L)
    assert(numcols M == r*n)
    assert(rank M == r*n - (r*(r+1))//2)
///

-- Test: known spanning and non-spanning cases
TEST ///
    -- K_{3,3} with r=2 is not spanning
    G = completeMultipartiteGraph({3,3});
    assert(isSpanningInSkewSymmetricCompletionMatroid(2, G) === false)
    -- K_4 with r=4 is spanning
    G = completeGraph 4;
    assert(isSpanningInSkewSymmetricCompletionMatroid(4, G) === true)
///

-- Test: odd rank throws an error
TEST ///
    assert(try (getSkewSymmetricCompletionMatrix(3, 4); false) else true)
///

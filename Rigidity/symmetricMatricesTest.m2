TEST ///

    -- testing a known example (d = 1: expect rank 3, true)
    n = 3; d = 1;
    E = {set {0}, set {0,1}, set{1,2}, set{2}}
    M = getSymmetricCompletionMatrix(d, n, E, Variable => x);
    assert (rank M == 3)
    assert (isSpanningInSymmetricCompletionMatroid(d, n, E) == true)
    -- testing a known example (d = 2: expect rank 4, false)
    d = 2;
    M = getSymmetricCompletionMatrix(d, n, E, Variable => x);
    assert (rank M == 4)
    assert (isSpanningInSymmetricCompletionMatroid(d, n, E) == false)

    -- compare list and graph (expect same value)
    d = 1;
    E = {set{0, 1}};
    G = completeGraph(2);
    assert (isSpanningInSymmetricCompletionMatroid(d, n, E) == isSpanningInSymmetricCompletionMatroid(d, G))

    d = 3;
    n = 6;
    G = completeGraph(n);
    E = edges G;
    assert (isSpanningInSymmetricCompletionMatroid(d, n, E) == isSpanningInSymmetricCompletionMatroid(d, G))


///

-- Test: matrix dimensions; K_4 does not span for r=2 (too few edges)
TEST ///
    r = 2; n = 4;
    G = completeGraph n;
    M = getSymmetricCompletionMatrix(r, G);
    assert(numrows M == #edges G)
    assert(numcols M == r*n)
    assert(not isSpanningInSymmetricCompletionMatroid(r, G))
///

-- Test: complete graph default matches explicit edge list (same rank and dimensions)
TEST ///
    r = 3; n = 5;
    M1 = getSymmetricCompletionMatrix(r, n);
    M2 = getSymmetricCompletionMatrix(r, n, subsets(toList(0..(n-1)), 2));
    assert(numrows M1 == numrows M2)
    assert(numcols M1 == numcols M2)
    assert(rank M1 == rank M2)
///
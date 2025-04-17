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
TEST ///
    -- numberStandardYoungTableaux
    assert(numberStandardYoungTableaux {4,2,1} == 35)
    -- Let f^\lambda be the number of standard Young tableaux of shape \lambda.
    -- FACT: sum_(\lambda \vdash n) (f^\lambda)^2 = n!.
    for n in 1..10 do (
        leftSum = sum(partitions n, lambda -> (numberStandardYoungTableaux youngDiagram lambda)^2);
        assert(leftSum == n!)
    )

    -- FACT: Let d_\lambda(m) be the number of semistandard Young tableaux of 
    --       shape lambda with content valued in [m]. Then
    --       sum_(\lambda \vdash n) f^lambda * d_\lambda(m) = m^n.

    -- FACT: sum_(lambda \vdash n) f^lambda = sum_{k=0}^{floor(n/2)} \frac{n!}{(n-2k)! 2^k k!}
    for n in 1..10 do (
        leftSum = sum(partitions n, lambda -> numberStandardYoungTableaux youngDiagram lambda);
        rightSum = sum(floor(n/2)+1, k -> (n! // ((n-2*k)! * 2^k * k!)));
        assert(leftSum == rightSum)
    )
///

TEST ///
    -- allStandardYoungTableaux
    -- The number of 2xn SYT is C_n, the n-th Catalan number.
    for n in 1..5 do (
        lambda = youngDiagram (n:2);
        assert(#(allStandardYoungTableaux lambda) == binomaial(2*n, n) // (n+1))
    )

    -- FACT: Let f(n) = |SYT(n)|. Then the following recurrence relation holds:
    --       f(n) = f(n-1) + (n-1) * f(n-2).
    assert(allStandardYoungTableaux 5 == allStandardYoungTableaux 4 + 4 * allStandardYoungTableaux 3)

    -- The number of tableaux generated should agree with the hook-length
    -- formualtion used in numberStandardYoungTableaux.
    lambda = {4,3,1}
    assert(#allStandardYoungTableaux lambda == numberStandardYoungTableaux lambda)
///

TEST ///
    -- filledSYT
    for n in 1..5 do (
        partitionsList = (partitions n) / toList;
        for lambda in partitionsList do (
            assert(#(filledSYT lambda) == (numberStandardYoungTableaux youngDiagram lambda))
        )
    )
///
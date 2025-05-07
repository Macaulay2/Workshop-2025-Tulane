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
    -- filledSYT
    for n in 1..5 do (
        partitionsList = (partitions n) / toList;
        for lambda in partitionsList do (
            assert(#(filledSYT lambda) == (numberStandardYoungTableaux youngDiagram lambda))
        )
    )
///
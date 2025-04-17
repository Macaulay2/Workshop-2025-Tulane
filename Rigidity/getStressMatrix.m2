getStressMatrix = method(Options => {Variable => "x"}, TypicalValue => Matrix)

-- Core function
getStressMatrix(ZZ, List) := Matrix => opts -> (d, Gr) -> (
    G := Gr/toList;
    n := # unique join(toSequence G);
    -- Left kernel of the rigidity matrix
    tRigidityMatrix := transpose getRigidityMatrix(d, G, Variable => "x");
    R := ring tRigidityMatrix;
    tRigidityMatrixRational := sub(tRigidityMatrix, frac R);
    stressBasis := mingens ker tRigidityMatrixRational;
    -- New symbolic variables for each element in the basis of the left kernel
    auxiliaryVarCount := numgens source stressBasis;
    if auxiliaryVarCount == 0
    then (
        stressMatrixZero := mutableMatrix(R, n, n);
        matrix(stressMatrixZero)
    )
    else (
        y := symbol y;
        auxiliaryRing := frac(QQ[gens R, y_1..y_auxiliaryVarCount]);
        -- Symbolic linear combination of elements in the basis of the left kernel
        stressBasisLinearSum := 0;
        for i from 1 to auxiliaryVarCount do (
            stressBasisLinearSum = stressBasisLinearSum + y_i * sub(submatrix(stressBasis, {i - 1}), auxiliaryRing);
        );
        -- Build the symbolic stress matrix from the symbolic linear combination
        stressMatrix := mutableMatrix(auxiliaryRing, n, n);
        for i from 0 to (#G - 1) do (
            edge := G#i;
            stressMatrix_(edge#0, edge#1) = stressBasisLinearSum_(i, 0);
            stressMatrix_(edge#1, edge#0) = stressBasisLinearSum_(i, 0);
        );
        stressMatrixEntries := entries stressMatrix;
        for i from 0 to (n - 1) do (
            stressMatrix_(i, i) = -sum(stressMatrixEntries#i);
        );
        matrix(stressMatrix)
    )
);

-- List of edges not given -> use complete graph
getStressMatrix(ZZ, ZZ) := Matrix => opts -> (d, n) -> (
    getStressMatrix(d, subsets(toList(0..(n-1)), 2), opts)
);

-- Input a Graph instead of edge set without number of vertices -> get number of vertices from graph
getStressMatrix(ZZ, Graph) := Matrix => opts -> (d, G) -> (
    getStressMatrix(d, edges G, opts)
);
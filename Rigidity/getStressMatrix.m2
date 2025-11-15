getStressMatrix = method(TypicalValue => Matrix)

-- Core function
getStressMatrix(ZZ, List) := Matrix => (d, Gr) -> (
    G := Gr/toList;
    n := # unique join(toSequence G);
    -- Left kernel of the rigidity matrix
    tRigidityMatrix := transpose getRigidityMatrix(d, G);
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
        y := getSymbol "y";
        auxiliaryRing := frac(QQ[gens R, y_0..y_(auxiliaryVarCount-1)]);
	y = drop(gens auxiliaryRing, numgens R);
        -- Symbolic linear combination of elements in the basis of the left kernel
        stressBasisLinearSum := sum(auxiliaryVarCount, i -> y_i * sub(stressBasis_{i}, auxiliaryRing));
        -- Build the symbolic stress matrix from the symbolic linear combination
        stressMatrix := mutableMatrix(auxiliaryRing, n, n);
        scan(#G, i->(
            edge := G#i;
            stressMatrix_(edge#0, edge#1) = stressBasisLinearSum_(i, 0);
            stressMatrix_(edge#1, edge#0) = stressBasisLinearSum_(i, 0);
        ));
        stressMatrixEntries := entries stressMatrix;
        scan(n, i->(
            stressMatrix_(i, i) = -sum(stressMatrixEntries#i);
        ));
        matrix stressMatrix
    )
);

-- List of edges not given -> use complete graph
getStressMatrix(ZZ, ZZ) := Matrix => (d, n) -> getStressMatrix(d, subsets(n, 2))

-- Input a Graph instead of edge set without number of vertices -> get number of vertices from graph
getStressMatrix(ZZ, Graph) := Matrix => (d, G) -> getStressMatrix(d, edges G)

doc ///
    Key
        getFiniteCompletabilityMatrix
        (getFiniteCompletabilityMatrix, ZZ, ZZ, ZZ)
        (getFiniteCompletabilityMatrix, ZZ, ZZ, ZZ, List)
    Headline
        constructs the finite completability matrix for a partially observed matrix
    Usage
        getFiniteCompletabilityMatrix(r, n, m)
        getFiniteCompletabilityMatrix(r, n, m, E)
    Inputs
        r : ZZ
            the target completion rank
        n : ZZ
            number of rows of the matrix to be completed
        m : ZZ
            number of columns of the matrix to be completed
        E : List
            of pairs {\tt \{i, j\}} indicating which entries are observed;
            if omitted, all entries are assumed observed
    Outputs
        : Matrix
            the Jacobian matrix whose rank determines finite completability
    Description
        Text
            Given a partially observed $n \times m$ matrix with observed entries indexed by $E$,
            this function constructs the matrix whose rank detects whether the observed entries
            are finitely completable to a rank-$r$ matrix.

            The matrix is the Jacobian of the map $(A, B) \mapsto (AB)_{(i,j) \in E}$,
            where $A$ is a generic $n \times r$ matrix and $B$ is a generic $r \times m$ matrix.
            The observed entries are finitely completable to a rank-$r$ matrix if and only if
            this Jacobian has rank $r(n + m - r)$.
        Example
            getFiniteCompletabilityMatrix(2, 5, 4)
            rank oo == 2*(5 + 4 - 2)
        Example
            E = {{0,0},{0,1},{1,0},{1,1},{2,0},{2,1}};
            getFiniteCompletabilityMatrix(1, 3, 2, E)
///

doc ///
    Key
        isFinitelyCompletable
        (isFinitelyCompletable, ZZ, ZZ, ZZ, List)
    Headline
        tests whether a partially observed matrix is finitely completable to a given rank
    Usage
        isFinitelyCompletable(r, n, m, E)
    Inputs
        r : ZZ
            the target completion rank
        n : ZZ
            number of rows
        m : ZZ
            number of columns
        E : List
            of pairs {\tt \{i, j\}} indicating which entries are observed
    Outputs
        : Boolean
            {\tt true} if the observed entries are finitely completable to a rank-$r$ matrix
    Description
        Text
            Returns {\tt true} if a generic $n \times m$ matrix with entries observed at
            positions $E$ is finitely completable to a rank-$r$ matrix, i.e., if there are
            only finitely many rank-$r$ completions consistent with the observed entries.

            Equivalently, returns {\tt true} if the rank of @TO getFiniteCompletabilityMatrix@
            equals $r(n + m - r)$.
        Example
            E = {{0,0},{0,1},{0,2},{1,0},{1,1},{1,2},{2,0},{2,1},{2,3},{2,4},{3,2},{3,3},{3,4},{4,2},{4,3},{4,4}};
            isFinitelyCompletable(1, 5, 5, E)
    SeeAlso
        getFiniteCompletabilityMatrix
///

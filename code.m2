newtonIdentitySums = method()
-- newtonIdentitySums takes in an integer k and n and returns list of the 1,2,,...,kth sum of powers in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentitySums(ZZ,Ring) := List => (k,R) -> (
    -- I'll tell M2 that I'm using these as symbols for elementary polynomials and the sum of power polynomials
    if k < 1 then error "n and k need to be positive integers";
   -- e = symbol "e";
    --p = symbol "p";
    use R;
    for i from 0 to k list ( sum((for j from 1 to i-1 list (-1)^(i-1+j)*e_(i-j)*p_j) |  {(-1)^(i-1)*i*e_i}))
)
newtonIdentitySums(ZZ) := List => k -> newtonIdentity(k, QQ[e_0..e_k, p_0..p_k])

newtonIdentitySymmetry = method()
-- newtonIdentitySymmetry takes in an integer k and n and returns list of the 1,2,,...,kth elementary symmetric polynomials in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentitySymmetry(ZZ, Ring) := List => (k, R) -> (
    if k < 1 then error "k need to be positive integers";
    use R;
    ({1_R} | (for i from 1 to k list (1/i)*(sum((for j from 1 to i list (-1)^(j-1)*e_(i-j)*p_j)))))
)
newtonIdentitySymmetry(ZZ) := List => k -> newtonIdentitySymmetry(k, QQ[e_0..e_k, p_0..p_k])

solveGaussianSystem = method()
-- Takes in a matrix A describing the system of moment equations (these are in terms of sums of powers of variables), and the moments list m.
-- Returns values for the elementary symmetric polynomials e_i evaluated at the roots of the system.
solveGaussianSystem(Matrix, List, Ring) := List => (A, m, R) -> (
    -- Should check if its lower diagonal
    use R;
    n := numRows A;
    psSolved := solve(A**QQ,(transpose matrix {m})**QQ);
    newtonIds := newtonIdentitySymmetry(n);
    subvalues := mutableMatrix(1 | (vars R)_{1..n} | 1 | transpose psSolved);
    partialSolveNewtonIds := apply(newtonIds, e -> sub(e,matrix subvalues));
    for idx from 0 to length partialSolveNewtonIds - 1 list subvalues_(0,idx) = sub(partialSolveNewtonIds_idx, matrix subvalues)
)
solveGaussianSystem(Matrix, List) := List => (A, m) -> solveGaussianSystem(A, m, QQ[e_0..e_(numRows A), p_0..p_(numRows A)])
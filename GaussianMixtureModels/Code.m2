produceMomentSystemMatrices = method()
-*
The function produces the matrix being multiplied to [P,P^2,...,P^k]^T and the constant term
Input: k - number of P's of ZZ
       variance - sigma^2 of QQ
Output: k by k matrix and a k by 1 matrix
*-
produceMomentSystemMatrices (ZZ,QQ) := (k,variance) -> (
    if not k > 0 then error "k should be a positive integer";
    if k == 1 then return matrix{{0,1}};
    if k == 2 then return matrix{{0,1,0},{variance,0,1}};
    M := new MutableMatrix from map(QQ^(k),QQ^(k+1),0);
    M0 := produceMomentSystemMatrices(2,variance);
    scan(2,i -> (scan(3, j -> M_(i,j) = M0_(i,j))));
    scan(toList (2..(k-1)),i -> (
	    shiftedRow := shiftingRow (matrix M)^{i-1};
	    newRow := shiftedRow + i*variance*((matrix M)^{i-2});
	    newRow = flatten entries newRow;
	    scan(k+1,j ->(
		    M_(i,j) = newRow_j;
		    )))
	);
    ((1/k)*((matrix M)_{1..(numColumns M - 1)}),(matrix M)_{0})
    )

shiftingRow = method()
shiftingRow Matrix := M -> (
    n := numColumns M;
    (matrix{{0} | flatten entries M})_{0..(n-1)}
    )

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

solvePowerSystem = method()
-- Takes in a matrix A describing the system of moment equations (these are in terms of sums of powers of variables), and the moments list m.
-- Returns values for the elementary symmetric polynomials e_i evaluated at the roots of the system.
solvePowerSystem(Matrix, List, Ring) := List => (A, m, R) -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    if rank A != numRows A then error "Matrix A is not full rank";
    use R;
    n := numRows A;
    psSolved := solve(A**QQ,(transpose matrix {m})**QQ);
    newtonIds := newtonIdentitySymmetry(n);
    subvalues := mutableMatrix(1 | (vars R)_{1..n} | 1 | transpose psSolved);
    partialSolveNewtonIds := apply(newtonIds, e -> sub(e,matrix subvalues));
    solvedEs := for idx from 0 to length partialSolveNewtonIds - 1 list subvalues_(0,idx) = sub(partialSolveNewtonIds_idx, matrix subvalues);
    use QQ[y];
    f := sum(for i from 0 to n list (-1)^(i)*(lift(solvedEs_i,QQ))*y^(n-i));
    roots(f)
)
solvePowerSystem(Matrix, List) := List => (A, m) -> solvePowerSystem(A, m, QQ[e_0..e_(numRows A), p_0..p_(numRows A)])
solvePowerSystem(List) := List => m -> (
    n := length m;
    solvePowerSystem(map(ZZ^n, ZZ^n, 1),m)
)

produceMomentSystemMatrices = method()
-*
The function produces the matrix being multiplied to [P,P^2,...,P^k]^T and the constant term
Input: k - number of P's of ZZ
       variance - sigma^2 of QQ
Output: k by k matrix and a k by 1 matrix
*-
produceMomentSystemMatrices (ZZ,QQ) := (k,variance) -> (
    if not k > 0 then error "k should be a positive integer";
    if k == 1 then return (matrix{{1}},matrix{{0}});
    if k == 2 then return ((1/2)*(matrix{{1,0},{0,1}}),matrix{{0},{variance}});
    M := new MutableMatrix from map(QQ^(k),QQ^(k+1),0);
    M0 := matrix{{0,1,0},{variance,0,1}};
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
produceMomentSystemMatrices(ZZ,ZZ) := (k, variance) -> (
    produceMomentSystemMatrices(k, promote(variance,QQ))
)

shiftingRow = method()
shiftingRow Matrix := M -> (
    n := numColumns M;
    (matrix{{0} | flatten entries M})_{0..(n-1)}
    )

fabricateMoments = method()
fabricateMoments List := mu -> (
    k := #mu;
    powerSumList := apply(k, i->sum(apply(mu, u -> u^(i+1))));
    (A,B) := produceMomentSystemMatrices(k, 1/1);
    A*(transpose matrix({powerSumList}))+B
)

newtonIdentitySums = method()
-- newtonIdentitySums takes in an integer k and n and returns list of the 1,2,,...,kth sum of powers in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentitySums(ZZ,Ring) := List => (k,R) -> (
    -- I'll tell M2 that I'm using these as symbols for elementary polynomials and the sum of power polynomials
    if k < 1 then error "n and k need to be positive integers";
    e := local e;
    p := local p;
    use R;
    for i from 0 to k list ( sum((for j from 1 to i-1 list (-1)^(i-1+j)*e_(i-j)*p_j) |  {(-1)^(i-1)*i*e_i}))
)
newtonIdentitySums(ZZ) := List => k -> (
    e := local e;
    p := local p;
    newtonIdentitySums(k, QQ[e_0..e_k, p_0..p_k])
)

newtonIdentitySymmetry = method()
-- newtonIdentitySymmetry takes in an integer k and n and returns list of the 1,2,,...,kth elementary symmetric polynomials in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentitySymmetry(ZZ, Ring) := List => (k, R) -> (
    if k < 1 then error "k need to be positive integers";
    use R;
    maxIdx := (numColumns vars R) // 2;
    p := i -> if i < maxIdx then R_(i+maxIdx) else error("Index out of bounds");
    e := i -> if i < maxIdx then R_(i) else error("Index out of bounds");
    ({1_R} | (for i from 1 to k list (1/i)*(sum((for j from 1 to i list (-1)^(j-1)*e(i-j)*p(j))))))
)
newtonIdentitySymmetry(ZZ) := List => k -> (
    e := local e;
    p := local p;
    newtonIdentitySymmetry(k, QQ[e_0..e_k, p_0..p_k])
)

solvePowerSystem = method()
-- Takes in a matrix A describing the system of moment equations (these are in terms of sums of powers of variables), and the moments list m.
-- Returns values for the elementary symmetric polynomials e_i evaluated at the roots of the system.
solvePowerSystem(Matrix, List, Ring) := List => (A, m, R) -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    --if rank A != numRows A then error "Matrix A is not full rank"; This slows down computation a lot!
    solvedEs := getSymmetricPolynomialEvals(A, m, R);
    y := local y;
    use RR[y];
    n := numRows A;
    p := map(RR, R, matrix {toList(numColumns(vars R):0)});
    f := sum(for i from 0 to n list (-1)^(i)*(p(solvedEs_i))*y^(n-i));
    roots(f)
)
solvePowerSystem(Matrix, List) := List => (A, m) -> (
    e := local e;
    p := local p;
    solvePowerSystem(A, m, RR[e_0..e_(numRows A), p_0..p_(numRows A)])
)
solvePowerSystem(List) := List => m -> (
    n := length m;
    solvePowerSystem(map(ZZ^n, ZZ^n, 1),m)
)

getSymmetricPolynomialEvals = method()
getSymmetricPolynomialEvals(Matrix, List, Ring) := List => (A, m, R) -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    --if rank A != numRows A then error "Matrix A is not full rank"; This slows down computation a lot!
    use R;
    n := numRows A;
    solvedPs := solve(A**RR,(transpose matrix {m})**RR, MaximalRank => true);
    newtonIds := newtonIdentitySymmetry(n,R);
    subvalues := mutableMatrix(1_R | (vars R)_{1..n} | 1_R | (transpose solvedPs));
    partialNewtonIds := apply(newtonIds, e -> sub(e,matrix subvalues));
    for idx from 0 to length partialNewtonIds - 1 list subvalues_(0,idx) = sub(partialNewtonIds_idx, matrix subvalues)
)
getSymmetricPolynomialEvals(Matrix, List) := List => (A, m) -> (
    e := local e;
    p := local p;
    getSymmetricPolynomialEvals(A, m, RR[e_0..e_(numRows A), p_0..p_(numRows A)]
    )
)

getPowerSystem = method()
getPowerSystem(Matrix, List) := List => (A, m) -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    if rank A != numRows A then error "Matrix A is not full rank";
    n := numRows A;
    p := local p;
    x := local x;
    R := RR[p_1..p_n];
    S := RR[x_1..x_n];
    f := map(S,R, matrix{for i from 1 to n list (sum(for j from 1 to n list x_j^i))});
    flatten entries f(A*(transpose vars R) - transpose matrix {m})
)

getStartSystem = method()
getStartSystem(List,List) := (targetSystem,sols) -> (
    S := ring first targetSystem;
    targetSystem - (map(QQ,S,sols) \ targetSystem)
    )

getPowerSystemDiscriminant = method()
getPowerSystemDiscriminant(Matrix) := RingElement => A -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    if rank A != numRows A then error "Matrix A is not full rank";
    n := numRows A;
    e:= local e;
    p := local p;
    m := local m;
    R := QQ[e_0..e_n, p_0..p_n, m_1..m_n];
    mvec := toList(m_1..m_n);
    solvedPs := inverse(A**QQ)*(transpose matrix {mvec});
    newtonIds := newtonIdentitySymmetry(n);
    subvalues := mutableMatrix(1 | (vars(R))_{1..n} | 1 | transpose solvedPs);
    partialNewtonIds := apply(newtonIds, e -> sub(e,matrix subvalues));
    solvedEs := for idx from 0 to length partialNewtonIds - 1 list subvalues_(0,idx) = sub(partialNewtonIds_idx, matrix subvalues | matrix {mvec});
    y := local y;
    use R[y];
    f := sum(for i from 0 to n list (-1)^(i)*(solvedEs_i)*y^(n-i));
    discr := discriminant(f, y);
    S := QQ[m_1..m_n];
    auxiliaryVars := gens(QQ[e_0..e_n, p_0..p_n]);
    varsM := gens S;
    projection := map(S, R, toList apply(auxiliaryVars, x -> 0) | toList varsM);
    projection(discr)
)
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
newtonIdentitySums(ZZ) := List => k -> newtonIdentitySums(k, QQ[e_0..e_k, p_0..p_k])

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
    solvedEs := getSymmetricPolynomialEvals(A, m, R);
    use RR[y];
    n := numRows A;
    p := map(RR, R, matrix {toList(numColumns(vars R):0)});
    f := sum(for i from 0 to n list (-1)^(i)*(p(solvedEs_i))*y^(n-i));
    roots(f)
)
solvePowerSystem(Matrix, List) := List => (A, m) -> solvePowerSystem(A, m, RR[e_0..e_(numRows A), p_0..p_(numRows A)])
solvePowerSystem(List) := List => m -> (
    n := length m;
    solvePowerSystem(map(ZZ^n, ZZ^n, 1),m)
)

getSymmetricPolynomialEvals = method()
getSymmetricPolynomialEvals(Matrix, List, Ring) := List => (A, m, R) -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    if rank A != numRows A then error "Matrix A is not full rank";
    use R;
    n := numRows A;
    psSolved := solve(A**RR,(transpose matrix {m})**RR, MaximalRank => true);
    newtonIds := newtonIdentitySymmetry(n);
    subvalues := mutableMatrix(1_R | (vars R)_{1..n} | 1_R | (transpose psSolved));
    partialSolveNewtonIds := apply(newtonIds, e -> sub(e,matrix subvalues));
    for idx from 0 to length partialSolveNewtonIds - 1 list subvalues_(0,idx) = sub(partialSolveNewtonIds_idx, matrix subvalues)
)
getSymmetricPolynomialEvals(Matrix, List) := List => (A, m) -> getSymmetricPolynomialEvals(A, m, RR[e_0..e_(numRows A), p_0..p_(numRows A)])

getPowerSystem = method()
getPowerSystem(Matrix, List) := List => (A, m) -> (
    if numColumns A != numColumns A then error "Matrix A is not square";
    if rank A != numRows A then error "Matrix A is not full rank";
    n := numRows A;
    R := QQ[p_1..p_n];
    S := QQ[x_1..x_n];
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
    R := QQ[e_0..e_n, p_0..p_n, m_1..m_n];
    mvec := toList(m_1..m_n);
    psSolved := inverse(A**QQ)*(transpose matrix {mvec});
    newtonIds := newtonIdentitySymmetry(n);
    subvalues := mutableMatrix(1 | (vars(R))_{1..n} | 1 | transpose psSolved);
    partialSolveNewtonIds := apply(newtonIds, e -> sub(e,matrix subvalues));
    solvedEs := for idx from 0 to length partialSolveNewtonIds - 1 list subvalues_(0,idx) = sub(partialSolveNewtonIds_idx, matrix subvalues | matrix {mvec});
    use R[y];
    f := sum(for i from 0 to n list (-1)^(i)*(solvedEs_i)*y^(n-i));
    discr = discriminant(f, y);
    S = QQ[m_1..m_n];
    auxiliaryVars = gens(QQ[e_0..e_n, p_0..p_n]);
    varsM = gens S;
    projection = map(S, R, toList apply(auxiliaryVars, x -> 0) | toList varsM);
    projection(discr)
)

-*
- Hill Climbing Algorithm
*- 
HillClimber = new Type of MutableHashTable
HillClimber.synonym = "a hill climber"
HillClimber.GlobalAssignHook = globalAssignFunction
HillClimber.GlobalReleaseHook = globalReleaseFunction

-- constructor method for HillClimber
hillClimber = method (
    TypicalValue => HillClimber,
    Options => {
        StepSize => 0.2,
        NumDirections => 10
    }
)

hillClimber(FunctionClosure, FunctionClosure, List) := HillClimber => opts -> (lossFunction, stopCondition, startingPoint) -> (
    new HillClimber from {
        LossFunction => lossFunction,
        StopCondition => stopCondition,
        StartingPoint => startingPoint,
        CurrentPoint => startingPoint,
        CurrentStep => 1,
        StepSize => opts#StepSize,
        NumDirections => opts#NumDirections,
        symbol cache => new CacheTable
    }
) 

-- need isWellDefined

nextStep = method()
nextStep(HillClimber) := List => (hC) -> (
    ambientDim := length hC#StartingPoint;
    randPoints := matrix for i from 1 to hC#NumDirections list (
        for j from 1 to ambientDim list (
            random(-1.0,1.0)
        )
    ) ; -- this way biases the directions in the corner of cube, might be a better random point generation
   norms := (for p in entries randPoints list (for val in p list val^2)) / sum / sqrt;
   randNormalizedPoints := inverse(diagonalMatrix(norms))*randPoints;
   randDirections := (matrix toList(hC#NumDirections:hC#CurrentPoint)) + (hC#StepSize)*randNormalizedPoints;
   correctDirectionIdx := minPosition(for dir in entries randDirections list hC#LossFunction(dir));

   nextPoint := (entries randDirections)_correctDirectionIdx;
   hC#CurrentStep += 1;
   hC#CurrentPoint = nextPoint;
   nextPoint
)

track = method(
    Options => {
        Quiet => false
    }
)
track(HillClimber) := List => opts -> (hC) -> (
    while not hC#StopCondition(hC#CurrentPoint) do (
	if not opts#Quiet then (
        << "---------------------------------------" << endl;
        << "Current Point: " << hC#CurrentPoint << endl;
   --     << "Current Solution: " << solvePowerSystem(A,hC#CurrentPoint) << endl;
        << "Loss Function at Current Solution: " << hC#LossFunction hC#CurrentPoint << endl;
        );
        nextStep(hC);
    );
    if not opts#Quiet then (
    << "Number Steps: " << hC#CurrentStep << endl;
    << "Final Point: " << hC#CurrentPoint << endl;
    );
    hC#CurrentPoint
)

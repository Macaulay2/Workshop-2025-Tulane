-- I am a statistician, and I observe four moments of a distribution coming from a mixture of four gaussians in the wild. 

-- the following data comes from comes from 4 gaussians, means 3/5, 2/9, 8/3, 30/14, variance 1, 1, 1, 1
moments =  matrix {{1.40794}, {3.02808}, {11.4812}, {36.1147}} 
A = matrix {{1/4, 0, 0, 0}, {0, 1/4, 0, 0}, {3/4, 0, 1/4, 0}, {0, 3/2, 0, 1/4}} -- determined by the variance only!

-- Together, they are the moment equations
matrix{getPowerSystem(A, flatten entries moments)} -- the problem we are solving. x's are parameters.

--up to permutation, the solution is unique
parameters = time solvePowerSystem(A,flatten entries moments)

-- The algorithm works by turning the problem into finding the roots of a single univariate polynomial
-- in this case, the polynomial is
use RR[y]; p = y^4-5.63176*y^3+9.8022*y^2-5.33983*y+.761911
-- given any general moments m = (m_1, m_2, m_3, m_4) with this particular A, the polynomial is
use RR[y, m_1, m_2, m_3, m_4];
generalP = y^4-4*m_1*y^3+(8*m_1^2-2*m_2)*y^2+(-(32/3)*m_1^3+8*m_1*m_2+4*m_1-(4/3)*m_3)*y+(32/3)*m_1^4-16*m_1^2*m_2-16*m_1^2+2*m_2^2+(16/3)*m_1*m_3+6*m_2-m_4

-- This works for general (A,m) and is much faster than using numerical techniques
needsPackage "NumericalAlgebraicGeometry"

(B,m) = (random(ZZ^4, ZZ^4), random(ZZ^4, ZZ^1))
time solveSystem(getPowerSystem(B, flatten entries m));
time solvePowerSystem(B, flatten entries m);

-- Realistically, our observations of the moments contain noise.
noise = transpose matrix{for i from 1 to numRows moments list random(-2.0,2.0)}
noisyMoments = moments + noise

solvePowerSystem(A, flatten entries noisyMoments) -- oh no! it has complex roots!
-- Our parameters should be real, as we all know that imaginary numbers do not exist in the real world

-- Our problem: Move m minimally to get a polynomial with all real roots

-- The discriminant of the polynomial above is a hypersurface in the space of our inputs (m_1,...,m_4)
getPowerSystemDiscriminant(A) 
-- It divides the space into chambers based on the number of real roots (think b^2-4ac)
-- We want to move from m into the correct chamber.

-- We have three ways we've coded up to do this:
-- 1. Hill climbing algorithm
-- 2. Project onto the correct chamber using euclidean distance 
-- 3. Use a mesh grid search 


-- Lets just do 1. Hill climbing
-- This generates random directions to move in, and then takes the best one based on some loss function.

-- We've implemented a general HillClimber datatype which takes in 
-- a loss function, a stopping condition, and a starting point.

lossFunction = method(
    Options => {
        ComplexConstant => 0.5,
        DistanceConstant => 0.01,
        Tolerance => 0.001,
    }
)
lossFunction(List) := RR => opts -> L -> (
    sol := solvePowerSystem(A,L);
    rootsPartition := partition( z -> abs(imaginaryPart(z))< 0.001,  sol);
    complexRoots := if rootsPartition#?false then rootsPartition#false else {};
    realRoots := if rootsPartition#?true then rootsPartition#true else {};
    complexLoss := sum(for val in (complexRoots / imaginaryPart) list val^2);
    sortedRealRoots := sort(realRoots);
    minPairwiseDistance := min flatten for i from 1 to length(sortedRealRoots) - 1 list (
        sortedRealRoots_{i} - sortedRealRoots_{i-1}
    );
    realLoss := 1_QQ/minPairwiseDistance;
    opts#DistanceConstant*realLoss + opts#ComplexConstant*complexLoss
)

stopCondition = method(
    Options => {
        Tolerance => 0.001
    }
)
stopCondition(List) := Boolean => opts -> (L) -> (
    sol := solvePowerSystem(A,L);
    allRealRoots := all(sol, z -> abs(imaginaryPart(z))< opts#Tolerance);
    if (lossFunction(L) < opts#Tolerance) or (allRealRoots) then true else false
)


hC = hillClimber(lossFunction, stopCondition, flatten entries(noisyMoments))

nextStep(hC) -- one step

track(hC) -- go until stopping condition is met
flatten entries moments 
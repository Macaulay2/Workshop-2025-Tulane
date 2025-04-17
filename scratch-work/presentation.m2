restart 
debug needsPackage "PowerSums";

m =  matrix {{1.40794}, {3.02808}, {11.4812}, {36.1147}} -- comes from 4 gaussians, means 3/5, 2/9, 8/3, 30/14, variance 1, 1, 1, 1
A = matrix {{1/4, 0, 0, 0}, {0, 1/4, 0, 0}, {3/4, 0, 1/4, 0}, {0, 3/2, 0, 1/4}}

matrix{getPowerSystem(A, flatten entries m)} -- the problem we are solving

parameters = time solvePowerSystem(A,flatten entries m)

noise = transpose matrix{for i from 1 to numRows m list random(-2.0,2.0)}
mNoisy = m + noise

solvePowerSystem(A, flatten entries mNoisy) -- oh no! it has complex roots!
-- let's try to find a better solution

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


hC = hillClimber(lossFunction, stopCondition, flatten entries( mNoisy))

nextStep(hC)

track hC
flatten entries m 

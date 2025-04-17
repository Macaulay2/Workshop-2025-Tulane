-*
I need these methods

--solvePowerSystem
--getPowerSystemDiscriminant
*-

load "../PowerSums/RootCorrecting.m2"
load "../PowerSums/PowerSystems.m2"

A := matrix{{9,0,0,0},{8,7,0,3},{2,3,4,2},{1,0,2,3}};
m := {1,2,3,4};

hC := randomRealRootsFinder(A, m);

realRootsOfDiscriminant := findRealRootsOfDiscriminant(hC);

-*
Okay, so `findRealRootsOfDiscriminant` finds the real roots of the discriminant of the system
Now, given these roots $\hat{m}_i$, let's minimize $\|\hat{m}_i - m_i\|$ for $i = 1, \ldots, n$.
We can do this by using the `HillClimber` with the loss function being this minimization problem.
*-

-- let's define the loss function = $\|\hat{m}_i - m_i\|_2^2$
lossFunction = method()
lossFunction(List, List) := Number => (x, y) -> (
    if #x != #y then error "The size of the two lists must be the same";
    loss := sum(for i to #x-1 list (x#i - y#i)^2);
    loss
)

-- let's define the stopping condition = $\|\hat{m}_i - m_i\|_2^2 < \epsilon$
stopCondition = method(
    Options => {
        Tolerance => 0.001
    }
)
stopCondition(List, List) := Boolean => opts -> (x,y) -> (
    loss = lossFunction(x, y);
    if loss < opts#Tolerance then true else false
)

hC = hillClimber(lossFunction, stopCondition, flatten entries(observedm - B**RR))

end









-*
- Binary Hill Climber
*- 
BinaryHillClimber = new Type of MutableHashTable
BinaryHillClimber.synonym = "a binary hill climber"
BinaryHillClimber.GlobalAssignHook = globalAssignFunction
BinaryHillClimber.GlobalReleaseHook = globalReleaseFunction

-- constructor method for BinaryHillClimber
binaryHillClimber = method (
    TypicalValue => BinaryHillClimber,
    Options => {
        StepSize => 50.0,
        NumDirections => 1000
    }
)

binaryHillClimber(RingElement, List) := BinaryHillClimber => opts -> (lossFunction, startingPoint) -> (
    new BinaryHillClimber from {
        LossFunction => lossFunction,
        StartingPoint => startingPoint,
        CurrentPoint => startingPoint,
        CurrentStep => 1,
        StepSize => opts#StepSize,
        NumDirections => opts#NumDirections,
        symbol cache => new CacheTable
    }
)

findEndpoints(BinaryHillClimber) := List => (hC) -> (
    ambientDim := length hC#StartingPoint;
    randPoints := matrix for i from 1 to hC#NumDirections list (
        for j from 1 to ambientDim list (
            random(-1.0,1.0)
        )
    );
    norms := (for p in entries randPoints list (for val in p list val^2)) / sum / sqrt;
    randNormalizedPoints := inverse(diagonalMatrix(norms))*randPoints;
    randEndPoints := toList entries((matrix toList(hC#NumDirections:hC#StartingPoint)) + (random(0.0, sub(hC#StepSize,RR)))*randNormalizedPoints); -- (hC#StepSize * random(0.0,1.0))
    valueAtStartPoint := evalFunc(hC#LossFunction, hC#CurrentPoint); -- Not `LossFunction`, but `Discriminant`, but let's just pass it as a Loss function for now
    valuesAtEndPoints := apply(randEndPoints, pt -> evalFunc(hC#LossFunction, pt));
    correctEndPointIdx := positions(valuesAtEndPoints, valEndPoint -> valEndPoint * valueAtStartPoint < 0);
    print(correctEndPointIdx);

    if #correctEndPointIdx == 0 then error "No valid endPoint found";
    correctEndPoints := randEndPoints_(correctEndPointIdx);
    correctEndPoints
)


A := matrix{{9,0,0,0},{8,7,0,3},{2,3,4,2},{1,0,2,3}}
m := {1,2,3,4}
loss := getPowerSystemDiscriminant(A)


realRootsOfStarting = computeNumberOfRealRoots(A, m)

hC = binaryHillClimber(loss, m);
endPoints = findEndpoints(hC);
zerosOfLoss = for endPoint in endPoints list (
    binarySearch(m, endPoint, loss, 0.001)
);
directionsToEndPoints = for endPoint in endPoints list (
    (endPoint - hC#CurrentPoint) / norm(endPoint - hC#CurrentPoint)
);
smallShiftToEndPoints = for i to #zerosOfLoss-1 list (
    zerosOfLoss#i + 0.001 * (directionsToEndPoints#i)
);
print(zerosOfLoss);
print("Check the zeroes are really zeros");
print(apply(zerosOfLoss, pt -> evalFunc(loss, pt)));
print("Get roots of the system for zeroes");
apply(zerosOfLoss, pt -> print("point ", pt, ":\t roots:", solvePowerSystem(A, pt)));
print("Small shifts to ends:", smallShiftToEndPoints);
print("Get roots of the system for small shifts");
apply(smallShiftToEndPoints, pt -> print("point ", pt, ":\t roots:", solvePowerSystem(A, pt)));
-*
rootsOfShifts = apply(smallShiftToEndPoints, pt -> solvePowerSystem(A, pt));
partitionsPerShift = apply(rootsOfShifts, r -> partition(z -> abs(imaginaryPart(z))< 0.001, r));
complexRootsPerShift := apply(partitionsPerShift, rootsPartition -> if rootsPartition#?false then rootsPartition#false else {});
realRootsPerShift := apply(partitionsPerShift, rootsPartition -> if rootsPartition#?true then rootsPartition#true else {});
print(realRootsPerShift)
*-
realRootsPerZeroes := apply(zerosOfLoss, rt -> computeNumberOfRealRoots(A,rt));
numRealRootsPerShifts := apply(smallShiftToEndPoints, rt -> computeNumberOfRealRoots(A,rt));

solutionsIdx := positions(numRealRootsPerShifts, n -> n > realRootsOfStarting);
solutions := smallShiftToEndPoints_solutionsIdx;
--realResults = new HashTable from {smallShiftToEndPoints, realRootsPerShift}

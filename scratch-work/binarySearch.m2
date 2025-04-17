evalFunc = method()
evalFunc(RingElement, List) := QQ => (func, point) -> (
    supportFunc = support func;
    if #supportFunc != #point then error "The size of the support of func must match the size of point";
    substitutionRule = toList apply(0..#supportFunc-1, i -> supportFunc#i => point#i);
    sub(func, substitutionRule)
)

binarySearch = method()
binarySearch(List, List, RingElement, RR) := List => (startingPoint, endingPoint, func, eps) -> (
    if eps <= 0 then error "Epsilon must be positive";
    if (evalFunc(func, startingPoint) * evalFunc(func, endingPoint)) > 0 then error "Function values at the endpoints must have opposite signs";
    while norm(endingPoint - startingPoint) > eps do (
        print(norm(endingPoint - startingPoint));
        midPoint = (startingPoint + endingPoint) / 2;
        print midPoint;
        if evalFunc(func, midPoint) == 0 then return midPoint;
        if evalFunc(func, startingPoint) * evalFunc(func, midPoint) > 0 then (
            endingPoint = midPoint;
        ) else (
            startingPoint = midPoint;
        )
    );
    midPoint
)

-*
- Hill Climber
*- 
HillClimber = new Type of MutableHashTable
HillClimber.synonym = "a hill climber"
HillClimber.GlobalAssignHook = globalAssignFunction
HillClimber.GlobalReleaseHook = globalReleaseFunction

-- constructor method for HillClimber
hillClimber = method (
    TypicalValue => HillClimber,
    Options => {
        StepSize => 0.01,
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

nextStep = method()
nextStep(HillClimber) := List => (hC) -> (
    ambientDim := length hC#StartingPoint;
    randPoints := matrix for i from 1 to hC#NumDirections list (
        for j from 1 to ambientDim list (
            random(-1.0,1.0)
        )
    ) ;
   norms := (for p in entries randPoints list (for val in p list val^2)) / sum / sqrt;
   randNormalizedPoints := inverse(diagonalMatrix(norms))*randPoints;
   randDirections := (matrix toList(hC#NumDirections:hC#StartingPoint)) + (hC#StepSize)*randNormalizedPoints;
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
	if not opts#Quiet then (<< "---------------------------------------" << endl;);
	if not opts#Quiet then (<< "Current Point: " << hC#CurrentPoint << endl;);
	if not opts#Quiet then (<< "Current Solution: " << solvePowerSystem(A,hC#CurrentPoint) << endl;);
        nextStep(hC);
    );
    if not opts#Quiet then (
    << "Number Steps: " << hC#CurrentStep << endl;
    << "Final Point: " << hC#CurrentPoint << endl;
    );
    hC#CurrentPoint
)

-*
- Hill Climbing Algorithm
*- 
HillClimber = new Type of MutableHashTable
HillClimber.synonym = "hill climber"
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


-*
Generates lattice neighborhood around a general point
*-
makeLattice = method()
makeLattice (List, RR, RR) := (point, radius, epsilon) -> (
    n := length(point);

    -- Build interval
    m := 1;
    inter := {0}|(flatten while m*epsilon < radius list (
        {m*epsilon, -m*epsilon}
        ) do m=m+1);

    -- Build lattice
    lattice := inter;
    for i in 1..n-1 do lattice = apply(lattice**inter, t->flatten toList(t));

    apply(lattice, p -> p+point)
)

-- Euclidean distance minimizing in a real neighborhood
minimizeLocalDistance = method()
minimizeLocalDistance (List, List, List) := (point, neighborhood, F) -> (
    -- Apply the polynomial at each point of the neighborhood
    impoint := apply(F, f->f(toSequence point));
    images := apply(neighborhood, p -> apply(F, f -> f(toSequence p)));

    dist := apply(images, p -> norm(p - impoint));

    -- Return the minimizing point
    minimizer := min dist;
    for i in 0..#(dist) do
        if dist_i == minimizer then
            return neighborhood_i
)

-- Finds approximate real root of a polynomial system close to a point
localRootApproximation = method()
localRootApproximation (List, List, RR) := (point, F, tol) -> (
    realPoint := apply(point, c -> realPart(c));
    radius := norm(point-realPoint);
    epsilon := radius/2;

    lattice := makeLattice(realPoint, radius, epsilon);
    newpoint := minimizeLocalDistance(point, lattice, F);

    while epsilon > tol do (
        lattice = makeLattice(realPoint, radius, epsilon);
        newpoint = minimizeLocalDistance(newpoint, lattice, F);

        radius = radius/2;
        epsilon = radius/2;
    );

    newpoint
)

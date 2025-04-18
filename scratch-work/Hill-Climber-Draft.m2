-*
objectFunction,stopCondition,startingPoint,stepSize,numberDirections,currPoint,currStep
*-

nextStep = method()
nextStep HillClimber := hC -> (
    directions := normalizeColumns random(QQ^(hC.numberDirections),QQ^(hC.numberDirections));
    nextStepPoints := apply(numColumns hC.directions,i -> startingPoint + hC.stepSize*(matrix (hC.directions)_i));
    nextStartingPoints := {}
    scan(nextStepPoints,p -> if hC.stopCondition(hC.objectFunction(p)) then nextStepPoints = append(nextStepPoints,p));
    nextStepPoints
    )

normalizeColumns = method()
normalizeColumns Matrix := M -> (
    transpose matrix (entries \apply(numColumns M, i -> M_i / (norm_2 matrix M_i)))
    )

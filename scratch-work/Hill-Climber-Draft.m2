-*
objectFunction,stopCondition,startingPoint,stepSize,numberDirections,currPoint,currStep
*-

nextStep = method()
nextStep HillClimber := hC -> (
    directions := normalizeColumns random(QQ^(numberDirections),QQ^(numberDirections));
    nextStepPoint := apply(numColumns directions,i -> startingPoint + stepSize*(matrix directions_i));
    )

normalizeColumns = method()
normalizeColumns Matrix := M -> (
    transpose matrix (entries \apply(numColumns M, i -> M_i / (norm_2 matrix M_i)))
    )

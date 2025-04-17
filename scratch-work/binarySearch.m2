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
        if evalFunc(func, midPoint) == 0 then return apply(midPoint,i->sub(i,RR));
        if evalFunc(func, startingPoint) * evalFunc(func, midPoint) > 0 then (
            endingPoint = midPoint;
        ) else (
            startingPoint = midPoint;
        )
    );
    apply(midPoint,i->sub(i,RR))
)
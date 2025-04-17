-- test 0
TEST ///  -* making a hillClimber *-
lossFunction = L -> abs(L_1 - ((L_0)^2 + 1));
stopFunction = L -> lossFunction(L) < 0.001;
startingPoint = {4,8};
hC = hillClimber(lossFunction, stopFunction, startingPoint)
assert(hC#stopFunction(hC#CurrentPoint))
///
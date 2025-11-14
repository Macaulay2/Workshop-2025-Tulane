TEST ///
restart
needsPackage "Rigidity"
n=4;
T = tropicalCayleyMenger n;
assert(#T == 75);
G={{1,2},{2,3},{3,4},{1,4}};
T = tropicalCayleyMenger G;
assert(#T == 75 and numrows rays first T == 4);
assert(
    (
    rays last T - matrix {{0, 0}, {-1, 0}, {0, 0}, {0, -1}}
    )% linSpace first T == 0
)
assert(#(T/dim//uniique)==1)
///


TEST ///
permutationOfDoubleIndices = (p,G) -> apply(G, l->position(G,l' -> sort p_l' == l))
checkInvariance = perm -> (
    n := #perm;
    G := subsets(n,2);
    -- maxPairs := maximalTreePairs n;
    maximalCones := tropicalCayleyMenger n;
    p := permutationOfDoubleIndices(perm,G); 
    pSet = maximalCones/(c->coneFromVData((rays c)^p,(linSpace c)^p));
    wrong := select(
        apply(5, i->random(#maximalCones)), --take a few random cones to check
        i->(
	        c := maximalCones#i;
            c' := coneFromVData((rays c)^p,(linSpace c)^p);
            position(maximalCones, c -> c' == c) === null
            ));
    wrong
    )
perm = {3,0,1,2}
setRandomSeed 1234;
wrong = checkInvariance perm
assert isEmpty wrong


-* this takes longer to run 
perm = {4,0,1,2,3}
wrong = checkInvariance perm
assert isEmpty wrong
*-
///

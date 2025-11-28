TEST ///
n=4;
T = tropicalCayleyMenger n;
assert(#T == 75);
G={{1,2},{2,3},{1,3},{1,4},{2,4}};
T = tropicalCayleyMenger G;
assert(#T == 33 and numrows rays first T == 5 and all(T, C->dim C==5));

T = tropicalCayleyMenger(n,Type=>List)
assert(#T == 75 and all(T, R -> rank image transpose matrix R == 4))
T = tropicalCayleyMenger(G,Type=>List)
T4 = select(T, C->rank image transpose matrix(C | {toList(#G:1)})==5)
assert(#T4 == 33)
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

TEST ///
n=4;
G={{1,2},{2,3},{3,4},{1,4}};

GIndices=edgeListToIndices(G,n);
maximalPairs = maximalTreePairs(n);
assert (#maximalPairs == 75)
maximalCones = apply(maximalPairs,
    p->apply(raysOfTreePairCone(p_0,p_1),v->v_GIndices));
assert(toString max maximalPairs == "{x_1*x_2*x_3*x_4+x_1*x_2*x_3+x_1*x_2, x_1*x_2*x_3*x_4+x_1*x_3+x_2*x_4}")
///

TEST ///
permutationOfDoubleIndices = (p,G) -> apply(G, l->position(G,l' -> sort p_l' == l))
checkInvariance = perm -> (
    n := #perm;
    G := subsets(1..n,2);
    GIndices := edgeListToIndices(G,n);
    maximalPairs := maximalTreePairs(n);
    maximalCones = apply(maximalPairs,
	p->apply(raysOfTreePairCone(p_0,p_1),v->v_GIndices));
    lookupSet = maximalCones/toCompare//set;
    p := permutationOfDoubleIndices(perm,apply(G,p->p-{1,1})); -- need to decrease indices by 1
    wrong := select(#maximalCones, i->(
	    c := maximalCones#i;
	    c' := c/(r->r_p);
	    not member(toCompare c', lookupSet)
	    ));
    wrong
    )

perm = {3,0,1,2}
toCompare = set; -- comparison as sets holds for n=4
wrong = checkInvariance perm
assert isEmpty wrong

-* FAILS!!!
perm = {4,0,1,2,3}
toCompare = c -> mingens image transpose matrix(QQ,c);
wrong = checkInvariance perm
assert isEmpty wrong
*-
///

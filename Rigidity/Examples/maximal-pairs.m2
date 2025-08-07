restart
needsPackage "Rigidity"

-*
n=5;
G={{1,2},{2,3},{3,4},{1,4},{1,5},{2,5},{3,5},{4,5}};
n=7;
G={{1,5},{1,6},{1,7},{2,5},{2,6},{2,7},{3,5},{3,6},{3,7},{4,5},{4,6},{4,7}};
*-
n = 4;
G = subsets(1..n,2)  

GIndices=edgeListToIndices(G,n);
maximalPairs = maximalTreePairs(n);
maximalCones = apply(maximalPairs,
    p->apply(raysOfTreePairCone(p_0,p_1),v->v_GIndices));
VerticalList maximalCones

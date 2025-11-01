-----------------------------
-- maximal cones
-----------------------------
n=5;
G={{1,2},{2,3},{3,4},{1,4},{1,5},{2,5},{3,5},{4,5}};

-* ... one may pick one of these ... 
n=6;
G=subsets(1..n,2) -- takes long time

n=7;
G={{1,5},{1,6},{1,7},{2,5},{2,6},{2,7},{3,5},{3,6},{3,7},{4,5},{4,6},{4,7}};
*-

GIndices=edgeListToIndices(G,n);
time maximalPairs = maximalTreePairs(n);
time maximalCones = apply(maximalPairs,
    p->apply(raysOfTreePairCone(p_0,p_1),v->v_GIndices));

----------------------------
-- cones to complete
----------------------------
n=4;
G={{1,2},{2,3},{3,4},{1,4}};
GIndices=edgeListToIndices(G,n);
conesOfComplete=apply(getAllTrees(n),raysOfUltrametricCone);
apply(conesOfComplete,C->apply(C,v->v_GIndices))

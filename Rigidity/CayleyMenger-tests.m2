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

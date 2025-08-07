-- we want to see if `gfan _dualcone` works 
needsPackage "Rigidity"
n = 4;
G = subsets(1..n,2)  

GIndices=edgeListToIndices(G,n);
maximalPairs = maximalTreePairs(n);
maximalCones = apply(maximalPairs,
    p->apply(raysOfTreePairCone(p_0,p_1),v->v_GIndices));
VerticalList maximalCones

toPolyhedralCone'gfan = C -> (
    assert(#C > 0);
    n := #first C;
    "{ "| n | ", " | toString drop(C,1) | ", " | toString {toList(n:1)} | " }"
    )

end
restart
load "Rigidity/examples/example-conversion-to-gfan-format.m2"
C = first maximalCones
toPolyhedralCone'gfan C
-*
run
```
gfan _dualcone
```
*-

R=QQ[x,y,z,l1,l2]
u=(0,0,0)
f=(x-u_0)^2+(y-u_1)^2+(z-u_2)^2
g1=x^2+y^2+z^2-3
g2=x^3+y^3+z-7
L=f+l1*g1+l2*g2
F=jacobian(L)
needsPackage "NumericalAlgebraicGeometry"
s=solveSystem flatten entries F
r=realPoints s

--
restart

needsPackage "NumericalAlgebraicGeometry";

getClosestPoint=method()
getClosestPoint(List,Sequence):= (G,pt)->(
    R:=ring first G;
    f:=sum(apply(flatten entries vars R - toList pt, i->i^2));
    a:=#G;
    S:=first flattenRing (R[L_1..L_a]);
    -- print("???error???");
    l:=sub(f,S)+sub(sum(apply(a,i->L_(i+1)*G_i)),S);
    F:=jacobian(l);
    -- needsPackage "NumericalAlgebraicGeometry";
    print(F);
    print(primaryDecomposition radical ideal F);
    s:=solveSystem flatten entries F;
    r:=realPoints s;
    -- returns: variable order, complex points, only real points, distance function
    return (vars S,s,r,f)
)

--
r1 = apply(r, i-> drop(coordinates i,1))
allValues = apply(r1, j->sub(f, matrix{j}))

-- Example 1
R=QQ[x,y]
g1=x^2+y^2-4
G = {g1}
pt = (0,1)

(varOrder,s,r,f) = getClosestPoint(G, pt)

-- Example 2
R=QQ[x,y,z]
g1=x^2+y^2+z^2-3
g2=x^3+y^3+z-7
G = {g1,g2}
pt = (0,0,0)
(varOrder,s,r,f) = getClosestPoint(G, pt)

-- Example 3
R=QQ[x,y,z]
g1=x^2+y^2+z^2-3
G = {g1}
pt = (0,0,0)

(varOrder,s,r,f) = getClosestPoint(G, pt)



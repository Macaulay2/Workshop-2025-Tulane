--
restart

needsPackage "NumericalAlgebraicGeometry";

solveLagrangeSystem=method()
solveLagrangeSystem(List,Sequence):= (G,pt)->(
    R:=ring first G;
    f:=sum(apply(flatten entries vars R - toList pt, i->i^2));
    a:=#G;
    S:=first flattenRing (R[L_1..L_a]);
    l:=sub(f,S)+sub(sum(apply(a,i->L_(i+1)*G_i)),S);
    F:=jacobian(l);
    cd=codim ideal(F);
    if cd!=dim S then print("Caution: The solution space has positive dimension.");
    s:=solveSystem flatten entries F;
    r:=realPoints s;
    return (vars S,s,r,f)
)

solveLagrange = method()
solveLagrange(List,Sequence):= (G,pt)->(
    (varOrder,s,r,f) := solveLagrangeSystem(G, pt);
    a:=#G;
    r1 := apply(r, i-> drop(coordinates i,a));
    --return (r)
    allValues := apply(r1, j->sub(f, matrix{j}));
    ps:=positions(allValues, i-> i==min(allValues));
    r2:=apply(r1_ps, i-> apply(i, j-> realPart j));
    return (r2, min(allValues),f)
)


-- Example 1
R=QQ[x,y]
g1=x^2+y^2-4
G = {g1}
pt = (0,1)

(varOrder,s,r,f) = solveLagrangeSystem(G, pt)
solveLagrange(G, pt)

-- Example 2
R=QQ[x,y,z]
g1=x^2+y^2+z^2-3
g2=x^3+y^3+z-7
G = {g1,g2}
pt = (0,0,0)
(varOrder,s,r,f) = solveLagrangeSystem(G, pt)
solveLagrange(G, pt)

-- Example 3
R=QQ[x,y,z]
g1=x^2+y^2+z^2-3
G = {g1}
pt = (0,0,0)

(varOrder,s,r,f) = solveLagrangeSystem(G, pt)
solveLagrange(G, pt)

-- Example 4
R=QQ[x,y,z]
g1=x^2-1
G = {g1}
pt=(0,0,0) 
(varOrder,s,r,f) = solveLagrangeSystem(G, pt)
solveLagrange(G, pt)

--
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

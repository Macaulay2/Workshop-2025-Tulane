-- Goal: implement Lusztig's canonical basis of g
-- using the formulas from Geck and Lang,
-- "Canonical structure constants for simple Lie algebras", arXiv:2404.07652v1




-- Use the Dynkin diagram numbering in LieAlgebraRepresentations
-- Check: does this match Bourbaki?

epsfunction = (g) -> (
    if not isSimple(g) then error "Not implemented yet" << endl;
    if member(g#"RootSystemType",{"A","B","C","F","G"}) then return i -> (-1)^i;
    m:=g#"LieAlgebraRank";
    if g#"RootSystemType"=="D" then (
        return i -> (if i<=m-3 then (-1)^i else (-1)^(m-2))
    );
    if g#"RootSystemType"=="E" then (
        return i -> (if member(i+1,{1,4,6,8}) then 1 else -1)
    );    
);


allRoots = (g) -> (
    PhiPlus:=positiveRoots(g);
    join(PhiPlus,apply(PhiPlus, v -> -v))
);



p = (alpha,beta,g) -> (
    Phi:=allRoots(g);
    if alpha==beta or alpha==-beta then return "DNE";
    i:=0;
    while member(beta+(i+1)*alpha, Phi) do i=i+1;
    return i
);



q = (alpha,beta,g) -> (
    Phi:=allRoots(g);
    if alpha==beta or alpha==-beta then return "DNE";
    i:=0;
    while member(beta-(i+1)*alpha, Phi) do i=i+1;
    return i
);



sgn = (alpha,g) -> (
    if member(alpha,positiveRoots(g)) then 1 else -1
)



writeInDelta = (w,g) -> (
    M:=matrix apply(simpleRoots(g), a -> 1/1*a);
    v:=(inverse transpose M)*(transpose matrix {w});
    apply(flatten entries v, i -> lift(i,ZZ))
);



writeInDeltaCheck = (w,g) -> (
    M:=matrix apply(simpleRoots(g), a -> (2/killingForm(g,a,a))*a);
    v:=(inverse transpose M)*(transpose matrix {(2/killingForm(g,w,w))*w});
    flatten entries v
);



-- Implement formula from [GL] Definition 3.5
simplyLacedEtaHat = (alpha,beta,g) -> (
    eta:=sgn(alpha,g)*sgn(beta,g)*sgn(alpha+beta,g);
    n:=writeInDelta(alpha,g);
    m:=writeInDelta(beta,g);
    A:=cartanMatrix(g);
    Delta:=simpleRoots(g);
    eps:=epsfunction(g);
    eta*product(apply(#Delta, i -> product apply(#Delta, j -> (eps(i))^(A_(i,j)*n_i*m_j))))
);



etaHat = (alpha,beta,gtilde) -> (
    if member(gtilde#"RootSystemType",{"A","D","E"}) then return simplyLacedEtaHat(alpha,beta,gtilde);
    FD:=gtilde.cache#"FoldingData";
    g:=FD_0;
    FD=FD_1;
    alphalift:=first(FD#alpha);
    i:=0;
    betalift:=(FD#beta)_i;
    Phi:=allRoots(g);
    while not member(alphalift+betalift,Phi) do (
        i=i+1;
	betalift=(FD#beta)_i;
    );
    simplyLacedEtaHat(alphalift,betalift,g)
);



-- Compare to level in lieAlgebraModules.m2
ht = (w,g) -> (
    M:=matrix apply(simpleRoots(g), a -> 1/1*a);
    v:=(inverse transpose M)*(transpose matrix {w});
    lift(sum flatten entries v,ZZ)
);


-- First, compute brackets on the basis elements
brLusztigVar = memoize((x,y,g,LusztigRtoZ,weight,E) -> (
    if x==0 or y==0 then return 0;
    -- Geck and Lang's convention for the Cartan matrix is the transpose of
    -- the convention used in LieAlgebraRepresentations
    a:=transpose cartanMatrix(g);
    m:=g#"LieAlgebraRank";
    Phi:=allRoots(g);
    R:=ring(x);
    n:={};
    i:=0;
    -- Case 1. Both x and y are in h
    -- Then they commute
    if LusztigRtoZ#x < m and LusztigRtoZ#y < m then return 0_R;   
    -- Case 2. x is in h, and y is not
    -- Write x = h_i, y = e_alpha = sum n_j alpha_j
    -- Then [h_i,e_alpha] = alpha(h_i) e_alpha
    --                    = (sum n_j a_ij) e_alpha
    if LusztigRtoZ#x < m and LusztigRtoZ#y >= m then (
       n = writeInDelta(weight(y),g);
       i = LusztigRtoZ#x;
       return (sum apply(m, j -> n_j*a_(i,j)))*y
    );   
    -- Case 3. x is not in h, y is in h
    -- Flip and use Case 2.
    if LusztigRtoZ#x >= m and LusztigRtoZ#y < m then (
        return -brLusztigVar(y,x,g,LusztigRtoZ,weight,E)
    ); 
    -- Case 4. Both x and y are not in h
    -- x = e_alpha, y = e_beta
    alpha:=weight(x);
    beta:=weight(y);
    ---- Case 4a. alpha+beta = 0
    if alpha==-beta then (
	--print toString "Case 4a" << endl;
	n = writeInDeltaCheck(alpha,g);
	return (-1)^(ht(alpha,g))*(sum apply(m, i -> n_i*R_i))
    );
    ---- Case 4b1. alpha+beta != 0, alpha + beta is not in Phi
    if not member(alpha+beta,Phi) then return 0_R;
    ---- Case 4b2. alpha+beta != 0, alpha + beta is in Phi
    ---- Note: q_(a,b)=0 if g simply laced and a+b in Phi, and then this factor is 1 in the formula below
    etaHat(alpha,beta,g)*(q(alpha,beta,g)+1)*(E#(alpha+beta))
));

-- Now extend the bracket using bilinearity

brLusztig = (v,w,g,LusztigRtoZ,weight,E) -> (
    T1:=terms v;
    T2:=terms w;
    sum flatten apply(T1, t1 -> apply(T2, t2 -> leadCoefficient(t1)*leadCoefficient(t2)*brLusztigVar(leadMonomial(t1),leadMonomial(t2),g,LusztigRtoZ,weight,E))) 
);



lusztigBasis = (g) -> (
    if member(g#"RootSystemType",{"B","C","F","G"}) then (
        unfg:=unfoldingLieAlgebra(g);
        NodeOrbits:=nodeOrbits(g);
        g.cache#"FoldingData" = (unfg,partition(x -> alphatilde(x,NodeOrbits), allRoots(unfg)));
    );
    m := g#"LieAlgebraRank";
    Delta:=simpleRoots(g);
    PhiPlus:=positiveRoots(g);
    Phi:=allRoots(g);
    eps:=epsfunction(g);
    h:=getSymbol "h";
    e:=getSymbol "e";
    R:=QQ[join(apply(Delta, a -> h_a),apply(Phi, a -> e_a))];
    LusztigRtoZ:=new HashTable from apply(numgens R, i -> {R_i,i});
    weight := (x) -> (if LusztigRtoZ#x < m then apply(m, i -> 0) else Phi_(LusztigRtoZ#x-m));
    E := new HashTable from apply(#Phi, i -> {Phi_i,R_(i+m)});
    writeInLusztigBasis := (f) -> apply(gens R, x -> coefficient(x,f));
    ad := X -> transpose matrix apply(gens R, Y -> writeInLusztigBasis brLusztigVar(X,Y,g,LusztigRtoZ,weight,E));
    L := apply(gens R, X -> ad X);
    kappa := matrix apply(L, i-> apply(L, j -> trace(i*j)));
    cs := casimirScalar irreducibleLieAlgebraModule(highestRoot(g),g);
    cstar := entries transpose(cs*(inverse kappa));
    B:=gens R;
    Bstar := apply(#B, i -> sum apply(#B, j -> ((cstar_i)_j*B_j)));
    new LieAlgebraBasis from {
	"LieAlgebra"=>g,
        "BasisElements"=>gens R,
	"Bracket"=> (A,B) -> brLusztig(A,B,g,LusztigRtoZ,weight,E),
	--"DualBasis"=> slnDualBasis(n,B),
	"DualBasis"=> Bstar,
        "Weights"=> apply(gens R, x -> weight x),
	"Labels" => apply(gens R, x -> toString(x)),
	"RaisingOperatorIndices"=>apply(#PhiPlus, i -> m+i),
	"LoweringOperatorIndices"=>apply(#PhiPlus, i -> m+i+#PhiPlus),
	"WriteInBasis"=>writeInLusztigBasis
    }
);


-- From [GL] Table 2
unfoldingLieAlgebra = (gtilde) -> (
    mtilde:=gtilde#"LieAlgebraRank";
    if gtilde#"RootSystemType"=="B" then return simpleLieAlgebra("D",mtilde+1);
    if gtilde#"RootSystemType"=="C" then return simpleLieAlgebra("A",2*mtilde-1);
    if gtilde#"RootSystemType"=="F" then return simpleLieAlgebra("E",6);
    if gtilde#"RootSystemType"=="G" then return simpleLieAlgebra("D",4);
);

-- Adapted from [GL] Table 2
---- Start indexing at 0 rather than 1
---- Match Dynkin diagram node numbering used in LieAlgebraRepresentations
nodeOrbits = (gtilde) -> (
    mtilde:=gtilde#"LieAlgebraRank";
    if gtilde#"RootSystemType"=="B" then return append(apply(mtilde-1, i -> {i}),{mtilde-1,mtilde});
    if gtilde#"RootSystemType"=="C" then return append(apply(mtilde-1, i -> {i,2*mtilde-2-i}),{mtilde-1});
    if gtilde#"RootSystemType"=="F" then return {{1},{3},{2,4},{0,5}};
    if gtilde#"RootSystemType"=="G" then return {{0,2,3},{1}};
);
--assert(nodeOrbits(simpleLieAlgebra("B",3))== {{0}, {1}, {2,3}})
--assert(nodeOrbits(simpleLieAlgebra("C",3))=={{0, 4}, {1, 3}, {2}})



brhiealpha = (i,alpha,NodeOrbits) -> (
    w:=first select(NodeOrbits, j -> member(i,j));
    sum apply(w, i -> alpha_i)
);

alphatilde = (alpha,NodeOrbits) -> (apply(#NodeOrbits, j -> brhiealpha(first(NodeOrbits_j),alpha,NodeOrbits)))

cartanMatrixOfFolding = (gtilde) -> (
    g:=unfoldingLieAlgebra(gtilde);
    Phi:=allRoots(g);
    Deltatilde:=simpleRoots(gtilde);
    NodeOrbits:=nodeOrbits(gtilde);
    L:=apply(Deltatilde, i -> first select(Phi, w -> alphatilde(w,NodeOrbits)==i));
    mtilde:=gtilde#"LieAlgebraRank";
    sigma:=apply(NodeOrbits, i -> first i);
    matrix apply(mtilde, i -> apply(mtilde, j -> brhiealpha(sigma_j,L_i,NodeOrbits)))
);





end


load "GeckLang.4.m2"
debug LieAlgebraRepresentations
-*
-- Test the Cartan matrices
L = {{"B",5},{"C",5},{"F",4},{"G",2}};
all(L, x -> cartanMatrixOfFolding(simpleLieAlgebra(x_0,x_1))==cartanMatrix(x_0,x_1))
*-


LABA2 = lusztigBasis(simpleLieAlgebra("A",2));
checkLieAlgebraBasis(LABA2)
LABC3 = lusztigBasis(simpleLieAlgebra("C",3));
checkLieAlgebraBasis(LABC3)

-- Test the rainbow 

L = {{"A",1},{"A",2},{"A",4},{"B",4},{"C",4},{"D",4},{"E",6},{"E",7},{"E",8},{"F",4},{"G",2}};
for x in L do (
    print toString(x) << endl;
    g = simpleLieAlgebra(x_0,x_1);
    LAB = lusztigBasis(g);
    b=checkLieAlgebraBasis(LAB);
    print toString(b) << endl
);



-- Test etaHat

-- An example where alphalift+betalift is in Phi:
etaHat({2,-1,0},{-1,2,-1},gtilde)
-- An example where alphalift+betalift is not in Phi and we have to replace betalift by betalift' 
etaHat({2,-1,0},{0,1,0},gtilde)



-- Build a LieAlgebraBasis

geckLAB = (gtilde) -> (



);

-- Bind gtilde.cache#"FoldingData" = (g,partition(alphatilde, allRoots(g)))
gtilde = simpleLieAlgebra("C",3);
g=unfoldingLieAlgebra(gtilde);
NodeOrbits=nodeOrbits(gtilde);
gtilde.cache#"FoldingData" = (g,partition(x -> alphatilde(x,NodeOrbits), allRoots(g)));




-- To implement Theorem 4.10:
-- 
    






-- What are some good examples?
-- Here's an example where alphalift+betalift is in Phi
-- [B_3,B_4] = B_6
-- [e_{2,-1,0},e_{-1,2,-1}] = e_{1,1,-1}

alpha = {2,-1,0}
beta = {-1,2,-1}
alphalift = first(FD#alpha)
Phi=allRoots(g);

-*
-- Can I find an example where I need to replace beta by beta'?

Phitilde=allRoots(gtilde);
for i from 0 to #Phitilde-2 do (
 for j from i+1 to #Phitilde-1 do (
   alpha=Phitilde_i;
   beta=Phitilde_j;
   if alpha+beta==apply(#alpha, i -> 0) then continue;
   if not member(alpha+beta,Phitilde) then continue;
   alphalift=first(FD#alpha);
   betalift=first(FD#beta);
   if not member(alphalift+betalift,Phi) then print toString({alpha,beta}) << endl
   )
)
 {{2, -1, 0}, {0, 1, 0}}
{{-1, 2, -1}, {-1, 0, 1}}
{{-1, 2, -1}, {1, -1, 1}}
{{-1, 2, -1}, {0, -1, 0}}
{{1, 1, -1}, {-1, 0, 1}}
{{1, 1, -1}, {1, -1, 1}}
{{-1, 0, 1}, {0, -1, 0}}
{{0, 1, 0}, {1, -2, 1}}
{{0, 1, 0}, {1, 0, -1}}
{{-2, 1, 0}, {0, -1, 0}}
{{1, -2, 1}, {1, 0, -1}}
{{1, -2, 1}, {-1, 1, -1}}
{{-1, -1, 1}, {1, 0, -1}}
{{-1, -1, 1}, {-1, 1, -1}}

*-

alpha = {2,-1,0}
beta = {0,1,0}
alphalift = first(FD#alpha)
--  {2, -1, 0, 0, 0}
FD#beta
-- {{1, 0, 0, 1, -1}, {-1, 1, 0, 0, 1}}
member({2, -1, 0, 0, 0}+{1, 0, 0, 1, -1},Phi)
-- false
member({2, -1, 0, 0, 0}+{-1, 1, 0, 0, 1},Phi)
-- true

















-- Example 1: n=3, A5 to C3

---- Step 1. Describe the folding


g = simpleLieAlgebra("A",5);
Phi = allRoots(g);
n = g#"LieAlgebraRank";

gtilde = simpleLieAlgebra("C",3);





-*
-- What are the simple roots of gtilde?

Delta = simpleRoots(g);
L5 = unique apply(Delta, i -> first select(L4, j -> member(i,j)))
mtilde = #L2;
-- Note: the ordering of the orbits in L5 might not be correct to get the Cartan matrix
matrix apply(mtilde, i -> apply(mtilde, j -> brhiealpha(j,L5_i_0)))==cartanMatrix("C",3)
*-


-- Get the map between roots of g and roots of gtilde

alphatilde = (alpha,NodeOrbits) -> (apply(#NodeOrbits, j -> brhiealpha(j,alpha,NodeOrbits)))

-- Check that alphatilde is constant on elements of L4

all(L4, i -> #(unique apply(i, j -> alphatilde(j)))==1)




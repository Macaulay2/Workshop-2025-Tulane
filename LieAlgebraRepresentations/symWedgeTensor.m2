-- Goal: given the action of a Lie algebra g on a vector space W, 
-- compute the g action on Sym^d W,  Wedge^k W,
-- Given also the action on V,
-- compute the action on V otimes W


----------------------
----------------------
-- Sym^d W
----------------------
----------------------



-- Represent a degree d monomial as an exponent vector
-- Compute two hash tables: 
-- Z to E: the exponent vector with integer label i
-- E to Z: the integer label of an exponent vector


-- Let X be a sparse matrix recording the action of a basis element
-- Suppose X acts in the variable j
-- Get the coefficient and the monomials of the answer

-- Example: first three nonzero entries from X12 on Wedge^7 S+
-- Xhash = new HashTable from {(0, 4) => 1, (1, 5) => 1, (2, 6) => 1}



XactionOnVariablej = (Xhash,expv,j) -> (
    if expv_j == 0 then return null;
    -- Get the action in coord j
    Xwj:=select(Xhash, p -> p#0#1==j);
    if Xwj=={} then return null;
    newexpv:={};
    answer:= for t in Xwj list (
        if j==t#0#0 then newexpv = expv else newexpv=apply(#expv, i-> if i==j then expv_i-1 else if i==t#0#0 then expv_i+1 else expv_i);	
     	{newexpv, expv_j*(t#1)}
    );
    return answer
);



-- Simplify the expressions obtained
addExpressions = (H) -> (
    K:=unique apply(H, i -> first i);
    P:= for k in K list (
        {k,sum apply(select(H, h -> h_0==k), p -> p_1)}
    );
    select(P, p -> p_1 !=0)
);



-- Let X be an element of the spin basis represented as a hashtable
-- Let the monomial be represented by an exponent vector
-- Get the coefficients and the monomials of the answer
XactionOnMonomial = (Xhash,expv) -> (
    A:=delete(null,apply(#expv, j -> if expv_j > 0 then XactionOnVariablej(Xhash,expv,j)));
    addExpressions(flatten A)
);


exponentVectors = (n,d) -> (
    -*
    if d==2 then (
        B2a:=apply(n, i -> apply(n, j -> if i==j then 2 else 0));
        B2b:=apply(subsets(apply(n, i -> i),2), p -> apply(n, j -> if j==p_0 then 1 else if j==p_1 then 1 else 0));
        return sort join(B2a,B2b)
    );
    *-
    tt:=getSymbol "tt";
    SS:=QQ(monoid [tt_1..tt_n]);
    B:=flatten entries basis(d,SS);
    apply(B, i -> flatten exponents(i))
);


-- Now do the above for a basis of Symd


XactionOnSymd = (d,X) -> (
    Xsparse:=sparse X;
    n:=Xsparse#"NumberOfRows";
    Bd := exponentVectors(n,d);
    ZtoE := new HashTable from apply(#Bd, i -> {i,Bd_i});
    EtoZ := new HashTable from apply(#Bd, i -> {Bd_i,i});
    Xhash:=pairs(Xsparse#"Entries");
    N:=#keys(ZtoE);
    -- Build the matrix column-by-column
    M:={};
    Mj:={};
    i:=-1;
    for j from 0 to N-1 do (
      Mj=XactionOnMonomial(Xhash,ZtoE#j);
      for p in Mj do (
	i = EtoZ#(p_0);
        M = append(M, (i,j)=> p_1)  
      )
    );
    return sparseMatrix(N,N,Xsparse#"BaseRing",new HashTable from M)
);


symmetricPowerRepresentation = method(
    TypicalValue=>LieAlgebraModule
);

symmetricPowerRepresentation(ZZ,LieAlgebraModule) := (d,V) -> (
    W:=symmetricPower(d,V);
    rho:=V.cache#representation;
    CB:=rho_0;
    rhoB:=rho_1;
    installRepresentation(W,CB,apply(rhoB, M -> XactionOnSymd(d,M)));
    W
);



----------------------
----------------------
-- Wedge^k W
----------------------
----------------------


-- Suppose X acts in the variable j
-- Get the coefficient and the monomials of the answer

-- Example: first three nonzero entries from X12 on Wedge^7 S+
-- Xhash = new HashTable from {(0, 4) => 1, (1, 5) => 1, (2, 6) => 1}


-- Input: a list of integer labels, not necessarily increasing
straightenSign = (a) -> (
    b:=sort apply(#a, i -> {a_i,i});
    permutationSign(apply(b, i -> last i))
);



-- Let X be an element of g, represented in M2 sparse form 
-- That is, a list of options, e.g. {(0, 4) => 1, (1, 5) => 1, (2, 6) => 1}
-- Let wedge be a k-subset of {0,...,n-1}
-- Get the answer when X acts in the j^th position of a wedge (where counting starts at 0)
XactionInPositionj = (Xhash,wedge,j) -> (
    -- Get the action in coord j
    Xwj:=select(Xhash, p -> p#0#1==wedge_j);
    if Xwj=={} then return null;
    --if not Xhash#?(ZtoW#(wedge_j)) then return null;
    newwedge:={};
    dj:=0;
    answer:= for t in Xwj list (
	if not member(t#0#0,drop(wedge,{j,j})) then (
            if wedge_j==t#0#0 then newwedge = wedge else newwedge = apply(#wedge, k -> if k==j then t#0#0 else wedge_k);
	    dj = straightenSign(newwedge);
     	    {sort newwedge, dj*(t#1)}
	)
    );
    return delete(null,answer)
); 
    
  

-- Let X be an element of the spin basis represented as a hashtable
-- Let wedge be a k-subset of {0,...,n-1}
-- Get the coefficients and the wedges of the answer
XactionOnWedge = (Xhash,wedge) -> (
    A:=delete(null,apply(#wedge, j -> XactionInPositionj(Xhash,wedge,j)));
    addExpressions(flatten A)
);


-- Now do the above for a basis of Wedgek


XactionOnWedgek = (k,X) -> (
    Xsparse:= sparse X;
    n:=Xsparse#"NumberOfRows";
    Bk := subsets(apply(n, i -> i),k);
    ZtoW := new HashTable from apply(#Bk, i -> {i,Bk_i});
    WtoZ := new HashTable from apply(#Bk, i -> {Bk_i,i});
    Xhash:=pairs(Xsparse#"Entries");
    N:=#keys(ZtoW);
    -- Build the matrix column-by-column
    M:={};
    Mj:={};
    i:=-1;
    for j from 0 to N-1 do (
      Mj=XactionOnWedge(Xhash,ZtoW#j);
      for p in Mj do (
	i = WtoZ#(p_0);
        M = append(M, (i,j)=> p_1)  
      )
    );
    return sparseMatrix(N,N,Xsparse#"BaseRing",new HashTable from M)
);


exteriorPowerRepresentation = method(
    TypicalValue=>LieAlgebraModule
);


exteriorPowerRepresentation(ZZ,LieAlgebraModule) := (k,V) -> (
    W:=exteriorPower(k,V);
    rho:=V.cache#representation;
    CB:=rho_0;
    rhoB:=rho_1;
    installRepresentation(W,CB,apply(rhoB, M -> XactionOnWedgek(k,M)));
    W
);




--------------------------------------------
--------------------------------------------
-- V otimes W, both modules over g
--------------------------------------------
--------------------------------------------


-- Compute X(B1_i otimes B2_j) = rho1X(B1_i) otimes B2_j + B1_i otimes rho2X(B2_j)
---- Assume the inputs rho1X and rho2X are both sparse
XactionOnPair = (rho1Xhash,rho2Xhash,i,j) -> (
    --Xi otimes j
    e1:=select(rho1Xhash, p -> p#0#1==i);
    L1:=apply(e1, p -> {{p#0#0,j},p#1});
    e2:=select(rho2Xhash, p -> p#0#1==j);
    L2:=apply(e2, p -> {{i,p#0#0},p#1});    
    L:=join(L1,L2);
    U:=unique apply(L, i -> first i);
    return apply(U, p -> {p,last sum select(L, x -> x_0==p)})
);


-- Now do the above for a basis of Wedgek


XactionOnTensorProduct = (rho1X,rho2X) -> (
    if rho1X#"BaseRing" =!= rho2X#"BaseRing" then error "The matrices do not have the same base ring" << endl;
    m1:=rho1X#"NumberOfRows";
    m2:=rho2X#"NumberOfRows";
    domainPairs:=flatten apply(m1, i -> apply(m2, j -> {i,j}));
    codomainPairs:=domainPairs;
    L:={};
    Xp:={};
    p:={};
    q:={};
    for k from 0 to #domainPairs-1 do (
        p = domainPairs_k;
	Xp=new HashTable from XactionOnPair(pairs(rho1X#"Entries"),pairs(rho2X#"Entries"),p_0,p_1);
	for l from 0 to #codomainPairs-1 do (
	    q = codomainPairs_l;
            if Xp#?q and Xp#q != 0 then L = append(L,{(k,l),Xp#q})
	)
    );
    return transpose sparseMatrix(m1*m2,m1*m2,rho1X#"BaseRing",new HashTable from L)
);


tensorProductRepresentation = method(
    TypicalValue=>LieAlgebraModule
);

tensorProductRepresentation(LieAlgebraModule,LieAlgebraModule) := (V,W) -> (
    U:=V**W;
    rho1:=V.cache#representation;
    rho2:=W.cache#representation;
    if rho1_0 =!= rho2_0 then error "The representations do not have the same Chevalley basis" << endl;
    R1:=(sparse(rho1_1_0))#"BaseRing";
    R2:=(sparse(rho2_1_0))#"BaseRing";
    if R1 =!= R2 then error "The representations do not have the same base ring" << endl;
    CB:=rho1_0;
    installRepresentation(U,CB,apply(#CB, i -> XactionOnTensorProduct(sparse((rho1_1_i)),sparse ((rho2_1)_i))));
    U
);






--------------------------------------------
--------------------------------------------
-- A few extra things
--------------------------------------------
--------------------------------------------


checkLieAlgHomOnPair = (B, rhoB, br1,br2,i, j, writeInBasisFunction) -> (
    gbracket := br1(B_i,B_j);    
    Wbracket := br2(rhoB_i,rhoB_j);
    c := writeInBasisFunction(gbracket);
    Wbracket == sum apply(#rhoB, i -> c_i*rhoB_i)
);


isLieAlgebraHomomorphism = (B, rhoB, br1,br2,writeInBasisFunction) -> (
    for i from 0 to #B-2 do (
        for j from i+1 to #B-1 do (
	    if not checkLieAlgHomOnPair(B,rhoB,br1,br2,i,j,writeInBasisFunction) then (
	        print concatenate("Brackets not compatible on basis elements ",toString({i,j})) << endl;
		return false
	    )
        )
    );
    return true
);	


-*
isDiagonalMatrix = (M) -> (
    for i from 0 to numRows(M)-1 do (
        for j from 0 to numColumns(M)-1 do (
	    if j!=i and M_(i,j)!=0 then return false
	)
    );
    return true
);
*-



evToMonomial = (ev,R) -> (
    product apply(#ev, i -> if ev_i==0 then 1 else (R_i)^(ev_i))
);










end


--------------------------------------------------
--------------------------------------------------
-- Example 1: sl2, Sym^2 Std 
--------------------------------------------------
--------------------------------------------------

sl2=simpleLieAlgebra("A",1);
V = standardModule(sl2);
peek V
-- So V only has character information
-- Add the data of the standard representation
CB = chevalleyBasis("A",1);
installRepresentation(V,CB,CB#"BasisElements");

-- Now form the symmetric power
W = symmetricPowerRepresentation(2,0,V)
peek W
-- Look at the representation
sym2rho = (W.cache#representations)_0

-- Check against calculation by hand
sym2rho_1 == {sparseMatrix(3,3,QQ,new HashTable from {(0,0) => 2, (2,2) => -2}),sparseMatrix(3,3,QQ,new HashTable from {(0,1) => 1, (1,2) => 2}),sparseMatrix(3,3,QQ,new HashTable from {(1,0) => 2, (2,1) => 1})}



------------------------------------------------------------
------------------------------------------------------------
-- Example 2: Wedge^2 Std for sl3
------------------------------------------------------------
------------------------------------------------------------

sl3=simpleLieAlgebra("A",2);
V = standardModule(sl3);
peek V
-- So V only has character information
-- Add the data of the standard representation
CB = chevalleyBasis("A",2);
installRepresentation(V,CB,CB#"BasisElements");


-- Now form the symmetric power
W = exteriorPowerRepresentation(2,V)
peek W
-- Look at the representation
wedge2rho = W.cache#representation

-- Check against calculation by hand


------------------------------------------------------------
------------------------------------------------------------
-- Example 3: V11 otimes V10 for sl3
------------------------------------------------------------
------------------------------------------------------------

sl3=simpleLieAlgebra("A",2);
V = irreducibleLieAlgebraModule({1,1},sl3);
CB = chevalleyBasis("A",2);
installRepresentation(V,CB,GTrepresentationMatrices(V,{1,1}));
W = irreducibleLieAlgebraModule({1,0},sl3);
installRepresentation(W,CB,GTrepresentationMatrices(W,{1,0}));

U = tensorProductRepresentation(0,V,0,W);
Ymats = ((U.cache#representations)_0)_1;

-- Check against calculation by previous code
load "Xmats.m2"
Xmats==Ymats





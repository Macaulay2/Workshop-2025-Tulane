-- Restrict a sparse matrix to a subdomain and subcodomain

restrictRaisingOperatoritoWtmuSpace = (rho,i,mu) -> (
    W:=rho#"Module";
    CB:=rho#"Basis";
    L:=rho#"RepresentationMatrices";
    ROI:=CB#"RaisingOperatorIndices";
    weightShift:=(CB#"Weights")_(ROI_i);
    Wweights:=representationWeights(rho);
    domainIndices:=select(dim W, i -> Wweights_i==mu);
    codomainIndices:=select(dim W, i -> Wweights_i==mu+weightShift);
    M:=L_(ROI_i);
    if instance(M,Matrix) then (
	return M_domainIndices^codomainIndices
    ) else (
        return restrict(M,codomainIndices,domainIndices)
    )
);


weightMuHighestWeightVectorsInW = method(
    TypicalValue=>Matrix
);    

weightMuHighestWeightVectorsInW(List,LieAlgebraRepresentation) := (mu,rho) -> (
    W:=rho#"Module";
    CB:=rho#"Basis";
    L:=rho#"RepresentationMatrices";
    ROI:=CB#"RaisingOperatorIndices";
    K:=entries gens intersect apply(#ROI, i -> ker dense restrictRaisingOperatoritoWtmuSpace(rho,i,mu));
    Wweights:=representationWeights(rho);
    domainIndices:=select(dim W, i -> Wweights_i==mu);
    z:=apply(#(K_0), i -> 0);
    return matrix apply(dim W, i -> if member(i,domainIndices) then K_(position(domainIndices,x->x==i)) else z)
);


-- Here are a bunch of internal functions that are used to evaluate words
-- in the lowering operators on the highest weight vector

monomialFactors = (m) -> (
    e:=flatten exponents(m);
    A:={};
    for i from 0 to #e-1 do (
	for j from 0 to e_i-1 do (
	    A=append(A,i)
	)
    );    
    return sort A
);



actOnMonomial = (X,m) -> (
    --if first(degree(m))>2 then error "Only implemented for degrees 1 and 2";
    mf:=monomialFactors(m);
    R:=ring(m);
    --if first(degree(m))==1 then return (X(R_(mf_0)));
    --if first(degree(m))==2 then return (X(R_(mf_0))*(R_(mf_1)) + (R_(mf_0))*(X(R_(mf_1))));
    sum apply(#mf, i -> product(#mf, j -> if i==j then X(R_(mf_j)) else R_(mf_j)))
);



act = memoize((X,f) -> (
    if f==0_(ring f) then return f;
    T:=terms(f);
    sum apply(T, t -> leadCoefficient(t)*actOnMonomial(X,leadMonomial(t)))
));



applyTerm = (t,v,actInstance,LoweringOperators) -> (
    c:=t_1;
    w:=t_0;
    if w=={} then return v;
    x:=reverse(w);
    u:=v;
    for i from 0 to #x-1 do (
	u = actInstance(LoweringOperators_(x_i),u);
	if u==0 then return u;
    );
    return c*u    
);



applyWord = (w,v,actInstance,LoweringOperators) -> (
    T:=w#"Terms";
    sum apply(T, t -> applyTerm(t,v,actInstance,LoweringOperators))
);



VInSymdW = method(
    TypicalValue=>List
);

VInSymdW(LieAlgebraRepresentation,ZZ,LieAlgebraRepresentation,Matrix) := (rhoV,d,rhoW,hwv) -> (
    V:=rhoV#"Module";
    CBV:=rhoV#"Basis";
    LV:=rhoV#"RepresentationMatrices";
    W:=rhoW#"Module";
    CBW:=rhoW#"Basis";
    LW:=rhoW#"RepresentationMatrices";
    -- Check that they use the same basis of g
    if CBV =!= CBW then error "V and W do not use the same basis" << endl;
    CB:=CBV;
    n:=dim W;
    B:=getSymbol "B";
    R:=QQ[apply(n, i -> B_i),MonomialOrder=>Lex];
    Wweights:=representationWeights(rhoW);
    R.cache = new CacheTable from {"Weights"=>Wweights};
    LOMaps:={};
    if instance(LW_0,SparseMatrix) then (
        LOMaps=apply(CB#"LoweringOperatorIndices", i -> ringMap(R,R,LW_i))
    ) else (
        LOMaps=apply(CB#"LoweringOperatorIndices", i -> map(R,R,LW_i))
    );
    basisWords:=basisWordsFromMatrixGenerators(rhoV);
    hwvR := ( (basis(d,R))*(hwv) )_(0,0);
    apply(basisWords, w -> applyWord(w,hwvR,act,LOMaps))
)



VInWedgekW = method(
    TypicalValue=>List
);    

VInWedgekW(LieAlgebraRepresentation,ZZ,LieAlgebraRepresentation,Matrix) := (rhoV,k,rhoW,hwv) -> (
    V:=rhoV#"Module";
    CBV:=rhoV#"Basis";
    LV:=rhoV#"RepresentationMatrices";
    W:=rhoW#"Module";
    CBW:=rhoW#"Basis";
    LW:=rhoW#"RepresentationMatrices";
    -- Check that they use the same basis of g
    if CBV =!= CBW then error "V and W do not use the same basis" << endl;
    CB:=CBV;
    WedgekW:=exteriorPower(k,rhoW);
    n:=dim W;
    Bk := subsets(apply(n, i -> i),k);
    p:=getSymbol "p";
    R:=QQ[apply(Bk, i -> p_i),MonomialOrder=>Lex];
    m:=CB#"LieAlgebra"#"LieAlgebraRank";
    Wweights:=representationWeights(rhoW);
    Wedgekweights := apply(Bk, s -> sum apply(s, j -> Wweights_j));
    R.cache = new CacheTable from {"Weights"=>Wedgekweights};
    LWedgekW:=WedgekW#"RepresentationMatrices";
    LOMaps:=apply(CB#"LoweringOperatorIndices", i -> ringMap(R,R,LWedgekW_i));
    basisWords:=basisWordsFromMatrixGenerators(rhoV);
    hwvR := ( (vars R)*(hwv) )_(0,0);
    apply(basisWords, w -> applyWord(w,hwvR,act,LOMaps))
);



UInVtensorW = method(
    TypicalValue=>List
);

UInVtensorW(LieAlgebraRepresentation,LieAlgebraRepresentation,LieAlgebraRepresentation,Matrix) := (rhoU,rhoV,rhoW,hwv) -> (
    U:=rhoU#"Module";
    CBU:=rhoU#"Basis";
    LU:=rhoU#"RepresentationMatrices";    
    V:=rhoV#"Module";
    CBV:=rhoV#"Basis";
    LV:=rhoV#"RepresentationMatrices";
    W:=rhoW#"Module";
    CBW:=rhoW#"Basis";
    LW:=rhoW#"RepresentationMatrices";
    -- Check that they use the same basis of g
    if CBU =!= CBV then error "U and V do not use the same basis" << endl;
    if CBU =!= CBW then error "U and W do not use the same basis" << endl;
    CB:=CBU;
    n1:=dim V;
    n2:=dim W;
    A:=getSymbol "A";
    B:=getSymbol "B";
    R:=QQ[join(apply(n1, i -> A_i),apply(n2, i -> B_i)),MonomialOrder=>Lex];
    domainPairs:= flatten apply(n1, i -> apply(n2, j -> {i,j}));
    hwvR:=sum apply(#domainPairs, i -> hwv_(i,0)*R_((domainPairs_i)_0)*R_(n1+((domainPairs_i)_1)));
    Vweights:=representationWeights(rhoV);
    Wweights:=representationWeights(rhoW);
    R.cache = new CacheTable from {"Weights"=>join(Vweights,Wweights)};
    LOMaps:=apply(CB#"LoweringOperatorIndices", i->  ringMap(R,R,diagonalJoin(sparse(LV_i),sparse(LW_i))));
    basisWords:=basisWordsFromMatrixGenerators(rhoU);
    apply(basisWords, w -> applyWord(w,hwvR,act,LOMaps))
)








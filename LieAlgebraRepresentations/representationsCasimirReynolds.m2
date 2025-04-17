
installRepresentation = method(
);

installRepresentation(LieAlgebraModule,LieAlgebraBasis,List) := (V,CB,rhoB) -> (
    if V.cache#?representation then error "V already has a representation. Remove it before installing another." << endl;
    V.cache#representation = {CB,rhoB};
)

representationWeights = method(
    TypicalValue=>List
);

representationWeights(LieAlgebraModule) := memoize((W) -> (
    rho:=W.cache#representation;
    sparseGenerators:=instance(rho_1_0,SparseMatrix); 
    CB:=rho_0;
    dimW:=-1;
    Wweights:={};
    m:=CB#"LieAlgebra"#"LieAlgebraRank";
    if not sparseGenerators then (
	 return apply(dim W, i -> apply(m, j -> lift((rho_1_j)_(i,i),ZZ)))
    ) else (
         return apply(dim W, i -> apply(m, j -> if ((rho_1_j)#"Entries")#?(i,i) then lift(((rho_1_j)#"Entries")#(i,i),ZZ) else 0))
    )
));



-- Let V be a LieAlgebraModule with a representation rho installed

-- The Casimir operator is sum_i rho(Bstar_i)*rho(B_i)

casimirOperator = method(
);


casimirOperator(LieAlgebraModule) := (W) -> (
    rho:=W.cache#representation;
    --sparseGenerators:=instance(rho_1_0,SparseMatrix);
    CB:=rho_0;
    rhoB:=apply(rho_1, M->dense M);
    M:={};
    c:={};
    rhoBstar:=for i from 0 to #rhoB-1 list (
        M=(CB#"DualBasis")_i;
	c=(CB#"WriteInBasis")(M);
	sum apply(#rhoB, j -> c_j*rhoB_j)
    );
    sum apply(#rhoB, i -> (rhoBstar_i)*(rhoB_i))
);


casimirSpectrum = method(
    TypicalValue=>List
);


casimirSpectrum(LieAlgebraModule) := (W) -> (
    unique sort apply(keys(W#"DecompositionIntoIrreducibles"), w -> casimirScalar(irreducibleLieAlgebraModule(w,W#"LieAlgebra")))
);



casimirProjection = method(
);


casimirProjection(LieAlgebraModule,ZZ) := (W,z) -> (
    casimirProjection(W,1/1*z)
);

casimirProjection(LieAlgebraModule,QQ) := (W,z) -> (
    Cas:=casimirOperator(W);
    L:=delete(1/1*z,casimirSpectrum(W));
    N:=dim W;
    I:={};
    if instance(Cas,Matrix) then (
	I = matrix apply(N, i -> apply(N, j -> if i==j then 1_(ring Cas) else 0))
    ) else (
        I = sparseMatrix(N,N,Cas#"BaseRing",new HashTable from apply(N, i -> {(i,i),1_(Cas#"BaseRing")}))
    );
    product apply(L, x -> (Cas-x*I))
);


reynoldsOperator = method(
);


reynoldsOperator(LieAlgebraModule) := (W) -> (
    casimirProjection(W,0)
);


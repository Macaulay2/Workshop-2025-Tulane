LieAlgebraRepresentation = new Type of HashTable  
-- Keys:
-- Character
-- Basis
-- RepresentationMatrices

lieAlgebraRepresentation = method(
    TypicalValue=>LieAlgebraRepresentation
);


lieAlgebraRepresentation(LieAlgebraModule,LieAlgebraBasis,List):=(V,LAB,L) -> (
    new LieAlgebraRepresentation from {
        "Module"=>V,
        "Basis"=>LAB,
	"RepresentationMatrices"=>L
    }
);



trivialRepresentation = method(
    TypicalValue => LieAlgebraRepresentation
    )

trivialRepresentation(String,ZZ) := (type,m) -> (
    CB:=lieAlgebraBasis(type,m);
    trivialRepresentation(CB)
);

trivialRepresentation(LieAlgebra) := (g) -> (
    CB:=lieAlgebraBasis(g);
    trivialRepresentation(CB)
);

trivialRepresentation(LieAlgebraBasis) := CB -> (   
    L := apply(#(CB#"BasisElements"), i -> matrix {{0/1}});
    V := trivialModule(CB#"LieAlgebra");
    lieAlgebraRepresentation(V,CB,L)
);


standardRepresentation = method(
    TypicalValue => LieAlgebraRepresentation
    )

standardRepresentation(String,ZZ) := (type,m) -> (
    CB:=lieAlgebraBasis(type,m);
    standardRepresentation(CB)
);

standardRepresentation(LieAlgebra) := g -> (
    CB:=lieAlgebraBasis(g);
    standardRepresentation(CB)
);

standardRepresentation(LieAlgebraBasis) := CB -> (
    V := standardModule(CB#"LieAlgebra");
    lieAlgebraRepresentation(V,CB,CB#"BasisElements")
);


adjointRepresentation = method(
    TypicalValue => LieAlgebraRepresentation
    )

adjointRepresentation(String,ZZ) := (type,m) -> (
    CB:=lieAlgebraBasis(type,m);
    adjointRepresentation(CB)
);

adjointRepresentation(LieAlgebra) := (g) -> (
    CB:=lieAlgebraBasis(g);
    adjointRepresentation(CB)
);

adjointRepresentation(LieAlgebraBasis) := CB -> (
    br := CB#"Bracket";
    writeInBasis := CB#"WriteInBasis";
    B := CB#"BasisElements";
    ad := X -> transpose matrix apply(B, Y -> writeInBasis br(X,Y));
    L := apply(B, X -> ad X);
    V := adjointModule(CB#"LieAlgebra");
    lieAlgebraRepresentation(V,CB,L)
);






representationWeights = method(
    TypicalValue=>List
);

representationWeights(LieAlgebraRepresentation) := memoize((rho) -> (
    W:=rho#"Module";
    CB:=rho#"Basis";
    L:=rho#"RepresentationMatrices";
    sparseGenerators:=instance(L_0,SparseMatrix); 
    Wweights:={};
    m:=CB#"LieAlgebra"#"LieAlgebraRank";
    L1:={};
    if not sparseGenerators then (
	 L1=apply(dim W, i -> apply(m, j -> (L_j)_(i,i)))
    ) else (
         L1=apply(dim W, i -> apply(m, j -> if ((L_j)#"Entries")#?(i,i) then ((L_j)#"Entries")#(i,i) else 0))
    );
    M:=CB#"FundamentalDominantWeightValues";
    L2:=apply(L1, v -> flatten entries(M*(transpose matrix {v})));
    apply(L2, v -> apply(v, i -> lift(i,ZZ)))
));



-- Let V be a LieAlgebraModule with a representation rho installed

-- The Casimir operator is sum_i rho(Bstar_i)*rho(B_i)

casimirOperator = method(
);


casimirOperator(LieAlgebraRepresentation) := (rho) -> (
    W:=rho#"Module";
    CB:=rho#"Basis";
    L:=rho#"RepresentationMatrices";
    rhoB:=apply(L, M->dense M);
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


casimirProjection(LieAlgebraRepresentation,ZZ) := (rho,z) -> (
    casimirProjection(rho,1/1*z)
);

casimirProjection(LieAlgebraRepresentation,QQ) := (rho,z) -> (
    Cas:=casimirOperator(rho);
    W:=rho#"Module";
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


reynoldsOperator(LieAlgebraRepresentation) := (rho) -> (
    casimirProjection(rho,0)
);


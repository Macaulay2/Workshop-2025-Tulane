
--Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );
Hin = (i,n) -> ( Eijm(i,i,n) - Eijm(i+1,i+1,n));

-- Want to change between Dynkin basis of the weight lattice and L_i basis
-- Use the formula omega_j = L_1+...+L_j from [FH, Section 15]
-- Very similar to the formula for type C in [FH, Section 17.2]
DtoLMatrix = memoize((n) -> (
    transpose matrix apply(n, j -> apply(n, i -> if i<=j then 1 else 0/1))    
));


DtoL = (v) -> (
    M:=DtoLMatrix(#v);
    flatten entries(M*(transpose matrix {v}))
);


LtoD = (v) -> (
    M:=DtoLMatrix(#v);
    w:=flatten entries(M^-1*(transpose matrix {v}));
    apply(w, i -> lift(i,ZZ))
);

-*
LiminusLj = (i,j,n) -> (
    v:=apply(n-1, k -> if k==i then 1 else if k==j then -1 else 0/1);
    LtoD(v)
);
*-

LiminusLj = (i,j,n) -> (
    ei:={};
    if i==n-1 then ei = apply(n-1, k -> -1/1) else ei = apply(n-1, k -> if k==i then 1 else 0/1);
    ej:={};
    if j==n-1 then ej = apply(n-1, k -> -1/1) else ej = apply(n-1, k -> if k==j then 1 else 0/1);
    LtoD(ei-ej)
);




-- May 2025: change the order to match the positive roots in lex-level order
slnBasisElements = memoize((n) -> (
    Hbasis := apply(n-1, i -> Hin(i,n));
    PhiPlus := positiveRoots("A",n-1);
    unorderedXbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then Eijm(i,j,n))));
    Xbasisweights := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then LiminusLj(i,j,n) )));
    unorderedYbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then Eijm(i,j,n))));
    Ybasisweights := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then LiminusLj(i,j,n) )));
    Xbasis := apply(#PhiPlus, i -> first delete(null,apply(#Xbasisweights, j -> if Xbasisweights_j==PhiPlus_i then unorderedXbasis_j)));
    Ybasis := apply(#PhiPlus, i -> first delete(null,apply(#Ybasisweights, j -> if Ybasisweights_j==-PhiPlus_i then unorderedYbasis_j)));
    flatten {Hbasis, Xbasis, Ybasis}
));






slnDualBasis = (n,B) -> (
    Hcoeffs := entries(inverse(1/1*cartanMatrix("A",n-1)));
    Hdual := apply(n-1, i -> sum apply(n-1, j -> (Hcoeffs_i_j)*(B_j)));
    l:=lift((#B-(n-1))/2,ZZ);
    Xbasis := apply(l, i -> B_(n-1+i));
    Ybasis := apply(l, i -> B_(n-1+l+i));
    flatten {Hdual, Ybasis, Xbasis}
);




slnBasisWeights = (n) -> (
    PhiPlus:=positiveRoots("A",n-1);
    Hbasis := apply(n-1, i -> apply(n-1, i -> 0)); 
    flatten {Hbasis, PhiPlus, apply(PhiPlus, i -> -i)}
);


labelOfMatrix = (E) -> (
    S:=sparse E;
    k:=first keys(S#"Entries");
    (k_0,k_1)
);


labelOfMatrix1 = (E) -> (
    S:=sparse E;
    k:=first keys(S#"Entries");
    (k_0+1,k_1+1)
);



slnBasisSubscripts = memoize((n) -> (
    B:=slnBasisElements(n);
    l:=lift((#B-(n-1))/2,ZZ);
    apply(l, i -> labelOfMatrix(B_(n-1+i)))  
));


slnBasisLabels = (n) -> (
    B:=slnBasisElements(n);
    l:=lift((#B-(n-1))/2,ZZ);
    HbasisLabels := apply(n-1, i -> "H_"|toString(i+1));
    XandYbasisLabels := apply(2*l, i -> "E_"|toString(labelOfMatrix1(B_(n-1+i))));  
    flatten {HbasisLabels, XandYbasisLabels}
);



slnRaisingOperatorIndices = (n) -> (
    l:=lift(n*(n-1)/2,ZZ);
    apply(l, i -> (n-1)+i)
);



slnLoweringOperatorIndices = (n) -> (
    l:=lift(n*(n-1)/2,ZZ);
    apply(l, i -> (n-1)+l+i)
);





-- Need to update this
writeInslnBasis = (M) -> (
    n:=numRows M;
    Hcoeffs:=apply(n-1, i -> sum apply(i+1, j -> M_(j,j)));
    L:=slnBasisSubscripts(n);
    l:=#L;
    Xcoeffs := apply(L, p -> M_p);   
    Ycoeffs := apply(L, p -> M_(p_1,p_0));     
    flatten {Hcoeffs,Xcoeffs,Ycoeffs}
);

br = (A,B) -> A*B-B*A;



-- Lie algebra
-- Basis
-- Dual basis
-- Weights
-- Labels
-- RaisingOperatorIndices
-- LoweringOperatorIndices
-- WriteInBasis

slnBasis = (n) -> (
    B:=slnBasisElements(n);
    new LieAlgebraBasis from {
	"LieAlgebra"=>simpleLieAlgebra("A",n-1),
        "BasisElements"=>B,
	"Bracket"=>br,
	"DualBasis"=> slnDualBasis(n,B),
        "Weights"=>slnBasisWeights(n),
	"Labels"=>slnBasisLabels(n),
	"RaisingOperatorIndices"=>slnRaisingOperatorIndices(n),
	"LoweringOperatorIndices"=>slnLoweringOperatorIndices(n),
	"WriteInBasis"=>writeInslnBasis,
	"FundamentalDominantWeightValues"=>matrix apply(n-1, i -> apply(n-1, j -> if i==j then 1 else 0/1))
    }
);


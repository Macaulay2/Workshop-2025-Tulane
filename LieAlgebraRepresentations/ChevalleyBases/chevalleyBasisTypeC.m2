-- See Fulton and Harris, Section 16.1, especially p. 240


typeCHin = (i,n) -> ( Eijm(i,i,2*n) - Eijm(n+i,n+i,2*n));
typeCXijn = (i,j,n) -> ( Eijm(i,j,2*n)-Eijm(n+j,n+i,2*n));
typeCYijn = (i,j,n) -> ( Eijm(i,n+j,2*n)+Eijm(j,n+i,2*n));
typeCZijn = (i,j,n) -> ( Eijm(n+i,j,2*n)+Eijm(n+j,i,2*n));


sp2nBasisElements = (n) -> (
    Hbasis := apply(n, i -> typeCHin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then typeCXijn(i,j,n))));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeCYijn(i,j,n)))); 
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeCZijn(i,j,n))));
    Ubasis := apply(n, i -> Eijm(i,n+i,2*n));
    Vbasis := apply(n, i -> Eijm(n+i,i,2*n)); 
    flatten {Hbasis, Xbasis, Ybasis, Zbasis,Ubasis,Vbasis}
);



sp2nDualBasis = (n) -> (
    B:={};
    Hbasis := apply(n, i -> 1/2*typeCHin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then 1/2*typeCXijn(j,i,n))));   
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then 1/2*typeCZijn(i,j,n)))); 
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then 1/2*typeCYijn(i,j,n))));
    Vbasis := apply(n, i -> Eijm(n+i,i,2*n));
    Ubasis := apply(n, i -> Eijm(i,n+i,2*n));
    flatten {Hbasis, Xbasis, Zbasis, Ybasis, Vbasis,Ubasis}
);




-- Want to change between Dynkin basis of the weight lattice and L_i basis
-- Use the formula for type C in [FH, Section 17.2], p. 259
DtoLMatrixTypeC = memoize((n) -> (
    transpose matrix apply(n, j -> apply(n, i -> if i<=j then 1 else 0/1))    
));


DtoLTypeC = (v) -> (
    M:=DtoLMatrixTypeC(#v);
    flatten entries(M*(transpose matrix {v}))
);


LtoDTypeC = (v) -> (
    M:=DtoLMatrixTypeC(#v);
    w:=flatten entries(M^-1*(transpose matrix {v}));
    apply(w, i -> lift(i,ZZ))
);


sp2nBasisWeights = (n) -> (
    -- First make the weights in the Li basis
    -- Cartan subalgebra: weight 0
    Hweights := apply(n, i -> apply(n, i -> 0));
    -- Xij has weight Li-Lj
    Xweights := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then apply(n, k -> if k==i then 1 else if k==j then -1 else 0/1) )));
    -- Yij has weight Li+Lj
    Yweights := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then apply(n, k -> if k==i then 1 else if k==j then 1 else 0/1) )));
    -- Zij has weight -Li-Lj
    Zweights := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then apply(n, k -> if k==i then -1 else if k==j then -1 else 0/1))));
    -- Uij has weight 2Li
    Uweights := apply(n, i -> apply(n, k -> if k==i then 2 else 0/1));
    -- Vij has weight -2Li
    Vweights:= apply(n, i -> apply(n, k -> if k==i then -2 else 0/1));
    Lweights:=flatten {Hweights, Xweights, Yweights,Zweights,Uweights,Vweights};
    apply(Lweights, v -> LtoDTypeC v)
);




sp2nBasisLabels = (n) -> (
    B:={};
    Hbasis := apply(n, i -> "H_"|toString(i));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then "X_"|toString(i,j) )));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then "Y_"|toString(i,j) ))); 
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then "Z_"|toString(i,j) )));
    Ubasis := apply(n, i -> "U_"|toString(i));
    Vbasis := apply(n, i -> "V_"|toString(i));
    flatten {Hbasis, Xbasis, Ybasis, Zbasis,Ubasis,Vbasis}
);



sp2nRaisingOperatorIndices = (n) -> (
    XPositiveRoots := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeCXijn(i,j,n))));   
    YPositiveRoots := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeCYijn(i,j,n)))); 
    UPositiveRoots := apply(n, i -> Eijm(i,n+i,2*n));
    sp2nPositiveRoots:=flatten {XPositiveRoots, YPositiveRoots,UPositiveRoots};
    B:=sp2nBasisElements(n);
    select(#B, i -> member(B_i,sp2nPositiveRoots))
);


sp2nLoweringOperatorIndices = (n) -> (
    L:=sp2nRaisingOperatorIndices(n);
    B:=sp2nBasisElements(n);
    select(#B, i -> i>=n and not member(i,L))
);


writeInsp2nBasis = (M) -> (
    n:=lift(numrows(M)/2,ZZ);
    Hcoeffs:= apply(n, i -> M_(i,i));
    Xcoeffs:= flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then M_(i,j)))); 
    Ycoeffs := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then M_(i,n+j)))); 
    Zcoeffs := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then M_(n+j,i))));
    Ucoeffs := apply(n, i -> M_(i,n+i));
    Vcoeffs := apply(n, i -> M_(n+i,i));    
    return flatten {Hcoeffs, Xcoeffs, Ycoeffs, Zcoeffs,Ucoeffs,Vcoeffs}
);



-- Lie algebra
-- Basis
-- Dual basis
-- Weights
-- Labels
-- RaisingOperatorIndices
-- LoweringOperatorIndices
-- WriteInBasis

sp2nBasis = (n) -> (
    B:=sp2nBasisElements(n);
    new ChevalleyBasis from {
	"LieAlgebra"=>simpleLieAlgebra("C",n),
        "BasisElements"=>B,
	"Bracket"=> (A,B) -> A*B-B*A,
	"DualBasis"=> sp2nDualBasis(n),
        "Weights"=>sp2nBasisWeights(n),
	"Labels"=>sp2nBasisLabels(n),
	"RaisingOperatorIndices"=>sp2nRaisingOperatorIndices(n),
	"LoweringOperatorIndices"=>sp2nLoweringOperatorIndices(n),
	"WriteInBasis"=>writeInsp2nBasis
    }
);



end

-- Tests


-- Does it have dimension 2n^2+n?
apply({2,3,4}, n -> #((chevalleyBasis("C",n))#"BasisElements")==2*n^2+n)

-- Does the standard representation have the correct weights?
sp6 = simpleLieAlgebra("C",3)
CB = chevalleyBasis("C",3)
V = irreducibleLieAlgebraModule({1,0,0},sp6)
installRepresentation(V,CB,CB#"BasisElements")
representationWeights(V)


-- Does the adjoint representation have the correct weights?
sp4 = simpleLieAlgebra("C",2)
CB = chevalleyBasis("C",2)
V = irreducibleLieAlgebraModule(highestRoot("C",2),sp4)
br = CB#"Bracket";
writeInBasis = CB#"WriteInBasis";
B = CB#"BasisElements";
ad = X -> transpose matrix apply(B, Y -> writeInBasis br(X,Y));
L = apply(B, X -> ad X);
installRepresentation(V,CB,L)
representationWeights(V)




sp6 = simpleLieAlgebra("C",3)
CB = chevalleyBasis("C",3)
br = CB#"Bracket";
writeInBasis = CB#"WriteInBasis";
B = CB#"BasisElements";
ad = X -> transpose matrix apply(B, Y -> writeInBasis br(X,Y));
adH = apply(3, i -> ad(B_i))
adWts = apply(#B, i -> apply(3, j -> (adH_j)_(i,i)))
apply(adWts, x -> LtoDTypeC(x))==CB#"Weights"

-- What is the Casimir operator on the adjoint representation?

L = apply(B, X -> ad X);
V = irreducibleLieAlgebraModule(highestRoot("C",3),sp6)
installRepresentation(V,CB,L)
casimirOperator(V)




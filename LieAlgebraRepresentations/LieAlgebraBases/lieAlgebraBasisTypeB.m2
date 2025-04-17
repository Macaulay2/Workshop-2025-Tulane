-- Type B so(2n+1) Lie algebras
-- written by Naufil Sakran, Dinesh Limbu, Rohan Joshi

-- See Fulton and Harris, Section 18.1, especially p. 270

--Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );
--Hin = (i,n) -> ( Eijm(i,i,n) - Eijm(i+1,i+1,n));

typeBHin = (i,n) -> ( Eijm(i,i,2*n+1) - Eijm(n+i,n+i,2*n+1));
typeBXijn = (i,j,n) -> ( Eijm(i,j,2*n+1) - Eijm(n+j,n+i,2*n+1));
typeBYijn = (i,j,n) -> ( Eijm(i,n+j,2*n+1) - Eijm(j,n+i,2*n+1));
typeBZijn = (i,j,n) -> ( Eijm(n+i,j,2*n+1) - Eijm(n+j,i,2*n+1));
typeBUin = (i,n) -> ( Eijm(i,2*n,2*n+1) - Eijm(2*n,n+i,2*n+1));
typeBVin = (i,n) -> ( Eijm(n+i,2*n,2*n+1) - Eijm(2*n,i,2*n+1));


------------------------------------------------

so2n1BasisElements = (n) -> (
    B:={};
    Hbasis := apply(n, i -> typeBHin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then typeBXijn(i,j,n))));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBYijn(i,j,n)))); 
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBZijn(j,i,n))));
    Ubasis := flatten apply(n, i -> typeBUin(i,n));
    Vbasis := flatten apply(n, i -> typeBVin(i,n));
    flatten {Hbasis, Xbasis, Ybasis, Zbasis, Ubasis, Vbasis}
);

so2n1DualBasis = (n) -> (
    B:={};
    Hbasis := apply(n, i -> typeBHin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then typeBXijn(j,i,n))));   
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBZijn(j,i,n)))); 
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBYijn(i,j,n))));
    Vbasis := flatten apply(n, i -> -typeBVin(i,n));
    Ubasis := flatten apply(n, i -> -typeBUin(i,n));
    flatten {Hbasis, Xbasis, Zbasis, Ybasis, Vbasis, Ubasis}
);


--myTrace = M -> sum (apply(numgens target M, i -> M_(i,i)))
--killingform=(M,N) -> myTrace(matrix M*N)
--myBasis = so2n1BasisElements(3);
--myDualBasis = so2n1DualBasis(3);
--matrix apply(length myBasis, i -> apply ( length myDualBasis, j -> killingform(myBasis_i,myDualBasis_j)))

DtoLMatrixTypeB = memoize((n) -> (
    M:=apply(n, i -> apply(n, j -> if j<i then 0 else if j<n-1 then 1 else 1/2));    
    matrix M
));

DtoLTypeB = (v) -> (
    M:=DtoLMatrixTypeB(#v);
    flatten entries(M*(transpose matrix {v}))
);


LtoDTypeB = (v) -> (
    M:=DtoLMatrixTypeB(#v);
    w:=flatten entries(M^-1*(transpose matrix {v}));
    apply(w, i -> lift(i,ZZ))
);


---
so2n1BasisWeights = (n) -> (
    -- First make the weights in the Li basis
    -- Cartan subalgebra: weight 0
    Hweights := apply(n, i -> apply(n, i -> 0));
    -- Xij has weight Li-Lj
    Xweights := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then apply(n, k -> if k==i then 1 else if k==j then -1 else 0/1) )));
    -- Yij has weight Li+Lj
    Yweights := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then apply(n, k -> if k==i then 1 else if k==j then 1 else 0/1) )));
    -- Zij has weight -Li-Lj
    Zweights := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then apply(n, k -> if k==i then -1 else if k==j then -1 else 0/1))));
    -- Ui has weight Li
    Uweights := apply(n, i -> apply(n, k -> if k==i then 1 else 0/1));
    -- Vi has weight -Li
    Vweights := apply(n, i -> apply(n, k -> if k==i then -1 else 0/1));

    Lweights:= flatten {Hweights, Xweights, Yweights, Zweights, Uweights, Vweights};
    apply(Lweights, v -> LtoDTypeB v)
);


so2n1BasisLabels = (n) -> (
    B:={};
    Hbasis := apply(n, i -> "H_"|toString(i));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then "X_"|toString(i,j) )));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then "Y_"|toString(i,j) ))); 
    Zbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then "Z_"|toString(j,i) ))); 
    Ubasis := apply(n, i -> "U_"|toString(i) ); 
    Vbasis := apply(n, i -> "V_"|toString(i) ); 
    flatten {Hbasis, Xbasis, Ybasis, Zbasis, Ubasis, Vbasis}
);


so2n1RaisingOperatorIndices = (n) -> (
    XRaisingOperators := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBXijn(i,j,n))));   
    YRaisingOperators := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then typeBYijn(i,j,n)))); 
    URaisingOperators := apply(n, i -> typeBUin(i, n));
    so2n1RaisingOperators:=flatten {XRaisingOperators, YRaisingOperators, URaisingOperators};
    B:=so2n1BasisElements(n);
    select(#B, i -> member(B_i,so2n1RaisingOperators))
);

so2n1LoweringOperatorIndices = (n) -> (
    L:=so2n1RaisingOperatorIndices(n);
    B:=so2n1BasisElements(n);
    select(#B, i -> i>=n and not member(i,L))
);


--- writeInBasis

-- writeInso2n1Basis
writeInso2n1Basis = (M) -> (
    n:=lift((numrows(M)-1)/2,ZZ);
    Hcoeffs:= apply(n, i -> M_(i,i));
    Xcoeffs:= flatten apply(n, i -> delete(null,apply(n, j -> if j!=i then M_(i,j)))); 
    Ycoeffs := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then M_(i,n+j)))); 
    Zcoeffs := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then M_(n+j,i))));
    Ucoeffs := apply(n, i -> M_(i,2*n));
    Vcoeffs := apply(n, i -> M_(n+i,2*n));    
    return flatten {Hcoeffs, Xcoeffs, Ycoeffs, Zcoeffs, Ucoeffs, Vcoeffs}
);



-- Lie algebra
-- Basis
-- Dual basis
-- Weights
-- Labels
-- RaisingOperatorIndices
-- LoweringOperatorIndices
-- WriteInBasis

so2n1Basis = (n) -> (
    B:=so2n1BasisElements(n);
    new LieAlgebraBasis from {
	"LieAlgebra"=>simpleLieAlgebra("B",n),
        "BasisElements"=>B,
	"Bracket"=> (A,B) -> A*B-B*A,
	"DualBasis"=> so2n1DualBasis(n),
        "Weights"=>so2n1BasisWeights(n),
	"Labels"=>so2n1BasisLabels(n),
	"RaisingOperatorIndices"=>so2n1RaisingOperatorIndices(n),
	"LoweringOperatorIndices"=>so2n1LoweringOperatorIndices(n),
	"WriteInBasis"=>writeInso2n1Basis
    }
);

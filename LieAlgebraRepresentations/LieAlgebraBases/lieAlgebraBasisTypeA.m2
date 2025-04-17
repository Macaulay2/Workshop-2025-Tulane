
--Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );
Hin = (i,n) -> ( Eijm(i,i,n) - Eijm(i+1,i+1,n));


slnBasisElements = (n) -> (
    Hbasis := apply(n-1, i -> Hin(i,n));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then Eijm(i,j,n))));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then Eijm(i,j,n))));    
    flatten {Hbasis, Xbasis, Ybasis}
);






slnDualBasis = (n,B) -> (
    Hcoeffs := entries(inverse(1/1*cartanMatrix("A",n-1)));
    Hdual := apply(n-1, i -> sum apply(n-1, j -> (Hcoeffs_i_j)*(B_j)));
    Hlabels := apply(n-1, i -> (i,i));
    Xlabels := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then (i,j))));   
    Ylabels := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then (i,j))));
    labels := flatten {Hlabels, Xlabels, Ylabels};
    Xdual := apply(Xlabels, p -> B_(first select(#labels, i -> labels_i==(p_1,p_0))));
    Ydual := apply(Ylabels, p -> B_(first select(#labels, i -> labels_i==(p_1,p_0))));
    flatten {Hdual, Xdual, Ydual}
);


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


slnBasisWeights = (n) -> (
    Hbasis := apply(n-1, i -> apply(n-1, i -> 0));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then LiminusLj(i,j,n) )));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then LiminusLj(i,j,n) ))); 
    flatten {Hbasis, Xbasis, Ybasis}
);


slnBasisLabels = (n) -> (
    Hbasis := apply(n-1, i -> "H_"|toString(i));
    Xbasis := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then "E_"|toString(i,j) )));   
    Ybasis := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then "E_"|toString(i,j) ))); 
    flatten {Hbasis, Xbasis, Ybasis}
);



slnRaisingOperatorIndices = (n) -> (
    h:=lift(n*(n-1)/2,ZZ);
    apply(h, i -> (n-1)+i)
);



slnLoweringOperatorIndices = (n) -> (
    h:=lift(n*(n-1)/2,ZZ);
    apply(h, i -> (n-1)+h+i)
);


writeInslnBasis = (M) -> (
    n:=numRows M;
    Hcoeffs:=apply(n-1, i -> sum apply(i+1, j -> M_(j,j)));
    Xcoeffs := flatten apply(n, i -> delete(null,apply(n, j -> if i<j then M_(i,j))));   
    Ycoeffs := flatten apply(n, i -> delete(null,apply(n, j -> if j<i then M_(i,j))));    
    flatten {Hcoeffs,Xcoeffs,Ycoeffs}
);

br = (A,B) -> A*B-B*A


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
	"WriteInBasis"=>writeInslnBasis
    }
);


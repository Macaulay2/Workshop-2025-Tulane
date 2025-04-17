needs "./LieAlgebraBases/lieAlgebraBasisTypeA.m2"
needs "./LieAlgebraBases/lieAlgebraBasisTypeB.m2"
needs "./LieAlgebraBases/lieAlgebraBasisTypeC.m2"
needs "./LieAlgebraBases/lieAlgebraBasisTypeD.m2"

LieAlgebraBasis = new Type of HashTable  
-- Keys:
-- LieAlgebra
-- BasisElements
-- DualBasis
-- Weights
-- Labels
-- RaisingOperatorIndices
-- LoweringOperatorIndices
-- WriteInBasis


net(LieAlgebraBasis) := CB -> net "Enhanced basis of"expression(CB#"LieAlgebra")





lieAlgebraBasis = method(
    TypicalValue => LieAlgebraBasis
    )

lieAlgebraBasis(String,ZZ) := (type,m) -> (
    if not member(type,{"A","B","C","D"}) then error "Not implemented yet" << endl;
    if type=="A" then return slnBasis(m+1);
    if type=="B" then return so2n1Basis(m);
    if type=="C" then return sp2nBasis(m);
    if type=="D" then return so2nBasis(m);
);

Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );

lieAlgebraBasis(LieAlgebra) := (g) -> (
    if isSimple(g) and g#"RootSystemType"=="A" then return slnBasis(g#"LieAlgebraRank"+1);
    if isSimple(g) and g#"RootSystemType"=="B" then return so2n1Basis(g#"LieAlgebraRank");
    if isSimple(g) and g#"RootSystemType"=="C" then return sp2nBasis(g#"LieAlgebraRank");
    if isSimple(g) and g#"RootSystemType"=="D" then return so2nBasis(g#"LieAlgebraRank");
    error "Not implemented yet"
);







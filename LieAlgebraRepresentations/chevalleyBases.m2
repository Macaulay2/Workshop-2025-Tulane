needs "./ChevalleyBases/chevalleyBasisTypeA.m2"
needs "./ChevalleyBases/chevalleyBasisTypeC.m2"
needs "./ChevalleyBases/chevalleyBasisTypeD.m2"

ChevalleyBasis = new Type of HashTable  
-- Keys:
-- LieAlgebra
-- BasisElements
-- DualBasis
-- Weights
-- Labels
-- RaisingOperatorIndices
-- LoweringOperatorIndices
-- WriteInBasis


net(ChevalleyBasis) := CB -> net "Chevalley basis of "expression(CB#"LieAlgebra")





chevalleyBasis = method(
    TypicalValue => ChevalleyBasis
    )

chevalleyBasis(String,ZZ) := (type,m) -> (
    if not member(type,{"A","C","D"}) then error "Not implemented yet" << endl;
    if type=="A" then return slnBasis(m+1);
    if type=="C" then return sp2nBasis(m);
    if type=="D" then return so2nBasis(m);
);

Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );

chevalleyBasis(LieAlgebra) := (g) -> (
    if isSimple(g) and g#"RootSystemType"=="A" then return slnBasis(g#"LieAlgebraRank"+1);
    if isSimple(g) and g#"RootSystemType"=="C" then return sp2nBasis(g#"LieAlgebraRank");
    if isSimple(g) and g#"RootSystemType"=="D" then return so2nBasis(g#"LieAlgebraRank");
    error "Not implemented yet"
);

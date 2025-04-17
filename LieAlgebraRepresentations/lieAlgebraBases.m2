needs "./LieAlgebraBases/lieAlgebraBasisTypeA.m2"
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
    if not member(type,{"A","C","D"}) then error "Not implemented yet" << endl;
    if type=="A" then return slnBasis(m+1);
    if type=="C" then return sp2nBasis(m);
    if type=="D" then return so2nBasis(m);
);

Eijm = (i0,j0,m) -> ( matrix apply(m, i -> apply(m, j -> if i==i0 and j==j0 then 1/1 else 0/1)) );

lieAlgebraBasis(LieAlgebra) := (g) -> (
    if isSimple(g) and g#"RootSystemType"=="A" then return slnBasis(g#"LieAlgebraRank"+1);
    if isSimple(g) and g#"RootSystemType"=="C" then return sp2nBasis(g#"LieAlgebraRank");
    if isSimple(g) and g#"RootSystemType"=="D" then return so2nBasis(g#"LieAlgebraRank");
    error "Not implemented yet"
);


trivialRepresentation = method(
    TypicalValue => LieAlgebraModule
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
    installRepresentation(V,CB,L);
    V
);


standardRepresentation = method(
    TypicalValue => LieAlgebraModule
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
    installRepresentation(V,CB,CB#"BasisElements");
    V
);


adjointRepresentation = method(
    TypicalValue => LieAlgebraModule
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
    installRepresentation(V,CB,L);
    V
);



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
-- FundamentalDominantWeightValues

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




-- level moved to lieAlgebraModules.m2


-- Implement fromula from de Graaf, page 98
star = (j, a) -> (
    R:=ring(a);
    ea:=first exponents(a);
    ea = apply(#ea, i -> if i!=j then ea_i else ea_i+1);
    product reverse apply(#ea, i -> R_i^(ea_i))
);


extendedWeightDiagram = (V) -> (
    WD := weightDiagram(V);
    K := keys(WD);
    PhiPlus := positiveRoots(V#"LieAlgebra");
    D := K;
    for i from 0 to #PhiPlus-1 do (
        for j from 0 to #K-1 do (
            if not member(K_j-PhiPlus_i,D) then D = append(D,K_j-PhiPlus_i)
        )
    );
    D
);



-- U(g)
-- Order the basis vectors as x,h,y
-- Within each group, put in order reverse lex level

universalEnvelopingAlgebra = method(
    TypicalValue => FreeAlgebraQuotient
    )

universalEnvelopingAlgebra(LieAlgebraBasis) := (LAB) -> (
    -- Set up the Lie algebra basis
    g := LAB#"LieAlgebra";
    B := LAB#"BasisElements";
    br := LAB#"Bracket";
    writeInBasis := LAB#"WriteInBasis";
    Bweights:=LAB#"Weights";
    -- Create U(g) in the original basis
    BB:=getSymbol "BB";
    R1 := QQ<|apply(#B, i -> BB_i)|>;
    bracketRelations := {};
    v:={};
    r:=0;
    for i from 0 to #B-1 do (
        for j from 0 to #B-1 do (
            v = writeInBasis(br(B_i,B_j));
            r = R1_i*R1_j-R1_j*R1_i - (sum apply(#B, k -> v_k*R1_k));
            bracketRelations = append(bracketRelations,r)
        )
    );
    -- Now set up the free algebra
    PhiPlus := positiveRoots(g);
    x:=getSymbol "x";
    h:=getSymbol "h";
    y:=getSymbol "y";
    varListx := reverse apply(#PhiPlus, i -> x_(i+1));
    varListh := reverse apply(g#"LieAlgebraRank", i -> h_(i+1));
    varListy := reverse apply(#PhiPlus, i -> y_(i+1));
    R2 := QQ<|flatten {varListx,varListh,varListy}|>;
    -- Get the map
    WtToZZ:=new HashTable from apply(#B, i -> (Bweights_i,i));
    posRootMap:=reverse apply(PhiPlus, w -> WtToZZ#w);
    cartanMap:=reverse apply(g#"LieAlgebraRank", i -> i);
    negRootMap:=reverse apply(PhiPlus, w -> WtToZZ#(-w));
    sigma:=join(posRootMap,cartanMap,negRootMap);
    sigmainverse := apply(sort apply(#sigma, i -> {sigma_i,i}), p -> p_1);
    f12:=map(R2,R1,apply(#sigma, i -> R2_(sigmainverse_i)));
    (R2/f12(ideal bracketRelations),sigma,sigmainverse)
);

universalEnvelopingAlgebra(LieAlgebra) := (g) -> (
    universalEnvelopingAlgebra(lieAlgebraBasis(g))
);


uNminus = method(
    TypicalValue => FreeAlgebraQuotient
    )

uNminus(LieAlgebraBasis) := (LAB) -> (
    -- Set up the Lie algebra basis
    g := LAB#"LieAlgebra";
    B := LAB#"BasisElements";
    br := LAB#"Bracket";
    writeInBasis := LAB#"WriteInBasis";
    Bweights:=LAB#"Weights";
    -- Get the bracket relations with respect to the original basis
    BB:=getSymbol "BB";
    R1 := QQ<|apply(#B, i -> BB_i)|>;
    LOI:=LAB#"LoweringOperatorIndices";
    uNminusbracketRelations := {};
    v:={};
    r:=0;
    for i from 0 to #B-1 do (
        for j from 0 to #B-1 do (
	    if not(member(i,LOI) and member(j,LOI)) then continue;
            v = writeInBasis(br(B_i,B_j));
            r = R1_i*R1_j-R1_j*R1_i - (sum apply(#B, k -> v_k*R1_k));
            uNminusbracketRelations = append(uNminusbracketRelations,r)
        )
    );
    -- Now set up the free algebra
    PhiPlus := positiveRoots(g);
    Y:=getSymbol "Y";
    varListy := reverse apply(#PhiPlus, i -> Y_(i+1));
    R2 := QQ<|varListy|>;
    -- Get the map
    WtToZZ:=new HashTable from apply(#B, i -> (Bweights_i,i));
    posRootMap:=reverse apply(PhiPlus, w -> WtToZZ#w);
    cartanMap:=reverse apply(g#"LieAlgebraRank", i -> i);
    negRootMap:=reverse apply(PhiPlus, w -> WtToZZ#(-w));
    sigma:=join(posRootMap,cartanMap,negRootMap);
    sigmainverse := apply(sort apply(#sigma, i -> {sigma_i,i}), p -> p_1);
    n:=#PhiPlus+g#"LieAlgebraRank";
    f12:=map(R2,R1,apply(#sigma, i -> if sigmainverse_i <n then 0 else R2_(sigmainverse_i-n)));
    R2/f12(ideal uNminusbracketRelations)
);



uNminus(LieAlgebra) := (g) -> (
    uNminus(lieAlgebraBasis(g))
);

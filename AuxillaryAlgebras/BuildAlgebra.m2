--(sl_2 x sl_2) plus C^(2 x 2)

/// TODO figure out how to bundle everything into nice ring
AuxillaryAlgebra = new Type of Ring;
AuxillaryAlgebraElement = new Type of RingElement;

buildAlgebra = method()
buildAlgebra(ZZ,ZZ,Symbol,Ring) := (pow, nvars,e, KK) ->(
  auxillaryAlg := new AuxillaryAlgebra of AuxillaryAlgebraElement;
  ----------------------------------------------------------------------------------------------------------------
  --- setting up the exterior algebra and some of its properties
  ----------------------------------------------------------------------------------------------------------------
  exteriorAlg := KK[e_0..e_(nvars-1), SkewCommutative => true];
  h := local h;
  E := local E;
  LieAlg := KK[h_1..h_(nvars -1),
      (flatten for i to nvars -1 list for j from i+1 to nvars -1 list E_{i,j}),
      (flatten for i to nvars -1 list for j from i+1 to nvars -1 list E_{j,i})]; -- a copy of sl_n = a_0
  extensionAlg.LieAlgebra = LieAlg;
///


X = matrix{{0,1},{0,0}}
Y = matrix{{0,0},{1,0}}
H = X*Y-Y*X
sl2Basis = {X, Y, H}

sl2HashTable = new HashTable from {(X,Y,H)=> 1, (H,X,X) => 2, (H,Y,Y) => -2, (Y,X,H) => -1, (X,H,X)=> -2, (Y,H,Y) => 2}

includeIntoFirstFactor = (A,B,C) -> ((A,0),(B,0),(C,0))
includeIntoSecondFactor = (A,B,C) -> ((0,A),(0,B),(0,C))

firstFactorList = for triple in keys sl2HashTable list (
  includeIntoFirstFactor(triple) => sl2HashTable#triple
)
secondFactorList = for triple in keys sl2HashTable list (
  includeIntoSecondFactor(triple) => sl2HashTable#triple
)

sl2SquaredHashTable = new HashTable from firstFactorList | secondFactorList

E11 = matrix{{1,0},{0,0}}
E12 = matrix{{0,1},{0,0}}
E21 = matrix{{0,0},{1,0}}
E22 = matrix{{0,0},{0,1}}

--Hardcoded for now
B'011' = new HashTable from {
    ((H,0),E11,E11) => 1, 
    ((H,0),E22,E22) => -1,
    ((H,0),E12,E12) => 1,
    ((H,0),E21,E21) => -1,
    ((X,0),E21,E11) => 1,
    ((X,0),E22,E12) => 1,
    ((Y,0),E11,E21) => 1,
    ((Y,0),E12,E22) => 1,
    ((0,X),E22,E21) => 1,
    ((0,X),E12,E11) => 1,
    ((0,Y),E11,E12) => 1,
    ((0,Y),E21,E22) => 1,
    ((0,H),E11,E11) => 1,
    ((0,H),E12,E12) => -1,
    ((0,H),E21,E21) => 1,
    ((0,H),E22,E22) => -1
}

swap01 = (A,B,C) -> (B,A,C)
swap02 = (A,B,C) -> (C,B,A)

B'101' = new HashTable from for triple in keys B'011' list (
    swap01(triple) => B'011'#triple
)
B'110' = new HashTable from for triple in keys B'011' list (
    swap02(triple) => B'011'#triple
)

BHashTable = new HashTable from {
    (0,0) => sl2SquaredHashTable,
    (0,1) => B'011',
    (1,0) => B'101',
    (1,1) => B'110'
}

multiply11Basis = (A,B) ->(
    keylist = keys B'110';
    nonzeroProducts = for triple in keylist list delete(last triple, triple);
    if isMember((A,B) ,nonzeroProducts) then (
        idx = positions(nonzeroProducts, i -> i==(A,B));
        lastElements = for i in idx list(last keylist_i);
        coeffs = for i in idx list B'110'#(keylist_i);
        --coeff = B'110'#(keylist_idx);
        outputCoord0 = sum for i to (#idx-1) list coeffs_i*(lastElements_i)_0;
        outputCoord1 = sum for i to (#idx -1) list coeffs_i*(lastElements_i)_1;
        (outputCoord0, outputCoord1)
    )
    else
        0
)

bracket = method()

bracket00 = (A,B) -> toSequence for i from 0 to (#A-1) list (A_i * B_i - B_i * A_i) --For products of groups
bracket01 = (A,M) -> A_0*M + M*(transpose A_1)
bracket10 = (M,A) -> -1*(A_0*M + M*(transpose A_1))
bracket11 = (M,N) -> (
    intToEntries := new HashTable from {0 => (0,0), 1=> (0,1), 2 =>(1,0), 3 =>(1,1)};
    intToBasis := new HashTable from {0 => E11, 1 => E12, 2 => E21, 3 => E22};
    summands = for i to 3 list(
        for j to 3 list(
            temp = multiply11Basis(intToBasis#i,intToBasis#j);
            if not instance(temp,ZZ) then ( 
                multiplier = M_(intToEntries#i) * N_(intToEntries#j);
                (multiplier*temp_0,multiplier*temp_1)
            )
            else
                (0,0)
        )
    );

    flattenedSummands = flatten summands;
    keptSummands = select(flattenedSummands, i -> i!= (0,0));
    outputComponent0 = sum for i to (#keptSummands - 1) list (keptSummands_i)_0;
    outputComponent1 = sum for i to (#keptSummands - 1) list (keptSummands_i)_1;
    (outputComponent0,outputComponent1)
)
end--

restart
load "BuildAlgebra.m2"
multiply11Basis(E11,E11)
multiply11Basis(E21,E22)
multiply11Basis(E21,E12)

bracket11(E11,E11)

testA = random(QQ^2,QQ^2)
testB = random(QQ^2,QQ^2)

bracket11(testA,testB)

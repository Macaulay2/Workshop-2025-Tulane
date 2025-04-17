///
Hard Coded algebra construction of (sl_2 x sl_2) plus C^(2 x 2) to expand/generalize in future

Turns out that the algebra is a lie algebra with nondegenerate killing form

(Tests start on Line 249)
///

--(sl_2 x sl_2) plus C^(2 x 2)

AuxillaryAlgebra = new Type of Ring;
AuxillaryAlgebraElement = new Type of RingElement;

buildAlgebra = method()
--buildAlgebra(ZZ,ZZ,Symbol,Ring) := (pow, nvars,e, KK) ->(
buildAlgebra(ZZ) := (nvars) ->(
  auxillaryAlg := new AuxillaryAlgebra of AuxillaryAlgebraElement;
  ----------------------------------------------------------------------------------------------------------------
  --- setting up the exterior algebra and some of its properties
  ----------------------------------------------------------------------------------------------------------------
  vectorSpace := QQ[e_(0,0)..e_(1,1)]; --C^(2 x 2)
  --HVar := local HVar;
  --XVar := local XVar;
  --YVar := local YVar;
  --create a copy of sl_2 x sl_2
  LieAlg := QQ[HVar_(1,0),HVar_(0,1),XVar_(1,0),XVar_(0,1),YVar_(1,0),YVar_(0,1)]; --
      --(flatten for i to nvars -1 list for j from i+1 to nvars -1 list E_{i,j}),
      --(flatten for i to nvars -1 list for j from i+1 to nvars -1 list E_{j,i})]; -- a copy of sl_n = a_0
  auxillaryAlg.LieAlgebra = LieAlg;
  auxillaryAlg.VectorSpace = vectorSpace;
  
  mats2LieAlg := (A,B)->(
    use LieAlg;
    if not zero(A) and not zero(B) then (
        A_(0,0)*HVar_(1,0) + A_(1,0)*YVar_(1,0)+A_(0,1)*XVar_(1,0) + B_(0,0)*HVar_(0,1) + B_(1,0)*YVar_(0,1)+B_(0,1)*XVar_(0,1)
    ) else if not zero(A) then(
        A_(0,0)*HVar_(1,0) + A_(1,0)*YVar_(1,0)+A_(0,1)*XVar_(1,0)
    ) else if not zero(B) then (
        B_(0,0)*HVar_(0,1) + B_(1,0)*YVar_(0,1)+B_(0,1)*XVar_(0,1)
    ) else (
        0
    )
  );
  
  X = matrix{{0,1},{0,0}};
  Y = matrix{{0,0},{1,0}};
  H = X*Y-Y*X;

  LieAlg2Mats := f -> (
    outputComponent0 = coefficient(HVar_(1,0),f)*H + coefficient(XVar_(1,0),f)*X + coefficient(YVar_(1,0),f)*Y;
    outputComponent1 = coefficient(HVar_(0,1),f)*H + coefficient(XVar_(0,1),f)*X + coefficient(YVar_(0,1),f)*Y;
    (outputComponent0,outputComponent1)
  );

  auxillaryAlg.mats2LieAlg = mats2LieAlg;
  auxillaryAlg.LieAlg2Mats = LieAlg2Mats;

  E11 = matrix{{1,0},{0,0}};
  E12 = matrix{{0,1},{0,0}};
  E21 = matrix{{0,0},{1,0}};
  E22 = matrix{{0,0},{0,1}};

  vectorSpace2mat := f -> coefficient(e_(0,0),f)*E11 + coefficient(e_(1,0),f)*E21 + coefficient(e_(0,1),f)*E12 + coefficient(e_(1,1),f)*E22;
  mat2vectorSpace := mat -> mat_(0,0)*e_(0,0) + mat_(1,0)*e_(1,0) + mat_(0,1)*e_(0,1) + mat_(1,1)*e_(1,1);
  auxillaryAlg.vectorSpace2mat = vectorSpace2mat;

  --Build the multiplication Hash Table
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
  };

  swap01 = (A,B,C) -> (B,A,C);
  swap02 = (A,B,C) -> (C,B,A);

  B'101' = new HashTable from for triple in keys B'011' list (
    swap01(triple) => B'011'#triple
  );

  B'110' = new HashTable from for triple in keys B'011' list (
    swap02(triple) => B'011'#triple
  );

  multiply11Basis = (A,B) ->(
    keylist = keys B'110';
    nonzeroProducts = for triple in keylist list delete(last triple, triple);
    if isMember((A,B) ,nonzeroProducts) then (
        idx = positions(nonzeroProducts, i -> i==(A,B));

        lastElements = for i in idx list(last keylist_i);
        coeffs = for i in idx list B'110'#(keylist_i);

        outputCoord0 = sum for i to (#idx-1) list coeffs_i*(lastElements_i)_0;
        outputCoord1 = sum for i to (#idx -1) list coeffs_i*(lastElements_i)_1;
        (outputCoord0, outputCoord1)
    )
    else
        0
  );

  --Bracket Helper Functions
  bracket00 = (A,B) -> toSequence for i from 0 to (#A-1) list (A_i * B_i - B_i * A_i); -- For inputs as (A_1,A_2,A_3,...,A_k) etc.
  bracket01 = (A,M) -> A_0*M + M*(transpose A_1);
  bracket10 = (M,A) -> -1*(A_0*M + M*(transpose A_1));
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
  );
  
  bracket = method();
    bracket(Sequence,Sequence) := (A,B) -> bracket00(A,B);
    bracket(Sequence,Matrix) := (A,M) -> bracket01(A,M);
    bracket(Matrix,Sequence) := (M,A) -> bracket10(M,A);
    bracket(Matrix,Matrix) := (M,N) -> (
        outMN := bracket11(M,N); 
        outNM := bracket11(N,M);
        ((outMN_0 - outNM_0)*(1/2), (outMN_1 - outNM_1)*(1/2))
    );
    
    bracket(LieAlg,LieAlg) := (A,B) -> (
      matsA := LieAlg2Mats(A);
      matsB := LieAlg2Mats(B);
      mats2LieAlg bracket(matsA,matsB)
    );

    bracket(LieAlg,vectorSpace) := (A,f) -> (
      matsA := LieAlg2Mats(A);
      M := vectorSpace2mat(f);
      mat2vectorSpace bracket(matsA,M)
    );
  
    bracket(vectorSpace,LieAlg) := (f,A) -> (
      matsA := LieAlg2Mats(A);
      M := vectorSpace2mat(f);
      mat2vectorSpace bracket10(M,matsA)
    );

    bracket(vectorSpace,vectorSpace) := (f,g) -> (
      M := vectorSpace2mat(f);
      N := vectorSpace2mat(g);
      mats2LieAlg bracket(M,N)
    );

  auxillaryAlg.bracket = bracket;
  
  allGenerators = gens LieAlg | gens vectorSpace;
  auxillaryAlg.allGenerators = allGenerators;
  
  Ad = method();
    Ad(LieAlg) := (A) -> (
      outList := for gen in allGenerators list bracket(A,gen);
        totalRing := LieAlg ** vectorSpace;
      --auxillaryAlg.totalRing = totalRing;
      
      matrixEntries := for element in allGenerators list( 
        for output in outList list(
            coefficient(sub(element,totalRing),sub(output,totalRing))
        )
      );
      matrix matrixEntries
    );

    Ad(vectorSpace) := (A) -> (
      outList := for gen in allGenerators list bracket(A,gen);
        totalRing := LieAlg ** vectorSpace;
      --auxillaryAlg.totalRing = totalRing;
      
      matrixEntries := for element in allGenerators list( 
        for output in outList list(
            coefficient(sub(element,totalRing),sub(output,totalRing))
        )
      );
      matrix matrixEntries
    );
  
  auxillaryAlg.ad = Ad;
  
  --Move things from graded pieces to the 10D vector space
  toTotalRing = method();
    toTotalRing(LieAlg) := (A) -> (
      totalRing := LieAlg ** vectorSpace;
        vectorEntries = for element in allGenerators list(
            coefficient(sub(element,totalRing),sub(A,totalRing))
        );
      transpose matrix {vectorEntries}
    );

    toTotalRing(vectorSpace) := (A) -> (
       totalRing := LieAlg ** vectorSpace;
        vectorEntries = for element in allGenerators list(
            coefficient(sub(element,totalRing),sub(A,totalRing))
        );
      transpose matrix {vectorEntries}
    );

  auxillaryAlg.toTotalRing = toTotalRing;

  --Construct Killing Form 
  killingForm = () ->(
    matrixEntries := for i to (#allGenerators - 1) list (
      for j to (#allGenerators - 1) list (
          ei := allGenerators_i;
          ej := allGenerators_j; 
          trace (Ad(ei)*Ad(ej)) --this is the Killing form
      ) 
    );
    matrix matrixEntries
  );  
  
    auxillaryAlg.killingForm = killingForm;

  --return the auxillaryAlgebra
  auxillaryAlg
)
end--

restart
load "BuildAlgebra.m2"

auxillaryAlgebra = buildAlgebra(2)
grade0 = auxillaryAlgebra.LieAlgebra
V = auxillaryAlgebra.VectorSpace

--test antisymmetry of Bracket
-----------------------------------------------
--grade0
f = random(1,grade0)
g = random(1,grade0)
auxillaryAlgebra.bracket(f, g) + auxillaryAlgebra.bracket(g, f)

--grade 1
M = random(1,V)
N = random(1,V)
P = random(1,V)

auxillaryAlgebra.bracket(M,N)
auxillaryAlgebra.bracket(N,M)

auxillaryAlgebra.bracket(M,N) + auxillaryAlgebra.bracket(N,M)

--mixed grade
auxillaryAlgebra.bracket(f,M) + auxillaryAlgebra.bracket(M,f)
------------------------------------------------------
--testing ad function etc.
ad0 = auxillaryAlgebra.ad(f)
M = random(1,V)
ad1 = auxillaryAlgebra.ad(M)
ad1 = auxillaryAlgebra.ad(random(1,V))

vec = auxillaryAlgebra.toTotalRing(f)
ad1*vec
vectorEntries = auxillaryAlgebra.toTotalRing(M)

-----------------------------------------------------------------------------
---Testing Jacobi Identity
auxillaryAlgebra = buildAlgebra(2)
grade0 = auxillaryAlgebra.LieAlgebra
V = auxillaryAlgebra.VectorSpace

M = random(1,V)
N = random(1,V)
P = random(1,V)

--[M,[N,P]] + [N,[P,M]] + [P,[M,N]] = 0
auxillaryAlgebra.bracket(M,auxillaryAlgebra.bracket(N,P)) + auxillaryAlgebra.bracket(N,auxillaryAlgebra.bracket(P,M)) + auxillaryAlgebra.bracket(P,auxillaryAlgebra.bracket(M,N))
-------------------------------------------------------------------------------
--Killing Form
auxillaryAlgebra = buildAlgebra(2)
grade0 = auxillaryAlgebra.LieAlgebra
V = auxillaryAlgebra.VectorSpace

K = auxillaryAlgebra.killingForm()
rank K


///ad and bracket don't work well together--to fix
auxillaryAlgebra.ad(bracket(M,N))
adM = auxillaryAlgebra.ad(M)
adN = auxillaryAlgebra.ad(N)
auxillaryAlgebra.ad(bracket(M,N)) - (adM*adN - adN*adM)
///

new NCPolynomialRing from List := (NCPolynomialRing, inits) -> new NCPolynomialRing of NCRingElement from new HashTable from inits

Ring List := (R, varList) -> (
   -- get the symbols associated to the list that is passed in, in case the variables have been used earlier.
   if #varList == 0 then error "Expected at least one variable.";
   if #varList == 1 and class varList#0 === Sequence then varList = toList first varList;
   varList = varList / baseName;
   A := new NCPolynomialRing from {(symbol generators) => {},
                                   (symbol generatorSymbols) => varList,
                                   (symbol degreesRing) => degreesRing 1,
				   (symbol CoefficientRing) => R,
                                   (symbol cache) => new CacheTable from {},
				   (symbol baseRings) => {ZZ},
                                   BergmanRing => false};
   newGens := apply(varList, v -> v <- putInRing({v},A,1));

   if R === QQ or R === ZZ/(char R) then A#BergmanRing = true;

   A#(symbol generators) = newGens;
   
   setWeights(A, toList (#(gens A):1));
      
   --- all these promotes will need to be written between this ring and all base rings.
   promote (ZZ,A) := (n,A) -> putInRing({},A,promote(n,R));


   promote (QQ,A) := (n,A) ->  putInRing({},A,promote(n,R));
        
   promote (R,A) := (n,A) -> putInRing({},A,n);
      
   promote (NCMatrix,A) := (M,A) -> (
       if M.source == {} or M.target == {} then
          ncMatrix(A,M.target,M.source)
       else (
          prom := ncMatrix apply(M.matrix, row -> apply(row, entry -> promote(entry,A)));
          if isHomogeneous M then
             assignDegrees(prom,M.target,M.source);
          prom
       )
   );

   promote (A,A) := (f,A) -> f;
   
   addVals := (c,d) -> (
      e := c+d;
      if e == 0 then continue else e
   );

   multVals := (c,d) -> c*d;
      
   multKeys := (m,n) -> m | n;

   A + A := (f,g) -> (
      -- new way
      newHash := removeZeroes merge(f.terms,g.terms,addVals);
      -- old way
      --newHash := new MutableHashTable from pairs f.terms;
      --for s in pairs g.terms do (
      --   newMon := s#0;
      --   if newHash#?newMon then newHash#newMon = newHash#newMon + s#1 else newHash#newMon = s#1;
      --);
      --newHash = removeZeroes hashTable pairs newHash;
      if newHash === hashTable {} then newHash = (promote(0,f.ring)).terms;
      new A from hashTable {(symbol ring, f.ring),
                            (symbol cache, new CacheTable from {("isReduced",false)}),
                            (symbol terms, newHash)}   
   );

   A ? A := (f,g) -> (
      m := first pairs (leadMonomial f).terms;
      n := first pairs (leadMonomial g).terms;
      m ? n
   );

   A * A := (f,g) -> (
      -- new way
      -- time not very predictable...
      newHash := removeZeroes combine(f.terms,g.terms,multKeys,multVals,addVals);
      -- old way
      --newHash := new MutableHashTable;
      --for t in pairs f.terms do (
      --   for s in pairs g.terms do (
      --      newMon := t#0 | s#0;
      --      newCoeff := (t#1)*(s#1);
      --      if newHash#?newMon then newHash#newMon = newHash#newMon + newCoeff else newHash#newMon = newCoeff;
      --   );
      --);
      --newHash = removeZeroes hashTable pairs newHash;
      if newHash === hashTable {} then newHash = (promote(0,f.ring)).terms;
      new A from hashTable {(symbol ring, f.ring),
                            (symbol cache, new CacheTable from {("isReduced",false)}),
                            (symbol terms, newHash)}
   );

   A ^ ZZ := (f,n) -> product toList (n:f);

   R * A := (r,f) -> promote(r,A)*f;
   A * R := (f,r) -> r*f;
   QQ * A := (r,f) -> promote(r,A)*f;
   A * QQ := (f,r) -> r*f;
   ZZ * A := (r,f) -> promote(r,A)*f;

   A * ZZ := (f,r) -> r*f;
   A - A := (f,g) -> f + (-1)*g;
   - A := f -> (-1)*f;
   A + ZZ := (f,r) -> f + promote(r,A);
   ZZ + A := (r,f) -> f + r;
   A + QQ := (f,r) -> f + promote(r,A);
   QQ + A := (r,f) -> f + r;
   A + R  := (f,r) -> f + promote(r,A);
   R + A  := (r,f) -> f + r;
   
   A ? A := (f,g) -> (leadNCMonomial f) ? (leadNCMonomial g);

   A == A := (f,g) -> #(f.terms) == #(g.terms) and (sort pairs f.terms) == (sort pairs g.terms);
   A == ZZ := (f,n) -> (#(f.terms) == 0 and n == 0) or (#(f.terms) == 1 and ((first pairs f.terms)#0#monList === {}) and ((first pairs f.terms)#1 == n));
   ZZ == A := (n,f) -> f == n;
   A == QQ := (f,n) -> (#(f.terms) == 0 and n == 0) or (#(f.terms) == 1 and ((first pairs f.terms)#0#monList === {}) and ((first pairs f.terms)#1 == n));
   QQ == A := (n,f) -> f == n;
   A == R := (f,n) -> (#(f.terms) == 0 and n == 0) or (#(f.terms) == 1 and ((first pairs f.terms)#0#monList === {}) and ((first pairs f.terms)#1 == n));
   R == A := (n,f) -> f == n;

   A
)
-- -*- coding: utf-8 -*-

newPackage(
        "CoxeterGroups",
        Version => "0.3", 
        Date => "March 23, 2024",
        Authors => {
	     {Name => "Matthew Mastroeni", 
		 Email => "mmastro@iastate.edu", 
		 HomePage => "https://mnmastro.github.io/"
		 },
         {Name => "Ethan Clayton",
         Email => "ewc0025@auburn.edu"
         },
         {Name => "Aniketh Sivakumar", 
		 Email => "asivakumar@tulane.edu",
		 }
             },
        Headline => "Coxeter groups",
	AuxiliaryFiles => true,
        DebuggingMode => true,
	PackageExports => {
	    "Cyclotomic",
	    "SimplicialComplexes",
	    "Graphs",
	    "Posets",
	    "Matroids"
	    }
        )


-- Record any symbols or functions (except "net") used in each file below.
-- Comment out the name of the function/symbol if it is not exported.

-- Type names must be exported if they are used in the documentation
-- of an overloaded function.

-- ?? = undocumented
-- ** = tested
-- ++ = double checked

-- QUESTIONS:

-- 1. Is there an algorithm to determine when 2 elements are conjugates?
-- 2. Are there characterizations of finitely generated/finite subgroups?
-- 3. Or is there an algorithm to recognize reflections? 
--    (re: error-checking for implementing reflection subgroups)


-- TO DO:

-- 1. Implement:
--    	1A. bruhatInterval
--    	1B. quotient(Subgroup) and CoxeterGroup/Subgroup

-- 2. Finish documentation:
--    	2A. dynkinDiagram
--    	2B. tableau
--      2C. parabolicSubgroup
--    	2D. poincare(CoxeterGroup)


export {
    
--CoxeterSystems.m2
    "AllReflections",	     	  -- option, ??
    "bruhatCompare",	    	  -- documented
    "bruhatInterval",	     	  -- ??
    "bruhatPoset",    	      	  -- documented
    "cartanMatrix",    	       	  -- documented
    "cosetEquals",    	      	  -- ??
    "CoxeterGroup",    	       	  -- type, ??
    "coxeterGroup",    	       	  -- documented
    "coxeterMatrix",	    	  -- documented
    "descentSet",    	     	  -- documented
    "dihedralGroup",		  -- documented
    "DynkinDiagram",	    	  -- type, ??
    "dynkinDiagram",	    	  -- ??
    "exchanges",    	      	  -- documented
    "expressions",    	      	  -- ??
    "Facets",	     	     	  -- option, ??
    -- generators,    	      	  -- overloaded, ??
    "generatorSymbols",	       	  -- ??
    "group",	    	    	  -- documented
    "GroupElement",    	       	  -- type, ??
    "groupElements",	    	  -- documented
    "groupOrder",    	     	  -- documented
    "hasType",	      	      	  -- ??
    "hyperoctahedralGroup",    	  -- documented
    -- id,    	      	      	  -- overloaded, ??
    "isCoxeterMatrix",	      	  -- documented
    "isFiniteGroup",           	  -- documented
    -- isNormal	   	       	  -- ??
    "isParabolic",    	      	  -- ??
    "isRightAngled",	    	  -- documented
    "isReduced",    	    	  -- ??
    -- length,	      	      	  -- overloaded, documented
    "longWord",	       	       	  -- documented
    "nerveComplex",    	       	  -- documented
    "normalForm",    	 	  -- ??
    -- numgens,	       	       	  -- overloaded, ??
    "permutationAction",	  -- ??
    -- poincare	       	       	  -- overloaded, ??
    "reduceWord",    	     	  -- ??
    "reflections",    	      	  -- documented
    "reflectionRep",	    	  -- documented
    "reflectionRepresentatives",  -- ??
    -- relations,    	    	  -- overloaded, documented
    -- roots,	     	     	  -- overloaded, documented
    "rootPairs",    	    	  -- ??
    "rows",    	       	       	  -- ??
    "sign",    	       	       	  -- documented
    "specificCoxeterGroup",    	  -- documented
    "specificDynkin",	     	  -- documented
    "Subgroup",	       	       	  -- type, ??
    "subgroup",	       	       	  -- ??      
    "symmetricGroup",    	  -- documented
    "tableau",	      	      	  -- ??
    "weakCompare",    	      	  -- ??
    "weakInterval",    	       	  -- ??
    "weakLattice",    	      	  -- ??
    "weights",	     	     	  -- ??
    "wordToGroup",    	      	  -- ??
   
-- ToddCoxeter.m2
    "CompleteComputation",    	  -- option, ??
    "Coset",	    	    	  -- type, ??
    "Cosets",	     	     	  -- option, ??
    "DisplayMode",    	      	  -- option, ??
    -- groundSet    	    	  -- overloaded, ??
    -- GroupMap,		  -- type, ??
    -- image         	      	  -- overloaded, ??
    "isNormal",	       	       	  -- ??
    -- kernel          	      	  -- overloaded, ??
    -- map    	      	      	  -- overloaded, ??
    "permutationRepresentation",  -- ??
    "quotientMap",    	      	  -- ??
    "QuotientSet",    	      	  -- type, ??
    "reflectionRepresentation",	  -- ??
    "regularEmbedding",	  	  -- ??
    "regularRepresentation",	  -- ??
    "relationTables",	     	  -- ??
    "schriererGraph",	     	  -- ??
    "signMap",	      	      	  -- ??
    -- source	     	     	  -- overloaded, ??
    -- substitute    	     	  -- overloaded, ??
    -- target	     	     	  -- overloaded, ??
    "targetValues",	     	  -- ??
    "toddCoxeterProcedure",    	  -- ??
    "transversal",    	     	  -- ??
    
-- CKVComplex.m2
    -- graph	    	    	  -- overloaded, ??
    "sphericalElements"	       	  -- ??    
    }

--exportMutable {}




-------------------------------------------
--- LOAD AUXILIARY FILES ------------------
-------------------------------------------

load "./CoxeterGroups/CoxeterSystems.m2"
load "./CoxeterGroups/ToddCoxeter.m2"
load "./CoxeterGroups/CKVComplex.m2"




beginDocumentation()

load "./CoxeterGroups/CoxeterSystemsDoc.m2"
load "./CoxeterGroups/ToddCoxeterDoc.m2"


undocumented {
    (net, Coset),
    (net, CoxeterGroup),
    (net, DynkinDiagram),
    (net, GroupMap)
    }

-- TESTS

--load "./LatticeChowRings/LatticeChowRingsTests.m2"




end


-- Here place M2 code that you find useful while developing this
-- package.  None of it will be executed when the file is loaded,
-- because loading stops when the symbol "end" is encountered.


restart
uninstallPackage "CoxeterGroups"
installPackage "CoxeterGroups"
check CoxeterGroups




restart
loadPackage "CoxeterGroups"











/// EXAMPLE

restart
load "CoxeterGroups.m2"
W = symmetricGroup 3
s_0^2
s_1*s_0*s_1
s_0*s_1*s_0*s_1
s_0*s_1*s_0*s_1*s_0
s_0*s_1*s_0*s_1*s_0*s_1
s_1^2
s_1*s_0*s_1*s_0
s_1*s_0*s_1*s_0*s_1
s_1*s_0*s_1*s_0*s_1*s_0

///

/// EXAMPLE

restart
load "CoxeterGroups.m2"
D = dihedralGroup 6
r = s*t
groupOrder r
-- (s*t)^4 = 1
r^2 == id_D
r^3 == id_D
r^4 == id_D
w = {s,t,s,t,s,t}
S = gens D
rep = reflectionRep D
pos = t ->  first select(numgens D, j -> S#j == t);
V = target cartanMatrix D
w' = wordToGroup(reducedExpression product drop(w, -1), D)
w = w'|{last w}
drops = lengthDrops(w, D)
w = drop(w', {first drops, first drops})
l = #w - 1;
drops = flatten apply(l, i -> (
	--w' := drop(w, -1);
	v := (rep product drop(w', i))_(pos last w);
	apply(select(pos w'#i, j -> (id_V)_j == v ), j -> (i, j) )
	) )
if #drops > 0 then (
	    (i, j) := first drops;
	    --w' = drop(w, -1);
	    w = take(w', i)|{S#j}|drop(w', i)
	    );
	apply(w, s -> first reducedExpression s)

s*t*s*t*s*t*s
s*t*s*t*s*t*s*t
groupOrder r
///


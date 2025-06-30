document {
	Key => {toddCoxeterProcedure},
	
	Headline => "run the Todd-Coxeter procedure",
	
	Usage => "toddCoxeterProcedure H \n toddCoxeterProcedure f",
	
	Inputs => {
	    	"H" => Subgroup => {"of a Coxeter group"},
		"f" => GroupMap,  
		DegreeLimit => ZZ => {"upper bound on the number of steps of the procedure completed"},
		},
	
	
	PARA {"This function is provided by the package ", TO CoxeterGroups,"."},
	
	PARA {"The Todd-Coxeter procedure is an incredibly versatile algorithm in computational 
	    group theory.  Given a subgroup H of a Coxeter group W or a group homomorphism
	    f: W ---> G where G is a computable group (such as a group of matrices), the Todd-
	    Coxeter procedure can be used among other things to:"}, 
	
	UL {"enumerate all the cosets of H (respectively the kernel of f) if H has finite index", 
	    "finite all elements of the image of f if the image is finite",
	    "construct the Schrierer graph for the translation action of H (respectively the 
	    kernel of f) on W", 
	    "find a Schrierer transveral for H (respectively the kernel of f)",
	    "compute a finite set of generators for the kernel and image of f is if the image 
	    is finite",
	    "find a presentation for the kernel and image of f if the image is finite",
	    }, 
	
	PARA {"Below we illustrate the steps of the Todd-Coxeter procedure on the infinite 
	    dihedral group W.  We consider the homomorphism by composing the reflection 
	    representation of W with reduction modulo 3."},
	
	EXAMPLE { 
	    "W = specificCoxeterGroup({s, t}, \"A'1\")",
	    "g = apply(reflectionRepresentatives W, w -> sub(w, ZZ/3) )",
	    "f = map(W, g)" 
	    },

	PARA {"The primary goal of the Todd-Coxeter procedure is the completion of certain
	    tables indexed by the relations of W as well as an edge-labeled digraph called the
	    Schrierer graph.  When a group homomorphism is first constructed, largely empty
	    relation tables are created for each defining relation of W. A digraph with only
	    a single vertex is also created."},
	
	EXAMPLE {
	     "relationTables(f, CompleteComputation => false, DisplayMode => \"pretty\")",
	     "schriererGraph(f, CompleteComputation => false)" 
	     },
	 
	 PARA {"Equivalently, the data of the Coxeter matrix can be encoded into a Dynkin diagram."},
	
	EXAMPLE {
	    "toddCoxeterProcedure(f, DegreeLimit => 2)",
	    "relationTables(f, CompleteComputation => false, DisplayMode => \"pretty\")",
	    "schriererGraph(f, CompleteComputation => false)",
	    "toddCoxeterProcedure(f, DegreeLimit => 3)",
	    "relationTables(f, CompleteComputation => false, DisplayMode => \"pretty\")",
	    "schriererGraph(f, CompleteComputation => false)",
	    "toddCoxeterProcedure(f, DegreeLimit => 4)",
	    "relationTables(f, CompleteComputation => false, DisplayMode => \"pretty\")",
	    "schriererGraph(f, CompleteComputation => false)",
	    "toddCoxeterProcedure(f, DegreeLimit => 5)",
	    "relationTables(f, CompleteComputation => false, DisplayMode => \"pretty\")",
	    "schriererGraph(f, CompleteComputation => false)",
	    "toddCoxeterProcedure(f, DegreeLimit => 6)",
	    "relationTables(f, CompleteComputation => false, DisplayMode => \"pretty\")",
	    "schriererGraph(f, CompleteComputation => false)",
	    "f.cache.CompleteComputation"
	     },
	    
	 SeeAlso => {(map, CoxeterGroup, List), (map, CoxeterGroup, CoxeterGroup, List), 
	     subgroup, schriererGraph, transversal, quotientMap, (kernel, GroupMap), (image, GroupMap)}
	    }
	
document {
	Key => {(kernel, GroupMap)},
	
	Headline => "compute the kernel of a group homomorphism",
	
	Usage => "kernel f",
	
	Inputs => {
		"f" => GroupMap,
		},
	
	   
	Outputs => {
	    Subgroup => {"the kernel of the homomorphism"}
	    },
	
	
	PARA {"This function is provided by the package ", TO CoxeterGroups,"."},
	
	PARA {"This function computes a set of generators for the kernel of a group homomorphism
	    via the Todd-Coxeter procedure."},
	
	PARA {"The kernel of the sign homomorphism on the symmetric group on 4 letters is the 
	    alternating group on 4 letters."},
	
	EXAMPLE { 
	    "S = symmetricGroup 4",
	    "sgn = signMap S",
	    "A = ker sgn" 
	    },

	PARA {"The dihedral group of symmetries of a square admits a homomorphism to the Klein 4 group.
	    We compute the kernel of this homomorphism."},
	
	EXAMPLE {
	     "C2 = symmetricGroup 2",
	     "V = C2 * C2",
	     "D = dihedralGroup 4",
	     "f = map(V, D, {V_0, V_1})",
	     "ker f" 
	     },
	    
	 SeeAlso => {(map, CoxeterGroup, List), (map, CoxeterGroup, CoxeterGroup, List), 
	     toddCoxeterProcedure}
	    }

--(map,CG,GG)
document {
	Key => {(map, CoxeterGroup, CoxeterGroup)},
	
	Headline => "create a map",
	
	Usage => "map(H,G)",
	
	Inputs => {
      "H" => CoxeterGroup,
      "G" => CoxeterGroup
		},
	
	   
	Outputs => {
	    GroupMap => {"the map from G to H by sending a generator to the genererator of the same name if there, and else to the identity element."}
	    },
	
	
	PARA {"This function is provided by the package ", TO CoxeterGroups,"."},
	
	PARA {"This function creates a group homorphism between the given Coxeter groups."},
	PARA {"The image of a generator in the first Coxeter group is sent to the corresponding generator with the same symbol of the second Coxeter group if it exists, if not the generator is sent to the identity element."},
	
	--PARA {"The kernel of the sign homomorphism on the symmetric group on 4 letters is the alternating group on 4 letters."},
	
	--EXAMPLE { 
   --    "G = coxeterGroup({a,b},matrix{{1,2},{2,1}})"
   --    "H = coxeterGroup({c,d},matrix{{1,4},{4,1}})"
	--    "f = map",
	--    "A = ker sgn" 
	--    },

	PARA {"The dihedral group of symmetries of a square admits a homomorphism to the Klein 4 group.
	    We create this homomorphism."},
	
	EXAMPLE {
         "G = dihedralGroup 8",
         "H = dihedralGroup 4",
         "f = map(H,G)"
	     },
	    
	 SeeAlso => {(map, CoxeterGroup, List), (map, CoxeterGroup, CoxeterGroup), 
	     toddCoxeterProcedure}
	    }

--(map, CG,CG,List)
document {
	Key => {(map, CoxeterGroup, CoxeterGroup,List)},
	
	Headline => "create a map",
	
	Usage => "map(H,G,L)",
	
	Inputs => {
      "H" => CoxeterGroup,
      "G" => CoxeterGroup,
      "L" => List
		},
	
	   
	Outputs => {
	    GroupMap => {"the map from G to H where  generators are mapped in order to the entries in L"}
	    },
	
	
	PARA {"This function is provided by the package ", TO CoxeterGroups,"."},
	
	PARA {"This function creates a map from the given list when it defines a group homorphism between the given Coxeter groups."},
	PARA {"The list gives the images in the first Coxeter group of the generators of the second Coxeter group."},
	
	--PARA {"The kernel of the sign homomorphism on the symmetric group on 4 letters is the alternating group on 4 letters."},
	
	--EXAMPLE { 
   --    "G = coxeterGroup({a,b},matrix{{1,2},{2,1}})"
   --    "H = coxeterGroup({c,d},matrix{{1,4},{4,1}})"
	--    "f = map",
	--    "A = ker sgn" 
	--    },

	PARA {"For example, the dihedral group of symmetries of a square admits a homomorphism to the Klein 4 group.
	    We create this homomorphism."},
	
	EXAMPLE {
	     "C2 = symmetricGroup 2",
	     "V = C2 * C2",
	     "D = dihedralGroup 4",
	     "f = map(V, D, {V_0, V_1})",
	     },
	    
	 SeeAlso => {(map, CoxeterGroup, List), (map, CoxeterGroup, CoxeterGroup), 
	     toddCoxeterProcedure}
	    }

--(map, CG,List)
document {
	Key => {(map, CoxeterGroup, List)},
	
	Headline => "create a group map",
	
	Usage => "map(G,L)",
	
	Inputs => {
      "G" => CoxeterGroup,
      "L" => List
		},
	
	   
	Outputs => {
	    GroupMap => {"the map from G to GL_n where the list is the images of the generators of G in GL_n"}
	    },
	
	
	PARA {"This function is provided by the package ", TO CoxeterGroups,"."},
	
	PARA {"This function creates a map from the given group to GL_n by  mapping in order the generators of the given group the elements of GL_n from the given list."},
	PARA {"The given list needs to be a list of square matrices that satisfy the relations of the group."},
	
	--PARA {"The kernel of the sign homomorphism on the symmetric group on 4 letters is the alternating group on 4 letters."},
	
	--EXAMPLE { 
   --    "G = coxeterGroup({a,b},matrix{{1,2},{2,1}})"
   --    "H = coxeterGroup({c,d},matrix{{1,4},{4,1}})"
	--    "f = map",
	--    "A = ker sgn" 
	--    },

	--PARA {"The dihedral group of symmetries of a square admits a homomorphism to the Klein 4 group. We create this homomorphism."},
	
	EXAMPLE {
	     "G = dihedralGroup 8",
        "ms = matrix{{-1,0},{0,-1}}",
        "mt = matrix{{1,0},{0,1}}",
	     "f = map(G,{ms,mt})"
	     },
	    
	 SeeAlso => {(map, CoxeterGroup, CoxeterGroup, List), (map, CoxeterGroup, CoxeterGroup), toddCoxeterProcedure}
	    }

/// EXAMPLE

uninstallPackage "CoxeterGroups"
installPackage "CoxeterGroups"
help "toddCoxeterProcedure"
help "kernel(GroupMap)"




restart
loadPackage "CoxeterGroups"
W = specificCoxeterGroup({s, t}, "A'1")
nerveComplex W

W = coxeterGroup cycleGraph 4
nerveComplex W
sphericalElements W
H = subgroup(s,t,s,t,s)
g = apply(reflectionRepresentatives W, w -> sub(w, ZZ/3) )
f = map(W, g)
toddCoxeterProcedure(f, DegreeLimit => 6)
peek f.cache
ker f


restart
loadPackage "CoxeterGroups"
C2 = symmetricGroup 2
V = C2 * C2
D = dihedralGroup 4
f = map(V, D, {V_0, V_1})
ker f

restart
loadPackage "CoxeterGroups"
S = symmetricGroup 3
s = signMap S
toddCoxeterProcedure(s, DegreeLimit => 3)
peek s.cache
ker s


restart
loadPackage "CoxeterGroups"
D = dihedralGroup 3
H = subgroup {s}
X = D/H
groundSet X
s*t*s H
t * oo

///

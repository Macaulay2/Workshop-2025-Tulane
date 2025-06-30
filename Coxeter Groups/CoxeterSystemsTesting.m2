-- Adds tests upto and including isFiniteGroup


restart
loadPackage "CoxeterGroups"

--specific case tests
I = matrix({{1,0},{0,1}})
assert(isCoxeterMatrix(matrix({{1,2},{0,1}}))==false)
assert(isCoxeterMatrix(I) == true)

M =matrix{{1,2},{2,1}}
G = coxeterGroup({a,b},M)
assert(expressions(G_0)=={{a}})

assert(wordToGroup(normalForm G_0, G)=={a})
-- wordToGroup({a,b,b,a},G) fails



assert(exchanges(G_0,G_0)=={0})
-- exchanges(G_0*G_1,G_1*G_0) fails
-- exchange needs statements on  what is expected in second argument, expects second argument to be a generator

assert(descentSet(G_1*G_0)=={0,1})

assert(reduceWord(normalForm(G_0*G_1),G)=={symbol a,symbol b})
assert(reduceWord({symbol a,symbol b},G)=={symbol a,symbol b})

assert(normalForm(a) == {symbol a})

H = coxeterGroup({c,d,e}, matrix{{1,3,4},{3,1,6},{4,6,1}})

-- putInGroup is not exported -- probablly fine
assert(isReduced({symbol c, symbol d, symbol e},H)==true)

-- no == between coxeterGroups, just checking some properties
K = coxeterGroup({f,g,h}, matrix{{1,3,4},{3,1,6},{4,6,1}})
assert((K_0*K_2)^4== id_K)
assert(K.coxeterMatrix == matrix{{1,3,4},{3,1,6},{4,6,1}})
graph1 = graph({{0,1},{1,2}})
assert(graph(dynkinDiagram(coxeterGroup(graph1))) === graph1)

subGrpMapG = map(G,G,{a,id_G})
subGrpG = image subGrpMapG
subGrpG' = kernel subGrpMapG
--error coxeterGroup subGrpG -- subGrpG_* does not have a length
--yet coxeterGroup subGrpG' -- subGrpG'_* does have a length
   -- I believe the error is in
      --image GroupMap in ToddCoxter, line (symbol generators) => targetValues, not being what is quite wanted
--subGrpGCox = coxeterGroup subGrpG 
--assert(length gens subGrpGCox == 1)
subGrpG'Cox = coxeterGroup subGrpG' 
assert(length gens subGrpG'Cox == 1)


assert(coxeterMatrix(G)==M)
assert(generators(G)=={G_0, G_1})


assert(numgens G == 2)
assert(numgens H == 3)


assert(groupOrder G == 4)

assert(longWord G == G_0*G_1)

assert(entries cartanMatrix G == {{1,0},{0,1}})
assert(degree ring cartanMatrix G == 2)


-- generic, for anyish G
assert(coxeterMatrix(coxeterGroup(dynkinDiagram(G))) == coxeterMatrix(coxeterGroup(coxeterMatrix(G))))

-- skipping for now CoxeterGroup _ ZZ -- unshure how to access

assert(coxeterMatrix(group id_G) == coxeterMatrix(G))
assert(id_G == G_0*G_0^-1)
assert(all(gens G, g-> length g == 1))


assert(all(gens G, g-> g*g == id_G))
assert((G_0*G_1)^(M_(0,1))==id_G)


assert(all(relations G / (r-> product r), v -> v == id_G))

assert((G_0*G_1)^(M_(0,1))==(G_0*G_1)^(groupOrder (G_0*G_1)))
assert(sign (G_0)^2==1)
--check isFiniteGroup detects correctly when some g_ig_k has infininte order
assert(if any(flatten entries coxeterMatrix G, (e -> e == 0)) then not isFiniteGroup G else true)


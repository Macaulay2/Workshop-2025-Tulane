 -------- Tests for ToddCoxeter.m2 -------


--- Test 0: Maps ---

M = matrix{{1, 2}, {2, 1}}
N = matrix{{1, 0}, {0, 1}}

G = coxeterGroup({a, b}, M)
H = coxeterGroup({w, z}, N) 

f = map(G, H, {a, b}) 
g = map(G, G)
h = map(H, H)
j = map(G, H)

assert(f(w*z) == a*b)
assert(g(a*b) == a*b)
assert(h(w*z) == w*z)
assert(j(w*z) == id_G)

--- This tests the output of various maps when applied to the generators of the domain group.
--- Note when map(G, H) is given a list it default to wither the identity map if G == H or the trivial map if G != H

--- Test 0.5: Alternate Maps ---

M = matrix{{1, 2}, {2, 1}}
G = coxeterGroup({a, b}, M)

Matrix1 = matrix{{0, 1}, {1, 0}}
Matrix2 = matrix{{-1, 0}, {0, -1}}

IdMatrix = maxtrix{{1, 0}, {1, 0}}

phi = map(G, {Matrix1, Matrix1})
psi = map(G, {Matrix2, Matrix2})

assert (phi(a) == Matrix1)
assert (phi(b) == Matrix1)
assert (phi(a*b) == IdMatrix)

assert (psi(a) == Matrix2)
assert (psi(b) == Matrix2)
assert (psi(a*b) == IdMatrix)

-- This tests an alternate input type for the method map

----------------------------------------------------------------------------


--- Test 1: Reflection Representation ---

n = matrix{{1, 0}, {0, 1}}
p = matrix{{1, 2, 2}, {2, 1, 2}, {2, 2, 1}}

H = coxeterGroup({w, z}, n)
I = coxeterGroup(p)

assert (entries (reflectionRepresentation H) w == {{-1, 2}, {0, 1}})
assert (entries (reflectionRepresentation H) z == {{1, 0}, {2, -1}})

assert (entries (reflectionRepresentation I) I_0 == {{-1, 0, 0}, {0, 1, 0}, {0, 0, 1}})
assert (entries (reflectionRepresentation I) I_1 == {{1, 0, 0}, {0, -1, 0}, {0, 0, 1}})
assert (entries (reflectionRepresentation I) I_2 == {{1, 0, 0}, {0, 1, 0}, {0, 0, -1}})

----------------------------------------------------------------------------


--- Test 2: Permutation Representation

S4 = symmetricGroup 4

transpose1 = matrix{{0, 1, 0, 0}, {1, 0, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}}
transpose2 = matrix{{1, 0, 0, 0}, {0, 0, 1, 0}, {0, 1, 0, 0}, {0, 0, 0, 1}}
transpose3 = matrix{{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 0, 1}, {0, 0, 1, 0}}

assert ((permutationRepresentation S4) s_0 == transpose1) 
assert ((permutationRepresentation S4) s_1 == transpose2) 
assert ((permutationRepresentation S4) s_2 == transpose3) 


--- Test 3: Regular Embedding ---

--- Regular Embedding currently is not functional 


--- Test 4: Regular Representation ---

--- Regular Representation relys on Regular Embedding


--- Test 5: Sign Map ---

m = matrix{{1, 2}, {2, 1}}

G = coxeterGroup({a, b}, m)

Matrix3 = matrix{{-1}}

assert ((signMap G) a == Matrix3)
assert ((signMap G) b == Matrix3)
assert ((signMap G) (a*b) == Matrix3)


--- Test 6: Relation Tables ---

M = matrix{{1, 2}, {2, 1}}
N = matrix{{1, 0}, {0, 1}}

G = coxeterGroup({a, b}, M)
H = coxeterGroup({w, z}, N) 

f = map(G, H, {a, b}) 

assert (sort unique flatten keys (relationTables f) == sort gens source f)


--- Test 7: Kernels ---

M = matrix{{1, 2}, {2, 1}}
N = matrix{{1, 0}, {0, 1}}

G = coxeterGroup({a, b}, M)
H = coxeterGroup({w, z}, N) 

f = map(G, H, {a, b}) 
g = map(G, G)
j = map(G, H)

assert (gens kernel f == {w*z*w*z})
assert (gens kernel g == {})
assert (gens kernel j == {w, z})

--- Test 8: Images ---

M = matrix{{1, 2}, {2, 1}}
N = matrix{{1, 0}, {0, 1}}

G = coxeterGroup({a, b}, M)
H = coxeterGroup({w, z}, N) 

f = map(G, H, {a, b}) 
g = map(G, G)
h = map(H, H)
j = map(G, H)

assert (gens image f == {a, b})
assert (gens image g == {a, b})
assert (gens image h == {w, z})
assert (gens image j == {})

--- Test 9: Schierer Graph ---


--- Test 10: Transversal ---


--- Test 11: Quotient Maps ---


--- Test 12: Presentation ---
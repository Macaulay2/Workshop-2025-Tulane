restart 

load "../CoxeterGroups.m2"


m = matrix{{1, 2}, {2, 1}}
n = matrix{{1, 0}, {0, 1}}
p = matrix{{1, 4}, {4, 1}}
m1 = matrix{{1, 2, 2}, {2, 1, 2}, {2, 2, 1}}

G = coxeterGroup({a, b}, m) -- Finite Coxeter Group with 2 Generators
H = coxeterGroup({w, z}, n) -- Infinite Coxeter Group with 2 Generators
I = coxeterGroup({x, y}, p) -- Finite Coxeter Group with 2 Generators
G1 = coxeterGroup(m1)
generators G1

S4 = symmetricGroup 4
S8 = symmetricGroup 8

f = map(G1, G, {s_0*s_1, s_1*s_2}) 
g = map(I, H, {x, y})
h = map(G, I, {a, b})

h * g



phi = h*g -- GroupMap * GroupMap works correctly

phi(c*d) -- GroupMap GroupElement works correctly

substitute (a*b, G) -- Substitue (GroupElement, CoxeterGroup) works correctly

source h 
target g

-- target GroupMap and source GroupMap work correctly --


targetValues f --targetValues works correctly

expression f -- expression GroupMap works
net f -- net GroupMap works

reflectionRepresentation G
reflectionRepresentation G1
reflectionRepresentation H

-- reflectionRepresentation GroupMap works

permutationRepresentation S4
permutationRepresentation S8

-- permutationRepresentation GroupMap works

regularEmbedding G
regularEmbedding H
regularEmbedding G1
regularEmbedding I

-- Error: regularEmbedding has strange behavior --

regularRepresentation G
regularRepresentation H  
regularRepresentation G1
regularRepresentation I

-- Error: regularRepresentation calls embedding and therefore throughs some errors --

signMap G
signMap H 
signMap G1
signMap I

-- signMap works --

relationTables f
relationTables g
relationTables h
relationTables phi

-- relationTables works --

kernel f
kernel g
kernel h
kernel phi

-- kernel works --

relationTables kernel f
relationTables kernel g
relationTables kernel h
relationTables kernel phi

-- relationTables works for subgroups --

schriererGraph f
schriererGraph g
schriererGraph h
schriererGraph phi

-- schriererGraph works --

schriererGraph kernel f
schriererGraph kernel g
schriererGraph kernel h
schriererGraph kernel phi

-- Error: schriererGraph does not work for Subgroup --

transversal f
transversal g
transversal h 
transversal phi

transversal kernel f
transversal kernel g
transversal kernel h
transversal kernel phi

-- transversal works for both maps and subgroups --

toddCoxeterProcedure f -- works

toddCoxeterProcedure kernel f -- Error: calls isParabolic: Not yet implemented

-----------------------------------------------------------------------------


f' = quotientMap f
f'(b)
g' = quotientMap g
g'(c*d*c*d*c*d*c*d*c*d)

f'' = quotientMap kernel f -- error subgroup does not cache cosetEquals
-- further error  subgroup function does not detect that the subgroup is the identity
g'' = quotientMap kernel g -- error subgroup does not cache cosetEquals


image f -- error timing out
image g -- error timing out
image h -- error timing out 

-- image throws same error regardless of input function

presentation G
presentation H 
presentation I
presentation G1

-- presentation does not handle infinite coxeter groups


quotient kernel f
quotient kernel g
quotient kernel h
quotient kernel phi

-- quotient works --

G / kernel f
H / kernel g
I / kernel h
H / kernel phi

-- CoxeterGroup / Subgroup works --

kernel f \ G

-- Subgroup \ CoxeterGroup throws an error becuase quotient has an  unexpected option Cosets 

group quotient kernel f
group quotient kernel g
group quotient kernel h
group quotient kernel phi
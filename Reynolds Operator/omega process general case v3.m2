n = 2 --SLn
d = 2 --Sym^d

N = binomial(n+d-1, d) -- number of coefficients in the polynomial


U = QQ[X_1..X_n]
allMonomials = (entries basis(d, U))#0
aVars = apply(exponents(sum(allMonomials)), p -> a_(p#0, p#1));
aVars
S = QQ[aVars, X_1..X_n] --do we want all these parameters?
gens S

fromUtoS = map(S, U, take(gens S, -n))
--ring (allMonomials/fromUtoS)#1
allMonomials = allMonomials / fromUtoS

allMonomialsMatrix = matrix {allMonomials}
aVarsMatrix = matrix {(gens S)_{0..N-1}}

universaldForm = (allMonomialsMatrix * transpose(aVarsMatrix))_0_0

-- ****** linear change of variables ******

zVars = z_(1,1)..z_(n,n)

R = QQ[aVars, zVars, X_1..X_n]
R' = QQ[aVars, zVars][X_1..X_n]

fromStoR = map(R, S, join(take(gens R, N),take(gens R, -n)))
universaldForm = fromStoR(universaldForm)
fromRtoR' = map(R', R, gens coefficientRing R' | gens R')
f = fromRtoR' universaldForm
coefficient(X_1*X_2,f)
zVarsMatrix = genericMatrix(R, z_(1,1), n, n)
XVarsMatrix = genericMatrix(R, X_1, n, 1)

transformedXVars = zVarsMatrix * XVarsMatrix

transformeddForm = sub(universaldForm, aVarsMatrix | transpose(transformedXVars))


-- === 4. Form μ^*(a_1^2) and expand ===
muStarA1sq = expand (muStar#1)^2

-- === 5. Define the differential operator Ω^2 ===
Omega2 = f -> (
    term1 = diff(z(2,2), diff(z(2,2), diff(z(1,1), diff(z(1,1), f))))  -- :contentReference[oaicite:5]{index=5}
    term2 = 2 * diff(z(2,2), diff(z(1,2), diff(z(2,1), diff(z(1,1), f))))
    term3 = diff(z(1,2), diff(z(1,2), diff(z(2,1), diff(z(2,1), f))))
    term1 - term2 + term3
)                                                                      -- :contentReference[oaicite:6]{index=6}

-- === 6. Compute c_{2,2} = Ω^2(det(Z)^2) ===
Z  = matrix {{z(1,1), z(1,2)}, {z(2,1), z(2,2)}}
c22 = Omega2(det Z^2)

-- === 7. Finally, the Reynolds operator on a1^2 ===
R_a1sq = Omega2(muStarA1sq) / c22

-- Display results:
muStarA1sq, c22, R_a1sq

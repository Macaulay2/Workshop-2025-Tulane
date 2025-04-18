n = 2 --SLn
d = 2 --Sym^d

N = binomial(n+d-1, d) -- number of coefficients in the polynomial


U = QQ[X_1..X_n]
allMonomials = (entries basis(d, U))#0
aVars = apply(exponents(sum(allMonomials)), p -> a_(p#0, p#1));
aVars
S = QQ[aVars, X_1..X_n]
gens S

fromUtoS = map(S, U, take(gens S, -n))
--ring (allMonomials/fromUtoS)#1
allMonomials = allMonomials / fromUtoS

allMonomialsMatrix = matrix {allMonomials}
aVarsMatrix = matrix {(gens S)_{0..N-1}}

universaldForm = (allMonomialsMatrix * transpose(aVarsMatrix))_0_0

-- ****** linear change of variables & extract coefficients ******

zVars = z_(1,1)..z_(n,n)

R = QQ[aVars, zVars, X_1..X_n]
R' = QQ[aVars, zVars][X_1..X_n]

fromStoR = map(R, S, join(take(gens R, N),take(gens R, -n)))
universaldForm = fromStoR(universaldForm)
aVarsMatrix = matrix {(gens S)_{0..N-1} / fromStoR}
fromRtoR' = map(R', R, gens coefficientRing R' | gens R')
f = fromRtoR' universaldForm
coefficient(X_1*X_2,f)


zVarsMatrix = genericMatrix(R, (z_(1,1))_R, n, n)
XVarsMatrix = genericMatrix(R, (X_1)_R, n, 1)

SLnLinearChangeofVars = map(R,R, aVarsMatrix | matrix mutableMatrix(R, 1, n^2) | transpose(zVarsMatrix * XVarsMatrix))



transformeddForm = SLnLinearChangeofVars(universaldForm)

coefficient(X_1*X_2,fromRtoR'(transformeddForm))


-- ***** form the Omega matrix ****


permutations toList(1..n)

cayleyOmega = n -> (
    xVars = x_(1,1)..x_(n,n);

    R = QQ[xVars];

    omega = F -> (
      -- 3.3.1 sum over all σ ∈ S_n of sign(σ)·(∏_{i=0..n-1} ∂/∂x_{i,σ(i)}) F
      sum apply(permutations splice {1..n}, sigma -> (
        sgn = sign permutation sigma;
        --print(sigma);
        -- start from F and differentiate one variable at a time:
        G = fold((g,i) -> (
                 j   = sigma#(i-1);
                 --print(diff(x_(i,j), g));
                 diff(x_(i,j), g)
               ), F, toList(1..n));
        --print(sgn * G);
        sgn * G
      ))
    );

    -- 3.4 Return the operator (and carry its ring around in closure):
    omega
)

C2 = cayleyOmega 2;
R2 = QQ[x_(1,1)..x_(2,2)]
M = genericMatrix(R2, x_(1,1), 2, 2)
detM = det M
C2 (detM)


--******** omega constant c_p,n*************

C3 = cayleyOmega 3;
R3 = QQ[x_(1,1)..x_(3,3)];
M3 = genericMatrix(R3, x_(1,1), 3, 3)
detM3 = det M3
C3 C3 (detM3)

cayleyConstant = (p,n) -> (
    Cn = cayleyOmega n;
    RRRR = QQ[x_(1,1)..x_(n,n)];
    M = genericMatrix(RRRR, x_(1,1), n, n);
    cpn = det M;
    
    for i from 1 to p do (
        print(ring cpn);
        cpn = Cn(cpn)
    );
    cpn
)

cayleyConstant(2,3)

--******** reynolds GLn (4.5.27)*************

n = 3
p = 2
Cn = cayleyOmega n;
R = QQ[x_(1,1)..x_(n,n)];
M = genericMatrix(R, x_(1,1), n, n)
f = random (p, R)
f / det M
omegaf = f
for i from 1 to p do (
    omegaf = Cn(omegaf)
);
cpn = cayleyConstant(p,n)

omegaf / 



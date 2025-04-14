newtonIdentitySums = method()
-- newtonIdentitySums takes in an integer k and n and returns list of the 1,2,,...,kth sum of powers in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentitySums(ZZ,Ring) := List => (k,R) -> (
    -- I'll tell M2 that I'm using these as symbols for elementary polynomials and the sum of power polynomials
    if k < 1 then error "n and k need to be positive integers";
   -- e = symbol "e";
    --p = symbol "p";
    use R;
    for i from 0 to k list ( sum((for j from 1 to i-1 list (-1)^(i-1+j)*e_(i-j)*p_j) |  {(-1)^(i-1)*i*e_i}))
)
newtonIdentitySums(ZZ) := List => k -> newtonIdentity(k, QQ[e_0..e_k, p_0..p_k])

newtonIdentitySymmetry = method()
-- newtonIdentitySymmetry takes in an integer k and n and returns list of the 1,2,,...,kth elementary symmetric polynomials in n variables in terms of the
-- elementary symmmetric polynomials and sum of powers of degrees (k-1) and lower.
newtonIdentitySymmetry(ZZ, Ring) := List => (k, R) -> (
    if k < 1 then error "k need to be positive integers";
    use R;
    (for i from 1 to k list (1/i)*(sum((for j from 1 to i list (-1)^(j-1)*e_(i-j)*p_j))))
)
newtonIdentitySymmetry(ZZ) := List => k -> newtonIdentitySymmetry(k, QQ[e_0..e_k, p_0..p_k])
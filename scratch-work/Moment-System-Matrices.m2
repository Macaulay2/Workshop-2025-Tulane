produceMomentSystemMatrices = method()
-*
The function produces the matrix being multiplied to [1,P,P^2,...,P^k]^T
Input: k - number of P's of ZZ
       variance - sigma^2 of QQ
Output: k by (k+1) matrix
*-
produceMomentSystemMatrices (ZZ,QQ) := (k,variance) -> (
    if not k > 0 then error "k should be a positive integer";
    if k == 1 then return matrix{{0,1}};
    if k == 2 then return matrix{{0,1,0},{variance,0,1}};
    M := new MutableMatrix from map(QQ^(k),QQ^(k+1),0);
    M0 := produceMomentSystemMatrices(2,variance);
    scan(2,i -> (scan(3, j -> M_(i,j) = M0_(i,j))));
    scan(toList (2..(k-1)),i -> (
	    shiftedRow := shiftingRow (matrix M)^{i-1};
	    newRow := shiftedRow + i*variance*((matrix M)^{i-2});
	    newRow = flatten entries newRow;
	    scan(k+1,j ->(
		    M_(i,j) = newRow_j;
		    )))
	);
    M
    )

shiftingRow = method()
shiftingRow Matrix := M -> (
    n := numColumns M;
    (matrix{{0} | flatten entries M})_{0..(n-1)}
    )

fabricateMoments = method()
fabricateMoments List := mu -> (
    k := #mu;
    powerSumList := apply(k,i->sum(apply(mu,u -> u^(i+1))));
    (A,B) := produceMomentSystemMatrices(k,1/1);
    A*(transpose matrix{powerSumList})+B
    )

end

restart
needsPackage "GaussianMixtureModels"
setRandomSeed(415)
for i from 200 to 300 do (
    mu = flatten entries random(QQ^i,QQ^1);
    m = fabricateMoments(mu);
    (A,B) = produceMomentSystemMatrices(i,1/1);
    elapsedTime out = solveGaussianSystem(A,flatten entries(m-B));
    print(sort apply(mu,i->i_RR));
    print(sort out);
    )

m = fabricateMoments({1,2})
(A,B) = produceMomentSystemMatrices(2,1/1)
solveGaussianSystem(A,flatten entries (m-B))
--
for i from 1 to 20 do (
    M := produceMomentSystemMatrices(i,1/1);
    print M
    )

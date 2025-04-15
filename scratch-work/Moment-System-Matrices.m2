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
end

restart
needsPackage "GaussianMixtureModels"
(A,B) = produceMomentSystemMatrices(5,1/1)
solveGaussianSystem(A,flatten entries(random(QQ^5,QQ^1)-B))
--
for i from 1 to 20 do (
    M := produceMomentSystemMatrices(i,1/1);
    print M
    )

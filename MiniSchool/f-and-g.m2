f = x -> x^2
g = (x,y) -> x | y 
h = (x,y) -> transpose x | y

minimalMonomials = L -> (
    M := {};
    for m in L do (
	if all(delete(m,L), a -> m % a != 0) then M = M | {m} 
	);
    unique M
    )
end

restart
load "f-and-g.m2"
R = QQ[x,y,z]
L = apply(100,i->R_(apply(numgens R,i->abs random ZZ)))
minimalMonomials L

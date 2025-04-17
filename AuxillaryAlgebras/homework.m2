-- here are some things we worked on today... some don't work right yet
-- act on vectors
restart
R = QQ[x_0..x_1]
X = matrix{{0,1},{0,0}}
Y = matrix{{0,0},{1,0}}
H = X*Y-Y*X
sl2 = {H, X, Y}
E = id_(R^2)
E_{0}
sl2Action = (A,v) -> A*v
sl2Action(X,matrix{{0},{1}})


-- act on matrices
X = matrix{{0,1},{0,0}}
Y = matrix{{0,0},{1,0}}
H = X*Y-Y*X
sl2 = {H, X, Y}
sl2Action = (A, B, M) -> A*M + M*(transpose B)
sl2Action(X, X, matrix{{0,0},{0,1}})

-- act on S_{2,1}C^2: 
restart
R[x_{{0,0},{1}}, x_{{0,1},{1}}]
loadPackage"PieriMaps"
standardTableaux(2,{2,1})
X = matrix{{0,1},{0,0}} -- e_0 -> 0, e_1-> e_0
Y = matrix{{0,0},{1,0}} -- e_0 -> e_1, e_1-> 0
H = X*Y-Y*X
sl2 = {H, X, Y}
addValues(straighten {{0,0},{0}} , straighten {{1,0},{0}})

sl2Action (A, ht)
--(X, {{0,0},{1}} ) -> 0*x_{{0,0},{1}}  + 0*x_{{0,0},{1}} + 1*x_{{0,0},{0}} =0 
--(X, {{0,1},{1}} ) -> 0*x_{{0,1},{1}}  + 1*x_{{0,0},{1}} + 1*x_{{0,1},{0}} 
-- = new HashTable from {{{0, 0}, {1}} => 1/2}
unique ((keys straighten {{0,1},{0}})|(keys straighten {{0,1},{1}}))
addValues = (ht1, ht2) -> merge(ht1 , ht2, (i,j) -> i+j)
ht = straighten {{0,1},{0}}
keys ht
merge(straighten {{0,1},{1}} , straighten {{0,1},{0}}, (i,j) -> i+j)

--(Y, {{0,0},{1}} ) -> 1*x_{{1,0},{1}}  + 1*x_{{0,1},{1}} + 0*x_{{0,0},{1}} 
--(Y, {{0,1},{1}} ) -> 1*x_{{1,1},{1}}  + 0*x_{{0,1},{1}} + 0*x_{{0,1},{1}} =0
-- = new HashTable from {{{0, 0}, {1}} => 1/2}
addValues( straighten {{1,0},{1}}, straighten {{0,1},{1}})
scalarMult = (m, ht1) -> new HashTable from apply(keys ht1, key -> key=> m*ht1#key )
scalarMult(3,straighten({{0,1},{1}}))
sl2Action = (A, HT) -> (h:= A_(0,0);  x: =A_(0,1); y:=A_(1,0); 
addValues(addValues(scalarMult(h, sl2ActBasis(H,HT)), scalarMult(x, sl2ActBasis(X,HT))), scalarMult(y, sl2ActBasis(Y,HT))))
)

--- 
restart
R = QQ[x_0..x_1]
X = f-> x_1*diff(x_0, f)
Y = f-> x_0*diff(x_1, f)

f = random(2,R)
X X f
H = f-> ((Y X f) - (X Y f))
H f
H \ (gens R)
H \ flatten entries( basis(2, R))
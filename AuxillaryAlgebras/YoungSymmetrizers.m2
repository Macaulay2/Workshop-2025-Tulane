---Young Symmetrizers
restart
-- the folowing code produces a degree 4 polynomial in the 8 variables x_(i,j,k),
-- using auxillary variables a_(i,d), b_(j,d), c_(k,d)

-- the polynomial is the 2x2x2 hyperdeterminant

Ra = QQ[a_(0,0)..a_(1,3)] -- ring on  A times CC^d 
Rb = QQ[b_(0,0)..b_(1,3)] -- ring on  B times CC^d 
Rc = QQ[c_(0,0)..c_(1,3)] -- ring on  C times CC^d 
Rx = QQ[x_(0,0,0)..x_(1,1,1)] -- ring on A \otimes B\otimes C
R = Ra**Rb**Rc**Rx  -- big ring
-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux, and ideally there should be a function that makes 
--  them dynamically
A1= matrix apply(2,i -> apply({0,1}, j-> a_(i,j) ))
A2= matrix apply(2,i -> apply({2,3}, j-> a_(i,j) ))
B1= matrix apply(2,i -> apply({0,1}, j-> b_(i,j) ))
B2= matrix apply(2,i -> apply({2,3}, j-> b_(i,j) ))
C1= matrix apply(2,i -> apply({0,2}, j-> c_(i,j) ))
C2= matrix apply(2,i -> apply({1,3}, j-> c_(i,j) ))
-- this should be held as a product and not expanded for larger problems
time T =  det(A1)*det(A2)*det(B1)*det(B2)*det(C1)*det(C2);
-- this loop builds the poylnomial in Rx, one factor at a time.  This should also be held as a product.
F=T; time for d from 0 to 3 do F= sum(2,k-> sum(2, j-> sum(2,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F))));


myList = flatten flatten apply(2, i-> apply(2, j-> apply(2, k-> {i,j,k}  )));
F=T; time for d from 0 to 3 do F = sum(myList, L-> x_(L#0, L#1, L#2)*diff(a_(L#0,d)*b_(L#1,d)*c_(L#2,d),F));



-- there should also be an evaluation option, instead of multiplying by each x_I
 -- evauate at each stage.

---Young Symmetrizers  -- try II
restart
-- the folowing code produces a degree 4 polynomial in the variables x_(i,j,k),
-- using auxillary variables a_(i,d), b_(j,d), c_(k,d)

-- the polynomial is the 3x3x3 degree 4 Strassen polynomial(s)
dg = 4; aa = 2; bb = 2; cc = 2;

Ra = QQ[a_(0,0)..a_(aa,dg-1)] -- ring on  A times CC^d 
Rb = QQ[b_(0,0)..b_(bb,dg-1)] -- ring on  B times CC^d 
Rc = QQ[c_(0,0)..c_(cc,dg-1)] -- ring on  C times CC^d 
Rx = QQ[x_(0,0,0)..x_(aa,bb,cc)] -- ring on A \otimes B\otimes C
R = Ra**Rb**Rc**Rx  -- big ring


-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux, and ideally there should be a function that makes 
--  them dynamically
A1= matrix apply(3,i -> apply({0,1,2}, j-> a_(i,j) ))
A2= matrix apply(1,i -> apply({3}, j-> a_(i,j) ))

B1= matrix apply(3,i -> apply({0,1,3}, j-> b_(i,j) ))
B2= matrix apply(1,i -> apply({2}, j-> b_(i,j) ))

C1= matrix apply(3,i -> apply({0,2,3}, j-> c_(i,j) ))
C2= matrix apply(1,i -> apply({1}, j-> c_(i,j) ))

-- this should be held as a product and not expanded for larger problems
time T = det(A1)*det(A2)*det(B1)*det(B2)*det(C1)*det(C2);

-- this loop builds the poylnomial in Rx, one factor at a time.  This should also be held as a product.
F=T; time for d from 0 to dg-1 do F= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*contract(a_(i,d)*b_(j,d)*c_(k,d),F))));

-- get rid of extra factors in the coefficients
uco = F-> gcd unique apply( unique flatten entries (coefficients F)_1, p-> abs sub(p,QQ))
F = F/((uco F)*(leadCoefficient F))
 
--- construct Lie-Algebra operators
-- eat a polynomial (F), the factor you want to act in (m), and the operation (p to q) on the indices.
lie = (F,m,p,q)->(
     if m ==1 then tmp = sum(bb+1,j-> sum(cc+1,k->  x_(q,j,k) *diff(x_(p,j,k) ,F) ));
     if m ==2 then tmp = sum(aa+1,i-> sum(cc+1,k->  x_(i,q,k) *diff(x_(i,p,k) ,F) ));
     if m ==3 then tmp = sum(aa+1,i-> sum(bb+1,j->  x_(i,j,q) *diff(x_(i,j,p) ,F) ));
if tmp != 0 then tmp = tmp/uco(tmp);
tmp
);
F
lie(F,1,1,0)
-- apply the Lie algebra many times in every factor, eventually get a basis of the module
L = {F};
for m from 1 to 3 do for f in L do  for j from 0 to bb do ( for k from 0 to cc do( tmp = lie(f,m,j,k); if tmp!=0 and not member(tmp,L) and not member(-tmp,L) then L = L|{tmp};))
length L


---Young Symmetrizers  -- with tensor product rings, and one partial evaluation trick
restart
-- the folowing code produces a degree 9 polynomial in the 27 variables x_(i,j,k),
-- using auxillary variables a_(i,d), b_(j,d), c_(k,d)
-- the polynomial is the 3x3x3 degree 9 Strassen Invariant
(dg, aa, bb, cc) = (9,2,2,2);-- degree of the invariant, the projective dimensions of the spaces
Ra = QQ[a_(0,0)..a_(aa,dg-1)] -- ring on  A times CC^d 
Rb = QQ[b_(0,0)..b_(bb,dg-1)] -- ring on  B times CC^d 
Rc = QQ[c_(0,0)..c_(cc,dg-1)] -- ring on  C times CC^d 
Rx = QQ[x_(0,0,0)..x_(aa,bb,cc)] -- ring on A \otimes B\otimes C
R = Ra**Rb**Rc**Rx  -- big ring -- Later we compare to subsequent ring extensions instead of tensor product
-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux
A1= matrix apply(3,i -> apply({0,1,2}, j-> a_(i,j) ));
A2= matrix apply(3,i -> apply({3,4,5}, j-> a_(i,j) ));
A3= matrix apply(3,i -> apply({6,7,8}, j-> a_(i,j) ));

B1= matrix apply(3,i -> apply({0,3,6}, j-> b_(i,j) ));
B2= matrix apply(3,i -> apply({1,4,7}, j-> b_(i,j) ));
B3= matrix apply(3,i -> apply({2,5,8}, j-> b_(i,j) ));

C1= matrix apply(3,i -> apply({0,3,5}, j-> c_(i,j) ));
C2= matrix apply(3,i -> apply({1,4,6}, j-> c_(i,j) ));
C3= matrix apply(3,i -> apply({2,7,8}, j-> c_(i,j) ));

-- do one part at a time because we know that the determinant of the other A'matrices 
--  are just coming along for the ride
time T1 =det(A1)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 3s
#terms T1
F1=T1; time for d from 0 to 2 do F1= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F1)))); --33s
time F12 = det(A2)*F1;
#terms F12
time for d from 3 to 5 do F12= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F12)))); --115s
#terms F12
time F123 = det(A3)*F12;
#terms F123
time for d from 6 to 8 do F123= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F123)))); --185s
#terms F123
strassen9= F123;
-- here; the method to evauate at each stage.
myPt = flatten flatten apply(3, i-> apply(3, j-> apply(3, k-> x_(i,j,k) => 0 )) )
myPt = {x_(0,0,0) => 1, x_(0,0,1) => 0, x_(0,0,2) => 0, x_(0,1,0) => 0, x_(0,1,1) => 0, x_(0,1,2) => 1, x_(0,2,0) => 0, x_(0,2,1) => 0, x_(0,2,2) => 0, x_(1,0,0)
      => 0, x_(1,0,1) => 0, x_(1,0,2) => 0, x_(1,1,0) => 0, x_(1,1,1) => 1, x_(1,1,2) => 0, x_(1,2,0) => 0, x_(1,2,1) => 0, x_(1,2,2) => 0, x_(2,0,0) => 0,
      x_(2,0,1) => 0, x_(2,0,2) => 0, x_(2,1,0) => 0, x_(2,1,1) => 0, x_(2,1,2) => 0, x_(2,2,0) => 0, x_(2,2,1) => 0, x_(2,2,2) => 1}
-- this method evaluates every time a final variable is created
evalUnfactor = pt -> (
     for i to 2 do for j to 2 do for k to 2 do X_(i,j,k) = sub(x_(i,j,k), pt);
 T1 =det(A1)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 3s
F1=T1; time for d from 0 to 2 do F1= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->X_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F1)))); 
F12 = det(A2)*F1;
for d from 3 to 5 do F12= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->X_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F12)))); 
F123 = det(A3)*F12;
for d from 6 to 8 do F123= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->X_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F123)))); 
F123)

evalUnfactor(myPt)

myPt = flatten flatten apply(3, i-> apply(3, j-> apply(3, k-> x_(i,j,k) => random(QQ) )) )

evalUnfactor(myPt)
--- now try the method with nested ring structure.

---Young Symmetrizers  -- with stacked ring extensions (instead of tensor products of rings) and the partial evaluation trick
restart
-- the polynomial is the 3x3x3 degree 9 Strassen Invariant
(dg, aa, bb, cc) = (9,2,2,2);-- degree of the invariant, the projective dimensions of the spaces
Rx = QQ[x_(0,0,0)..x_(aa,bb,cc)]
-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux, and ideally there should be a function that makes 
--  them dynamically
genMat = (Rg, a,b) -> value toString transpose genericMatrix(Rg,Rg_0, a,b);
Ra1 = Rx[flatten apply(3, i->  apply({0,1,2}, j-> a_(i,j)))];
A1 = genMat(Ra1, 3,3);
Ra2 = Ra1[flatten apply(3, i->  apply({3,4,5}, j-> a_(i,j)))];
A2 = genMat(Ra2, 3,3);
Ra3 = Ra2[flatten apply(3, i->  apply({6,7,8}, j-> a_(i,j)))];
A3 = genMat(Ra3, 3,3);
Rb1 = Ra3[flatten apply(3, i->  apply({0,3,6}, j-> b_(i,j)))];
B1 = genMat(Rb1, 3,3);
Rb2 = Rb1[flatten apply(3, i->  apply({1,4,7}, j-> b_(i,j)))];
B2 = genMat(Rb2, 3,3);
Rb3 = Rb2[flatten apply(3, i->  apply({2,5,8}, j-> b_(i,j)))];
B3 = genMat(Rb3, 3,3);
Rc1 = Rb3[flatten apply(3, i->  apply({0,3,6}, j-> c_(i,j)))];
C1 = genMat(Rc1, 3,3);
Rc2 = Rc1[flatten apply(3, i->  apply({1,4,7}, j-> c_(i,j)))];
C2 = genMat(Rc2, 3,3);
Rc3 = Rc2[flatten apply(3, i->  apply({2,5,8}, j-> c_(i,j)))];
C3 = genMat(Rc3, 3,3);
-- naive method
--time T = det(A1)*det(A2)*det(A3)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 84s
--F=T; time for d from 0 to dg-1 do F= sum(cc+1,k-> sum(bb+1, j-> sum(cc+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F)))); -- not done after (25) minutes, and using something like 44Gb of ram. 

-- try to do one part at a time because we know that the determinant of the other A'matrices are just coming along for the ride
time T1 =det(A1)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 1.6s
F1=T1; elapsedTime for d from 0 to 2 do F1= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F1)))); --27s
myList = flatten flatten apply(aa+1, i-> apply(bb+1, j-> apply(cc+1, k-> {i,j,k}  )));
F=T1; time for d from 0 to 2 do F = sum parallelApply(myList, L-> x_(L#0, L#1, L#2)*diff(a_(L#0,d)*b_(L#1,d)*c_(L#2,d),F)); -- 22.4s
F1 ==F

allowableThreads = maxAllowableThreads -- this didn't decrease the time taken...
F=T1; elapsedTime time for d from 0 to 2 do F = sum parallelApply(myList, L-> x_(L#0, L#1, L#2)*diff(a_(L#0,d)*b_(L#1,d)*c_(L#2,d),F)); -- 22.4s
F1 ==F


-- is there a parallelSum function? If not, why not?
time F12 = det(A2)*F1; -- 2.5s
elapsedTime time for d from 3 to 5 do F12= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F12)))); --91s
F=det(A2)*F1; elapsedTime time for d from 3 to 5 do F = sum parallelApply(myList, L-> x_(L#0, L#1, L#2)*diff(a_(L#0,d)*b_(L#1,d)*c_(L#2,d),F)); -- 22.4s
F12 ==F

F=det(A2)*F1; elapsedTime time for d from 3 to 3 do LL = apply(myList, L-> x_(L#0, L#1, L#2)*diff(a_(L#0,d)*b_(L#1,d)*c_(L#2,d),F)); -- 30s for parallelApply, 39s for apply
elapsedTime time F=sum LL;
F12 ==F


myList = flatten flatten apply(2, i-> apply(2, j-> apply(2, k-> {i,j,k}  )));
F=T; time for d from 0 to 3 do F = sum(myList, L-> x_(L#0, L#1, L#2)*diff(a_(L#0,d)*b_(L#1,d)*c_(L#2,d),F));

time F123 = det(A3)*F12;--3.3s
time for d from 6 to 8 do F123= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F123)))); --75s
F123= sub(F123, Rx);
#terms F123
strassen9= F123;
-- I want to know if these steps go faster if you put all of the loops into one loop, and use "sum parallelApply"
-- naive method
-- time T = det(A1)*det(A2)*det(A3)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 
-- F=T; time for d from 0 to dg-1 do F= sum(cc+1,k-> sum(bb+1, j-> sum(cc+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F)))); --

--
---Young Symmetrizers  -- try a different term order
restart
-- the folowing code produces a degree 4 polynomial in the 8 variables x_(i,j,k),
-- using auxillary variables a_(i,d), b_(j,d), c_(k,d)
-- the polynomial is the 3x3x3 degree 9 Strassen Invariant
dg = 9
aa = 2
bb = 2 
cc = 2
Rx = QQ[x_(0,0,0)..x_(aa,bb,cc)]
-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux, and ideally there should be a function that makes 
--  them dynamically
Ra1 = Rx[flatten apply(3, i->  apply(3, j-> a_(i,j)))] 
Ra2 = Ra1[flatten apply(3, i->  apply(3, j-> a_(i,j+3)))] 
Ra3 = Ra2[flatten apply(3, i->  apply(3, j-> a_(i,j+6)))] 
Rb1 = Ra3[flatten apply(3, i->  apply(3, j-> b_(i,j)))]
Rb2 = Rb1[flatten apply(3, i->  apply(3, j-> b_(i,j+3)))]
Rb3 = Rb2[flatten apply(3, i->  apply(3, j-> b_(i,j+6)))]
Rc1 = Rb3[flatten apply(3, i->  apply(3, j-> c_(i,j)))]
Rc2 = Rc1[flatten apply(3, i->  apply(3, j-> c_(i,j+3)))]
Rc3 = Rc2[flatten apply(3, i->  apply(3, j-> c_(i,j+6)))]

A1= matrix apply(3,i -> apply({0,1,2}, j-> a_(i,j) ))
A2= matrix apply(3,i -> apply({3,4,5}, j-> a_(i,j) ))
A3= matrix apply(3,i -> apply({6,7,8}, j-> a_(i,j) ))

B1= matrix apply(3,i -> apply({0,3,6}, j-> b_(i,j) ))
B2= matrix apply(3,i -> apply({1,4,7}, j-> b_(i,j) ))
B3= matrix apply(3,i -> apply({2,5,8}, j-> b_(i,j) ))

C1= matrix apply(3,i -> apply({0,3,5}, j-> c_(i,j) ))
C2= matrix apply(3,i -> apply({1,4,6}, j-> c_(i,j) ))
C3= matrix apply(3,i -> apply({2,7,8}, j-> c_(i,j) ))
-- try to do one part at a time because we know that the determinant of the other A'matrices are just coming along for the ride
time T1 =det(A1)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 1.5s
F1=T1; time for d from 0 to 2 do F1= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F1)))); -- 26s
time F12 = det(A2)*F1; -- 2.3s
time for d from 3 to 5 do F12= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F12)))); -- 89s
time F123 = det(A3)*F12;--2.3s
time for d from 6 to 8 do F123= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F123)))); --53s
F123= sub(F123, Rx);
#terms F123
time T = det(A1)*det(A2)*det(A3)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 93s
F=T; time for d from 0 to dg-1 do F= sum(cc+1,k-> sum(bb+1, j-> sum(cc+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F)))); -- (more than 25 minutes)
#terms F

-- here; the method to evauate at each stage.
myPt = flatten flatten apply(3, i-> apply(3, j-> apply(3, k-> x_(i,j,k) => 0 )) )
myPt = {x_(0,0,0) => 1, x_(0,0,1) => 0, x_(0,0,2) => 0, x_(0,1,0) => 0, x_(0,1,1) => 0, x_(0,1,2) => 1, x_(0,2,0) => 0, x_(0,2,1) => 0, x_(0,2,2) => 0, x_(1,0,0)
      => 0, x_(1,0,1) => 0, x_(1,0,2) => 0, x_(1,1,0) => 0, x_(1,1,1) => 1, x_(1,1,2) => 0, x_(1,2,0) => 0, x_(1,2,1) => 0, x_(1,2,2) => 0, x_(2,0,0) => 0,
      x_(2,0,1) => 0, x_(2,0,2) => 0, x_(2,1,0) => 0, x_(2,1,1) => 0, x_(2,1,2) => 0, x_(2,2,0) => 0, x_(2,2,1) => 0, x_(2,2,2) => 1}

evalUnfactor = pt -> (
     for i to 2 do for j to 2 do for k to 2 do X_(i,j,k) = sub(x_(i,j,k), pt);
 T1 =det(A1)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 3s
F1=T1;  for d from 0 to 2 do F1= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->X_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F1)))); 
F12 = det(A2)*F1;
for d from 3 to 5 do F12= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->X_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F12)))); 
F123 = det(A3)*F12;
for d from 6 to 8 do F123= sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->X_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F123)))); 
F123)

time evalUnfactor(myPt)
myPt = flatten flatten apply(3, i-> apply(3, j-> apply(3, k-> x_(i,j,k) => random(QQ) )) );
time evalUnfactor(myPt)

-- naive method:
time T = det(A1)*det(A2)*det(A3)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); -- 
F=T; time for d from 0 to dg-1 do F= sum(cc+1,k-> sum(bb+1, j-> sum(cc+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F))));
#terms F

restart
-- the folowing code produces a degree 6 polynomial in the 32 variables x_(i,j,k,l,m),
-- using auxillary variables a_(i,p), b_(j,p), c_(k,p), d_(l,p), e_(m,p)

dg = 6
n = 1


Ra = QQ[a_(0,0)..a_(n,dg-1)] -- ring on  A times CC^d 
Rb = QQ[b_(0,0)..b_(n,dg-1)] -- ring on  B times CC^d 
Rc = QQ[c_(0,0)..c_(n,dg-1)] -- ring on  C times CC^d 
Rd = QQ[d_(0,0)..d_(n,dg-1)] -- ring on  C times CC^d 
Re = QQ[e_(0,0)..e_(n,dg-1)] -- ring on  C times CC^d 


Rx = QQ[x_(0,0,0,0,0)..x_(n,n,n,n,n)] -- ring on A \otimes B\otimes C
R = Ra**Rb**Rc**Rd**Re**Rx  -- big ring

--[1, 2, 3, 4, 5, 6], [1, 2, 3, 5, 4, 6], [1, 3, 2, 4, 5, 6], [1, 3, 2, 5, 4, 6], [1, 4, 2, 5, 3, 6]

-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux, and ideally there should be a function that makes 
--  them dynamically
A1= matrix apply(3,i -> apply({0,1,2}, j-> a_(i,j) ))
A2= matrix apply(3,i -> apply({3,4,5}, j-> a_(i,j) ))
A3= matrix apply(3,i -> apply({6,7,8}, j-> a_(i,j) ))

B1= matrix apply(3,i -> apply({0,3,6}, j-> b_(i,j) ))
B2= matrix apply(3,i -> apply({1,4,7}, j-> b_(i,j) ))
B3= matrix apply(3,i -> apply({2,5,8}, j-> b_(i,j) ))

C1= matrix apply(3,i -> apply({0,4,8}, j-> c_(i,j) ))
C2= matrix apply(3,i -> apply({1,5,6}, j-> c_(i,j) ))
C3= matrix apply(3,i -> apply({2,3,7}, j-> c_(i,j) ))

-- this should be held as a product and not expanded for larger problems
time T = det(A1)*det(A2)*det(A3)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3); 
--T = hold det(A1)*det(A2)*det(A3)*det(B1)*det(B2)*det(B3)*det(C1)*det(C2)*det(C3);

-- this loop builds the poylnomial in Rx, one factor at a time.  This should also be held as a product.
F=T
for d from 0 to dg-1 do F= sum(cc+1,k-> sum(bb+1, j-> sum(cc+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F))));
F

-- there should also be an evaluation option, instead of multiplying by each x_I
 -- evauate at each stage.


--------------------------------
--------------------------------
restart
-- the polynomial is a 3x3x3 degree 6 invariant
dg = 5
aa = 2
bb = 2 
cc = 2

Ra = QQ[a_(0,0)..a_(aa,dg-1)] -- ring on  A times CC^d 
Rb = QQ[b_(0,0)..b_(bb,dg-1)] -- ring on  B times CC^d 
Rc = QQ[c_(0,0)..c_(cc,dg-1)] -- ring on  C times CC^d 
Rx = QQ[x_(0,0,0)..x_(aa,bb,cc)] -- ring on A \otimes B\otimes C
R = Ra**Rb**Rc**Rx  -- big ring


-- the following matrices should have their column indices be determined by the 
--  columns of some triple of tableaux, and ideally there should be a function that makes 
--  them dynamically
A1= matrix apply(3,i -> apply({0,1,2}, j-> a_(i,j) ))
A2= matrix apply(3,i -> apply({3,4,5}, j-> a_(i,j) ))


B1= matrix apply(3,i -> apply({0,2,4}, j-> b_(i,j) ))
B2= matrix apply(3,i -> apply({1,3,5}, j-> b_(i,j) ))

C1= matrix apply(3,i -> apply({0,1,3}, j-> c_(i,j) ))
C2= matrix apply(3,i -> apply({2,4,5}, j-> c_(i,j) ))

-- this should be held as a product and not expanded for larger problems
time T = det(A1)*det(A2)*det(B1)*det(B2)*det(C1)*det(C2);
F=T;
size T
time for d from 0 to dg-1 do( print(size F); F= sum(cc+1,k-> sum(bb+1, j-> sum(cc+1,i->x_(i,j,k)*diff(a_(i,d)*b_(j,d)*c_(k,d),F))));)
size F
toString F


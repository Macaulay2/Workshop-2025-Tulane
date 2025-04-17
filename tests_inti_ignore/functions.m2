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

for d from 1 to dg do F1 = sum(cc+1,k-> sum(bb+1, j-> sum(aa+1,i->x_(i+1,j+1,k+1)*diff(a_(i+1,d)*b_(j+1,d)*c_(k+1,d),F1))))

restart
tab1 = {{1,2,3}, {4}}
tab2 = {{1,2,4}, {3}}
tab3 = {{1,3,4}, {2}}

highestWeight = (tab1,tab2,tab3) -> (

    (dg, aa, bb, cc) = (length flatten tab1, length tab1_0 ,length tab2_0 ,length tab3_0);
    -- print(dg);
    Rx := QQ[x_(1,1,1)..x_(aa,bb,cc)];
    -- print(Rx);
    genMat := (Rg, a,b) -> value toString transpose genericMatrix(Rg,Rg_0, a,b);
    listRa = {};
    for i from 1 to length tab1 list (
        if i > 1 then (
            listRa = listRa | {(last listRa)[flatten apply(length tab1_(i-1), k->  apply(tab1_(i-1), j-> a_(k+1,j)))]}
        )
        else (
            listRa = listRa | {Rx[flatten apply(length tab1_(i-1), k->  apply(tab1_(i-1), j-> a_(k+1,j)))]}
        )
    );
    -- print("---space---");
    -- print(genMat(listRa_0, length tab1_0,length tab1_0));
    -- print("---space---");
    -- print(genMat(listRa_1, length tab1_1, length tab1_1));

    detListA = {};
    for i from 0 to ((length listRa) -1) do (
        detListA = detListA | {det(genMat(listRa_i, length tab1_i,length tab1_i))}
    );
    print("---det---");
    print(detListA);

    -- prodDetA = product detListA;
    -- print("---product---");
    -- print(prodDetA);


    listRb = {};
    for i from 1 to length tab2 list (
        if i > 1 then (
            listRb = listRb | {(last listRb)[flatten apply(length tab2_(i-1), k->  apply(tab2_(i-1), j-> b_(k+1,j)))]}
        )
        else (
            listRb = listRb | {(last listRa)[flatten apply(length tab2_(i-1), k->  apply(tab2_(i-1), j-> b_(k+1,j)))]}
        )
    );
    -- print("---space---");
    -- print(genMat(listRb_0, length tab2_0,length tab2_0));
    -- print("---space---");
    -- print(genMat(listRb_1, length tab2_1, length tab2_1));

    detListB = {};
    for i from 0 to ((length listRb) -1) do (
        detListB = detListB | {det(genMat(listRb_i, length tab2_i,length tab2_i))}
    );
    print("---det---");
    print(detListB);

    -- prodDetB = product detListB;
    -- print("---product---");
    -- print(prodDetB);

    listRc = {};
    for i from 1 to length tab3 list (
        if i > 1 then (
            listRc = listRc | {(last listRc)[flatten apply(length tab3_(i-1), k->  apply(tab3_(i-1), j-> c_(k+1,j)))]}
        )
        else (
            listRc = listRc | {(last listRb)[flatten apply(length tab3_(i-1), k->  apply(tab3_(i-1), j-> c_(k+1,j)))]}
        )
    );
    -- print("---space---");
    -- print(genMat(listRc_0, length tab3_0,length tab3_0));
    -- print("---space---");
    -- print(genMat(listRc_1, length tab3_1, length tab3_1));

    detListC = {};
    for i from 0 to ((length listRc) -1) do (
        detListC = detListC | {det(genMat(listRc_i, length tab3_i,length tab3_i))}
    );
    print("---det---");
    print(detListC);

    -- prodDetC = product detListC;
    -- print("---product---");
    -- print(prodDetC);
    detListABC = detListA | detListB | detListC;

    T1 = product detListABC;
    print("---T1---");
    print(T1);
    F1 = T1;
    F1 = sum(cc-1,k-> sum(bb-1, j-> sum(aa-1,i->x_(i+1,j+1,k+1)*diff(a_(i+1,3)*b_(j+1,3)*c_(k+1,3),F1))));
    print("---F1---");
    print(F1);

    -- myList := flatten flatten apply(aa+1, i-> apply(bb+1, j-> apply(cc+1, k-> {i,j,k}  )));
    -- print("---myList---");
    -- print(myList);


)

time highestWeight(tab2,tab1,tab3)





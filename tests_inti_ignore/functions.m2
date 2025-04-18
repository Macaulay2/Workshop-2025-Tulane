restart
tab1 = {{1,2}, {3,4}}
tab2 = {{1,2}, {3,4}}
tab3 = {{1,3}, {2,4}}

highestWeight = (tab1,tab2,tab3) -> (

    (dg, aa, bb, cc) = (length flatten tab1, length tab1_0 ,length tab2_0 ,length tab3_0);
    print("---dg---");
    print(dg);
    Rx := QQ[x_(1,1,1)..x_(aa,bb,cc)];
    print(Rx);
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
    print("---space---");
    print(listRa);
    print(genMat(listRa_0, length tab1_0,length tab1_0));
    -- print("---space---");
    -- print(genMat(listRa_1, length tab1_1, length tab1_1));

    detListA = {};
    for i from 0 to ((length listRa) -1) do (
        detListA = detListA | {det(genMat(listRa_i, length tab1_i,length tab1_i))}
    );
    print("---det---");
    print(detListA);

    prodDetA = product detListA;
    print("---product---");
    print(prodDetA);


    listRb = {};
    for i from 1 to length tab2 list (
        if i > 1 then (
            listRb = listRb | {(last listRb)[flatten apply(length tab2_(i-1), k->  apply(tab2_(i-1), j-> b_(k+1,j)))]}
        )
        else (
            listRb = listRb | {(last listRa)[flatten apply(length tab2_(i-1), k->  apply(tab2_(i-1), j-> b_(k+1,j)))]}
        )
    );
    print("---space---");
    print(listRb);
    print(genMat(listRb_0, length tab2_0,length tab2_0));
    -- print("---space---");
    -- print(genMat(listRb_1, length tab2_1, length tab2_1));

    detListB = {};
    for i from 0 to ((length listRb) -1) do (
        detListB = detListB | {det(genMat(listRb_i, length tab2_i,length tab2_i))}
    );
    print("---det---");
    print(detListB);

    prodDetB = product detListB;
    print("---product---");
    print(prodDetB);

    listRc = {};
    for i from 1 to length tab3 list (
        if i > 1 then (
            listRc = listRc | {(last listRc)[flatten apply(length tab3_(i-1), k->  apply(tab3_(i-1), j-> c_(k+1,j)))]}
        )
        else (
            listRc = listRc | {(last listRb)[flatten apply(length tab3_(i-1), k->  apply(tab3_(i-1), j-> c_(k+1,j)))]}
        )
    );
    print("---space---");
    print(genMat(listRc_0, length tab3_0,length tab3_0));
    -- print("---space---");
    -- print(genMat(listRc_1, length tab3_1, length tab3_1));

    detListC = {};
    for i from 0 to ((length listRc) -1) do (
        detListC = detListC | {det(genMat(listRc_i, length tab3_i,length tab3_i))}
    );
    print("---det---");
    print(detListC);

    prodDetC = product detListC;
    print("---product---");
    print(prodDetC);
    detListABC = detListA | detListB | detListC;

    T1 = product detListABC;
    print("---T1---");
    print(T1);

    limitTab := (d,tab) -> (
        for item in tab do (
            if (isMember(d,item)) then (
                return length item
            )
        )

    );
    F1 = T1;
    for d from 1 to dg do (
        F1 = sum(limitTab(d,tab3),k-> sum(limitTab(d,tab2), j-> sum(limitTab(d,tab1),i->x_(i+1,j+1,k+1)*diff(a_(i+1,d)*b_(j+1,d)*c_(k+1,d),F1))));
    );
    print("---F1---");
    print(F1);

)

time highestWeight(tab1,tab1,tab3)
highestWeight({{1,2,3}, {4}}, {{1,2,4}, {3}}, {{1,3,4}, {2}})

restart

-- Sample input
tab1 = {{1,2}, {3,4}};
tab2 = {{1,2}, {3,4}};
tab3 = {{1,3}, {2,4}};


highestWeight = (tab1,tab2,tab3) -> (

    (dg, aa, bb, cc) = (length flatten tab1, length tab1_0 ,length tab2_0 ,length tab3_0);
    Rx := QQ[x_(1,1,1)..x_(aa,bb,cc)];
    genMat := (Rg, a,b) -> value toString transpose genericMatrix(Rg,Rg_0, a,b);
    
    buildList := (tab, listRabc, sourceRing) -> (
        for i from 1 to length tab list (
            if i > 1 then (
                listRabc = listRabc | {(last listRabc)[flatten apply(length tab_(i-1), k->  apply(tab_(i-1), j-> c_(k+1,j)))]}
            )
            else (
                listRabc = listRabc | {(sourceRing)[flatten apply(length tab_(i-1), k->  apply(tab_(i-1), j-> c_(k+1,j)))]}
            )
        );
        return listRabc
    );

    lisrRa = {};
    listRa = buildList(tab1,lisrRa,Rx);

    detListA = {};
    for i from 0 to ((length listRa) -1) do (
        detListA = detListA | {det(genMat(listRa_i, length tab1_i,length tab1_i))}
    );
    print("---detRa---");
    print(detListA);


    prodDetA = product detListA;

    lisrRb = {};
    listRb = buildList(tab2, lisrRa, (last listRa));
    print("---listRb---");
    print(listRb);


    detListB = {};
    for i from 0 to ((length listRb) -1) do (
        detListB = detListB | {det(genMat(listRb_i, length tab2_i,length tab2_i))}
    );
    print("---detRb---");
    print(detListB);

    prodDetB = product detListB;

    listRc = {};
    listRc = buildList(tab3, listRc, (last listRb));
    print("---listRc---");
    print(listRc);

    detListC = {};
    for i from 0 to ((length listRc) -1) do (
        detListC = detListC | {det(genMat(listRc_i, length tab3_i,length tab3_i))}
    );

    prodDetC = product detListC;
    detListABC = detListA | detListB | detListC;

    T1 = product detListABC;

    limitTab := (d,tab) -> (
        for item in tab do (
            if (isMember(d,item)) then (
                return length item
            )
        )

    );

    F1 = T1;
    for d from 1 to dg do (
        F1 = sum(limitTab(d,tab3),k-> sum(limitTab(d,tab2), j-> sum(limitTab(d,tab1),i->x_(i+1,j+1,k+1)*diff(a_(i+1,d)*b_(j+1,d)*c_(k+1,d),F1))));
    );
    print("---F1---");
    print(F1);
    return F1

)

-- Test run
time highestWeight(tab1, tab1, tab3)
highestWeight({{1,2,3}, {4}}, {{1,2,4}, {3}}, {{1,3,4}, {2}})








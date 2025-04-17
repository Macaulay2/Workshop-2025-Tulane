-- Test 0 : test getRigidityMatrix for /\ and triangle graph
TEST ///
    L = {{0,1},{1,2}}
    getRigidityMatrix(2,3,L, Variable => x)
    assert(not isLocallyRigid(2,3,L))
    
    L2 = {{0,1},{1,2},{2,0}}
    getRigidityMatrix(2,3,L2, Variable => x)
    assert(isLocallyRigid(2,3,L2))
    assert(isLocallyRigid(2,3,L2,Field => QQ))
    assert(isLocallyRigid(2,3,L2,Field => RR))
    assert(isLocallyRigid(2,3,L2,Field => RR_100))
--    assert(isLocallyRigid(4,3,L2,Field => RR_100, Iterations => 5))
///

TEST ///
    G = graph({{1,2},{1,3},{1,4}, {2,3},{3,4},{4,2}, {0,2},{0,3},{0,4}, {1,5},{1,6},{1,7}, {5,6},{6,7},{7,5}, {0,5},{0,6},{0,7}})
    edges(G)
    isLocallyRigid(2,G)
///
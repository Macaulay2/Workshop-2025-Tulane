-- Test 0 : test getRigidityMatrix for /\
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
    assert(isLocallyRigid(2,3,L2,Field => RR_100, Iterations => 5))
///
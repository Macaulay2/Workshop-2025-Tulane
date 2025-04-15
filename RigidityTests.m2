-- Test 0 : test getRigidityMatrix for /\
TEST //
    L = {{0,1},{1,2}}
    assert(not isLocallyRigid(2,3,L))
    getRigidityMatrix(2,3,L, Variable => x)
    isLocallyRigid(2,3,L, Numerical => true)
//

-- Example Test
-- Test n: Name of Test
-*
TEST ///
    definitions, etc
    assert(result = expected result)
///
*-
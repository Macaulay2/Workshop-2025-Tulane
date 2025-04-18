"""
Test for isGloballyRigid method 
"""
-- test for the method (ZZ, ZZ, List)
TEST ///
    L1 = {{0,1}, {1,2}}
    assert(not isGloballyRigid(2, L1))
    
    L2 = {{0,1}, {1,2}, {2,0}} -- triangle
    assert(isGloballyRigid(2, L2))
    assert(isGloballyRigid(2, L2, FiniteField => 0))	
    assert(isGloballyRigid(2, L2, FiniteField => 1))
    assert(isGloballyRigid(2, L2, FiniteField => 53))
    assert(isGloballyRigid(2, L2, FiniteField => 0, Iterations => 5))

	L3 = {{0,1}, {1,2}, {2,3}, {3,0}}  -- square
	assert(not isGloballyRigid(2, L3, FiniteField => 53))

	L31 = {{0,1}, {1,2}, {2,3}, {3,0}, {0,2}}  -- square with one diagonal
	assert(not isGloballyRigid(2, L3, FiniteField => 53))
	
	L4 = {{0,1}, {0,2}} -- n <= d+1 non-complete graph
	assert(not isGloballyRigid(3, L4, FiniteField => 2143))

	-- L5 = {{0,1}, {0,1}} -- n <= d+1 non-complete graph with duplicate edges 
	-- assert(not isGloballyRigid(3, L5, FiniteField => 2143))

	L6 = {{0,1}, {1,2}, {2,3}, {3,0}, {0,2}, {1,3}} -- n <= d+1 complete graph
	assert(isGloballyRigid(3, L6, FiniteField => 2143))

	-- L7 = {{0,1}, {1,2}, {2,3}, {3,0}, {0,2}, {1,3}, {0,1}, {1,2}} -- n <= d+1 complete graph with duplicate edges 
	-- assert(not isGloballyRigid(3, L7, FiniteField => 2143))
///

-- test for the method (ZZ, ZZ, Graph)
TEST ///
	G1 = completeGraph(4)
	assert(isGloballyRigid(2, G1))
	assert(isGloballyRigid(3, G1))

	G2 = completeGraph(10)
	assert(isGloballyRigid(30, G2))
	
    G3 = graph({{1,2},{1,3},{1,4}, {2,3},{3,4},{4,2}, {0,2},{0,3},{0,4}, {1,5},{1,6},{1,7}, {5,6},{6,7},{7,5}, {0,5},{0,6},{0,7}})
    assert(isGloballyRigid(2, G3))
    assert(not isGloballyRigid(3, G3))
///


-- test for the method (ZZ, ZZ)
TEST ///
	assert(isGloballyRigid(2, 4))
	assert(isGloballyRigid(3, 4))
///

-- test for the method (ZZ, Graph)
TEST ///
    G = graph({{1,2},{1,3},{1,4}, {2,3},{3,4},{4,2}, {0,2},{0,3},{0,4}, {1,5},{1,6},{1,7}, {5,6},{6,7},{7,5}, {0,5},{0,6},{0,7}})
    assert(isGloballyRigid(2, G))
    assert(not isGloballyRigid(3, G))	
///



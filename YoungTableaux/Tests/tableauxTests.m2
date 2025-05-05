TEST ///
    assert(isWellDefined youngTableau {{1,3,7},{2,4,6},{9,8,5}} == true)
    assert(isWellDefined youngTableau {{1,1,1},{2,2},{3}} == false)
    assert(isWellDefined youngTableau {{1,2,3},{4,5},{6,7},{8,1}} == false)
    assert(isWellDefined youngTableau {{1,2,3},{4,5},{6,7},{8}} == true)
    assert(isWellDefined youngTableau {{1,1,1}} == false)
    assert(isWellDefined youngTableau {{1},{2,3},{4}} == false)
    assert(isWellDefined youngTableau {{9}} == false)
    assert(isWellDefined youngTableau {{1,2,3,7},{4,5,6}} == true)
    assert(isWellDefined youngTableau {{1,2,3},{4,6},{5}} == true)
    assert(isWellDefined youngTableau {{1,2,3},{2,3},{6}} == false)
    assert(isWellDefined youngTableau {{1,1,1,2,3,9},{3,3,3,3,4},{5,7,8},{6},{7}} == false)
///

TEST ///
    assert(isStandard youngTableau {{1,3,7},{2,4,6},{9,8,5}} == false)
    assert(isStandard youngTableau {{1,1,1},{2,2},{3}} == false)
    assert(isStandard youngTableau {{1,2,3},{4,5},{6,7},{8,1}} == false)
    assert(isStandard youngTableau {{1,2,3},{4,5},{6,7},{8}} == true)
    assert(isStandard youngTableau {{1,1,1}} == false)
    assert(isStandard youngTableau {{1},{2,3},{4}} == false)
    assert(isStandard youngTableau {{9}} == false)
    assert(isStandard youngTableau {{1,2,3,7},{4,5,6}} == true)
    assert(isStandard youngTableau {{1,2,3},{4,6},{5}} == true)
    assert(isStandard youngTableau {{1,2,3},{2,3},{6}} == false)
    assert(isStandard youngTableau {{1,1,1,2,3,9},{3,3,3,3,4},{5,7,8},{6},{7}} == false)
///

TEST ///
    assert(isSemiStandard youngTableau {{1,3,7},{2,4,6},{9,8,5}} == false)
    assert(isSemiStandard youngTableau {{1,1,1},{2,2},{3}} == true)
    assert(isSemiStandard youngTableau {{1,2,3},{4,5},{6,7},{8,1}} == false)
    assert(isSemiStandard youngTableau {{1,2,3},{4,5},{6,7},{8}} == true)
    assert(isSemiStandard youngTableau {{1,1,1}} == true)
    assert(isSemiStandard youngTableau {{1},{2,3},{4}} == false)
    assert(isSemiStandard youngTableau {{9}} == false)
    assert(isSemiStandard youngTableau {{1,2,3,7},{4,5,6}} == true)
    assert(isSemiStandard youngTableau {{1,2,3},{4,6},{5}} == true)
    assert(isSemiStandard youngTableau {{1,2,3},{2,3},{6}} == false)
    assert(isSemiStandard youngTableau {{1,1,1,2,3,9},{3,3,3,3,4},{5,7,8},{6},{7}} == true)
///
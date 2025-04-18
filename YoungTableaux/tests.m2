TEST ///
    assert(isWellDefined youngDiagram {2,3,1} == false)
    assert(isWellDefined youngDiagram {5,3,2,1,1,1} == true)
    assert(isWellDefined youngDiagram {1} == true)
    assert(isWellDefined youngDiagram {20} == true)
    assert(isWellDefined youngDiagram {1,1,2} == false)
    assert(isWellDefined youngDiagram {6,3,3,2} == true)
///

TEST ///
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
    assert(conjugate youngDiagram {5,4,1} == youngDiagram {3,2,2,2,1})
    assert(transpose youngDiagram {5,4,1} == youngDiagram {3,2,2,2,1})
///

TEST ///
    assert(hookLength(youngDiagram {4,3,1}, 1, 2) == 4)
///

TEST ///
    assert(numberStandardYoungTableaux {4,2,1} == 35)
///
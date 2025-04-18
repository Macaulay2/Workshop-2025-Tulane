TEST ///
    assert(isWellDefined youngDiagram {2,3,1} == false)
    assert(isWellDefined youngDiagram {5,3,2,1,1,1} == true)
    assert(isWellDefined youngDiagram {1} == true)
    assert(isWellDefined youngDiagram {20} == true)
    assert(isWellDefined youngDiagram {1,1,2} == false)
    assert(isWellDefined youngDiagram {6,3,3,2} == true)
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
TEST ///
    assert(isWellDefined youngDiagram {2,3,1} == false)
    assert(isWellDefined youngDiagram {5,3,2,1,1,1} == true)
    assert(isWellDefined youngDiagram {1} == true)
    assert(isWellDefined youngDiagram {20} == true)
    assert(isWellDefined youngDiagram {1,1,2} == false)
    assert(isWellDefined youngDiagram {6,3,3,2} == true)
///

TEST ///
    assert(isCorner (youngDiagram {2,3,1}, (1,2)) == false)
    assert(isCorner (youngDiagram {2,3,1}, (1,1)) == false)
    assert(isCorner (youngDiagram {5,3,2,1,1,1}, (6,1)) == true)
    assert(isCorner (youngDiagram {5,3,2,1,1,1}, (1,6)) == false)
    assert(isCorner (youngDiagram {1}, (1,2)) == false)
    assert(isCorner (youngDiagram {1}, (1,1)) == true)
    assert(isCorner (youngDiagram {20}, (3,9)) == false)
    assert(isCorner (youngDiagram {20}, (1,1)) == false)
    assert(isCorner (youngDiagram {1,1,2}, (2,1)) == false)
    assert(isCorner (youngDiagram {1,1,2}, (3,2)) == true)
    assert(isCorner (youngDiagram {6,3,3,2}, (3,3)) == true)
    assert(isCorner (youngDiagram {6,3,3,2}, (4,1)) == false)
///

TEST ///
    assert(conjugate youngDiagram {5,4,1} == youngDiagram {3,2,2,2,1})
    assert(transpose youngDiagram {5,4,1} == youngDiagram {3,2,2,2,1})
///

TEST ///
    assert(hookLength(youngDiagram {4,3,1}, 1, 2) == 4)
///
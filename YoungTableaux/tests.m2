TEST ///
    assert(conjugate youngDiagram {5,4,1} == youngDiagram {3,2,2,2,1})
    assert(transpose youngDiagram {5,4,1} == youngDiagram {3,2,2,2,1})
///

TEST ///
    assert(hookLength(youngDiagram {4,3,1}, 1, 2) == 4)
///

TEST ///
    assert(numberStandardYoungTableaux youngDiagram {4,2,1} == 35)
///
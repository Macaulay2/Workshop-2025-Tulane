-- Using a package
needsPackage "ReesAlgebra"
help ReesAlgebra
examples ReesAlgebra
check ReesAlgebra
check_10 ReesAlgebra

-- Writing packages
help "packages"
help "creating a package"
help "an example of a package"

-- template
packageTemplate "MyAwesomePackage"
"MyAwesomePackage.m2" << packageTemplate "MyAwesomePackage" << close 

needsPackage "MyAwesomePackage"
-- change `doc` to be able to load
restart
needsPackage "MyAwesomePackage"

-- loadPackage (instead of `needsPackage`) should be used with caution

-* EXERCISE:
create your own package RandomBinomialIdeals
*-

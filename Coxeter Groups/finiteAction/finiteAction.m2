



if any(relations W, r -> product apply(r, s -> f#s) =!= id_(R^n)) then (
	error "map: The given list does not define a group homomorphism from the given 
	Coxeter group."
	);
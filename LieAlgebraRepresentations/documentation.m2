

doc ///
    Key
       LieAlgebraRepresentations
    Headline
       Lie algebra representations and characters
    Description
        Text 
            This package implements finite-dimensional representations of finite-dimensional complex semisimple Lie algebras and their characters. 
///

doc ///
    Key
       LieAlgebra
    Headline
        class for Lie algebras
    Description
        Text
    	    This class represents Lie algebras.  Currently only finite-dimensional semi-simple Lie algebras over the complex numbers are supported.
	    An object of type @TT "LieAlgebra"@ is a hash table whose keys record the rank of the Lie algebra and the type of the root system.
        Example
	    g=simpleLieAlgebra("A",1)
	    h=simpleLieAlgebra("E",6)
	    g++h
	Text
	    If you have access to unicode fraktur, you can use the shorthand
	Example
	    𝔣_4
	Text
	    See also @TO (NewFromMethod,LieAlgebra,Matrix)@.
///

doc ///
    Key
        simpleLieAlgebra
	(simpleLieAlgebra,String,ZZ)
    Headline
        construct a simple Lie algebra
    Usage
        simpleLieAlgebra("A",1)
    Inputs
        t:String
            the type of the root system of the desired Lie algebra
        k:ZZ
            the rank of the desired Lie algebra
    Outputs
        g:LieAlgebra
            the simple Lie algebra with the given rank and type	        
    Description
        Text
            The classification of simple Lie algebras over the complex numbers is well known.
	    There are four infinite families (types $\mathfrak{a}_n$, $\mathfrak{b}_n$, $\mathfrak{c}_n$, $\mathfrak{d}_n$) corresponding to the Lie algebras
	    $\mathfrak{sl}(n+1,\mathbb{C})$, $\mathfrak{so}(2n+1,\mathbb{C})$, $\mathfrak{sp}(2n,\mathbb{C})$, $\mathfrak{so}(2n,\mathbb{C})$ respectively,
	    and five exceptional simple Lie algebras, $\mathfrak{e}_6$, $\mathfrak{e}_7$, $\mathfrak{e}_8$, $\mathfrak{f}_4$, $\mathfrak{g}_2$.

        Example
            --simpleLieAlgebra(sl_2)
	    simpleLieAlgebra("A",1)
	    --simpleLieAlgebra(sp_10)
	    simpleLieAlgebra("E",6)
///	 	 

TEST ///
    assert(A=simpleLieAlgebra("A",1); A#"LieAlgebraRank"===1 and A#"RootSystemType"==="A" and isSimple A)
///

doc ///
    Key
	(symbol ==, LieAlgebra, LieAlgebra)
    Headline
        tests equality of LieAlgebra
    Usage
        g == h
    Inputs
        g:LieAlgebra
	h:LieAlgebra
    Outputs
        b:Boolean
    Description
        Text
	    This function tests equality of the underlying hash tables of $g$ and $h$ are the same.    
	       
        Example
	    g=simpleLieAlgebra("A",2)
	    h=simpleLieAlgebra("A",2)
	    g==h
///

TEST ///
    assert(simpleLieAlgebra("A",2) == simpleLieAlgebra("A",2))
///


doc ///
    Key
        dualCoxeterNumber
	(dualCoxeterNumber,LieAlgebra)
	(dualCoxeterNumber,String,ZZ)
    Headline
        returns the dual Coxeter number of a simple Lie algebra
    Usage
        dualCoxeterNumber(g)
    Inputs
        g:LieAlgebra
	    a simple Lie algebra
    Outputs
        n:ZZ
	    the dual Coxeter number of g
    Description
        Text
	    The dual Coxeter number is defined as the sum of the comarks plus 1.  See Di Francesco, Mathieu, and Senechal, {\it Conformal Field Theory}, Springer Graduate Texts in Theoretical Physics, Formula (13.35) and Appendix A.
	      
        Example
	    dualCoxeterNumber("A",2)	
	    g=simpleLieAlgebra("A",2)
	    dualCoxeterNumber(g)
///

TEST ///
    assert(dualCoxeterNumber("A",2) === 3)
///

doc ///
    Key
        highestRoot
	(highestRoot,LieAlgebra)
    Headline
        returns the highest root of a simple Lie algebra
    Usage
        highestRoot(g), highestRoot("A",2)
    Inputs
        g:LieAlgebra
    Outputs
        t:List
    Description
        Text  
            Let R be an irreducible root system of rank m, and choose a base of simple roots $\Delta = \{\alpha_1,...,\alpha_m\}$.  Then there is a unique root $\theta$ such that when $\theta$ is expanded in terms of the simple roots, i.e. $\theta= \sum c_i \alpha_i$, the sum $\sum c_i$ is maximized.  The formulas implemented here are taken from the tables following Bourbaki's {\it Lie Groups and Lie Algebras} Chapter 6.
	    
	Text       
	    In the example below, we see that for $sl_3$, the highest root $\theta$ is $\omega_1+ \omega_2$, where $\omega_1$ and $\omega_2$ are the fundamental dominant weights.
	    
	Example
	    highestRoot("A",2)
///

TEST ///
    assert(highestRoot("A",2) === {1,1})
///	

doc ///
    Key
        positiveRoots
	(positiveRoots,LieAlgebra)
        positiveCoroots
	(positiveCoroots,LieAlgebra)
    Headline
        returns the positive (co)roots of a simple Lie algebra
    Usage
        positiveRoots(g), positiveCoroots(g)
    Inputs
        g:LieAlgebra
    Outputs
        t:List
    Description
        Text  
            Let R be an irreducible root system of rank m, and choose a base of simple roots $\Delta = \{\alpha_1,...,\alpha_m\}$.
	    This function returns all the roots that are nonnegative linear combinations of the simple roots (expressed in the basis of fundamental weights).
	    The formulas implemented here are taken from the tables following Bourbaki's {\it Lie Groups and Lie Algebras} Chapter 6.
	    
	Text       
	    In the example below, we see that for $sl_3$, the positive roots are $\alpha_1$, $\alpha_2$, and $\alpha_1+\alpha_2$.
	    
	Example
	    sl3=simpleLieAlgebra("A",2)
	    positiveRoots(sl3)
///

TEST ///
    assert(set positiveRoots(simpleLieAlgebra("A",2)) === set {{2, -1}, {1, 1}, {-1, 2}})
///	

doc ///
    Key
        simpleRoots
	(simpleRoots,String,ZZ)
	(simpleRoots,LieAlgebra)
    Headline
        returns the simple roots of a simple Lie algebra
    Usage
        simpleRoots(g), simpleRoots("A",2)
    Inputs
        g:LieAlgebra
    Outputs
        t:List
///

doc ///
    Key
        starInvolution
	(starInvolution,LieAlgebraModule)
	(dual,LieAlgebraModule)
    Headline
        computes w* for a weight w
    Usage
        starInvolution(w,g)
    Inputs
        w:List
	g:LieAlgebra
    Description
        Text
	    Let $\mathbf{g}$ be a Lie algebra.  We give three equivalent descriptions of an involution * on the weights of $\mathbf{g}$: 
	    
	Text 
	    1. The involution * is given by $-w_0$, where $w_0$ is the longest word in the Weyl group $W(\mathbf{g})$.
		  
	Text
	    2. If $\mu$ is a dominant integral weight, and $V_{\mu}$ is the irreducible Lie algebra module with highest weight $\mu$, then $\mu^*$ is the highest weight of the dual module $(V_{\mu})^*$.
		  
	Text 
	    3. If the Dynkin diagram of $\mathbf{g}$ has an involution, then * corresponds to the action of this involution on weights.
		  
        Text
            The formulas implemented have been adapted from Di Francesco, Mathieu, and Senechal, {\it Conformal Field Theory}, Springer Graduate Texts in Theoretical Physics, p. 511.  Some changes are needed because we use the Bourbaki ordering of the roots in type E instead of the [DMS] ordering.
	       
	Text     
	    In the example below, we see that for $sl_3$, $\omega_1^* = \omega_2.$
        
	Example
	     g=simpleLieAlgebra("A",2)
	     starInvolution(LL_(1,0)(g))
///

TEST ///
    g=simpleLieAlgebra("A",2)
    assert(starInvolution({1,0},g) === {0,1})
///



doc ///
    Key
        killingForm
	(killingForm,LieAlgebra,List,List)
	(killingForm,LieAlgebra,Vector,Vector)
    Headline 
        computes the scaled Killing form applied to two weights
    Usage 
        killingForm(g,v,w)
    Inputs 
        g:LieAlgebra
	v:List
	w:List
    Description
        Text
	    Let $\mathbf{g}$ be a Lie algebra.  The Killing form on $\mathbf{g}$ is the symmetric bilinear form given by $(x,y) = Tr(\mathrm{ad}_x \mathrm{ad}_y)$.  It can restricted to a Cartan subalgebra $\mathbf{h}$ and transferred to $\mathbf{h}^*$, yielding a symmetric bilinear form on weights.  One popular convention is to scale the Killing form so that $(\theta,\theta) =2$, where $\theta$ is the highest root.
	    
        Example
            g=simpleLieAlgebra("A",2)
	    killingForm(g,{1,0},{0,1})
///

TEST ///
    g=simpleLieAlgebra("A",2)
    assert(killingForm(g,{1,0},{0,1}) === 1/3)
    assert(lift(matrix table(simpleRoots g,simpleRoots g,(v,w)->killingForm(g,v,w)),ZZ) == cartanMatrix g) -- true for all simply laced
///
	
doc ///
    Key
        weylAlcove
	(weylAlcove,String,ZZ,ZZ)
	(weylAlcove,LieAlgebra,ZZ)
	(weylAlcove,ZZ,LieAlgebra)
    Headline 
        the dominant integral weights of level less than or equal to l
    Usage 
        weylAlcove(g,l)
    Inputs 
        g:LieAlgebra
        l:ZZ
    Description
        Text
            Let $\mathbf{g}$ be a Lie algebra, and let $l$ be a nonnegative integer.
	    Choose a Cartan subalgebra $\mathbf{h}$ and a base $\Delta= \{ \alpha_1,\ldots,\alpha_n\}$ of simple roots of $\mathbf{g}$.
	    These choices determine a highest root $\theta$. (See @TO highestRoot@).
	    Let $\mathbf{h}_{\mathbf{R}}^*$ be the real span of $\Delta$, and let $(,)$ denote the Killing form, normalized so that $(\theta,\theta)=2$.
	    The fundamental Weyl chamber is $C^{+} = \{ \lambda \in \mathbf{h}_{\mathbf{R}}^*  : (\lambda,\alpha_i) \ge 0, i=1,\ldots,n \}$.
	    The fundamental Weyl alcove is the subset of the fundamental Weyl chamber such that $(\lambda,\theta) \leq l$.
	    This function computes the set of integral weights in the fundamental Weyl alcove.
	    
        Text
            In the example below, we see that the Weyl alcove of $sl_3$ at level 3 contains 10 integral weights.
	    
	Example 
	    g=simpleLieAlgebra("A",2)
	    weylAlcove(g,3)
///

TEST ///
    g=simpleLieAlgebra("A",2)
    assert(set(weylAlcove(g,3)) === set {{0, 0}, {1, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}, {0, 2}, {1, 2}, {3, 0}, {0, 3}}) 
///	
	

doc ///
    Key
        LieAlgebraModule
    Headline
        class for Lie algebra modules
    Description
        Text 
    	    This class represents Lie algebra modules.  Currently only modules over semi-simple Lie algebras over the complex numbers are supported.
	    An object of type LieAlgebraModule is a hash table recording the Lie algebra and the decomposition of the module into irreducible Lie algebra modules, which are indexed by their highest weights.
	    
	Example
	    g=simpleLieAlgebra("A",2)
	    M=irreducibleLieAlgebraModule(g,{1,1})
///

doc ///
    Key
        irreducibleLieAlgebraModule
	(irreducibleLieAlgebraModule,LieAlgebra,List)
	(irreducibleLieAlgebraModule,LieAlgebra,Vector)
	LL
	ω
    Headline
        construct the irreducible Lie algebra module with given highest weight
    Usage
        irreducibleLieAlgebraModule(w,g)
        irreducibleLieAlgebraModule(g,w)
    Inputs
        w:List
	    the highest weight of the desired module
	g:LieAlgebra     
    Outputs
        M:LieAlgebraModule
    Description
        Text
            This function creates the irreducible Lie algebra module with a given highest weight.
	Example
	    g=simpleLieAlgebra("A",2)
            irreducibleLieAlgebraModule(g,{1,1})
        Text
	    One can also use the shorthand LL:
	Example
            LL_(1,1) (g)
	Text
	    as well as the shorthand ω:
	    LL_(ω_2) (g)
///

TEST ///
    assert(irreducibleLieAlgebraModule({1,1},simpleLieAlgebra("A",2)) === new LieAlgebraModule from (simpleLieAlgebra("A",2),{{1,1}=>1} ))
///	
		
doc ///
    Key 
	(multiplicity,List,LieAlgebraModule)
	(multiplicity,Vector,LieAlgebraModule)
    Headline
        compute the multiplicity of a weight in a Lie algebra module
    Usage
        multiplicity(v,M)
    Inputs
        v:List
	M:LieAlgebraModule
    Outputs
        k:ZZ
    Description
	Text     
	    The example below shows that the $sl_3$ module with highest weight $(2,1)$ contains the weight $(-1,1)$ with multiplicity 2.
         
	Example
	    g=simpleLieAlgebra("A",2)
	    V=irreducibleLieAlgebraModule({2,1},g)
	    multiplicity({-1,1},V)
    SeeAlso
        weightDiagram
	     
///

TEST ///
    assert(multiplicity({-1,1},irreducibleLieAlgebraModule({2,1},simpleLieAlgebra("A",2))) === 2)
///

doc ///
    Key
	(dim,LieAlgebraModule)
    Headline
        computes the dimension of a Lie algebra module as a vector space over the ground field
    Usage
        dim(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        k:ZZ
    Description
        Example
	    g=simpleLieAlgebra("A",2)
	    V=irreducibleLieAlgebraModule({1,0},g)
	    dim(V)
///
TEST ///
    g=simpleLieAlgebra("A",2)
    V=irreducibleLieAlgebraModule({1,0},g)
    assert(dim(V) === 3)
    W=irreducibleLieAlgebraModule({5,2},g)
    assert(dim W == sum values weightDiagram W)
///

doc ///
    Key
        weightDiagram
	(weightDiagram,LieAlgebraModule)
	(weightDiagram,LieAlgebra,List)
	(weightDiagram,LieAlgebra,Vector)
	[weightDiagram,Strategy]
    Headline
        computes the weights in a Lie algebra module and their multiplicities
    Usage
        weightDiagram(V)
    Inputs
        V:LieAlgebraModule
    Outputs
        T:VirtualTally
    Description
        Text
	    Let $V$ be the irreducible $\mathbf{g}$-module with highest weight $v$.  This function returns a tally whose keys are the weights appearing in $V$ and whose values are the multiplicities of these weights.
	    An optional argument {\tt "Strategy"} allows to specify which algorithm to use, see @TO character@.
	     
        Example
	     g=simpleLieAlgebra("A",2)
	     V=irreducibleLieAlgebraModule({2,1},g)
	     weightDiagram(V)
	     
    SeeAlso
        (multiplicity,List,LieAlgebraModule)
	character
///

TEST ///
    assert(weightDiagram(irreducibleLieAlgebraModule({2,1},simpleLieAlgebra("A",2))) === new VirtualTally from {{{-1, 1}, 2}, {{1, 0}, 2}, {{3, -1}, 1}, {{-2, 0}, 1}, {{0, -1}, 2}, {{2, -2}, 1}, {{-2, 3}, 1}, {{0, 2}, 1}, {{2, 1}, 1}, {{-1, -2}, 1}, {{1, -3}, 1}, {{-3, 2}, 1}})
///	

	

doc ///
    Key
	(symbol **, LieAlgebraModule, LieAlgebraModule)
    Headline
        tensor product of LieAlgebraModules
    Usage
        U ** V
    Inputs
        U:LieAlgebraModule
	V:LieAlgebraModule
    Outputs
        W:LieAlgebraModule
    Description
        Text
	    Computes the tensor product of two Lie algebra modules.  
	       
        Example
	    g=simpleLieAlgebra("A",2)
	    U=irreducibleLieAlgebraModule({4,2},g)
	    V=irreducibleLieAlgebraModule({3,1},g)
	    U**V
	    
    SeeAlso
        tensorCoefficient
///

TEST ///
    assert(irreducibleLieAlgebraModule({2,1},simpleLieAlgebra("A",2)) ** irreducibleLieAlgebraModule({1,2},simpleLieAlgebra("A",2)) === new LieAlgebraModule from (simpleLieAlgebra("A",2), {{{1, 1}, 2}, {{3, 0}, 1}, {{1, 4}, 1}, {{3, 3}, 1}, {{0, 0}, 1}, {{0, 3}, 1}, {{2, 2}, 2}, {{4, 1}, 1}} ))
///

doc ///
    Key
	(symbol ++, LieAlgebraModule, LieAlgebraModule)
	(directSum, LieAlgebraModule)
    Headline
        direct sum of LieAlgebraModules
    Usage
        U ++ V
    Inputs
        U:LieAlgebraModule
	V:LieAlgebraModule
    Outputs
        W:LieAlgebraModule
    Description
        Text
	    Computes the direct sum of two Lie algebra modules.  
	    
        Example
	    g=simpleLieAlgebra("A",2)
	    U=irreducibleLieAlgebraModule({4,2},g)
	    V=irreducibleLieAlgebraModule({3,1},g)
	    U++V
///

TEST ///
    assert(irreducibleLieAlgebraModule({2,1},simpleLieAlgebra("A",2)) ** irreducibleLieAlgebraModule({1,2},simpleLieAlgebra("A",2)) === new LieAlgebraModule from (simpleLieAlgebra("A",2), {{{1, 1}, 2}, {{3, 0}, 1}, {{1, 4}, 1}, {{3, 3}, 1}, {{0, 0}, 1}, {{0, 3}, 1}, {{2, 2}, 2}, {{4, 1}, 1}} ))
///

doc ///
    Key
        tensorCoefficient
	(tensorCoefficient,LieAlgebraModule,LieAlgebraModule,LieAlgebraModule)     
    Headline
        computes the multiplicity of W in U tensor V
    Usage
        tensorCoefficient(U,V,W)
    Inputs
        U:LieAlgebraModule
	V:LieAlgebraModule
	W:LieAlgebraModule
    Outputs
        k:ZZ
    Description
        Text
	    This function implements the Racah-Speiser algorithm; see Di Francesco, Mathieu, and Senechal, {\it Conformal Field Theory}, Springer Graduate Texts in Theoretical Physics, Section 13.5.2. 
	       
	Text     
	    Given three irreducible Lie algebra modules $U$, $V$, and $W$, the function returns the multiplicity of $W$ in $U \otimes V$.  In Type A, these are related to the Littlewood-Richardson coefficients (though in this package, irreducible representations are indexed by the Dynkin labels of their highest weights, rather than by partitions).  
	   
        Text
	    The example below shows that for $g=sl_3$ and $\lambda=2 \omega_1 + \omega_2$, $\mu= \omega_1 + 2 \omega_2$, and $\nu= 2 \omega_1 + 2 \omega_2$, the tensor product of $sl_3$ modules $V_{\lambda} \otimes V_{\mu}$ contains two copies of $V_{\nu}$.
	       
        Example
	    g=simpleLieAlgebra("A",2)
	    U=irreducibleLieAlgebraModule({2,1},g)
	    V=irreducibleLieAlgebraModule({1,2},g)
	    W=irreducibleLieAlgebraModule({2,2},g)
	    tensorCoefficient(U,V,W)
    SeeAlso
        (symbol **, LieAlgebraModule, LieAlgebraModule)
///


TEST ///
    g=simpleLieAlgebra("A",2);
    U=irreducibleLieAlgebraModule({2,1},g);
    V=irreducibleLieAlgebraModule({1,2},g);
    W=irreducibleLieAlgebraModule({2,2},g);
    assert(tensorCoefficient(U,V,W) === 2)         
///
		


doc ///
    Key
        fusionCoefficient
	(fusionCoefficient,LieAlgebraModule,LieAlgebraModule,LieAlgebraModule,ZZ)     
    Headline
        computes the multiplicity of W in the fusion product of U and V
    Usage
        fusionCoefficient(U,V,W,l)
    Inputs
        U:LieAlgebraModule
	V:LieAlgebraModule
	W:LieAlgebraModule
        l:ZZ	
    Description
        Text
	    This function implements the Kac-Walton algorithm; see Di Francesco, Mathieu, and Senechal, {\it Conformal Field Theory}, Springer Graduate Texts in Theoretical Physics, Section 16.2.2.  
	    
	Text    
	    Given three irreducible Lie algebra modules $U$, $V$, and $W$, the function returns the multiplicity of $W$ in the fusion product of $U$ and $V$ at level $l$.  (We are abusing notation and terminology a little here; the fusion product is really a product for modules over an affine Lie algebra.  However, since the Kac-Walton algorithm is defined entirely using the combinatorics of the root system of the underlying finite-dimensional Lie algebra, we may therefore use the Kac-Walton algorithm to define a product on Lie algebra modules as well.)
       
       
	Text
	    The example below shows that for $g=sl_3$ and $\lambda=2 \omega_1 + \omega_2$, $\mu= \omega_1 + 2 \omega_2$, and $\nu= \omega_1 +  \omega_2$, the level 3 fusion product  $V_{\lambda} \otimes_3  V_{\mu}$ contains one copy of $V_{\nu}$.
	    
        Example
	    g=simpleLieAlgebra("A",2);
	    U=irreducibleLieAlgebraModule({2,1},g);
	    V=irreducibleLieAlgebraModule({1,2},g);
	    W=irreducibleLieAlgebraModule({1,1},g);
	    fusionCoefficient(U,V,W,3)
///

doc ///
    Key
       LieAlgebraModuleFromWeights
       (LieAlgebraModuleFromWeights,VirtualTally,LieAlgebra)
       (LieAlgebraModuleFromWeights,RingElement,LieAlgebra)
    Headline
       finds a Lie algebra module based on its weights
    Usage
        LieAlgebraModuleFromWeights(T,g)
    Inputs
        T:Tally
	g:LieAlgebra
    Description
        Example
	    g=simpleLieAlgebra("A",2);
	    U=irreducibleLieAlgebraModule({1,1},g);
	    M=U**U
	    T=weightDiagram M
            LieAlgebraModuleFromWeights(T,g)
///
doc ///
    Key
        fusionProduct
	(fusionProduct,LieAlgebraModule,LieAlgebraModule,ZZ)     
    Headline
        computes the multiplicities of irreducibles in the decomposition of the fusion product of U and V
    Usage
        fusionProduct(U,V,l)
    Inputs
        U:LieAlgebraModule
	V:LieAlgebraModule
        l:ZZ
    Description
        Text
	    This function implements the Kac-Walton algorithm; see Di Francesco, Mathieu, and Senechal, {\it Conformal Field Theory}, Springer Graduate Texts in Theoretical Physics, Section 16.2.2.  
	    
 	Text   
	    Given two irreducible Lie algebra modules $U$ and $V$, the function returns the fusion product of $U$ and $V$ at level $l$.  (We are abusing notation and terminology a little here; the fusion product is really a product for modules over an affine Lie algebra.  However, since the Kac-Walton algorithm is defined entirely using the combinatorics of the root system of the underlying finite-dimensional Lie algebra, we may therefore use the Kac-Walton algorithm to define a product on Lie algebra modules as well.)  
	    
	    
        Text
	    The example below shows that for $g=sl_3$ and $\lambda=2 \omega_1 + \omega_2 = (2,1)$, $\mu= \omega_1 + 2 \omega_2 = (1,2)$, the level 3 fusion product  $V_{(2,1)} \otimes_3  V_{(1,2)}$ contains one copy of $V_{(0,0)}$ and one copy of $V_{(1,1)}$.
	    
        Example
	    g=simpleLieAlgebra("A",2);
	    U=irreducibleLieAlgebraModule({2,1},g);
	    V=irreducibleLieAlgebraModule({1,2},g);
	    fusionProduct(U,V,3)
///


TEST ///
    g=simpleLieAlgebra("A",2);
    U=irreducibleLieAlgebraModule({2,1},g);
    V=irreducibleLieAlgebraModule({1,2},g);
    W=irreducibleLieAlgebraModule({1,1},g);
    assert(fusionCoefficient(U,V,W,3) === 1)         
///



doc ///
    Key
        casimirScalar
	(casimirScalar,LieAlgebraModule)
    Headline
        computes the scalar by which the Casimir operator acts on an irreducible Lie algebra module
    Usage
        casimirScalar(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        k:QQ
    Description
        Text
	    The Casimir operator is an element of the universal enveloping algebra that acts by a scalar on each irreducible Lie algebra module.  One has $c(\mu) = (\mu,\mu) + 2(\mu,\rho)$, where $\rho$ is half the sum of the positive weights and (,) is the Killing form scaled so that $(\theta,\theta)=2$, where $\theta$ is the highest root.  See Di Francesco, Mathieu, and Senechal, {\it Conformal Field Theory}, Springer Graduate Texts in Theoretical Physics, (13.127) p. 512, and (13.46) p. 499.
	    
	Text     
            In the example below, we see that the Casimir operator acts as multiplication by 8/3 on the standard representation of $sl_3$.  
         
	Example
	    g=simpleLieAlgebra("A",2)
	    V=irreducibleLieAlgebraModule({1,0},g)
	    casimirScalar(V)
///

TEST ///
    g=simpleLieAlgebra("A",2)
    V=irreducibleLieAlgebraModule({1,0},g)
    assert(casimirScalar(V) === 8/3)
///

-*
doc ///
    Key
        isIsomorphic
	(isIsomorphic,LieAlgebraModule,LieAlgebraModule)
    Headline
        tests whether two Lie algebra modules are isomorphic
    Usage
        isIsomorphic(V,W)
    Inputs
        V:LieAlgebraModule
	W:LieAlgebraModule
    Outputs
        b:Boolean
    Description
        Text
	    To test whether two Lie algebra modules are isomorphic, we first test whether they are modules over the same Lie algebra, and if so, then test whether they have the same decomposition into irreducible Lie algebra modules.
        
	Example
	    g=simpleLieAlgebra("A",2)
	    M=irreducibleLieAlgebraModule({2,1},g)
	    N=irreducibleLieAlgebraModule({1,2},g)
	    Z=irreducibleLieAlgebraModule({0,0},g)
	    isIsomorphic(M,N)
	    isIsomorphic(M,M)
	    isIsomorphic(M,M**Z)
	    isIsomorphic(M**N,N**M)
///

TEST ///
    g=simpleLieAlgebra("A",2);
    M=irreducibleLieAlgebraModule({2,1},g);
    N=irreducibleLieAlgebraModule({1,2},g);
    Z=irreducibleLieAlgebraModule({0,0},g);
    assert(isIsomorphic(M,N) === false)
    assert(isIsomorphic(M,M) === true)
    assert(isIsomorphic(M,M**Z) === true)
    assert(isIsomorphic(M**N,N**M) ===true)
///

doc ///
    Key
        MaxWordLength
        [fusionCoefficient, MaxWordLength]
        [fusionProduct, MaxWordLength]
    Headline
        Optional argument to specify the allowable length of words in the affine Weyl group when computing fusion products.
    Description
        Text
            The Weyl group of a simple Lie algebra is finite; in contrast, the affine Weyl group of an affine Lie algebra is infinite.  To keep Macaulay2 from trying to compute infinitely long words in this group, the default length of allowed words is set to max \{10, rank($\mathbf{g}$)+1\}.   The user may override this with the optional argument "MaxWordLength".  If the word length is too small, the program will return an error.

///
*-

doc ///
    Key
        character
	(character,LieAlgebraModule)
	(character,LieAlgebra,List)
	(character,LieAlgebra,Vector)
	[character,Strategy]
    Headline
        Computes the character of a Lie algebra module
    Usage
        character V
    Inputs
        V:LieAlgebraModule
    Outputs
        C:RingElement
    Description
        Text
	    An optional argument {\tt "Strategy"} allows to specify which algorithm to use:
	    {\tt "Freudenthal"} for Freudenthal's recursive algorithm; see Humphreys, {\it Introduction to Lie Algebras and Representation Theory}, Section 22.3.
	    {\tt "Weyl"} for Weyl's character formula (in classical types).
	    {\tt "JacobiTrudi"} and {\tt "JacobiTrudi'"} for Jacobi-Trudi and dual Jacobi-Trudi formulae (in type A).
    SeeAlso
        weightDiagram
///

TEST ///
    g=simpleLieAlgebra("D",4);
    M=LL_(1,1,0,0) g;
    N=LL_(1,0,0,1) g;
    assert(character(M**N) == character M * character N)
///

doc ///
    Key
        isIrreducible
	(isIrreducible,LieAlgebraModule)
    Headline
        Whether a Lie algebra module is irreducible or not
    Description
        Example
	    g=simpleLieAlgebra("A",2)
	    M=irreducibleLieAlgebraModule({2,1},g)
	    isIrreducible M
	    isIrreducible(M++M)
	    isIrreducible(M**M)
///	

TEST ///
    g=simpleLieAlgebra("A",2);
    assert(isIrreducible irreducibleLieAlgebraModule({2,1},g))
///

doc ///
    Key
        trivialModule
	(trivialModule,LieAlgebra)
    Headline
        The trivial module of a Lie algebra
    Description
        Text
	    Returns the one-dimensional module with zero highest weight.
///

doc ///
    Key
        zeroModule
	(zeroModule,LieAlgebra)
    Headline
        The zero module of a Lie algebra
    Description
        Text
	    Returns the zero-dimensional module.
///

doc ///
    Key
        adjointModule
	(adjointModule,LieAlgebra)
    Headline
        The adjoint module of a Lie algebra
    Description
        Text
	    Returns the module corresponding to the adjoint representation of a Lie algebra.
        Example
	    g=simpleLieAlgebra("A",2)
	    adjointModule g
	    adjointModule (g++g)
///

TEST ///
    g=simpleLieAlgebra("A",2);
    M=irreducibleLieAlgebraModule({2,1},g);
    assert(M ** trivialModule g === M)
    assert(M ** zeroModule g === zeroModule g)
    assert(dim adjointModule(g++g)==2*dim adjointModule g)
///

doc ///
    Key
    	adams
	(adams,ZZ,LieAlgebraModule)
    Headline
        Computes the action of the nth Adams operator on a Lie algebra module
    Usage
        adams(n,M)
    Inputs
	n:ZZ
        M:LieAlgebraModule
    Outputs
        M':LieAlgebraModule
///

doc ///
    Key
    	(symmetricPower,ZZ,LieAlgebraModule)
	(exteriorPower,ZZ,LieAlgebraModule)
    Headline
        Computes the nth symmetric / exterior tensor power of a Lie algebra module
    Usage
        symmetricPower(n,M)
        exteriorPower(n,M)
    Inputs
	n:ZZ
        M:LieAlgebraModule
    Outputs
        M':LieAlgebraModule
///

TEST ///
    g=simpleLieAlgebra("A",3);
    M=irreducibleLieAlgebraModule({1,0,0},g);
    assert(exteriorPower(2,M) === irreducibleLieAlgebraModule({0,1,0},g));
    assert(exteriorPower(3,M) === irreducibleLieAlgebraModule({0,0,1},g));
    scan(1..5, i -> assert(symmetricPower(i,M) === irreducibleLieAlgebraModule({i,0,0},g)));
///

doc ///
    Key
	(symbol ^**,LieAlgebraModule,ZZ)
    Headline
        Computes the nth tensor power of a Lie algebra module
    Usage
        M^**n
    Inputs
        M:LieAlgebraModule
	n:ZZ
    Outputs
        M':LieAlgebraModule
///

TEST ///
    g=simpleLieAlgebra("B",3);
    M=irreducibleLieAlgebraModule({1,0,1},g);
    c=character M;
    scan(1..4, n -> assert(character(M^**n) == c^n))
///

doc ///
    Key
       qdim
       (qdim,LieAlgebraModule)
       (qdim,LieAlgebraModule,ZZ)
    Headline
       Compute principal specialization of character or quantum dimension
    Usage
       qdim M
       qdim(M,l)
    Inputs
        M:LieAlgebraModule
	l:ZZ
    Outputs
        P:RingElement
    Description
        Text
	    @TT "qdim M"@ computes the principal specialization of the character of @TT "M"@.
	    @TT "qdim (M,l)"@ evaluates it modulo the appropriate cyclotomic polynomial,
	    so that upon specialization of the variable $q$ to be the corresponding root of unity of smallest positive argument,
	    it provides the quantum dimension of @TT "M"@.
	Example
	    g=simpleLieAlgebra("A",2)
	    W=weylAlcove(g,3)
	    L=LL_(1,1) (g)
	    M=matrix table(W,W,(v,w)->fusionCoefficient(L,LL_v g,LL_w g,3))
	    first eigenvalues M
	    qdim L
	    qdim (L,3)
///

TEST ///
    g=simpleLieAlgebra("B",3);
    L=LL_(1,0,0) g;
    M=LL_(0,1,1) g;
    assert(qdim(L,3) * qdim(M,3) == qdim(fusionProduct(L,M,3),3))
///

doc ///
    Key
    	dynkinDiagram
	(dynkinDiagram,LieAlgebra)
    Headline
    	Provide the Dynkin diagram of a simple Lie algebra
    Description
	Example
	    g=simpleLieAlgebra("F",4)
	    dynkinDiagram g
///

doc ///
    Key
    	cartanMatrix
	(cartanMatrix,LieAlgebra)
    Headline
    	Provide the Cartan matrix of a simple Lie algebra
    Description
	Example
	    g=simpleLieAlgebra("G",2)
	    cartanMatrix g
///

TEST ///
    assert(cartanMatrix simpleLieAlgebra("B",2) == matrix {{2,-2},{-1,2}})
///

doc ///
    Key
    	subLieAlgebra
	(subLieAlgebra,LieAlgebra,List)
	(subLieAlgebra,LieAlgebra,Matrix)
    Headline
        Define a sub-Lie algebra of an existing one
    Usage
       subLieAlgebra(g,S)
    Inputs
        g:LieAlgebra
	S:{List,Matrix}
    Outputs
        h:LieAlgebra
    Description
        Text
	   @TT "S"@ must be a subset of vertices of the Dynkin diagram of @TT "g"@ (as labelled by @TO dynkinDiagram@);
	   or a matrix whose columns are the simple coroots of the subalgebra expanded in the basis of simple coroots of @TT "g"@.
	Example
	   g=𝔢_8; dynkinDiagram g
	   subLieAlgebra(g,{1,2,3,4,5,8})
	   h=𝔣_4; dynkinDiagram h
	   subLieAlgebra(h,matrix transpose{{1,0,0,0},{0,1,0,0},{0,0,1,0},-{2,3,2,1}}) -- simple coroots 1,2,3 and opposite of highest root
    Caveat
        If @TT "S"@ is a matrix, does not check if the map of root lattices leads to a valid Lie algebra embeddng.
///

TEST ///
g = simpleLieAlgebra("E",8)
h = subLieAlgebra(g,{2,3,4,5})
assert ( h#"LieAlgebraRank" === 4 and h#"RootSystemType" === "D" )
k = subLieAlgebra(h,{1,3,4})
assert ( k#"LieAlgebraRank" === (1,1,1) and k#"RootSystemType" === ("A","A","A") )
///

doc ///
    Key
        branchingRule
        (branchingRule,LieAlgebraModule,List)
        (branchingRule,LieAlgebraModule,Matrix)
        (branchingRule,LieAlgebraModule,LieAlgebra)
    Headline
        A Lie algebra module viewed as a module over a Lie subalgebra 
    Usage
        branchingRule(V,S)
    Inputs
        V:LieAlgebraModule
	S:{List,Matrix,LieAlgebra}
    Outputs
        V':LieAlgebraModule
    Description
        Text
	   @TT "S"@ must be a subset of vertices of the Dynkin diagram of the Lie algebra of @TT "V"@, or a matrix, see @TO subLieAlgebra@;
	   or a sub-Lie algebra.
	   Returns @TT "V"@ viewed as a module over the Lie subalgebra determined by @TT "S"@.
	Example
	    g=simpleLieAlgebra("D",4);
	    M=adjointModule g;
	    branchingRule(M,{1,2,3})
///

TEST ///
g=simpleLieAlgebra("A",2);
M=LL_(4,2) g;
assert(dim branchingRule(M,{1}) == dim M)
h=subLieAlgebra(g,matrix vector {2,2})
assert(branchingRule(LL_(1,0)(g),h) == LL_2(h))
///

doc ///
    Key
       (symbol ++,LieAlgebra,LieAlgebra)
       (directSum,LieAlgebra)
    Headline
        Take the direct sum of Lie algebras
    Description
        Text
	   Starting from simple Lie algebras, one can take direct sums and produce semi-simple ones:
	Example
	   g=simpleLieAlgebra("D",4);
	   h=simpleLieAlgebra("G",2);
	   g++h
	   directSum(g,g,h)
///

doc ///
    Key
       (symbol @,LieAlgebraModule,LieAlgebraModule)
    Headline
        Take the tensor product of modules over different Lie algebras
    Description
        Text
	   Produces a module over the direct sum of the Lie algebras of the two modules.
	Example
	   LL_(1,2,3,4) (simpleLieAlgebra("D",4)) @ LL_(5,6) (simpleLieAlgebra("G",2))
        Text
	   A complicated way to define usual tensor product @TO (symbol **,LieAlgebraModule,LieAlgebraModule)@ would be using the diagonal embedding:
	Example
	   g := simpleLieAlgebra("A",1)
	   h := g ++ g
	   gdiag := subLieAlgebra(h,matrix {{1},{1}})
	   M = LL_5 (g); M' = LL_2 (g);
	   M @ M'
	   branchingRule(oo,gdiag)
	   M ** M'
///

TEST ///
g=simpleLieAlgebra("A",2);
h=simpleLieAlgebra("B",2);
k=g++h
A=LL_(1,2) g
B=LL_(2,1) h
M=LL_(1,2,2,1) k;
assert ( M == A @ B )
assert(character(M,Strategy=>"Weyl")==character(M,Strategy=>"Freudenthal"))
///

doc ///
    Key
        (NewFromMethod,LieAlgebra,Matrix)
    Headline
        Define a Lie algebra from its Cartan matrix
    Description
        Text
	   @TT "new LieAlgebra from M"@

	   If M is a valid Cartan matrix, it will reorder if needed the rows/columns of M to a standard form and then output the
	   corresponding Lie algebra @TT "g"@.
	Example
	    M = matrix {{2, 0, -3, 0}, {0, 2, 0, -1}, {-1, 0, 2, 0}, {0, -1, 0, 2}}
	    h := new LieAlgebra from M
	    cartanMatrix h
///

doc ///
    Key
       (symbol _,LieAlgebraModule,ZZ)
       (symbol _,LieAlgebraModule,List)
       (symbol _,LieAlgebraModule,Vector)
       (symbol _,LieAlgebraModule,LieAlgebraModule)
    Headline
        Pick out one irreducible submodule of a Lie algebra module
    Description
        Text
	   If a number is given, the ordering is the same as when the module is displayed:
	Example
	   g=simpleLieAlgebra("A",2);
	   (adjointModule g)^**3
	   oo_2
        Text
	   Instead one can simply use a weight or irreducible module as subscript:
	Example
	   g=simpleLieAlgebra("A",3);
	   M=(adjointModule g)^**2
	   describe M
	   M_{1,0,1}
	   M_(trivialModule g)
///

doc ///
    Key
       (symbol _*,LieAlgebraModule)
    Headline
        List irreducible submodules of a Lie algebra module
    Description
        Text
	   Gives a list of nonisomorphic irreducible submodules:
	Example
	   g=simpleLieAlgebra("A",2);
	   (adjointModule g)^**3
	   oo_*
///

-- New documention after LieTypes version 0.9

-- From chevalleyBasis.m2
doc ///
    Key
       ChevalleyBasis
    Headline
        class for a Chevalley basis
    Description
        Text
    	    This class represents a specific kind of basis of a Lie algebra.  A Chevalley basis is adapted to the decomposition of $\mathfrak{g}$ into its root spaces, i.e. $\mathfrak{g} = \mathfrak{h} \oplus \bigoplus_{\Phi^{+}} \mathfrak{g}_{\alpha} \oplus \bigoplus_{\Phi^{+}} \mathfrak{g}_{-\alpha}$.
        Text
	    This class also stores additional information about the basis in addition to the basis elements themselves. For instance, it records the weights of the basis elements and their dual elements with respect to the Killing form.
	Text    
	    Currently only implemented for for simple Lie algebras of type A.
        Example
	    CB=chevalleyBasis("A",2)
	    peek CB

///


doc ///
    Key
        chevalleyBasis
	(chevalleyBasis,String,ZZ)
	(chevalleyBasis,LieAlgebra)
    Headline
        computes a Chevalley basis for a simple Lie algebra
    Usage
        chevalleyBasis("A",2)
    Inputs 
        t:String
	m:ZZ
    Outputs
        CB:ChevalleyBasis
    Description
        Text
	    Currently only implemented for simple Lie algebras of types A, C, and D.
	Text
	    The user may either input the type and rank, or the simple Lie algebra.
	Example
	    CB=chevalleyBasis("A",2);
	    peek CB
	    sl3=simpleLieAlgebra("A",2);
	    chevalleyBasis(sl3)===CB
///

TEST ///
CB=chevalleyBasis("A",2);
assert(sort keys(CB)=={"BasisElements","Bracket","DualBasis","Labels","LieAlgebra","LoweringOperatorIndices","RaisingOperatorIndices","Weights","WriteInBasis"})
assert(CB#"LieAlgebra"#"RootSystemType"=="A")
assert(CB#"LieAlgebra"#"LieAlgebraRank"==2)
assert(CB#"LoweringOperatorIndices"=={5, 6, 7})
assert(CB#"DualBasis"=={map(QQ^3,QQ^3,{{2/3, 0, 0}, {0, -1/3, 0}, {0, 0, -1/3}}),map(QQ^3,QQ^3,{{1/3, 0, 0}, {0, 1/3, 0}, {0, 0, -2/3}}),map(QQ^3,QQ^3,{{0, 0, 0}, {1, 0, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 0, 0}, {1, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 0, 0}, {0, 1, 0}}),map(QQ^3,QQ^3,{{0, 1, 0}, {0, 0, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 1}, {0, 0, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 0, 1}, {0, 0, 0}})})
assert(CB#"BasisElements"=={map(QQ^3,QQ^3,{{1, 0, 0}, {0, -1, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 1, 0}, {0, 0, -1}}),map(QQ^3,QQ^3,{{0, 1, 0}, {0, 0, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 1}, {0, 0, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 0, 1}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {1, 0, 0}, {0, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 0, 0}, {1, 0, 0}}),map(QQ^3,QQ^3,{{0, 0, 0}, {0, 0, 0}, {0, 1, 0}})})
///


-- From gelfandTsetlinTypeA.m2


doc ///
    Key
        dynkinToPartition
	(dynkinToPartition,List)
    Headline
        converts a highest weight written in the basis of fundamental dominant weights for type A into a partition
    Usage
        dynkinToPartition(lambda)
    Inputs 
        lambda:List
    Outputs
        L:List
    Description
        Text
            There are at least two popular ways to describe irreducible $\gl_n$ and $sl_n$ modules. We can either give its highest weight as a linear combination of the fundamental dominant weights $\omega_i$, or describe it as a partition. This function allows us to convert from the first convention to the second.

        Text
	    In the example below, we convert the weight $\lambda = (1,2,0,0,1) =  \omega_1 + 2\omega_2 + \omega_5$ for $sl_6$ into a partition. 
	    
	Example
	    lambda = {1,2,0,0,1}
	    dynkinToPartition(lambda)
///

TEST ///
    assert(dynkinToPartition({1,2,0,0,1}) === {4,3,1,1,1,0})
///


doc ///
    Key
        GTPattern
    Headline
        class for a Gelfand-Tsetlin pattern
    Description
        Text
    	    A Gelfand-Tsetlin pattern is a type of combinatorial object that is useful in representation theory.  We follow the definitions given in Molev, "Gelfand-Tsetlin bases for classical Lie algebras", 2018.

	    Let $\lambda$ be a partition with $n$ parts, written in nonincreasing order. A Gelfand-Tsetlin pattern of shape  $\lambda$ is a triangular array of the following form:

	    $\begin{array}{ccccccccc} x_{n,1} & & x_{n,2} & & x_{n,3} & & \cdots && x_{n,n} \\ &x_{n-1,1} & & x_{n-1,2} & & \cdots & x_{n-1,n-1} & \\ && \ddots \\ && & x_{2,1} && x_{2,2} \\ &&&& x_{1,1}\end{array}$

           Each entry $x_{i,j}$ is a nonnegative integer, the top row $x_{n,i}$ corresponds to $\lambda$, and the entries satisfy the inequalities $x_{k,i} \geq x_{k-1,i} \geq x_{k,i+1}$. 

            The Gelfand-Tsetlin patterns of shape $\lambda$ form a basis of the irreducible $sl_n$ module with highest weight $\lambda$, and there are explicit formulae for the actions of a Chevalley basis of $sl_n$ on this basis.

            The Gelfand-Tsetlin patterns correspond to the integer points of a polytope called the Gelfand-Tsetlin polytope. The @TT "LieAlgebraRepresentations"@ package can create this polytope with the function @TO (gtPolytope,List)@.

             A @TT "GTPattern"@ is a hash table with keys recording the shape, entries, content, and weight of the pattern. 

	Text    
	    Currently only implemented for type A.


///



doc ///
    Key
        gtPolytope
	(gtPolytope,List)
    Headline
        the polytope defined by the inequalities and equations appearing in the definition of Gelfand-Tsetlin patterns
    Usage
        gtPolytope(lambda)
    Inputs 
        lambda:List
    Outputs
        P:Polyhedron
    Description
        Text
            Currently only supported for $\mathfrak{g} = sl_n$.
        Text
            Let $\lambda$ be a partition with $n$ parts, written in nonincreasing order. A Gelfand-Tsetlin pattern of shape  $\lambda$ is a triangular array of the following form:

	    $\begin{array}{ccccccccc} x_{n,1} & & x_{n,2} & & x_{n,3} & & \cdots && x_{n,n} \\ &x_{n-1,1} & & x_{n-1,2} & & \cdots & x_{n-1,n-1} & \\ && \ddots \\ && & x_{2,1} && x_{2,2} \\ &&&& x_{1,1}\end{array}$

           Each entry $x_{i,j}$ is a nonnegative integer, the top row $x_{n,i}$ corresponds to $\lambda$, and the entries satisfy the inequalities $x_{k,i} \geq x_{k-1,i} \geq x_{k,i+1}$. 
	    
        Text
	    This function outputs the polytope defined by these inequalities and equations.
	    
	Example
	    P=gtPolytope({2,0,0})
	    dim P
	    halfspaces(P)
	    hyperplanes(P)
	    vertices(P)

///

TEST ///
    P=gtPolytope({2,0,0})
    assert(dim P === 2)
    assert(sort transpose entries vertices(P) === {{2/1,0/1,0/1,0/1,0/1,0/1},{2/1,0/1,0/1,2/1,0/1,0/1},{2/1,0/1,0/1,2/1,0/1,2/1}})
///


doc ///
    Key
        gtPatterns
	(gtPatterns,List)
    Headline
        a list of Gelfand-Tsetlin patterns of shape lambda
    Usage
        gtPattern(lambda)
    Inputs 
        lambda:List
    Outputs
        L:List
    Description
        Text
            Currently only supported for $\mathfrak{g} = sl_n$.
        Text
            This function computes a list of Gelfand-Tsetlin patterns of shape $\lambda$ by computing the lattice points of the Gelfand-Tsetlin polytope.  See the documentation for @TO "GTPattern"@ and @TO (gtPolytope,List)@ for more details.
	    
	    
	Example
	    gtPatterns({2,0,0})

	Text
	    We compare this to the lattice points of the Gelfand-Tsetlin polytope for this shape.
	    
	Example
            P = gtPolytope({2,0,0})
	    latticePoints(P)
///

TEST ///
    assert(gtPatterns({2,0,0}) === {{2, 0, 0, 2, 0, 2}, {2, 0, 0, 2, 0, 1}, {2, 0, 0, 2, 0, 0}, {2, 0, 0, 1, 0, 1}, {2, 0, 0, 1, 0, 0}, {2, 0, 0, 0, 0, 0}})
///


doc ///
    Key
        gtPatternFromEntries
	(gtPatternFromEntries,List)
    Headline
        creates an object of type GTPattern from a list of entries
    Usage
        gtPatternFromEntries(L)
    Inputs 
        L:List
    Outputs
        P:GTPattern
    Description
        Text
            Currently only supported for $\mathfrak{g} = sl_n$.
        Text
            This function creates an object of type GTPattern from a list of entries.  In doing so it computes the content and weight associated to the pattern with these entries, and makes the entries accessible from their indices.
	    
	    
	Example
	    x = gtPatternFromEntries({2, 0, 0, 2, 0, 2})
            peek x
	    x#(2,2)

///

TEST ///
    x = gtPatternFromEntries({2, 0, 0, 2, 0, 2})
    assert(keys(x) === {"entries","shape","weight","content",(1,1),(2,1),(2,2),(3,1),(3,2),(3,3)})
    assert(x#"entries"==={2, 0, 0, 2, 0, 2})
    assert(x#"shape"==={2,0,0})
    assert(x#"weight"==={2,0})
    assert(x#"content"==={2, 0, 0})
///





doc ///
    Key
        GTrepresentationMatrices
	(GTrepresentationMatrices,LieAlgebraModule)
    Headline
        creates a list of matrices for the action of $\mathfrak{g}$ on Gelfand-Tsetlin basis
    Usage
        GTrepresentationMatrices(V,lambda)
    Inputs 
        V:LieAlgebraModule
    Outputs
        L:List
    Description
        Text
            Currently only supported for $\mathfrak{g} = sl_n$.
        Text
            Let $\rho: sl_n \rightarrow \mathfrak{gl}(V)$ be a representation where $V$ is irreducible of highest weight $\lambda$. Let $\{B_i\}$ be a Chevalley basis for $sl_n$. This function creates the list of matrices $\{M_i\}$, where $M_i$ is the matrix of the endomorphism $\rho(B_i)$ with respect to the Gelfand-Tsetlin basis on $V$. See Molev, "Gelfand-Tsetlin bases for classical Lie algebras", 2018 for additional details about the Gelfand-Tsetlin basis.
	    
        Text
	    The output is a list of matrices that may in turn be installed as a representation.

	Text
	    We create matrix generators for the adjoint representation of $sl_3$ with respect to the Gelfand-Tsetlin basis of $sl_3$, and then install it to the module $V$.
	    
	Example
	    sl3=simpleLieAlgebra("A",2)
	    V=irreducibleLieAlgebraModule({1,1},sl3)
	    L=GTrepresentationMatrices(V)
	    CB=chevalleyBasis(sl3)
	    installRepresentation(V,CB,L)
///

TEST ///
    sl3=simpleLieAlgebra("A",2)
    V=irreducibleLieAlgebraModule({1,1},sl3)
    assert(GTrepresentationMatrices(V) === {map(QQ^8,QQ^8,{{1, 0, 0, 0, 0, 0, 0, 0}, {0, -1, 0, 0, 0, 0, 0, 0}, {0, 0, 2, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, -2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 1, 0}, {0, 0, 0, 0, 0, 0, 0, -1}}),map(QQ^8,QQ^8,{{1, 0, 0, 0, 0, 0, 0, 0}, {0, 2, 0, 0, 0, 0, 0, 0}, {0, 0, -1, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 1, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, -2, 0}, {0, 0, 0, 0, 0, 0, 0, -1}}),map(QQ^8,QQ^8,{{0, 1, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 2, 0, 0, 0, 0}, {0, 0, 0, 0, 2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 1}, {0, 0, 0, 0, 0, 0, 0, 0}}),map(QQ^8,QQ^8,{{0, 0, 0, -1, 0, 3, 0, 0}, {0, 0, 0, 0, -2, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 3, 0}, {0, 0, 0, 0, 0, 0, 0, 3/2}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, -3/2}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}}),map(QQ^8,QQ^8,{{0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 3, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 3/2, 0}, {0, 0, 0, 0, 0, 0, 0, 3/2}, {0, 0, 0, 0, 0, 0, 3/2, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}}),map(QQ^8,QQ^8,{{0, 0, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 1, 0, 0, 0, 0, 0}, {0, 0, 0, 1, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 1, 0}}),map(QQ^8,QQ^8,{{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {-1/2, 0, 0, 0, 0, 0, 0, 0}, {0, -1/2, 0, 0, 0, 0, 0, 0}, {1/2, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 1/3, 0, 0, 0, 0, 0}, {0, 0, 0, 1/3, 0, -1, 0, 0}}),map(QQ^8,QQ^8,{{0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {1, 0, 0, 0, 0, 0, 0, 0}, {0, 1/2, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0}, {0, 1/2, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 1/3, 0, 1, 0, 0}, {0, 0, 0, 0, 2/3, 0, 0, 0}})})
///

-- From symWedgeTensor.m2

doc ///
    Key
        symmetricPowerRepresentation
	(symmetricPowerRepresentation,ZZ,LieAlgebraModule)
    Headline
        computes the explicit action on $\operatorname{Sym}^d V$ for a $\mathfrak{g}$-module $V$
    Usage
        symmetricPowerRepresentation(d,V)
    Inputs
        d:ZZ
        V:LieAlgebraModule
    Outputs
        W:LieAlgebraModule
    Description
        Text
	    Let $V$ be a LieAlgebraModule with a representation installed. Then this function computes the action of $\mathfrak{g}$ on $W = \operatorname{Sym}^d V$, and caches the result in W.cache#representation.
	    
	Text     
            In the example below, we compute $\operatorname{Sym}^2 V$ for the standard representation of $sl_2$.
         
	Example
	    sl2=simpleLieAlgebra("A",1);
	    V = standardModule(sl2);
	    peek V

	Text
	    So far, $V$ only has information about its decomposition into irreducible submodules. Now we install the standard representation, then compute its symmetric square.
	    
        Example
	    CB = chevalleyBasis("A",1);
            installRepresentation(V,CB,CB#"BasisElements");
	    W = symmetricPowerRepresentation(2,V)
            peek W
	    W.cache#representation
///

TEST ///
    sl2=simpleLieAlgebra("A",1);
    V = standardModule(sl2);
    CB = chevalleyBasis("A",1);
    installRepresentation(V,CB,CB#"BasisElements");
    W = symmetricPowerRepresentation(2,V)
    assert( last(W.cache#representation) == {sparseMatrix(3,3,QQ,new HashTable from {(0,0) => 2, (2,2) => -2}),sparseMatrix(3,3,QQ,new HashTable from {(0,1) => 1, (1,2) => 2}),sparseMatrix(3,3,QQ,new HashTable from {(1,0) => 2, (2,1) => 1})})
///


doc ///
    Key
        exteriorPowerRepresentation
	(exteriorPowerRepresentation,ZZ,LieAlgebraModule)
    Headline
        computes the explicit action on $\bigwedge^k V$ for a $\mathfrak{g}$-module $V$
    Usage
        exteriorPowerRepresentation(k,V)
    Inputs
        k:ZZ
        V:LieAlgebraModule
    Outputs
        W:LieAlgebraModule
    Description
        Text
	    Let $V$ be a LieAlgebraModule with a representation installed. Then this function computes the action of $\mathfrak{g}$ on $W = \bigwedge^k V$, and caches the result in W.cache#representation.
	    
	Text     
            In the example below, we compute $\bigwedge^2 V$ for the standard representation of $sl_3$.
         
	Example
	    sl2=simpleLieAlgebra("A",1);
	    V = standardModule(sl2);
	    peek V

	Text
	    So far, $V$ only has information about decomposition into irreducible submodules. Now we install the standard representation, then compute its symmetric square.
	    
        Example
            sl3=simpleLieAlgebra("A",2);
            V = standardModule(sl3);
            CB = chevalleyBasis("A",2);
	    installRepresentation(V,CB,CB#"BasisElements");
	    W = exteriorPowerRepresentation(2,V)
	    W.cache#representation
///

-- TO DO: Check this result by hand
TEST ///
    sl3=simpleLieAlgebra("A",2);
    V = standardModule(sl3);
    CB = chevalleyBasis("A",2);
    installRepresentation(V,CB,CB#"BasisElements");
    W = exteriorPowerRepresentation(2,V)
    assert(last(W.cache#representation)=={new SparseMatrix from {"Entries" => new HashTable from {(2,2) => -1/1, (1,1) => 1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(0,0) => 1/1, (1,1) => -1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(1,2) => 1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(0,2) => -1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(0,1) => 1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(2,1) => 1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(2,0) => -1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3},new SparseMatrix from {"Entries" => new HashTable from {(1,0) => 1/1}, "NumberOfRows" => 3, "BaseRing" => QQ, "NumberOfColumns" => 3}})
///


doc ///
    Key
        tensorProductRepresentation
	(tensorProductRepresentation,LieAlgebraModule,LieAlgebraModule)
    Headline
        computes the explicit action on $V \otimes W$ given $\mathfrak{g}$-modules $V$ and $W$
    Usage
        tensorProductRepresentation(V,W)
    Inputs
        V:LieAlgebraModule
        W:LieAlgebraModule
    Outputs
        Y:LieAlgebraModule
    Description
        Text
	    Let $V$ and $W$ be LieAlgebraModules with representations installed. Then this function computes the action of $\mathfrak{g}$ on $U = V \otimes V$, and caches the result in U.cache#representation.
	    
	Text     
            In the example below, we compute $V \otimes W$, where $V$ is the adjoint represention of $sl_3$, and $W$ is the standard representation of $sl_3$.
         	    
        Example
            sl3=simpleLieAlgebra("A",2);
            V = irreducibleLieAlgebraModule({1,1},sl3);
            CB = chevalleyBasis(sl3);
	    installRepresentation(V,CB,GTrepresentationMatrices(V));
	    W = irreducibleLieAlgebraModule({1,0},sl3);
	    installRepresentation(W,CB,GTrepresentationMatrices(W));
	    U = tensorProductRepresentation(V,W);
	    (U.cache#representation)_1_0
///

-- TO DO: Check this result by hand
TEST ///
    sl3=simpleLieAlgebra("A",2);
    V = irreducibleLieAlgebraModule({1,1},sl3);
    CB = chevalleyBasis("A",2);
    installRepresentation(V,CB,GTrepresentationMatrices(V));
    W = irreducibleLieAlgebraModule({1,0},sl3);
    installRepresentation(W,CB,GTrepresentationMatrices(W));
    U = tensorProductRepresentation(V,W);
    assert((U.cache#representation)_1_0==new SparseMatrix from {"Entries" => new HashTable from {(20,20) => 1/1, (4,4) => -2/1, (5,5) => -1/1, (6,6) => 3/1, (22,22) => -2/1, (23,23) => -1/1, (7,7) => 1/1, (8,8) => 2/1, (9,9) => 1/1, (10,10) => -1/1, (12,12) => -1/1, (13,13) => -3/1, (14,14) => -2/1, (15,15) => 1/1, (0,0) => 2/1, (16,16) => -1/1, (2,2) => 1/1, (18,18) => 2/1}, "NumberOfRows" => 24, "BaseRing" => QQ, "NumberOfColumns" => 24})
///


doc ///
    Key
        isLieAlgebraRepresentation
	(isLieAlgebraRepresentation,ChevalleyBasis,List)
    Headline
        checks whether a list of matrices defines a Lie algebra representation
    Usage
        isLieAlgebraRepresentation(CB,L)
    Inputs 
        CB:ChevalleyBasis
	L:List
    Outputs
        b:Boolean
    Description
        Text
	    Let CB be a Chevalley basis of $\mathfrak{g}$, and let $L$ be a list of $n \times n$ matrices with $\#L = \#CB$.  Let $\rho: \mathfrak{g} \rightarrow \mathbb{C}^n$ be the linear transformation defined by mapping $B_i$ in CB to $L_i$. This function checks whether $\rho$ preserves the Lie bracket; that is, for each pair of indices $i,j$, if $[B_i,B_j] = \sum c_{ijk} B_k$, then is $[\rho(B_i),\rho(B_j)] = \sum c_{ijk} \rho(B_k)$?
	     
	Text
	    In the example below, we compute the adjoint representation of $sl_3$ directly, and check that the list of matrices we obtain defines a Lie algebra representation.
	    
	Example
            sl3 = simpleLieAlgebra("A",2);
            CB = chevalleyBasis("A",2);
	    br = CB#"Bracket";
	    writeInBasis = CB#"WriteInBasis";
	    B = CB#"BasisElements"
	    ad = X -> transpose matrix apply(B, Y -> writeInBasis br(X,Y))
            L1 = apply(B, X -> ad X)
	    isLieAlgebraRepresentation(CB,L1)
	    
        Text
            Next, we present an example where the linear transformation $\rho: sl_3 \rightarrow \mathfrak{gl}(\mathbb{C}^8)$ does not preserve the Lie bracket.

	Example
	    L2 = apply(#L1, i -> if i==6 then -2*L1_i else L1_i)
	    isLieAlgebraRepresentation(CB,L2)
	    

///

-- TO DO: Check this result by hand
TEST ///
    sl3 = simpleLieAlgebra("A",2);
    CB = chevalleyBasis("A",2);
    br = CB#"Bracket";
    writeInBasis = CB#"WriteInBasis";
    B = CB#"BasisElements";
    ad = X -> transpose matrix apply(B, Y -> writeInBasis br(X,Y));
    L1 = apply(B, X -> ad X);
    assert(isLieAlgebraRepresentation(CB,L1))
    L2 = apply(#L1, i -> if i==6 then -2*L1_i else L1_i);
    assert(not isLieAlgebraRepresentation(CB,L2))
///


-- From representationsCasimirReynolds.m2


doc ///
    Key
        installRepresentation
	(installRepresentation,LieAlgebraModule,ChevalleyBasis,List)
    Headline
        Install an explicit Lie algebra representation to a Lie algebra module
    Usage
        installRepresentation(V,CB,L)
    Inputs 
        V:LieAlgebraModule
	CB:ChevalleyBasis
	L:List
    Outputs
    Description
        Text
            Let $\{B_i\}$ be a basis of $\mathfrak{g}$, and $\rho: \mathfrak{g} \rightarrow \mathfrak{gl}(V)$ be a Lie algebra representation to the $\mathfrak{g}$-module $V$. 

	Text
	    To construct $\rho$, we require a Chevalley basis @TT "CB"@ of $\mathfrak{g}$, and a list @TT "L"@ of matrices that are the images $\rho(B_i) \in \mathfrak{gl}(V)$. Then the list {CB,L} is stored in V.cache#representation.
        Text	    
	    First, we build the standard representation for $sl_3$. The list of matrices we need is already contained in the Chevalley basis.
	Example
	    sl3=simpleLieAlgebra("A",2);
	    V=irreducibleLieAlgebraModule({1,0},sl3);
	    peek V
            CB = chevalleyBasis("A",2);
	    installRepresentation(V,CB,CB#"BasisElements");
	    peek V
	    peek (V.cache)
        Text
	    Note how @TT "V.cache"@ changed after we ran @TT "installRepresentation"@.
	Text
	    Next, we install an explicit representation to the irreducible $sl_3$ module with highest weight $(2,0)$. This time, we create the list of matrices using the command @TO GTrepresentationMatrices@.
        Example
	    V=irreducibleLieAlgebraModule({2,0},sl3);
            L = GTrepresentationMatrices(V)
            installRepresentation(V,CB,L)
	    peek V
	    peek (V.cache)
///


doc ///
    Key
        representationWeights
	(representationWeights,LieAlgebraModule)
    Headline
        computes the weights of the basis of $V(\lambda)$ used to define a representation
    Usage
        representationWeights(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        L:List
    Description
        Text
	    Let @TT "V"@ be a LieAlgebraModule with a representation installed. Computing @TT "weightDiagram(V)"@ will give a VirtualTally of the weights of $V$ and their multiplicities, but this aggregated report does not tell us the weight of each basis element used to define the matrices in the representation.

	Text
            Instead, this function first checks that for the Cartan subalgebra elements $H_i$ in the Chevallay basis of $\mathfrak{g}$, the image $\rho(H_i)$ is a diagonal matrix. If not, this function returns an error that the basis of $V(\lambda) is not an eigenbasis for the Cartan subalgebra. Otherwise, this function returns the list of weights of these basis elements, which are obtained from the diagonal entries of the matrices $\rho(H_i)$.

	Text
	    In the example below, we compute the weights of the Gelfand-Tsetlin basis for the adjoint representation of $sl_3$.
	    
	Example
            sl3 = simpleLieAlgebra("A",2);
            CB = chevalleyBasis("A",2);
            V=irreducibleLieAlgebraModule({1,1},sl3);
            installRepresentation(V,CB,GTrepresentationMatrices(V));
            L1 = representationWeights(V)
	    
        Text
            We can check that this agrees with the weight of the Gelfand-Tsetlin pattern labelling each basis element.

	Example
	    dynkinToPartition({1,1})
	    L2 = gtPatterns({2,1,0})
	    
        Text
	    Right now, the entries of L2 are just lists. We turn them into objects of type GTPattern, and then get their weights.

	Example
	    L2 = apply(L2, x -> (gtPatternFromEntries(x))#"weight")
	    L1==L2

	Text
	    Finally, we check that this agrees with the weight diagram of V.

	Example
	    tally(L2)
	    weightDiagram(V)
	    weightDiagram(V) === new VirtualTally from tally(L2)
///

-- TO DO: Check this result by hand
TEST ///
    sl3 = simpleLieAlgebra("A",2);
    CB = chevalleyBasis("A",2);
    V=irreducibleLieAlgebraModule({1,1},sl3);
    installRepresentation(V,CB,GTrepresentationMatrices(V));
    L = basisWordsFromMatrixGenerators(V)
    assert(apply(L,w -> w#"Terms") == {{{{}, 1}}, {{{0}, 1}}, {{{2}, 1}}, {{{0, 2}, 1}}, {{{0, 1}, -2}}, {{{1}, 2}, {{0, 2}, 1}}, {{{1, 2}, 3}}, {{{1, 1}, -3/2}}});
///


doc ///
    Key
        casimirOperator
	(casimirOperator,LieAlgebraModule)
    Headline
        computes the Casimir operator associated to a representation
    Usage
        casimirOperator(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        M:Matrix
    Description
        Text
	    Let @TT "V"@ be a LieAlgebraModule with a representation $\rho: \mathfrak{g} \rightarrow \mathfrak{gl}(V)$ installed.
	    
	Text
            Let $\{B_i\}$ be a basis of $\mathfrak{g}$, and let $\{B_i^{*}\}$ be the dual basis with respect to the Killing form. The Casimir operator is
	    
        Text
	    $\operatorname{Cas} = \sum_{i} \rho(B_i^*) \rho(B_i)$.

	Text
	    Recall that in creating a Chevalley basis, we compute the dual basis $\{B_i^{*}\}$. This makes it straightforward to compute the Casimir operator.

	Text
	    If @TT "V"@ is irreducible with highest weight lambda, then $\operatorname{Cas} = c(\lambda) \operatorname{Id}$, where $c(\lambda)$ is the scalar computed by @TO (casimirScalar,LieAlgebraModule)@.

        Text
	    We compute the Casimir operator for $\operatorname{Sym^2} \mathbb{C}^3$. Since this is an irreducible representation, we get a scalar multiple of the identity.
	    
	Example
	    sl3=simpleLieAlgebra("A",2);
	    CB = chevalleyBasis(sl3);
	    V=irreducibleLieAlgebraModule({1,0},sl3);
	    installRepresentation(V,CB,CB#"BasisElements");
	    S2V=symmetricPowerRepresentation(2,V);
	    CasS2V = casimirOperator(S2V)
	    
        Text
            Next, we compute the Casimir operator for $\operatorname{Sym^2} \operatorname{Sym^2} \mathbb{C}^3$. It has two distinct eigenvalues. The eigenvalues match the Casimir scalars of the irreducible submodules appearing in the decomposition of $\operatorname{Sym^2} \operatorname{Sym^2} \mathbb{C}^3$, and the multiplicities of the eigenvalues match the dimensions of these submodules. 

	Example
	    S2S2V=symmetricPowerRepresentation(2,S2V);
	    CasS2S2V = casimirOperator(S2S2V)
	    tally eigenvalues CasS2S2V
	    peek S2S2V
	    V40 = irreducibleLieAlgebraModule({4,0},sl3);
	    dim V40
	    casimirScalar(V40)
	    V02 = irreducibleLieAlgebraModule({0,2},sl3);
	    dim V02
	    casimirScalar(V02)

///

-- TO DO: Check this result by hand
TEST ///
    sl3=simpleLieAlgebra("A",2);
    CB = chevalleyBasis(sl3);
    V=irreducibleLieAlgebraModule({1,0},sl3);
    installRepresentation(V,CB,CB#"BasisElements");
    S2V=symmetricPowerRepresentation(2,V);
    CasS2V = casimirOperator(S2V);
    assert(CasS2V == map(QQ^6,QQ^6,{{20/3, 0, 0, 0, 0, 0}, {0, 20/3, 0, 0, 0, 0}, {0, 0, 20/3, 0, 0, 0}, {0, 0, 0, 20/3, 0, 0}, {0, 0, 0, 0, 20/3, 0}, {0, 0, 0, 0, 0, 20/3}}))
    S2S2V=symmetricPowerRepresentation(2,S2V);
    CasS2S2V = casimirOperator(S2S2V);
    assert(CasS2S2V == map(QQ^21,QQ^21,{{56/3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 56/3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 56/3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 32/3, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 32/3, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 32/3, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 8, 0, 0, 44/3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 8, 0, 0, 44/3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 56/3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 44/3, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32/3, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 44/3, 0, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 32/3, 0, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 0, 0, 44/3, 0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56/3, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56/3, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56/3, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32/3, 4, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 44/3, 0, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56/3, 0}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 56/3}}))
///


doc ///
    Key
        casimirSpectrum
	(casimirSpectrum,LieAlgebraModule)
    Headline
        computes the eigenvalues of the Casimir operator associated to a representation
    Usage
        casimirOperator(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        M:Matrix
    Description
        Text
	    Let @TT "V"@ be a LieAlgebraModule, and recall the definition of the Casimir operator from @TO (casimirOperator,LieAlgebraModule)@.
	    
	Text
	    If @TT "V"@ is irreducible with highest weight lambda, then $\operatorname{Cas} = c(\lambda) \operatorname{Id}$, where $c(\lambda)$ is the scalar computed by @TO (casimirScalar,LieAlgebraModule)@.

        Text
	    This function returns a nonredundant list of eigenvalues of $\operatorname{Cas}$ by computing the scalars $c(\lambda)$ for each irreducible summand in $V$, and then removing any duplicates.
	    
	Example
	    sl3=simpleLieAlgebra("A",2);
	    CB = chevalleyBasis(sl3);
	    V=irreducibleLieAlgebraModule({1,0},sl3);
            S3V=symmetricPower(3,V);
            S4S3V=symmetricPower(4,S3V);
	    casimirSpectrum(S4S3V)

///

-- TO DO: Check this result by hand
TEST ///
    sl3=simpleLieAlgebra("A",2);
    CB = chevalleyBasis(sl3);
    V=irreducibleLieAlgebraModule({1,0},sl3);
    S3V=symmetricPower(3,V);
    S4S3V=symmetricPower(4,S3V);
    assert(casimirSpectrum(S4S3V) == {0, 16, 24, 30, 36, 48, 60, 76, 120})
///


doc ///
    Key
        casimirProjection
	(casimirProjection,LieAlgebraModule,QQ)
    Headline
        projection operator to a specified eigenspace of the Casimir operator
    Usage
        casimirProjection(V,z)
    Inputs 
        V:LieAlgebraModule
	z:QQ
    Outputs
        M:Matrix
    Description
        Text
	    Let @TT "V"@ be a LieAlgebraModule with a representation installed, and recall the definition of the Casimir operator from @TO (casimirOperator,LieAlgebraModule)@.

        Text
	    This function returns the projection matrix to the eigenspace of the Casimir operator for the input eigenvalue @TT "z"@.  This matrix is computed as the product of factors $\operatorname{Cas}-x I$ over all eigenvalues $x \neq z$. 
	    
	Example
	    sl3=simpleLieAlgebra("A",2);
	    CB = chevalleyBasis(sl3);
	    V=irreducibleLieAlgebraModule({1,0},sl3);
            installRepresentation(V,CB,CB#"BasisElements");
            S2V=symmetricPowerRepresentation(2,V);
            S3S2V=symmetricPowerRepresentation(3,S2V);
	    casimirProjection(S3S2V,16)

///

-- TO DO: Check this result by hand
TEST ///
    sl3=simpleLieAlgebra("A",2);
    CB = chevalleyBasis(sl3);
    V=irreducibleLieAlgebraModule({1,0},sl3);
    installRepresentation(V,CB,CB#"BasisElements");
    S2V=symmetricPowerRepresentation(2,V);
    S3S2V=symmetricPowerRepresentation(3,S2V);
    assert(casimirProjection(S3S2V,16)==dense sparseMatrix(56,56,QQ, new HashTable from {(40,31) => 64/1, (36,36) => -192/1, (32,41) => 64/1, (5,5) => -256/1, (44,35) => 256/1, (5,11) => 64/1, (40,40) => -256/1, (9,9) => -192/1, (9,12) => 128/1, (13,10) => 128/1, (44,44) => -64/1, (13,13) => -192/1, (21,8) => 128/1, (9,22) => 128/1, (48,48) => -256/1, (48,49) => 64/1, (17,17) => -192/1, (17,18) => -32/1, (52,50) => 128/1, (13,26) => 128/1, (52,52) => -192/1, (17,25) => -32/1, (21,21) => -192/1, (25,17) => -64/1, (25,18) => 96/1, (17,28) => 48/1, (29,19) => 128/1, (25,25) => -224/1, (25,28) => 16/1, (37,17) => -64/1, (17,37) => -32/1, (37,18) => 96/1, (29,29) => -192/1, (37,25) => 96/1, (25,37) => 96/1, (37,28) => 16/1, (33,32) => 128/1, (33,33) => -192/1, (29,38) => 128/1, (6,3) => 256/1, (41,32) => 128/1, (33,41) => 128/1, (37,37) => -224/1, (41,33) => 128/1, (6,6) => -64/1, (41,41) => -192/1, (10,10) => -256/1, (10,13) => 64/1, (14,14) => -128/1, (22,9) => 128/1, (49,48) => 256/1, (49,49) => -64/1, (22,12) => 128/1, (18,17) => -64/1, (18,18) => -224/1, (10,26) => 64/1, (26,10) => 128/1, (26,13) => 128/1, (53,51) => 256/1, (53,53) => -64/1, (18,25) => 96/1, (22,22) => -192/1, (18,28) => 16/1, (14,36) => 192/1, (26,26) => -192/1, (18,37) => 96/1, (38,19) => 128/1, (38,29) => 128/1, (34,34) => -192/1, (3,3) => -256/1, (3,6) => 64/1, (7,4) => 256/1, (42,34) => 64/1, (38,38) => -192/1, (34,42) => 128/1, (34,43) => 128/1, (7,7) => -64/1, (11,5) => 256/1, (42,42) => -256/1, (42,43) => 64/1, (11,11) => -64/1, (15,15) => -256/1, (50,50) => -128/1, (50,52) => 192/1, (19,19) => -256/1, (15,23) => 64/1, (23,15) => 256/1, (27,16) => 128/1, (23,23) => -64/1, (19,29) => 64/1, (27,24) => 128/1, (27,27) => -192/1, (19,38) => 64/1, (39,20) => 256/1, (31,31) => -64/1, (35,35) => -256/1, (31,40) => 256/1, (4,4) => -256/1, (4,7) => 64/1, (43,34) => 128/1, (39,39) => -64/1, (35,44) => 64/1, (8,8) => -128/1, (12,9) => 64/1, (43,42) => 128/1, (43,43) => -192/1, (12,12) => -256/1, (8,21) => 192/1, (16,16) => -256/1, (12,22) => 64/1, (51,51) => -256/1, (24,16) => 128/1, (16,24) => 64/1, (20,20) => -256/1, (51,53) => 64/1, (16,27) => 64/1, (28,17) => 384/1, (28,18) => 64/1, (24,24) => -192/1, (36,14) => 128/1, (24,27) => 128/1, (28,25) => 64/1, (28,28) => -96/1, (20,39) => 64/1, (32,32) => -256/1, (32,33) => 64/1, (28,37) => 64/1}))
///


doc ///
    Key
        reynoldsOperator
	(reynoldsOperator,LieAlgebraModule)
    Headline
        computes the projection to the sum of the trivial submodules in $V$
    Usage
        reynoldsOperator(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        M:Matrix
    Description
        Text
	    Let @TT "V"@ be a LieAlgebraModule with representation installed. Suppose that the trivial module $V_0$ occurs with multiplicity $m_0 \geq 1$ in $V$. This function returns a matrix for the projection $V \rightarrow V_0^{\oplus m_0}$. 
	    
	Text
	    This is a special case of the function @TO (casimirProjection,LieAlgebraModule,QQ)@ where the input eigenvalue is $z=0$.
	    
	Example
	    sl3=simpleLieAlgebra("A",2)
	    CB = chevalleyBasis(sl3)
	    V=irreducibleLieAlgebraModule({1,0},sl3)
	    installRepresentation(V,CB,CB#"BasisElements")
	    S2V=symmetricPowerRepresentation(2,V)
	    S3S2V=symmetricPowerRepresentation(3,S2V)
	    reynoldsOperator(S3S2V)
            
///
-- TO DO: Check this result by hand
TEST ///
    sl3=simpleLieAlgebra("A",2);
    CB = chevalleyBasis(sl3);
    V=irreducibleLieAlgebraModule({1,0},sl3);
    installRepresentation(V,CB,CB#"BasisElements");
    S2V=symmetricPowerRepresentation(2,V);
    S3S2V=symmetricPowerRepresentation(3,S2V);
    assert(reynoldsOperator(S3S2V)==dense sparseMatrix(56,56,QQ, new HashTable from {(37,37) => 96/1, (17,17) => 192/1, (17,18) => -96/1, (18,17) => -192/1, (18,18) => 96/1, (17,25) => -96/1, (25,17) => -192/1, (18,25) => 96/1, (25,18) => 96/1, (28,17) => 384/1, (17,28) => 48/1, (18,28) => -48/1, (28,18) => -192/1, (25,25) => 96/1, (25,28) => -48/1, (28,25) => -192/1, (17,37) => -96/1, (37,17) => -192/1, (18,37) => 96/1, (37,18) => 96/1, (28,28) => 96/1, (25,37) => 96/1, (37,25) => 96/1, (37,28) => -48/1, (28,37) => -192/1}))
///

    
-- From basesAsWords.m2

doc ///
    Key
        basisWordsFromMatrixGenerators
	(basisWordsFromMatrixGenerators,LieAlgebraModule)
    Headline
        express each basis element of $V(\lambda)$ as a linear combination of words in the lowering operators applied to the highest weight vector
    Usage
        basisWordsFromMatrixGenerators(V)
    Inputs 
        V:LieAlgebraModule
    Outputs
        L:List
    Description
        Text
	    Irreducible Lie algebra modules are cyclic modules. That is, it is possible to write each element of $V(\lambda)$ as a linear combination of words in the lowering operators applied to the highest weight vector. In particular, we can do this for elements of the basis of $V(\lambda)$ that is used to write the matrix generators of the representation $\rho$.
        Text
	    The output may be parsed as follows. Suppose that we order the lowering operators of $\mathfrak{g}$ as $Y_0,\ldots,Y_k$. Then if the output indicates that $v$ is represented by a word with terms {{{1}, 2}, {{0, 2}, 1}}, this means $v = 2 Y_1.v_\lambda + Y_0.Y_2.v_\lambda$, where $v_\lambda$ represents the highest weight vector.
	Text
	    In the example below, we compute the words that yield the Gelfand-Tsetlin basis for the adjoint representation of $sl_3$.
	    
	Example
            sl3 = simpleLieAlgebra("A",2);
            CB = chevalleyBasis("A",2);
            V=irreducibleLieAlgebraModule({1,1},sl3);
            installRepresentation(V,CB,GTrepresentationMatrices(V));
            basisWordsFromMatrixGenerators(V)
///

-- TO DO: Check this result by hand
TEST ///
    sl3 = simpleLieAlgebra("A",2);
    CB = chevalleyBasis("A",2);
    V=irreducibleLieAlgebraModule({1,1},sl3);
    installRepresentation(V,CB,GTrepresentationMatrices(V));
    L = basisWordsFromMatrixGenerators(V)
    assert(apply(L,w -> w#"Terms") == {{{{}, 1}}, {{{0}, 1}}, {{{2}, 1}}, {{{0, 2}, 1}}, {{{0, 1}, -2}}, {{{1}, 2}, {{0, 2}, 1}}, {{{1, 2}, 3}}, {{{1, 1}, -3/2}}});
///


-- From highestWeightVectorsAndSubmodules.m2

doc ///
    Key
        weightMuHighestWeightVectorsInW
	(weightMuHighestWeightVectorsInW,List,LieAlgebraModule)
    Headline
        computes the highest weight vectors of weight mu in W
    Usage
        weightMuHighestWeightVectorsInW(mu,V)
    Inputs
        mu:List
        V:LieAlgebraModule
    Outputs
        M:Matrix
    Description
        Text
	    A highest weight vector is one that is killed by all the raising operators. We compute the intersection of the kernels of the raising operators restricted to the weight $\mu$ subspace in $W$.
	    
	Text     
            Let $V$ be the adjoint representation of $sl_3$. Then $V$ has highest weight $(1,1)$ and dimension 8, and the multiplicity of $V$ in $W = V \otimes V$ is 2. In the example below, we compute two highest weight vectors of $(1,1)$ in $V \otimes V$.
	    
         
	Example
	    sl3=simpleLieAlgebra("A",2)
	    V=irreducibleLieAlgebraModule({1,1},sl3)
	    CB = chevalleyBasis("A",2);
	    installRepresentation(V,CB,GTrepresentationMatrices(V));
	    W = tensorProductRepresentation(V,V);
	    weightMuHighestWeightVectorsInW({1,1},W)

///

TEST ///
    sl3=simpleLieAlgebra("A",2)
    V=irreducibleLieAlgebraModule({1,1},sl3)
    CB = chevalleyBasis("A",2);
    installRepresentation(V,CB,GTrepresentationMatrices(V));
    W = tensorProductRepresentation(V,V);
    assert(weightMuHighestWeightVectorsInW({1,1},W)==map(QQ^64,QQ^2,{{0, 0}, {0, 0}, {0, 0}, {1/2, 3/2}, {0, 0}, {1/2, -1/2}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {-1, -3}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {-2, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {1, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 1}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}}))
///






doc ///
    Key
        VInSymdW
	(VInSymdW,LieAlgebraModule,ZZ,LieAlgebraModule,Matrix)
    Headline
        computes a basis of a submodule of $\operatorname{Sym}^d W$ isomorphic to $V$ with a given highest weight vector  
    Usage
        VInSymdW(V,d,W,hwv)
    Inputs 
        V:LieAlgebraModule
	d:ZZ
	W:LieAlgebraModule
	hwv:Matrix
    Outputs
        L:List
    Description
        Text
	    Suppose that an irreducible module $V$ appears in the decomposition of $\operatorname{Sym}^d W$ with multiplicity at least one. Then we can find a highest weight vector using @TO (weightMuHighestWeightVectorsInW,List,LieAlgebraModule)@, and then compute a basis of a submodule in $\operatorname{Sym}^d W$ isomorphic to $V$. The basis elements are expressed as polynomials in the basis of $W$ used to define the matrix generators of the representation on $W$.
	    
	Text     
            We compute the degree four invariant for plane cubics by finding a trivial submodule in $  \operatorname{Sym}^4 \operatorname{Sym}^3 \mathbb{C}^3$.  
	Example
	    sl3=simpleLieAlgebra("A",2);
	    CB = chevalleyBasis("A",2);
	    V=irreducibleLieAlgebraModule({1,0},sl3);
	    installRepresentation(V,CB,CB#"BasisElements");
	    S3V = symmetricPowerRepresentation(3,V);
	    S4S3V = symmetricPowerRepresentation(4,S3V);
	    hwv = weightMuHighestWeightVectorsInW({0,0},S4S3V); 
	    remove(S4S3V.cache,representation);
	    V0=irreducibleLieAlgebraModule({0,0},sl3);
	    installRepresentation(V0,CB,GTrepresentationMatrices(V0));
	    L = VInSymdW(V0,4,S3V,hwv)
        Text
	    Note: this polynomial appears as early as 1856 in work of Cayley, who attributes it to Salmon. See Cayley, "A third memoir upon quantics", tables 62 and 63. 
///


TEST ///
    sl3=simpleLieAlgebra("A",2);
    CB = chevalleyBasis("A",2);
    V=irreducibleLieAlgebraModule({1,0},sl3);
    installRepresentation(V,CB,CB#"BasisElements");
    S3V = symmetricPowerRepresentation(3,V);
    S4S3V = symmetricPowerRepresentation(4,S3V);
    hwv = weightMuHighestWeightVectorsInW({0,0},S4S3V); 
    remove(S4S3V.cache,representation);
    V0=irreducibleLieAlgebraModule({0,0},sl3);
    installRepresentation(V0,CB,GTrepresentationMatrices(V0));
    L = VInSymdW(V0,4,S3V,hwv);
    assert(L=={B_0*B_3*B_7*B_9-B_0*B_3*B_8^2-B_0*B_4*B_6*B_9+B_0*B_4*B_7*B_8+B_0*B_5*B_6*B_8-B_0*B_5*B_7^2-B_1^2*B_7*B_9+B_1^2*B_8^2+B_1*B_2*B_6*B_9-B_1*B_2*B_7*B_8+B_1*B_3*B_4*B_9-B_1*B_3*B_5*B_8-2*B_1*B_4^2*B_8+3*B_1*B_4*B_5*B_7-B_1*B_5^2*B_6-B_2^2*B_6*B_8+B_2^2*B_7^2-B_2*B_3^2*B_9+3*B_2*B_3*B_4*B_8-B_2*B_3*B_5*B_7-2*B_2*B_4^2*B_7+B_2*B_4*B_5*B_6+B_3^2*B_5^2-2*B_3*B_4^2*B_5+B_4^4})
///






doc ///
    Key
        VInWedgekW
	(VInWedgekW,LieAlgebraModule,ZZ,LieAlgebraModule,Matrix)
    Headline
        computes a basis of a submodule of $\bigwedge^k W$ isomorphic to $V$ with a given highest weight vector  
    Usage
        VInWedgekW(V,k,W,hwv)
    Inputs 
        V:LieAlgebraModule
	k:ZZ
	W:LieAlgebraModule
	hwv:Matrix
    Outputs
        L:List
    Description
        Text
	    Suppose that an irreducible module $V$ appears in the decomposition of $\bigwedge^k W$ with multiplicity at least one. Then we can find a highest weight vector using @TO (weightMuHighestWeightVectorsInW,List,LieAlgebraModule)@, and then compute a basis of a submodule in $\bigwedge^k W$ isomorphic to $V$. The basis elements are expressed as linear polynomials in the Plucker coordinates.
	    
	Text     
            In the example below, let $V$ be the standard representation for $sl_4$. Then $\bigwedge^3 \bigwedge^2 V$ contains an irreducible submodule with highest weight $(2,0,0)$. We compute a basis for this submodule explicitly.
         
	Example
	    sl4=simpleLieAlgebra("A",3);
	    V= standardModule(sl4);
	    CB = chevalleyBasis("A",3);
	    installRepresentation(V,CB,CB#"BasisElements");
	    W2V = exteriorPowerRepresentation(2,V);
	    W3W2V = exteriorPowerRepresentation(3,W2V);
	    hwv = weightMuHighestWeightVectorsInW({2,0,0},W3W2V)
	    remove(W3W2V.cache,representation);
	    V=irreducibleLieAlgebraModule({2,0,0},sl4);
	    installRepresentation(V,CB,GTrepresentationMatrices(V));
	    L = VInWedgekW(V,3,W2V,hwv)
///

TEST ///
    sl4=simpleLieAlgebra("A",3);
    V= standardModule(sl4);
    CB = chevalleyBasis("A",3);
    installRepresentation(V,CB,CB#"BasisElements");
    W2V = exteriorPowerRepresentation(2,V);
    W3W2V = exteriorPowerRepresentation(3,W2V);
    hwv = weightMuHighestWeightVectorsInW({2,0,0},W3W2V)
    remove(W3W2V.cache,representation)
    V=irreducibleLieAlgebraModule({2,0,0},sl4);
    installRepresentation(V,CB,GTrepresentationMatrices(V));
    L = VInWedgekW(V,3,W2V,hwv)
    assert(L=={p_{0, 1, 3}, p_{0, 2, 3}+p_{0, 1, 4}, 2*p_{0, 2, 4}, 3*p_{1, 2, 3}+3*p_{0, 1, 5}, 3*p_{1, 2, 4}+3*p_{0, 2, 5}, 12*p_{1, 2, 5}, -12*p_{1, 3, 4}+12*p_{0, 3, 5}, -12*p_{2, 3, 4}+12*p_{0, 4, 5}, -24*p_{2, 3, 5}+24*p_{1, 4, 5}, 144*p_{3, 4, 5} })
///


doc ///
    Key
        UInVtensorW
	(UInVtensorW,LieAlgebraModule,LieAlgebraModule,LieAlgebraModule,Matrix)
    Headline
        computes a basis of a submodule of $V \otimes W$ isomorphic to $U$ with a given highest weight vector  
    Usage
        UInVtensorW(U,V,W,hwv)
    Inputs
        U:LieAlgebraModule
        V:LieAlgebraModule
	W:LieAlgebraModule
	hwv:Matrix
    Outputs
        L:List
    Description
        Text
	    Suppose that an irreducible module $U$ appears in the decomposition of $V \otimes W$ with multiplicity at least one. Then we can find a highest weight vector using @TO (weightMuHighestWeightVectorsInW,List,LieAlgebraModule)@, and then compute a basis of a submodule in $V \otimes W$ isomorphic to $U$. The basis elements are expressed as polynomials in two sets of variables corresponding to bases of $V$ and $W$, respectively.
	    
	Text     
            Let $V$ be the adjoint representation of $sl_3$, and let $W$ be the standard representation. Then $V \otimes W$ contains a submodule with highest weight $(0,2)$. We compute an explicit basis for this submodule. 
         
	Example
	    sl3=simpleLieAlgebra("A",2);
	    CB = chevalleyBasis("A",2);
	    V = irreducibleLieAlgebraModule({1,1},sl3);
	    installRepresentation(V,CB,GTrepresentationMatrices(V));
	    W = irreducibleLieAlgebraModule({1,0},sl3);
	    installRepresentation(W,CB,GTrepresentationMatrices(W));
	    T = tensorProductRepresentation(V,W);
	    hwv = weightMuHighestWeightVectorsInW({0,2},T)
	    remove(T.cache,representation);
	    U = irreducibleLieAlgebraModule({0,2},sl3);
	    installRepresentation(U,CB,GTrepresentationMatrices(U));
	    L = UInVtensorW(U,V,W,hwv)
///

TEST ///
    sl3=simpleLieAlgebra("A",2);
    CB = chevalleyBasis("A",2);
    V = irreducibleLieAlgebraModule({1,1},sl3);
    installRepresentation(V,CB,GTrepresentationMatrices(V));
    W = irreducibleLieAlgebraModule({1,0},sl3);
    installRepresentation(W,CB,GTrepresentationMatrices(W));
    T = tensorProductRepresentation(V,W);
    hwv = weightMuHighestWeightVectorsInW({0,2},T)
    remove(T.cache,representation);
    U = irreducibleLieAlgebraModule({0,2},sl3);
    installRepresentation(U,CB,GTrepresentationMatrices(U));
    L = UInVtensorW(U,V,W,hwv)
    assert(L == {-A_0*B_1+A_1*B_0, -(1/2)*A_0*B_2-A_2*B_1+(1/2)*A_3*B_0+(1/2)*A_5*B_0, -(1/2)*A_1*B_2-(1/2)*A_3*B_1+(1/2)*A_4*B_0+(1/2)*A_5*B_1, -A_2*B_2+(2/3)*A_6*B_0, -A_3*B_2+(2/3)*A_6*B_1+(2/3)*A_7*B_0, -A_4*B_2+(4/3)*A_7*B_1})
///




undocumented ( {
    (describe,LieAlgebra),(expression,LieAlgebra),(net,LieAlgebra),(texMath,LieAlgebra),
    (describe,LieAlgebraModule),(expression,LieAlgebraModule),(net,LieAlgebraModule),(texMath,LieAlgebraModule),
    (symbol ==,LieAlgebraModule,LieAlgebraModule), (symbol ==,LieAlgebraModule,ZZ),
    (NewFromMethod,LieAlgebraModule,Sequence),
    (symbol ^,LieAlgebraModule,QQ),
    (irreducibleLieAlgebraModule,LieAlgebra,ZZ), (irreducibleLieAlgebraModule,LieAlgebra,VisibleList), (irreducibleLieAlgebraModule,LieAlgebra,Expression), (irreducibleLieAlgebraModule,Thing,LieAlgebra),
    (dynkinDiagram,String,ZZ),(cartanMatrix,String,ZZ),(cartanMatrix,Sequence,Sequence),(isSimple,String,ZZ),isSimple,(isSimple,LieAlgebra),
    (dim,LieAlgebra),(rank,LieAlgebra),
    (character,String,ZZ,List),(character,Sequence,Sequence,List),
    (dynkinDiagram,String,ZZ,ZZ),
    (positiveRoots,Sequence,Sequence),(positiveRoots,String,ZZ),(positiveCoroots,Sequence,Sequence),(positiveCoroots,String,ZZ),
    (killingForm,String,ZZ,List,List),(killingForm,Sequence,Sequence,List,List),
    (starInvolution,List,LieAlgebra),(starInvolution,Vector,LieAlgebra),(starInvolution,LieAlgebra,List),(starInvolution,LieAlgebra,Vector),(starInvolution,String,ZZ,List),(starInvolution,Sequence,Sequence,List),
    (casimirScalar,String,ZZ,List),(casimirScalar,Sequence,Sequence,List),
    (highestRoot,String,ZZ),(highestRoot,Sequence,Sequence)
    })


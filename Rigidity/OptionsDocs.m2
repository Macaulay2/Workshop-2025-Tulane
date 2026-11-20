-- This documentation was made by ChatGPT and verified by Griffin
-- The function-specific option keys are documented in the existing function nodes.

doc ///
    Key
        Field
    Headline
        selects the field for the local and global rigidity computation
    Usage
        isLocallyRigid(d, G, Field => K)
        isGloballyRigid(d, G, Field => K)
    Inputs
        K : Ring
            a field, or ZZ to request symbolic computation
    Description
        Text
            This option is used by @TO isLocallyRigid@ and @TO isGloballyRigid@. Its default value is @TO ZZ@, which requests a symbolic rank calculation over the rational coordinate ring. The value ZZ is a selector for this symbolic calculation; it does not request random integer coordinates.

            When a field such as @TO QQ@, @TO RR@, or a finite field is supplied,
            the rigidity matrix is evaluated at random coordinates in that field. Exact fields use exact rank computations. Inexact fields use @TO numericalRank@. The number of trials is controlled by @TO Iterations@.

            The global rigidity evaluation may also encounter division by zero when a symbolic stress denominator specializes to zero.
        Example
            (options isLocallyRigid)#Field
            E = {{0,1},{0,2},{1,2}};
            isLocallyRigid(2, E, Field => QQ, Iterations => 5)
    SeeAlso
        isLocallyRigid
        isGloballyRigid
        FiniteField
        Iterations
///

doc ///
    Key
        FiniteField
    Headline
        selects the computation mode or finite field
    Usage
        isSpanningInSymmetricCompletionMatroid(r, n, E, FiniteField => q)
        isSpanningInSkewSymmetricCompletionMatroid(r, n, E, FiniteField => q)
    Inputs
        q : ZZ
            a prime power, or a special value described below
    Description
        Text
            The default is 0. The value 0 disables finite-field evaluation. In that case the calculation is symbolic unless @TT "Numerical => true"@ is supplied. A prime power q selects GF(q) and takes precedence over @TO Numerical@.

            Randomized calculations use up to @TO Iterations@ trials and return true if any trial attains the required rank. Specialization and reduction modulo a prime can lower the rank. A false result can therefore require further trials or verification by symbolic computation.
        Example
            (options isSpanningInSymmetricCompletionMatroid)#FiniteField
            E = {{0,1},{0,2},{1,2}};
            isSpanningInSkewSymmetricCompletionMatroid(2, 3, E, FiniteField => 101)
    Caveat
        Use odd characteristic for symmetric completion: the Jacobian of the
        Gram parametrization degenerates in characteristic 2. Repeated trials
        in a fixed characteristic do not resolve rank loss caused by that
        characteristic.
    SeeAlso
        isSpanningInSymmetricCompletionMatroid
        isSpanningInSkewSymmetricCompletionMatroid
        Numerical
        Iterations
///

doc ///
    Key
        Iterations
    Headline
        specifies the number of randomized trials
    Usage
        isLocallyRigid(d, G, Field => K, Iterations => k)
        isGloballyRigid(d, G, Field => K, Iterations => k)
        isSpanningInSymmetricCompletionMatroid(r, n, E, Numerical => true, Iterations => k)
        isSpanningInSkewSymmetricCompletionMatroid(r, n, E, Numerical => true, Iterations => k)
    Inputs
        k : ZZ
            a positive integer; the default is 3
    Description
        Text
            This option specifies how many random specializations are attempted.
            It is ignored when the computation is symbolic or the result is
            determined without random trials.

            For @TO isLocallyRigid@ over an exact field, a successful trial
            suffices. Over an inexact field, a strict majority of trials must
            succeed; a tie returns false. For the two
            completion-matroid spanning tests, a successful trial suffices.

            Additional trials can reduce failures due to nongeneric sample
            points. They do not eliminate rank loss inherent in a fixed
            characteristic or numerical errors from finite precision.
        Example
            (options isLocallyRigid)#Iterations
            E = {{0,1},{0,2},{1,2}};
            isLocallyRigid(2, E, Field => QQ, Iterations => 5)
    SeeAlso
        Field
        FiniteField
        Numerical
        isLocallyRigid
        isGloballyRigid
        isSpanningInSymmetricCompletionMatroid
        isSpanningInSkewSymmetricCompletionMatroid
///

doc ///
    Key
        Numerical
    Headline
        requests random rational evaluation for completion-matroid tests
    Usage
        isSpanningInSymmetricCompletionMatroid(r, n, E, Numerical => b)
        isSpanningInSkewSymmetricCompletionMatroid(r, n, E, Numerical => b)
    Inputs
        b : Boolean
            whether to use random rational evaluation; the default is false
    Description
        Text
            This option is used by @TO isSpanningInSymmetricCompletionMatroid@ and @TO isSpanningInSkewSymmetricCompletionMatroid@. When true, the completion matrix is evaluated at random rational coordinates and its rank is computed exactly over @TO QQ@. When false, the rank is computed symbolically, provided @TT "FiniteField => 0"@.

            A nonzero @TO FiniteField@ option selects finite-field evaluation regardless of this option. The number of random rational trials is controlled by @TO Iterations@. One trial attaining the target rank suffices for a true result; a false result may reflect nongeneric
            sample points.
        Example
            (options isSpanningInSymmetricCompletionMatroid)#Numerical
            E = {{0,1},{0,2},{1,2}};
            isSpanningInSymmetricCompletionMatroid(1, 3, E, Numerical => true, Iterations => 5)
    SeeAlso
        isSpanningInSymmetricCompletionMatroid
        isSpanningInSkewSymmetricCompletionMatroid
        FiniteField
        Iterations
///

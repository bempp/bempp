#pylint: disable-msg=too-many-arguments

"""Definition of sparse boundary operators."""


def identity(domain, range_, dual_to_range,
             label="IDENTITY", symmetry='no_symmetry',
             parameters=None):
    """Return the identity operator."""

    import bempp
    from bempp.core.operators.boundary.sparse import identity_ext
    from bempp.api.assembly import LocalBoundaryOperator

    if parameters is None:
        parameters = bempp.api.global_parameters

    return LocalBoundaryOperator(\
            identity_ext(parameters, domain, range_,
                         dual_to_range, "", symmetry),
            parameters=parameters, label=label)

def maxwell_identity(space,
                     label="MAXWELL_IDENTITY", symmetry='no_symmetry',
                     parameters=None):
    """Return the Maxwell identity operator."""

    import bempp
    from bempp.core.operators.boundary.sparse import maxwell_identity_ext
    from bempp.api.assembly import LocalBoundaryOperator

    if parameters is None:
        parameters = bempp.api.global_parameters

    return LocalBoundaryOperator(\
            maxwell_identity_ext(parameters, space, space,
                                 space, "", symmetry),
            parameters=parameters, label=label)

def laplace_beltrami(domain, range_, dual_to_range,
                     label="LAPLACE_BELTRAMI", symmetry='no_symmetry',
                     parameters=None):
    """Return the Laplace-Beltrami operator."""

    import bempp
    from bempp.core.operators.boundary.sparse import laplace_beltrami_ext
    from bempp.api.assembly import LocalBoundaryOperator

    if parameters is None:
        parameters = bempp.api.global_parameters

    return LocalBoundaryOperator(\
            laplace_beltrami_ext(parameters, domain, range_,
                                 dual_to_range, "", symmetry),
            parameters=parameters, label=label)


#cython: embedsignature=True

from bempp.utils.parameter_list cimport c_ParameterList, ParameterList
from bempp.space.space cimport SpaceVariants,Space
from libcpp.string cimport string
from bempp.utils.enum_types cimport symmetry_mode
from bempp.assembly.boundary_operator cimport GeneralBoundaryOperator,DenseBoundaryOperator,BoundaryOpVariants
from cython.operator cimport dereference as deref
from bempp.utils.byte_conversion import convert_to_bytes
from bempp.utils.enum_types cimport symmetry_mode
from bempp.utils cimport complex_float, complex_double, catch_exception
from bempp import global_parameters
import numpy as np
cimport numpy as np

cdef extern from "bempp/operators/py_operators.hpp" namespace "Bempp":
    BoundaryOpVariants c_maxwellSingleLayerOperator "Bempp::c_maxwellSingleLayerOperator<double>"(
            const c_ParameterList&,
            const SpaceVariants&,
            const SpaceVariants&,
            const SpaceVariants&,
            complex_double,
            const string&,
            int) except+catch_exception

cdef extern from "bempp/operators/py_operators.hpp" namespace "Bempp":
    BoundaryOpVariants c_maxwellDoubleLayerOperator "Bempp::c_maxwellDoubleLayerOperator<double>"(
            const c_ParameterList&,
            const SpaceVariants&,
            const SpaceVariants&,
            const SpaceVariants&,
            complex_double,
            const string&,
            int) except+catch_exception


def single_layer(Space domain, Space range, Space dual_to_range,
        object wave_number, 
        object label="", object symmetry="auto_symmetry",
        object parameters=None):
    """

    Return the Maxwell single layer boundary operator.

    """

    cdef ParameterList local_parameters
    cdef GeneralBoundaryOperator bop

    if not len({domain.dtype,range.dtype,dual_to_range.dtype})==1:
        raise ValueError("All spaces must have the same data type")

    if parameters is None:
        local_parameters = global_parameters
    else:
        if not isinstance(parameters,ParameterList):
            raise ValueError("parameters must be of type bempp.ParameterList")
        local_parameters = parameters

    cdef complex_double c_wave_number = complex_double(
            np.real(wave_number),np.imag(wave_number))

    bop = GeneralBoundaryOperator("float64","complex128",
            local_parameters)
    bop.operator_type = 'synthetic'

    bop.impl_.assign(
            c_maxwellSingleLayerOperator(
                deref(local_parameters.impl_),domain.impl_,
                range.impl_,dual_to_range.impl_,
                c_wave_number, convert_to_bytes(label),
                symmetry_mode(convert_to_bytes(symmetry))))

    return bop

def double_layer(Space domain, Space range, Space dual_to_range,
        object wave_number, 
        object label="", object symmetry="auto_symmetry",
        object parameters=None):
    """

    Return the Maxwell double layer boundary operator.

    """

    cdef ParameterList local_parameters
    cdef GeneralBoundaryOperator bop

    if not len({domain.dtype,range.dtype,dual_to_range.dtype})==1:
        raise ValueError("All spaces must have the same data type")

    if parameters is None:
        local_parameters = global_parameters
    else:
        if not isinstance(parameters,ParameterList):
            raise ValueError("parameters must be of type bempp.ParameterList")
        local_parameters = parameters

    cdef complex_double c_wave_number = complex_double(
            np.real(wave_number),np.imag(wave_number))

    bop = GeneralBoundaryOperator("float64","complex128",
            local_parameters)
    bop.operator_type = 'synthetic'

    bop.impl_.assign(
            c_maxwellDoubleLayerOperator(
                deref(local_parameters.impl_),domain.impl_,
                range.impl_,dual_to_range.impl_,
                c_wave_number, convert_to_bytes(label),
                symmetry_mode(convert_to_bytes(symmetry))))

    return bop






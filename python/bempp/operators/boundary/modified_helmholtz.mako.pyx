#cython: embedsignature=True
<%
from data_types import dtypes, compatible_dtypes, ctypes, scalar_cython_type
op_names = [('single_layer','c_modifiedHelmholtz3dSingleLayerBoundaryOperator',
             'Return the modified Helmholtz single layer boundary operator.'),
            ('double_layer','c_modifiedHelmholtz3dDoubleLayerBoundaryOperator',
             'Return the modified Helmholtz double layer boundary operator.'),
            ('adjoint_double_layer','c_modifiedHelmholtz3dAdjointDoubleLayerBoundaryOperator',
             'Return the modified Helmholtz adjoint double layer boundary operator.'),
            ('hypersingular','c_modifiedHelmholtz3dHypersingularBoundaryOperator',
              'Return the modified Helmholtz hypersingular boundary operator.')]

%>

__all__=['single_layer','double_layer','adjoint_double_layer','hypersingular']

from bempp.utils.parameter_list cimport c_ParameterList, ParameterList
from bempp.space.space cimport SpaceVariants,Space
from libcpp.string cimport string
from bempp.utils.enum_types cimport symmetry_mode
from bempp.assembly.boundary_operator cimport GeneralBoundaryOperator,DenseBoundaryOperator,BoundaryOpVariants
from cython.operator cimport dereference as deref
from bempp.utils.byte_conversion import convert_to_bytes
from bempp.utils.enum_types cimport symmetry_mode
from bempp.utils cimport complex_float, complex_double
from bempp import global_parameters
import numpy as np
cimport numpy as np

% for pyname,c_name,help_text in op_names:
def ${pyname}(Space domain, Space range, Space dual_to_range,
        object wave_number,
        object label="", object symmetry="auto_symmetry", 
        object parameters=None):
    """

    ${help_text}

    """

    cdef ParameterList local_parameters
    cdef GeneralBoundaryOperator bop 
% if pyname=='hypersingular':
    cdef object operator_type = 'synthetic'
% else:
    cdef object operator_type = 'standard'
% endif

% for pyresult,cyresult in dtypes.items():
    cdef ${scalar_cython_type(cyresult)} cy_wave_number_${pyresult}
    cdef ${cyresult} c_wave_number_${pyresult}
% endfor

    if not len({domain.dtype,range.dtype,dual_to_range.dtype})==1:
        raise ValueError("All spaces must have the same data type")

    if parameters is None:
        local_parameters = global_parameters
    else:
        if not isinstance(parameters,ParameterList):
            raise ValueError("parameters must be of type bempp.ParameterList")
        local_parameters = parameters

    basis_type = domain.dtype

    result_type = None

    if np.iscomplexobj(wave_number):
        result_type = 'complex128'
    else:
        result_type = 'float64'

% for pybasis, cybasis in dtypes.items():
%     for pyresult, cyresult in dtypes.items():
%         if pyresult in compatible_dtypes[pybasis]:


    if basis_type=="${pybasis}" and result_type=="${pyresult}":

        cy_wave_number_${pyresult} = wave_number
        c_wave_number_${pyresult} = deref(<${cyresult}*>&cy_wave_number_${pyresult})
        bop = GeneralBoundaryOperator(basis_type,result_type,
                local_parameters)

% if pyname=='hypersingular':
        bop.operator_type = 'synthetic'
% else:
        bop.operator_type = 'standard'
% endif

        bop.impl_.assign(
            ${c_name}[${cybasis},${cyresult}](
            deref(local_parameters.impl_),domain.impl_,range.impl_,
            dual_to_range.impl_, c_wave_number_${pyresult}, convert_to_bytes(label),
            symmetry_mode(convert_to_bytes(symmetry))))

        return bop

%           endif
%       endfor
% endfor

    raise ValueError("Wrong basis_type or result_type")


% endfor

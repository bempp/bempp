from cython.operator cimport dereference as deref
from bempp.core.utils.shared_ptr cimport shared_ptr
from bempp.core.utils.eigen cimport Vector
from bempp.core.utils.eigen cimport eigen_vector_to_np_float64


cdef class ChebychevTools:

    def __cinit__(self, int order):
        pass

    def __init__(self, int order):
        self.impl_.assign(shared_ptr[c_ChebychevTools](new c_ChebychevTools(order)))

    def __dealloc__(self):
        self.impl_.reset()

    def chebychev_nodes(self):
        """Compute the Chebychev nodes"""

        cdef Vector[double] nodes
        deref(self.impl_).chebychevNodes(nodes)
        return eigen_vector_to_np_float64(nodes)





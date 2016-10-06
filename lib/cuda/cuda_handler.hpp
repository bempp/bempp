// Copyright (C) 2011-2012 by the BEM++ Authors
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#include "../common/common.hpp"

#ifndef fiber_cuda_handler_hpp
#define fiber_cuda_handler_hpp

#define __CUDA_ENABLE_EXCEPTIONS

#include "cuda_options.hpp"
#include "types.hpp"

namespace Fiber {

#ifdef WITH_CUDA

class CUDAHandler {
public:
  /**
   * \brief Default constructor.
   * Initializes CUDA context and automatically chooses platform and device
   */
  CUDAHandler(const bool useCUDA, const CUDAOptions &options);

  /**
   * Default destructor.
   * Releases CUDA objects and frees device memory
   */
  ~CUDAHandler();

  bool UseCUDA() const { return useCUDA; }

  /**
   * \brief Push the mesh geometry to device memory
   * \param vtx mesh vertices
   * \param idx element corner indices
   */
  template <typename CoordinateType, typename IndexType>
  void pushGeometry(const Matrix<CoordinateType> &vtx,
                    const Matrix<IndexType> &idx) const;

  struct MeshGeom {
    struct MeshDims {
      int dim;  ///< Mesh dimension
      int nVtx; ///< Number of vertices
      int nEls; ///< Number of elements
      int nIdx; ///< Max number of indices per element
    } size;
    thrust::device_vector cu_vtx; ///< Mesh geometry: vertex list
    thrust::device_vector cu_els;  ///< Mesh geometry: node index list
  };

  const MeshGeom &meshGeom() const { return meshGeom; }

private:

  bool useCUDA;
  unsigned int deviceUsed;

  MeshGeom meshGeom;
};

#else

// Dummy implementation for the CUDA handler

class CUDAHandler {
public:
  CUDAHandler(const bool useCUDA, const CUDAOptions &options) {}

  bool UseCUDA() const { return false; }

  template <typename CoordinateType, typename IndexType>
  void pushGeometry(const Matrix<CoordinateType> &vtx,
                    const Matrix<IndexType> &idx) const {}
};

#endif // WITH_CUDA

} // namespace Fiber

#endif // fiber_cuda_handler_hpp

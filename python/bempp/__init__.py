""" Boundary Element Method package BEM++ """

__all__=['grid_from_sphere',
         'grid_from_element_data',
         'structured_grid',
         'function_space',
         'GridFunction',
         'global_parameters',
         'BlockedBoundaryOperator',
         'ZeroBoundaryOperator',
         'export',
         'GridFactory',
         'import_grid',
         'operators',
         'shapes',
         'applications',
         'FileReader',
         'generate_block_cluster_tree',
         'InverseSparseDiscreteBoundaryOperator']

# This imports dolfin at the same time as bempp if available to avoid delays
# at later imports of dolfin

try:
    import dolfin
except:
    have_dolfin = False
else:
    have_dolfin = True


# Check if config directory exists. If not create it.

def _check_create_init_dir():
    from os.path import expanduser, join, isdir
    from os import mkdir
    

    home = expanduser("~")
    config_path = join(home,".bempp")
    tmp_path = join(config_path,"tmp")

    if not isdir(config_path):
        mkdir(config_path)
    if not isdir(tmp_path):
        mkdir(tmp_path)

    return (config_path, tmp_path)

config_path, tmp_path = _check_create_init_dir()

# Get the path to Gmsh

def _gmsh_path():
    from .utils import which

    gmsh_path = which("gmsh")
    if gmsh_path is None:
        print("Could not find Gmsh. Interactive plotting and shapes module not available.")
    return gmsh_path

gmsh_path = _gmsh_path()


# Define the global default options

from .common import global_parameters as __global_parameters
global_parameters = __global_parameters()

# Now all the module imports

from bempp.grid import Grid,grid_from_sphere,grid_from_element_data, structured_grid
from bempp.assembly import GridFunction
from bempp.assembly import BlockedBoundaryOperator, InverseSparseDiscreteBoundaryOperator, ZeroBoundaryOperator
from bempp.space import function_space
from bempp.file_interfaces import FileReader, import_grid, export
from bempp.grid import GridFactory
from bempp.hmat import generate_block_cluster_tree
from bempp import operators
from bempp import shapes
from bempp import applications

def test():
    """ Runs BEM++ python unit tests """
    from py.test import main
    from os.path import dirname
    main(dirname(__file__))

#ifndef bempp_p1_entity_hpp
#define bempp_p1_entity_hpp

#include "../../../common/common.hpp"
#include "../bempp_grid_types.hpp"
#include "p1_geometry.hpp"
#include "p1_entity_seed.hpp"
#include <dune/grid/common/gridenums.hh>
#include <dune/grid/common/geometry.hh>
#include <dune/geometry/type.hh>
#include <dune/grid/common/entity.hh>
#include <dune/grid/common/entityseed.hh>
#include <dune/grid/common/entitypointer.hh>

namespace BemppGrid {

    class P1Grid;
    class P1DataContainer;
    class P1LevelIndexSetImp;

    template <int cd, int dim, class GridImp>
    class P1EntityImp {};

    template <int codim, class>
    class P1EntityPointerImp;

    // Elements
    template<>
    class P1EntityImp<0, 2, const P1Grid> : 
    public Dune::EntityDefaultImplementation<0, 2, const P1Grid, P1EntityImp>  {

        friend class P1EntitySeedImp<0, const P1Grid>;
        friend class P1EntityPointerImp<0, const P1Grid>;
        friend class P1Grid;

        public:

            typedef typename P1Grid::GridFamily::Traits::Codim<0>::Geometry Geometry;
            typedef typename P1Grid::GridFamily::Traits::Codim<0>::Entity Entity;    

            typedef Dune::EntitySeed<const P1Grid, P1EntitySeedImp<0, const P1Grid>> EntitySeed;
            template <int codim> using 
                EntityPointer = Dune::EntityPointer<const P1Grid, P1EntityPointerImp<codim, const P1Grid>>;

            P1EntityImp(const shared_ptr<P1DataContainer>& data, 
                    int level, std::size_t index);

            int level() const;
            Geometry geometry() const;
            Dune::GeometryType type() const;
            Dune::PartitionType partitionType() const;
            bool equals(const P1EntityImp<0, 2, const P1Grid>& other) const;
            EntitySeed seed() const; 

            template<int cd>
            EntityPointer<cd> subEntity(int i) const;

            template <int cc>
            int count() const;

            bool hasFather() const;
            bool isLeaf() const;
            bool isRegular() const;
            bool isNew() const;

            EntityPointer<0> father() const;

        private:

            P1EntityImp() {}

            shared_ptr<P1DataContainer> m_data;
            int m_level;
            std::size_t m_index;

    };

    // Edges
    template<>
    class P1EntityImp<1, 2, const P1Grid> : 
    public Dune::EntityDefaultImplementation<1, 2, const P1Grid, P1EntityImp> {

        friend class P1EntityPointerImp<1, const P1Grid>;
        friend class P1Grid;

        public:
            typedef Dune::EntitySeed<const P1Grid, P1EntitySeedImp<1, const P1Grid>> EntitySeed;
            typedef typename P1Grid::GridFamily::Traits::Codim<1>::Geometry Geometry;
            typedef typename P1Grid::GridFamily::Traits::Codim<1>::Entity Entity;    

            P1EntityImp(const shared_ptr<P1DataContainer>& data,
                    int level, std::size_t index);

            int level() const;
            Geometry geometry() const;
            Dune::GeometryType type() const;
            Dune::PartitionType partitionType() const;
            bool equals(const P1EntityImp<1, 2, const P1Grid>& other) const;
            EntitySeed seed() const;

        private:

            P1EntityImp() {}

            shared_ptr<P1DataContainer> m_data;
            int m_level;
            std::size_t m_index;

    };

    // Vertices
    template<>
    class P1EntityImp<2, 2, const P1Grid> :
    public Dune::EntityDefaultImplementation<2, 2, const P1Grid, P1EntityImp> {

        friend class P1EntityPointerImp<2, const P1Grid>;
        friend class P1Grid;

        public:
            typedef Dune::EntitySeed<const P1Grid, P1EntitySeedImp<2, const P1Grid>> EntitySeed;
            typedef typename P1Grid::GridFamily::Traits::Codim<2>::Geometry Geometry;
            typedef typename P1Grid::GridFamily::Traits::Codim<2>::Entity Entity;    

            P1EntityImp(const shared_ptr<P1DataContainer>& data,
                    int level, std::size_t index);

            int level() const;
            Geometry geometry() const;
            Dune::GeometryType type() const;
            Dune::PartitionType partitionType() const;
            bool equals(const P1EntityImp<2, 2, const P1Grid>& other) const;
            EntitySeed seed() const;

        private:

            P1EntityImp() {}

            shared_ptr<P1DataContainer> m_data;
            int m_level;
            std::size_t m_index;
    };

}

#include "p1_entity_impl.hpp"

#endif

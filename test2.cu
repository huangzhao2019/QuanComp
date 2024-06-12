#include <cuda.h>
#include <cassert>

#if defined(FEATURE_BLS12_381)
# include <ff/bls12-381.hpp>
#else
# error "no FEATURE"
#endif

#include <ec/jacobian_t.hpp>
#include <ec/xyzz_t.hpp>

typedef jacobian_t<fp_t> point_t;
typedef xyzz_t<fp_t> bucket_t;
typedef bucket_t::affine_inf_t affine_t;
typedef fr_t scalar_t;

#include <iostream>
#include <fstream>
#include <tuple>
using namespace std;

tuple<scalar_t*, affine_t*> readData(size_t npoints) {
    ifstream file_obj;
    scalar_t* scalars = new scalar_t[npoints];
    affine_t* points = new affine_t[npoints];
    string fname = "./data/affine_t_" + to_string(npoints) + ".dat";
    file_obj.open(fname, ios::out | ios::binary);
    for (unsigned i = 0; i < npoints; i++) {
        // file_obj.read((char*)&scalars[i], sizeof(scalars[i]));
        file_obj.read((char*)&points[i], sizeof(points[i]));
    }
    file_obj.close();
    return make_tuple(scalars, points);
}

// int main() {
//     size_t npoints = 1000;
//     scalar_t* scalars = new scalar_t[npoints];
//     affine_t* points = new affine_t[npoints];
//     tie(scalars, points) = readData(npoints);
//     printf("read data done\n");
// }


int main() {
    size_t npoints = 1000;
    scalar_t* scalars = new scalar_t[npoints];
    affine_t* points = new affine_t[npoints];
    tie(scalars, points) = readData(npoints);
    printf("Testing curve on host...");
    for (size_t i = 0; i<npoints; i++) {
        affine_t p = points[i];
        // enable accessors in the source code to make the below lines work
        
        fp_t x = p.return_x();
        fp_t y = p.return_y();


        fp_t const1 = fp_t::one();
        fp_t r = (y*y)-(x*x*x)-(const1+const1+const1+const1);

        assert( r.is_zero() );
    }
}


// @Date    : 2019-05-22 22:08:30
// @Author  : Mengji Zhang (zmj_xy@sjtu.edu.cn)
#include "stdio.h"
#include "stdlib.h"
static void HandleError( cudaError_t err,
                         const char *file,
                         int line ) {
    if (err != cudaSuccess) {
        printf( "%s in %s at line %d\n", cudaGetErrorString( err ),
                file, line );
        exit( EXIT_FAILURE );
    }
}
#define HANDLE_ERROR( err ) (HandleError( err, __FILE__, __LINE__ ))
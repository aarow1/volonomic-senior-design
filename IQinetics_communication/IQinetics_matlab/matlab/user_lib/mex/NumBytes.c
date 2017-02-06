#include "mex.h"
#include <string.h>

/* Gateway function */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double outbytes;
    char *outstring;


/* Check input arguments */
    
	if( nrhs != 1 ) {
        mexErrMsgTxt("NumBytes has exclusively one input.");
	}
	if( nlhs != 1 ) {
        mexErrMsgTxt("NumBytes has exclusively one output.");
	}
	if( !mxIsChar(prhs[0]) ) {
        mexErrMsgTxt("The first input argument must be a character array.");
	}
   
/* Check second input argument for desired output type */
   
   outstring = mxArrayToString(prhs[0]);

   if(        strcmp(outstring,"int8") == 0 ) {
       outbytes = 1;
   } else if( strcmp(outstring,"uint8") == 0 ) {
       outbytes = 1;
   } else if( strcmp(outstring,"int16") == 0 ) {
       outbytes = 2;
   } else if( strcmp(outstring,"uint16") == 0 ) {
       outbytes = 2;
   } else if( strcmp(outstring,"int32") == 0 ) {
       outbytes = 4;
   } else if( strcmp(outstring,"uint32") == 0 ) {
       outbytes = 4;
   } else if( strcmp(outstring,"int64") == 0 ) {
       outbytes = 8;
   } else if( strcmp(outstring,"uint64") == 0 ) {
       outbytes = 8;
   } else if( strcmp(outstring,"double") == 0 ) {
       outbytes = 8;
   } else if( strcmp(outstring,"single") == 0 ) {
       outbytes = 4;
   } else if( strcmp(outstring,"char") == 0 ) {
       outbytes = 2;
   } else if( strcmp(outstring,"logical") == 0 ) {
       outbytes = 1;
   } else {
       mxFree(outstring);
       mexErrMsgTxt("Unsupported class.\n");
   }
   mxFree(outstring);
   
   plhs[0] = mxCreateDoubleScalar(outbytes); 
}

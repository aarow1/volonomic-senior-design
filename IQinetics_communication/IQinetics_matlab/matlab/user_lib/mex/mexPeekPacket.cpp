// mex initPF.c CFLAGS="\$CFLAGS -std=c99" -I/home/ujb/Projects/pry_software/packet_utils/c/inc/


#include "mex.h"
#include <string.h>

#include "crc_helper.h"
#include "packet_finder.h"
#include "byte_queue.h"

#define PF_INDEX_DATA_SIZE 20   // size of index buffer in packet_finder

//#define DEBUG 1

static struct ByteQueue pf_index_queue;
static struct PacketFinder pf;      // packet_finder instance

static uint8_t pf_index_data[PF_INDEX_DATA_SIZE];    // data for pf

static int initialized = false;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  
    if ( nrhs < 1 ) {
      mexErrMsgTxt( "Need input buffer data\n" );
    }
  
    if ( !mxIsClass(prhs[0],"uint8") ) {
      mexErrMsgTxt( "Input buffer must by of type uint8\n" );
    }

    // If the bytequeue and packet finder haven't been initialized then initialize them 
    if ( !initialized ) {
      InitBQ(&pf_index_queue, pf_index_data, PF_INDEX_DATA_SIZE);
      InitPacketFinder(&pf, &pf_index_queue);
      initialized = true;
    }

    // Get length of the buffer
    int buflen = mxGetM(prhs[0]);
    if (buflen > 255) { 
      mexErrMsgTxt( "Length of input buffer is too long, tell Uriah to fix this code \n" );
    }
   
    // Get Buffer ... hopefully this is robust 
    uint8_t *buf = (uint8_t*)mxGetPr( prhs[0] );
    // Put bytes from buffer into byte queue
    uint8_t status = PutBytes( &pf, buf, buflen );

    #ifdef DEBUG
    mexPrintf("buflen: %d\n", buflen);
    for (uint8_t i=0; i<buflen; i++){
      mexPrintf("data[%d]: %d\n", i, buf[i]);
    }
    mexPrintf("status: %d\n", status);
    #endif

    // Peek Packet Finder and see if there is a valid packet to be found
    // if so, copy and return this data
    uint8_t *rx_data;
    uint8_t rx_len;
    uint8_t msg_type;    
    uint8_t *msg_data;    

    if ( PeekPacket(&pf, &rx_data, &rx_len) ) { 
      #ifdef DEBUG
	mexPrintf("Packet found\n");
	mexPrintf("rx_len: %d\n", rx_len);
	for (uint8_t i=0; i<rx_len; i++){
	  mexPrintf("rx_data[%d]: %d\n", i, rx_data[i]);
	}
      #endif

      int dims[2] = {1,rx_len};
      plhs[0] = mxCreateNumericArray(2, dims, mxUINT8_CLASS, mxREAL);
      uint8_t *packet = (uint8_t*)mxGetPr(plhs[0]);
      memcpy( packet, rx_data, rx_len );
      DropPacket(&pf);
    } else {
      int dims[2] = {1,0};
      plhs[0] = mxCreateNumericArray(2, dims, mxUINT8_CLASS, mxREAL);
    }
}

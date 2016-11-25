/**
* Parallel programming
* Lab 7
*
* Functions:
* F1: C = A - B * (MA * MD)
* F2: o = Min(MK * MM)
* F3: T = (MS * MZ) * (W + X)
*
* @since 2015-11-11
* @author Olexandr Kovalchuk
* @group IP-32
*/

#include <iostream>
#include <mpi.h>
#include "functions.h"
#include "cmdopts.h"
#include "tasks.h"

int main(int argc, char* argv[]) {
  int size, threads, tid, ctid;
  int group_size = 1;

  int ranks[] = {1};

  MPI::Group group;
  MPI::Intercomm communicator;

  MPI::Init(argc, argv);

  group = MPI::COMM_WORLD.Get_group().Excl(group_size, ranks);
  communicator = MPI::COMM_WORLD.Create(group);

  threads = MPI::COMM_WORLD.Get_size();
  tid = MPI::COMM_WORLD.Get_rank();
  ctid = (communicator == MPI::COMM_NULL) ? -1 : communicator.Get_rank();

  {
    char *sizeopt = getCmdOption(argv, argv + argc, "-s");
    size = sizeopt ? atoi(sizeopt) : 4;
  }

  switch(tid % 3) {
    case 0:
      task1(size, tid, ctid);
      break;
    case 1:
      task2(size, tid, ctid);
      break;
    default: case 2:
      task3(size, tid, ctid);
      break;
  }

  MPI::Finalize();

	return 0;
}

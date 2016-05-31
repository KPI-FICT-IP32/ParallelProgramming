#!/usr/bin/env python

from mpi4py import MPI
from pprint import pprint

N = 13


def mk_scatter(comm):
    def scatter(data, root):
        n = comm.Get_size()
        chunks = None
        if data is not None:
            size, rem = len(data) // n, len(data) % n
            chunks = [
                data[i * size + min(i, rem):(i + 1) * size + min(i + 1, rem)]
                for i in range(n)
            ]
        return comm.scatter(chunks, root)
    return scatter


def mk_gather(comm):
    def gather(data, root):
        n = comm.Get_size()
        chunks = comm.gather(data, root)
        gathered = [
            c for chunk in chunks for c in chunk
        ]
        return gathered
    return gather



"""
Formula: 
TODO: Formula

Topology:
TODO: Topology

Parallel algorithm
TODO: Parallel algorithm
"""
if __name__ == '__main__':
    comm = MPI.COMM_WORLD
    P = comm.Get_size()
    # TODO: build topology graph
    scatter = mk_scatter(comm)
    gather = mk_gather(comm)
    rank = comm.Get_rank()
    print("Task {} started".format(rank))

    # TODO: Input at rank == 0
    if rank == 0:
        pass

    # TODO: Share data
    
    # TODO: Calculate result matrix
    A = gather(Ah, root=0)

    # TODO: Output at rank == 0
    if rank == 0 and N < 12:
        pprint(A)

    print("Task {} finished".format(rank))

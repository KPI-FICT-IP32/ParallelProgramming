#!/usr/bin/env python
"""
Parallel Programming 2
Lab 08. MPI

MA = (B dot C) * ME + e * MT * MK

:author Oleksandr Kovalchuk
:group  IP-32
"""
from operator import mul
from pprint import pprint
import sys

from mpi4py import MPI


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
        if chunks:
            gathered = [
                c for chunk in chunks for c in chunk
            ]
        else:
            gathered = chunks
        return gathered
    return gather


def get_graph_config(nnodes):
    assert (nnodes is not None and nnodes> 0), nnodes

    edges = []
    for i in range(P):
        edges_ = []
        if i == 0:
            edges.append(edges_)
        elif i < 5:
            edges_.append(0)
            edges[0].append(i)
            edges.append(edges_)
        else:
            parent = (i % 4) or 4
            edges_.append(parent)
            edges[parent].append(i)
            edges.append(edges_)

    index = list(map(len, edges))
    for i in range(1, len(index)):
        index[i] += index[i-1]

    all_edges = [e for es in edges for e in es]
    return index, all_edges


if __name__ == '__main__':
    """
    Formula:
    --------

        MA = (B dot C) * ME + e * MT * MK

    Topology:
    ---------

        STAR TOPOLOGY. ALL INPUT ON MIDDLE

    Parallel algorithm
    ------------------

        1. p_i = sum(B_H dot C_H)
        2. p = sum(p_i)
        3. MA_H = p * ME_H + e * MT * MK_H

    """
    try:
        N = int(sys.argv[1])
    except:
        N = 13
    comm = MPI.COMM_WORLD
    P = comm.Get_size()
    H = int(N / P)
    
    (index, edges) = get_graph_config(nnodes=P)
    comm = comm.Create_graph(index, edges, reorder=True)

    scatter = mk_scatter(comm)
    gather = mk_gather(comm)
    rank = comm.Get_rank()

    if rank == 0:
        print("Index:", index, "\nEdges:", edges)
    print("Task {} started".format(rank))

    # Input at rank == 0
    # For convenience in passing matricies, first index is column and the
    # second is a row
    MA, B, C, ME, e, MT, MK = [None for _ in range(7)]
    if rank == 0:
        B, C = ([1 for _ in range(N)] for _ in range(2))
        ME, MT, MK = (
            [[1 for _ in range(N)]  for _ in range(N)]
            for _ in range(3)
        )
        e = 1

    # Share data
    B_H = scatter(B, root=0)
    C_H = scatter(C, root=0)
    ME_H = scatter(ME, root=0)
    MK_H = scatter(MK, root=0)
    MT = comm.bcast(MT, root=0)
    e = comm.bcast(e, root=0)

    # Calculate dot product of B and C
    pi = sum(map(mul, B_H, C_H))
    p = comm.reduce(pi, op=MPI.SUM, root=0)
    p = comm.bcast(p, root=0)

    # Calculate result matrix
    MA_H = [[0 for _ in range(N)] for _ in range(H)]
    for i in range(N):
        for j in range(H):
            for k in range(N):
                # ith row and jth column
                MA_H[j][i] += MT[k][i] * MK_H[j][k]
            MA_H[j][i] *= e
            MA_H[j][i] += p * ME_H[j][i]

    MA = gather(MA_H, root=0)

    # Output at rank == 0
    if rank == 0 and N <= 13:
        # Do not forget to transpose matrix to print it good
        pprint(list(zip(*MA)))

    print("Task {} finished".format(rank))

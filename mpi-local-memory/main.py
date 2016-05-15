from math import log2, floor
from mpi4py import MPI

N = 4


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


def merge(left, right):
    result = []
    left_idx, right_idx = 0, 0
    while left_idx < len(left) and right_idx < len(right):
        if left[left_idx] <= right[right_idx]:
            result.append(left[left_idx])
            left_idx += 1
        else:
            result.append(right[right_idx])
            right_idx += 1
 
    if left:
        result.extend(left[left_idx:])
    if right:
        result.extend(right[right_idx:])
    return result


"""
A = sort(Z)(MO*MK) + alpha*(E*MU)

Topology:
1 - 3 - ... - P-1
|   |   ...   |
2 - 4 - ... - P

Parallel algorithm
1. Zh = sort(Zh)
2. repeat Z = merge(Zh, Zh)
3. A = Z * (MO * MKh) + alpha*(E*MUh)
"""
if __name__ == '__main__':
    comm = MPI.COMM_WORLD
    P = comm.Get_size()
    comm = comm.Create_cart(
        dims=[1, 1] if P == 1 else [P//2, 2],
        periods=[False, False],
        reorder=True,
    )
    scatter = mk_scatter(comm)
    rank = comm.Get_rank()

    print("[{}] {} started".format(rank, tuple(comm.coords)))

    # 0 input

    # For simplicity rows and columns in matrices are swapped:
    # I.E. MA[x][y] means y row and x column of MA matrix
    A, Z, MO, MU, MK, E, alpha = (None for _ in range(7))
    if rank == 0:
        Z = [1 for _ in range(N)]
        MO = [[1 for _ in range(N)] for _ in range(N)]
        MU = [[1 for _ in range(N)] for _ in range(N)]
    if rank == P - 1:
        MK = [[1 for _ in range(N)] for _ in range(N)]
        E = [1 for _ in range(N)]
        alpha = 1

    # 1  Sort Z
    Zh = scatter(Z, root=0)
    Zh.sort()
    if (rank % 2 == 1 and rank - 1 > -1):
        comm.send(Zh, dest=rank - 1, tag=0)

    if (rank % 2 == 0 and rank + 1 < P):
        Zh = merge(Zh, comm.recv(source=rank + 1, tag=0))
        pw = 2
        while pw - 2 < log2(P//2):
            if rank % (2 ** pw) == 0 and rank + 2 ** (pw - 1) < P:
                Zh = merge(Zh, comm.recv(source=rank + 2 ** (pw - 1), tag=pw))
            elif rank % (2 ** (pw - 1)) == 0 and rank - 2 ** (pw - 1) > -1:
                comm.send(Zh, dest=rank - 2 ** (pw - 1), tag=pw)
            pw += 1
    if (rank == 0):
        Z = Zh

    # 2 Share data
    Z = comm.bcast(Z, root=0)
    alpha = comm.bcast(alpha, root=P-1)
    E = comm.bcast(E, root=P-1)
    MO = comm.bcast(MO, root=0)
    MUh = scatter(MU, root=0)
    MKh = scatter(MK, root=P-1)

    # 3 Calculate
    Ah = [0 for _ in range(len(MUh))]
    for i in range(len(MKh)):
        for j in range(N):
            for k in range(N): 
                Ah[i] += Z[j] * MO[k][j] * MKh[i][k]
            Ah[i] += alpha * E[j] * MUh[i][j]
    
    # 4 Gather result
    A = comm.gather(Ah, root=0)
    A = [a for as_ in A for a in as_] if A else None

    # 5 Output
    if rank == 0:
        print(A)

    print("[{}] {} finished".format(rank, tuple(comm.coords)))

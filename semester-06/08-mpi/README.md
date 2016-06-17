# Lab 8. MPI. Local memory

## Task def

### Formula
MA = (B dot C) * ME + e * MT * MK

### Topology

```
    STAR TOPOLOGY. ALL INPUT ON MIDDLE

```

## Planning

### Parallel algorithm
1. p_i = sum(B_H dot C_H)
2. p = sum(p_i)
3. MA_H = p * ME_H + e * MT * MK_H

## Running

```bash
mpiexec -n <num of processes> main.py
```

# MPI. Local memory

## Task def

### Formula
A = sort(Z)(MO*MK) + alpha*(E*MU)

### Topology

```
1 - 3 - ... - P-1
|   |   ...   |
2 - 4 - ... - P
```

## Planning

### Parallel algorithm

1. Zh = sort(Zh)
2. repeat Z = merge(Zh, Zh)
3. A = Z * (MO * MKh) + alpha*(E*MUh)

## Running

```bash
./test.sh <num of processes> ./main.py
```

## Results

see `results` folder for csv

import numpy as np
import sys
import functools
import get_nnz

if __name__ == "__main__":
    f = sys.argv[1]
    print(get_nnz.get_nnz(f) / functools.reduce(lambda x,
                                                y: x * y, list(np.load(f).shape), 1))

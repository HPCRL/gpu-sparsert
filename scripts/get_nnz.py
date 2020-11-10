import numpy as np
import sys
def get_nnz(npyFile):
    return np.load(npyFile).nonzero()[0].shape[0]

if __name__ == "__main__":
    print(get_nnz(sys.argv[1]))
import MapReduce
import sys

"""
Word Count Example in the Simple Python MapReduce Framework
"""

mr = MapReduce.MapReduce()

# =============================
# Do not modify above this line

def mapper(record):
    # key: document identifier
    # value: document contents
    # key = record[0:2]
    # key.append("row")
    # value = record[-1]
    # mr.emit_intermediate(key, value)
    # key1 = list(record[i] for i in [0,2])
    # key1.append("col")
    # value1 = record[-1]
    key = record[0]
    if key == "a":
        for i in range(5):
            mr.emit_intermediate((record[1],i),(record[2],record[3]))
    if key == "b":
        for i in range(5):
            mr.emit_intermediate((i,record[2]),(record[1],record[3]))

def reducer(key, list_of_values):
    # key: word
    # value: list of occurrence counts
    s = 0
    dictA = {}
    dictB = {}
    for v in list_of_values:
        if v[0] in dictA:
            dictB[v[0]] = v[1]
        else:
            dictA[v[0]] = v[1]
    for k in dictB.keys():
        s = s + dictB[k] * dictA[k]
    mr.emit((key[0],key[1],s))

# Do not modify below this line
# =============================
if __name__ == '__main__':
  inputdata = open(sys.argv[1])
  mr.execute(inputdata, mapper, reducer)

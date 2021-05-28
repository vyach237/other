import string
import sys


def sort_pyzir(lst):
    for i in range(len(lst)):
        for j in range(len(lst) - i - 1):
            if lst[j][1] > lst[j+1][1]:
                lst[j], lst[j+1] = lst[j+1], lst[j]
    return lst

def jadngreedy_cut(lst):
   result = [lst[0][1]]
   for i in lst:
        if i[0] > result[-1]:
            result.append(i[1])
   return result



massiv = []
n = int(input())
for i in range(1,n+1):
  x,y = map(int, input().split())
  massiv.append([x,y])

#massiv = sort_pyzir(massiv)
massiv.sort(key=lambda x: x[1])
#print(massiv)
massiv = jadngreedy_cut(massiv)
print(len(massiv))
for i in massiv:
    print(i, end=' ')
#print(massiv)
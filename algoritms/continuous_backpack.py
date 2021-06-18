# -*- coding: utf-8 -*-
"""
Created on Wed Jun  2 09:43:32 2021

@author: Arman
"""

n,W = map(int, input().split())

def sort_pyzir(lst):
    for i in range(len(lst)):
        for j in range(len(lst) - i - 1):
            if lst[j][2] > lst[j+1][2]:
                lst[j], lst[j+1] = lst[j+1], lst[j]
    return lst

def continuous_backpack(lst):
    w, c = 0, 0
    for x, y, C in lst:
        while y > 0:
            if W < (w + 1):
                break
            w += 1
            c += C
            y -= 1
    return c


import string
import sys


massiv = []
for i in range(1,n+1):
  x,y = map(int, input().split())
  massiv.append([x,y, x/y])
  
#sort
massiv = sort_pyzir(massiv)
massiv = massiv[::-1]
print(continuous_backpack(massiv))
# -*- coding: utf-8 -*-
from collections import Counter
import heapq

def huffman_encoding_v1(s):
    encoding_dict = {}
    heap = [(freq, char) for char, freq in Counter(s).items()]
    
    heapq.heapify(heap)
    print(heap)    
    if len(heap) == 1:  # there is only one type of characters in the string
        _freq, char = heapq.heappop(heap)
        encoding_dict[char] = str(0)  # the only type of characters is encoded by zero

    while len(heap) >= 2:  # there are at least two type of characters in the string
        min_freq, min_char = heapq.heappop(heap)
        min2_freq, min2_char = heapq.heappop(heap)

        # (min_char + min2_char) - new nodes accumulate information about their descendants
        heapq.heappush(heap, (min_freq + min2_freq, min_char + min2_char))

        for i, char_string in enumerate([min_char, min2_char]):  # 0 for min_char, 1 for min2_char
            for char in char_string:  # every descendant's code is prepended with 0/1
                if char in encoding_dict:
                    encoding_dict[char] = str(i) + encoding_dict[char]
                else:
                    encoding_dict[char] = str(i)

    return encoding_dict

def huffman_decoding(encoding_dict, encoded_str):
    decoded_str = ''
    encoding_dict = {value: key for key, value in encoding_dict.items()}

    sequence = ''
    for char in encoded_str:
        sequence += char
        if sequence in encoding_dict:
            decoded_str += encoding_dict[sequence]
            sequence = ''

    return decoded_str
    
# s = 'accepted'
# encoding_dict = huffman_encoding_v1(s)
# encoded_str = ''.join([encoding_dict[char] for char in s])
# print(len(encoding_dict), len(encoded_str))
# for key, value in sorted(encoding_dict.items()):
#     print('{}: {}'.format(key, value))
# print(encoded_str)

k, _l = (int(i) for i in input().split())

encoding_dict = {}
for _ in range(k):
    key, value = (i.strip() for i in input().split(':'))
    encoding_dict[key] = value

encoded_str = input()
print(huffman_decoding(encoding_dict, encoded_str))
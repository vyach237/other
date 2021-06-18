def different_addends_iterative(n):
    k = 1
    addends = []

    while n >= 2 * k + 1:
        addends.append(k)
        n -= k
        k += 1

    addends.append(n)
    return k, addends


def different_addends_arithm_progr(n):
    k = int((-1 + (1 + 8 * n) ** 0.5) / 2)  # based on theoretical calculations

    addends = list(range(1, k))
    addends.append(n - (k - 1) * k // 2)  # based on theoretical calculations

    return k, addends


def main():
    n = int(input())

    k, addends = different_addends_iterative(n)

    print(k)
    print(*addends)


if __name__ == '__main__':
    main()
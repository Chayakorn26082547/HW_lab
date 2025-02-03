filename = "rom.mem"

def digitToBinary(A: int):
    binary = ""
    for i in [8, 4, 2, 1]:
        binary += str(A // i)
        A %= i
    return binary

with open(filename, "w") as f:
    for i in range(64):
        word = digitToBinary(i//10) + digitToBinary(i%10) + "\n"
        f.write(word)
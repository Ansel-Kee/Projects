#Universal functions
def isprime(n):
    counter = 0
    prime = True
    for i in range(2, n):
        if not(n%i) and i != n:
            prime = False
            break
    return prime

def sieve(n):
    lst = [2]
    prime = True
    for i in range(3, n+1):
        if isprime(i):
            lst.append(i)
    if n == 1:
        lst = []
    return lst

def countprime(n, r):
    counter = 0
    primelst = sieve(n)
    for i in primelst:
        if not((i-r)%4):
            counter += 1
    return counter

def checkprime(n,r):
    lst = [2]
    counter = 0
    prime = True
    for i in range(3, n+1):
        if isprime(i):
            lst.append(i)
            if not((i-r)%4):
                counter += 1
    if n == 1:
        lst = []
    length = len(lst)
    return (counter, length)

#Different versions
def findn_v1(a, b):
    c = 0
    while countprime(c, a) <= countprime(c, b):
        c += 1
        print(c)
    return c

def findn_v2(a):
    c = 0
    n = checkprime(c, a)
    while n[0] <= abs(n[1]-n[0]-1):
        c += 1
        print(c)
        n = checkprime(c, a)
    return c

def findn_v3(a):
    c = 0
    n = checkprime(c, a)
    while n[2] <= abs(n[1]-n[0]-1):
        c += 1
        print(c)
        n = checkprime(c, a)
    return c

def findn_v4():
    c = 1
    count1 = 0
    count3 = 0
    while count1 <= count3:
        c += 1
        if isprime(c): #checks if its a prime
            if not (c-1)%4: # checks if it fulfils 4k+1
                count1 += 1                
            elif not (c-3)%4: # checks if it fulfils 4k+3
                count3 += 1
        
    return c

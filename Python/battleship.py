import random
human, bot = 0, 0
def construct(pos, ship, player):
    # + is up/left, - is down/right
    length = 3 + "cs".index(ship.lower())
    if len(pos) == 4:
        pos[0], pos[1] = "abcdefghij".index(pos[0].lower()), int(pos[1])-1
        if pos[2].upper() == "V":
            if 0+length*"+-".index(pos[3]) <= pos[0] <= 10-length*"+-".index(pos[3]) and 0 <= pos[1] <= 10 and human1[pos[0]][pos[1]] == " ":
                for i in range(length):
                    for j in range(1 + "cs".index(ship.lower())):
                        exec(f'{player}{j+1}[pos[0]{pos[3]}{i}][pos[1]] = "{ship}"')
                return True
     
        elif pos[2].upper() == "H":
            if 0+length*"+-".index(pos[3]) <= pos[1] <= 10-length*"+-".index(pos[3]) and 0 <= pos[0] <= 10 and human1[pos[0]][pos[1]] == " ":
                for i in range(length):
                    for j in range(1 + "cs".index(ship.lower())):
                        exec(f'{player}{j+1}[pos[0]][pos[1]{pos[3]}{i}] = "{ship}"')
                return True
    if player == "human":
        print("Invalid location")
    return False

def check(move, player):
    print(eval(f'{player}{move[2]}[move[0]][move[1]]'))
    if sum(i.count("C") for i in bot1) == 1 and eval(f'{player}{move[2]}[move[0]][move[1]] == "C"'):
        print(f"{player} Carrier destroyed")
        exec(f'{player} += 1')
    if (sum(i.count("S") for i in bot1) + sum(i.count("S") for i in bot2)) == 1 and eval(f'{player}{move[2]}[move[0]][move[1]] == "S"'):
        print(f"{player} Submarine destroyed")
        exec(f'{player} += 1')
    print(f'{player}' + str(eval(f'{player}')))

for i in range(4):
    exec(f'{["human", "bot"][i%2]}{i//2+1} = [[" " for i in range(10)] for i in range(10)]')


done = 0
print("Format: Row (A-Z),Column (1-9),Horizontal/Vertical (H/V), Direction (+: Down/Right, -: Up/Left)")
while done < 2:
    pos = input(["Carrier location: ", "Submarine location: "][done]).split(",")
    done += construct(pos, "CS"[done], "human")
    
done = 0
while done < 2:
    direction = "VH"[random.randint(0,1)]
    if direction == "V":
        pos = ["abcdefghij"[random.randint(0, 6+done)], random.randint(0,9), direction, "+-"[random.randint(0,1)]]
    else:
        pos = ["abcdefghij"[random.randint(0, 9)], random.randint(0,6+done), direction, "+-"[random.randint(0,1)]]
    done += construct(pos, "CS"[done], "bot")

while human < 2 and bot < 2:
    print("Format: Row (A-Z),Column (1-9),Layer: (0-1)")
    move = input("Make your move: ").split(",")
    
    if len(move) != 3 or move[0].lower() not in "abcdefghij" or 1 > int(move[1]) > 10 or 0 > int(move[2]) > 1:
        print("Invalid move")
        continue
    else:
        move[0], move[1], move[2] = "abcdefghij".index(move[0]), int(move[1])-1, int(move[2])+1
        if eval(f'bot{move[2]}[move[0]][move[1]] == "X"'):
            print("Invalid move")
            continue
        check(move, "bot")
        exec(f'bot{move[2]}[move[0]][move[1]] = "X"')
##    print("Bot Layer 1")
##    print("    "+"    ".join("123456789")+"    "+"10")
##    print("\n".join("ABCDEFGHIJ"[i] + " " + str([" " if j != "X" else "X" for j in bot1[i]]) for i in range(len(bot1))))
##    print("Bot Layer 2")
##    print("    "+"    ".join("123456789")+"    "+"10")
##    print("\n".join(str([" " if j != "X" else "X" for j in i]) for i in bot2))
##    print()
    print("Bot Layer 1")
    print("    "+"    ".join("123456789")+"    "+"10")
    print("\n".join("ABCDEFGHIJ"[i] + " " + str(bot1[i]) for i in range(len(bot1))))
    print("Bot Layer 2")
    print("    "+"    ".join("123456789")+"    "+"10")
    print("\n".join("ABCDEFGHIJ"[i] + " " + str(bot2[i]) for i in range(len(bot2))))
    print()
    while True:
        move = [random.randint(0, 9), random.randint(0, 9), random.randint(1, 2)]
        if eval(f'human{move[2]}[{move[0]}][{move[1]}] != "X"'):
            check(move, "human")
            exec(f'human{move[2]}[{move[0]}][{move[1]}] == "X"')
            break
    print("Player Layer 1")
    print("    "+"    ".join("123456789")+"    "+"10")
    print("\n".join("ABCDEFGHIJ"[i] + " " + str(human1[i]) for i in range(len(human1))))
    print("Player Layer 2")
    print("    "+"    ".join("123456789")+"    "+"10")
    print("\n".join("ABCDEFGHIJ"[i] + " " + str(human2[i]) for i in range(len(human2))))
    print()
print(["Human", "Bot"][bot > human], "wins")

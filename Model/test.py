__author__ = 'dgc1'
import matplotlib.pyplot as plt
#from mpl_toolkits.mplot3d import Axes3D
#from matplotlib import animation
import random
#import numpy as np
#import subprocess

def TT_calc(TTs, test):
    "Finds the lowest value matching a key"
    TTs = sorted(TTs)
    for x in TTs:
        if x[0] >= test:
            return x[1]
    print "Error no TT"

def pos_check(seeds, clods, pos, radi=1):
    found = True
    if len(clods) > 0:
        for x in range(0, len(clods)):
            if pos[0] + radi >= clods[x].pos[0] - clods[x].radi >= radi - pos[0]:
                if pos[1] + radi >= clods[x].pos[1] - clods[x].radi >= radi - pos[1]:
                    if pos[2] + radi >= clods[x].pos[2] - clods[x].radi >= radi - pos[2]:
                        found = False
    if len(seeds) > 0:
        for x in range(0, len(seeds)):
            if pos[0] + radi >= seeds[x].pos[0] >= radi - pos[0]:
                if pos[1] + radi >= seeds[x].pos[1] >= radi - pos[1]:
                    if pos[2] + radi >= seeds[x].pos[2] >= radi - pos[2]:
                        found = False
    return found

def position_calc(seeds, clods, sow_depth, plot_xyz, is_clod): # this function needs to caculate the size of clods too
    #print str(len(seeds)) + " seeds\t" + str(len(clods)) +  " clods\tXYZ-" + str(plot_xyz) + "\t is clod = " + str(is_clod)
    found = False
    trys = 0
    while found == False:
        if is_clod:
            pos = [int(round(random.random() * plot_xyz[0])), int(round(random.random() * plot_xyz[1])),
                   int(round(random.random() * plot_xyz[2]))]
            found = pos_check(seeds, clods, pos, 5) # need a radi no

        else:
            pos = [int(round(random.random() * plot_xyz[0])), int(round(random.random() * plot_xyz[1])), sow_depth]
            found = pos_check(seeds, clods, pos, 1)

        trys += 1
        if trys > 3:
            print "tried " + str(trys) + " Times to place. Clod = " + str(is_clod)
            if trys > 25:
                print "Hard to place!"
                if trys >= 250:
                    print "May Not Be able to place!!!"
                    if trys >= 1500:
                        print "################################## Can not place!!! #############################"
                        pos = "CAN'T MAKE SEDBED"
                        break
        #print str(pos)

    return pos


class Seed(object):
    germ = False
    dead = False
    ds_sow = 0
    ds_germ = 0
    hieght = 0
    tt = 0
    emerge = False

    def __init__(self, seed_no, deth_prob, tt_req, base_germ, base_elong, base_wat, pos):
        self.seed_no = seed_no
        self.deth_prob = deth_prob
        self.tt_req = TT_calc(tt_req, random.random())  # this may need to better mimic a normal dist
        self.base_germ = base_germ
        self.base_elong = base_elong
        self.base_wat = base_wat
        self.pos = pos

    def __str__(self):
        self.out = "\tSeed " + str(self.seed_no)

        if self.ds_sow == 0:  # setup infomation can only print at start
            self.out = self.out + "\t- TT to germ " + str(self.tt_req)
            self.out = self.out + "\t- poz " + str(self.pos)

        if self.dead == True:  # main info
            self.out = self.out + "\t- Dead"
        else:
            if self.germ == True:
                self.out = self.out + "\t- Germinated"
                self.out = self.out + "\t- Elongation of " + str(round(self.hieght, 2)) + "mm"
            if self.emerge == True:
                self.out = self.out + "\t- Seed has Emerged " + str(
                    round(self.hieght - self.pos[2], 2)) + "mm above ground"
        return self.out

    def next_day(self, Temp, wat):
        self.ds_sow += 1
        if self.dead == False:
            if self.germ == False:
                self.tt += (Temp - self.base_germ)
                if random.random() < self.deth_prob:
                    self.dead = True
                if self.tt >= self.tt_req and self.dead == False and wat > self.base_wat:
                    self.germ = True
            else:
                if random.random() * 4 < self.deth_prob:  # this shod be changed to reprosent reaity
                    self.dead = True
                if self.dead == False and self.germ == True:
                    self.ds_germ += 1
                    self.hieght += random.random()  # webil eq...
                    if self.hieght >= self.pos[2] and self.emerge == False:
                        self.emerge = True


class Clod(object):
    # pos = [0,0,0] # x y z
    # size = [0,0,0] # long, mid, short
    # rotation = [0,0,0] # rot x y z
    # serfice = False # center is above serfice
    # below = False # hole clod is below serfice
    def __init__(self, clod_no, pos, depth, clod_lims):
        self.clod_no = clod_no
        self.pos = pos
        self.size = clod_lims  # function will be haer like seed lims ( + ridus high )
        self.radi = (sum(self.size) / float(len(self.size))) / 2
        self.rotation = [random.randint(1, 360), random.randint(1, 360), random.randint(1, 360)]

        if self.pos[2] >= depth:
            self.serfice = True
        if self.pos[2] - self.radi < depth:
            self.serfice = True

    def __str__(self):
        self.out = "\tClod " + str(self.clod_no)
        self.out = self.out + "\tX-" + str(self.pos[0]) + " Y-" + str(self.pos[1]) + " Z-" + str(self.pos[2])
        self.out = self.out + "\tLong-" + str(self.size[0]) + " Mid-" + str(self.size[1]) + " Tall-" + str(self.size[2])

        return self.out

seed_tray = list()
clod_bed = list()
no_seeds = 10
no_days = 20
plot_xyz = [50, 50, 8]
sow_depth = 5
day_death = 0.1
therm_times = [
    [0.1, 20],
    [0.35, 80],
    [0.50, 120],
    [0.75, 250],
    [1, 9999]]
base_germ = 5
base_elong = 5
base_wet = 0.1

fig = plt.figure()
dd_fig = fig.add_subplot(111, projection='3d')

for sd in range(0, no_seeds):
    print "seed " + str(sd+1)
    seed_tray.append(Seed(sd + 1, day_death, therm_times, base_germ, base_elong, base_wet,
                          position_calc(seed_tray, clod_bed, sow_depth, plot_xyz, False)))


no_clods = 20
clod_lims = [12,11,10] ## will need a method to call

for sd in range(0, no_clods):
    print "clod " + str(sd+1)
    clod_bed.append(Clod(sd + 1, position_calc(seed_tray, clod_bed, sow_depth, plot_xyz, True), plot_xyz[2], clod_lims))
    print clod_bed[sd]



for day in range(0, no_days + 1):
    print "Day " + str(day)
    for sd in range(0, no_seeds):
        seed_tray[sd].next_day(25, 0.2)
        hights = list()
        hights.append([seed_tray[sd].pos[0], seed_tray[sd].pos[1], seed_tray[sd].hieght + seed_tray[sd].pos[2]])
        print(hights)
        ax = [row[0] for row in hights]
        ay = [row[1] for row in hights]
        az = [row[2] for row in hights]
        dd_fig.scatter(ax, ay, az,c="g")


# hights = list() # for final hights
# ####plot end
# for sd in range(0, no_seeds):
#         hights.append([seed_tray[sd].hieght,sd])
#
# x = [row[1] for row in hights]
# y = [row[0] for row in hights]
# plt.scatter(x, y)

dd_fig.set_xlabel('Plot Lenth')
dd_fig.set_ylabel('Plot Width')
dd_fig.set_zlabel('Plot Hight')
plt.show()

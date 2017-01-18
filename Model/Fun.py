import random
import Write


def TT_calc(TTs):
    """Finds the lowest value matching a key
    :argument TTs: A array of proportions of seed germinated with thermal times
    :rtype x: a amount of thermal time required to germinate (99999 for never)
    if cannot find a mach logs error to run file
    """
    test = random.random()
    TTs = sorted(TTs)
    for x in TTs:
        if x[0] >= test:
            return x[1]
    Write.run_summ("Error no TT")


def Wat_calc(wats):
    """Finds the lowest value matching a key
    :argument wats: A array of proportions of seed germinated with thermal times
    :rtype x: a amount of water required to germinate (has no never is a proportion of seeds)
    if cannot find a mach logs error to run file
    """
    # todo make this a variable like TT
    test = random.random()
    wats = sorted(wats)
    for x in wats:
        if x[0] >= test:
            return x[1]
    Write.run_summ("Error no wat")


def pos_check(seeds, clods, pos, radi=1):
    """Checks if there is a clash at a specific location
    :argument seeds: All of the seeds currently placed
    :argument clods: All of the clods currently placed
    :argument pos: The proposed osition of a new seed or clod
    :argument radi: A default of 1 (a 2x2x2mm) if it is a seed or the radius of the clod if it is not
    :rtype : bool
    """
    # todo this dose not account for ellipsoids
    found = True
    if len(clods) > 0:
        for x in range(0, len(clods)):
            if (pos[0] + radi) >= (clods[x].pos[0] - clods[x].radi) and (pos[0] - radi) <= (clods[x].pos[0] + clods[x].radi):
                if (pos[1] + radi) >= (clods[x].pos[1] - clods[x].radi) and (pos[1] - radi) <= (clods[x].pos[1] + clods[x].radi):
                    #print "pos = " + str(pos) + " rdi=" + str(radi)
                    #print "testing clods " + str(x) + " pos = " + str(clods[x].pos) + " rdi=" + str(clods[x].radi)
                    if (pos[2] + radi) >= (clods[x].pos[2] - clods[x].radi) and (pos[2] - radi) <= (clods[x].pos[2] + clods[x].radi):
                        #print "FAIL"
                        found = False
    if len(seeds) > 0:
        for x in range(0, len(seeds)):
            #print "testing seed " + str(x) + " pos = " + str(seeds[x].pos) + " rdi=" + str(radi)
            if (pos[0] + radi) >= seeds[x].pos[0] and (pos[0] - radi) <= seeds[x].pos[0]:
                if (pos[1] + radi) >= seeds[x].pos[1] and (pos[1] - radi) <= seeds[x].pos[1]:
                    #print  "pos = " + str(pos) + " rdi=" + str(radi)
                    #print "testing seeds " + str(x) + " pos = " + str(seeds[x].pos)
                    if (pos[2] + radi) >= seeds[x].pos[2] and (pos[2] - radi) <= seeds[x].pos[2]:
                        #print "FAIL"
                        found = False
    return found


def position_calc(seeds, clods, sow_depth, plot_xyz, is_clod, radi=1, serf_prob=None):
    """Finds colds and seeds a valid x y z coronets in the plot
    Takes account of clod soil surface specifications
    :param seeds: All current seed objects in seedbed
    :param clods: All current clod objects in seedbed
    :param sow_depth: The specific depth to sow the seeds at
    :param plot_xyz: The limits of the plot
    :param is_clod: bool if this is a clod
    :param radi: The radius of the clod (missing for seed defaults to 1)
    :param serf_prob: The probability the clod is on the surface (above or below)
    :return: pos a list of a valid zyz
    """
    if serf_prob is None: serf_prob = [False,False,False]
    #print str(len(seeds)) + " seeds\t" + str(len(clods)) +  " clods\tXYZ-" + str(plot_xyz) + "\t is clod = " + str(is_clod)
    found = False
    trys = 0
    while found == False:
        if is_clod:
            if not serf_prob[0]:    # section checks the
                pos = [random.randint(1, plot_xyz[0]), random.randint(1, plot_xyz[1]),
                       random.randint(1, round(plot_xyz[2]-radi,0))]
            elif serf_prob[0] and serf_prob[1]:
                pos = [random.randint(1, plot_xyz[0]), random.randint(1, plot_xyz[1]),
                       random.randint(plot_xyz[2], round(plot_xyz[2]+radi,0))]
            elif serf_prob[0] and serf_prob[2]:
                pos = [random.randint(1, plot_xyz[0]), random.randint(1, plot_xyz[1]),
                       random.randint(round(plot_xyz[2]-radi,0), round(plot_xyz[2]+(radi/3),0))]
            else:
                 pos = [random.randint(1, plot_xyz[0]), random.randint(1, plot_xyz[1]),
                       random.randint(round(plot_xyz[2]-(radi/3),0), plot_xyz[2])]
            found = pos_check(seeds, clods, pos, radi)                      # Check the position

        else:
            pos = [int(round(random.random() * plot_xyz[0])), int(round(random.random() * plot_xyz[1])), sow_depth]
            found = pos_check(seeds, clods, pos)

        trys += 1
        if trys > 10:
            #print "tried " + str(trys) + " Times to place. Clod = " + str(is_clod)
            if trys > 200:
                #print "Hard to place!"
                if trys >= 500:
                    Write.run_summ("May Not Be able to place!!!")
                    if trys >= 2000:
                        Write.run_summ("################################## Can not place!!! #############################")
                        pos = "CAN'T MAKE SEDBED"
                        quit(1)
        #print str(pos)
    return pos


def growth_pos_check(clods, pos):
    """for checking the position of a growing seed tip
    Like position_calc but amended for growing seed
    each time the seed grows there is a cheek for clod collisions
    :param clods: All the clod objects in the bed
    :param pos: The proposed position of the seed tip
    :return: found int 0 for no clod hit or the number of the clod hit
    """
    found = 0
    if len(clods) > 0:
        for x in range(0, len(clods)):
            if (pos[0]) >= (clods[x].pos[0] - clods[x].radi) and (pos[0]) <= (clods[x].pos[0] + clods[x].radi):     # check x only move on if a clash is found
                if (pos[1]) >= (clods[x].pos[1] - clods[x].radi) and (pos[1]) <= (clods[x].pos[1] + clods[x].radi): # check y
                    #print  "pos seedling tip = " + str(pos)
                    #print "hiting clod " + str(x) + " or " + str(clods[x].clod_no) + " at pos = " + str(clods[x].pos) + " rdi=" + str(clods[x].radi)
                    if (pos[2]) >= (clods[x].pos[2] - clods[x].radi) and (pos[2]) <= (clods[x].pos[2] + clods[x].radi): # check z
                        #print "FAIL"
                        found = clods[x].clod_no # the seed grouth is inpeaded!
    return found # return clod number of clod hit [refrences to clod list will need -1]


def emerge_summry(seed_tray, seed):
    """makes output shiny friendly
    :param seed_tray: the list of seed objects
    :param seed: seed place in list of seeds (0 indexed)
    :return: A string describing the status of the seed
    """
    if seed_tray[seed].emerge and seed_tray[seed].clod.clod_no == 0:
        emerge = "y"
    elif seed_tray[seed].circumvented and seed_tray[seed].emerge:
        emerge = 'Y-around'
    elif not seed_tray[seed].circumvented and seed_tray[seed].clod.clod_no > 0:
        emerge = 'N-around'
    elif seed_tray[seed].circumvent == 0 and seed_tray[seed].clod.clod_no > 0:
        emerge = 'N-Clod'
    else:
        emerge = '0' # add number for crust stuck

    return emerge


def clod_restriction(prob_serf, stuck_serf, stuck_soil):
    """print prob_serf
    :param prob_serf:
    :param stuck_serf:
    :param stuck_soil:
    :return:
    """
    prob_out = [False,False,False]               # if not all false
    if random.random() <= prob_serf:             # test if clod is stuck on serfice
        prob_out[0] = True
        if random.random() <= stuck_serf:
            prob_out[1] = True
        elif random.random() <= stuck_soil:
            prob_out[2] = True

    return prob_out

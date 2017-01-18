# coding=utf-8
import Fun
import random
import Clods
import math
import Write

class Seed(object):
    germ = False        # seed germination status default
    dead = False        # seed death status default
    ds_sow = 0          # Days since sowing
    ds_germ = 0         # days since germination
    hieght = 0          # elongation of steam
    tt = 0              # thermal time accumulated till germination
    ttd = 0             # thermal time since germination
    emerge = False      # seed emergence status default
    stuck_clod = False  # if the seed is currently stuck under a clod
    clod = Clods.Clod(0,[0,0,0,],0,[0,0,0])            # A default clod as a place holder
    hit_h = 0           # height of clod above seed
    clod_impassable = True  # is the clod passable or impassable
    circumvent = 0      # Number of attempts to circumvent clod
    circumvented = False # successfully circumvented the clod          # todo only copes with one clod
    stuck_crust = False  # if the seed is stuck under the crust          ##
    crust_attempt = 0    # number of try to brake threw the crust        ##
    tod = 0              # time of death
    cod = "none"         # corse of death


    def __init__(self, seed_no, deth_prob, tt_req, base_germ, base_elong, base_wat, pos):
        """ Initialise a seed
        :param seed_no:
        :param deth_prob:
        :param tt_req:
        :param base_germ:
        :param base_elong:
        :param base_wat:
        :param pos:
        """
        self.seed_no = seed_no                      # set seed number
        self.deth_prob = deth_prob                  # set death prob # todo make this a real thing
        self.tt_req = Fun.TT_calc(tt_req)           # set thermal time requierd to germinate # todo this may need to better mimic a normal dist
        self.base_wat = Fun.Wat_calc(base_wat)  # set minimum water for germination [proportion seeds, WV]
        self.base_germ = base_germ                  # set base temp for germination
        self.base_elong = base_elong                # set base temp for elongation
        self.base_crust = 0.9                       # chance of geting thrugh crusty soil # todo make this a variable
        self.pos = pos                              # seed xyz

    def __str__(self):
        self.out = ""
        if self.seed_no == 1:
            self.out = "D-" + str(self.ds_sow) + "\tSeed\n"
        self.out += "\t\t" + str(self.seed_no) + "\t"
        if self.ds_sow == 0:                                # setup infomation can only print at start
            self.out += "\t-TT for germ " + real_tt(self.tt_req) + " -\t"
            self.out += "\t-poz " + str(self.pos) + " -\t"
        if self.dead == True:                               # main info
            if self.germ == True:
                self.out += "-Germinated..."
            else:
                self.out += "\t\t\t"
            self.out += "\t-Dead-" + "\t"
            self.out += "\t-Time of Death = day " + str(self.tod) + "\t- "
            self.out += "\t-Cause of Death - " + self.cod + "\t\t\t"
            if self.stuck_clod:
                if not self.clod_impassable:
                    self.out += "\t-failed to pass-" + "\t"
                else:
                    self.out += "\t-impassable clod-" + "\t"
        else:
            if self.germ == True:
                self.out += "\t-Germinated-"
                self.out += "\t-Elongation of " + str(round(self.hieght, 2)) + "mm-"
                self.out += "\t-from a TT of " + str(round(self.ttd, 2)) + "DegD-"
            if self.emerge == True:
                self.out += "\t-Seed has Emerged-"
            if self.circumvent != 0:
                self.out += "\t-hit clod-"
                self.out += "\t-under there for " + str(self.circumvent) + " Day(s)-"
                # should add more
        return self.out


    def next_day(self, day, setup, clod_bed, crusty):
        """method to increment the changes for this seed for the next day
        :param day: day since sowing
        :param setup: the current setup object
        :param clod_bed: the current clod-bed object
        :param crusty: the current crustiness of the soil
        """
        start_doy = setup.enviro_data_day.index(setup.start_day)
        Temp = setup.enviro_data_temp[start_doy + day]
        wat = setup.enviro_data_wat[start_doy + day]
        self.ds_sow += 1
        if self.dead == False:              # If the seed is alive
            if self.germ == False:          # and not get germinated
                self.seed_germ(Temp, wat)   # check if it will germinate now
            else:                           # or if it has already germinated
                self.seed_growth(Temp, wat, setup, clod_bed, crusty) # calculate its growth


    def seed_germ(self, day_temp, day_water):   # test if seed has germinated with the current accumulated thermal time and water leval
        """method to calculate if the seed has germinated
        :param day_temp: todays temprituer
        :param day_water: todays soil water W/V
        :rtype bool: if the seed is germinated
        """
        self.tt += (day_temp - self.base_germ)  # increse thermal time up till germination
        self.is_seed_lost()                     # Calculate if the seed is dead or lost in the soil
        if self.tt >= self.tt_req and self.dead == False and day_water >= self.base_wat:
            self.germ = True

    def seed_growth(self, Temp, wat, setup, clod_bed, crusty):
        """method to calculate much has the seedling grown (mm)
        :param Temp:
        :param wat:
        :param setup:
        :param clod_bed:
        :param crusty:
        :return: Seedling growth self.height
        """
        if not self.stuck_clod and not self.stuck_crust:     # only increment thermal time if seed can grow
            self.ttd += (Temp - self.base_elong)     # tt since germination (used for weibull eq)
        self.is_seedling_dead(wat)                  # test if the seedling has any ransom to have died
        if self.dead == False:
            self.ds_germ += 1                       # germinated and alive one more day
            if self.ds_germ > 1:
                growth = self.growth(setup, Temp)
                if not self.emerge:
                    hit = Fun.growth_pos_check(clod_bed, [self.pos[0], self.pos[1], self.pos[2] + self.hieght + growth])    # dose the growing seed hit a clod
                    if hit != 0 and not self.circumvented:
                        self.clod_circumvent(setup, clod_bed, hit)          # can it circumvent the lod it is under
                    self.crust_stuck(setup.sow_depth, growth, crusty)       # has the seedling hit a crusty serfice
                if not self.stuck_clod and not self.stuck_crust:            # if notning is stoping it - let it grow
                    self.hieght += growth                                   # increment growth


    def is_seed_lost(self):
        """method to determine chance of a seed being lost into the soil
        :return dead: if seed is dead
        :return tod: Day Seedling died
        :return cod: the cores of the seedling death was "MIA"
        """
        if random.random() < self.deth_prob:    # lost or dead before germ probability
            self.dead = True                    # this is based on deth prob which is from setup.day_death
            self.tod = self.ds_sow              # record time of death
            self.cod = "Lost"


    def is_seedling_dead(self, wat):
        """method to check if the seedlings dead
        :param wat:
        """
        if wat < self.base_wat and random.random() + self.ds_germ / 10.0 < .2:     # todo this shod be changed to represent reality
            print(wat)
            print(self.ds_germ / 10.0)
            self.dead = True                                    # chance of drying out and dieing
            self.tod = self.ds_sow                              # record time of death
            self.cod = "WaterLow"

        if self.circumvent >= 5:                                # there is know way to get around a clod
            self.dead = True
            self.tod = self.ds_sow                              # record time of death
            self.cod = "Clod"

        if self.crust_attempt >= 5:                             # the seed can not baeck thrugh the crust in a timely way
            self.dead = True
            self.tod = self.ds_sow                              # record time of death
            self.cod = "Crust"


    def clod_passable(self, setup):
        """method to determine if the clod is passable
        :param setup:
        """
        if 30 < self.clod.rotation[0] > 170:
            self.clod_impassable = False
        if (self.clod.pos[0] - setup.min_hit/4 < self.pos[0] > self.clod.pos[0] + setup.min_hit/4) and (self.clod.pos[1] - setup.min_hit/4 < self.pos[1] > self.clod.pos[1] + setup.min_hit/4):
            self.clod_impassable = False


    def growth(self, setup, Temp):
        """method to determine if not emerged there is a strong chance of dieing
        :param setup:
        :param Temp:
        :return:
        """
        if self.hieght > setup.stage_two and not self.emerge:   # if large and not on the surface
            if random.random() < 0.25:           # one in 4 chance of dieing
                self.dead = True
                self.tod = self.ds_sow                              # record time of death
                self.cod = "TooDeep"
        if self.hieght >= setup.stage_two and not self.dead:    # if rapid growth stage ended
            growth = (0.0022 * self.hieght) * (Temp - self.base_germ)  # linear function calculated from patch sowing soil # todo may be beter to calculate from soing methods soil
        elif self.hieght < setup.stage_two and not self.dead:   # if still in rapid growth
            growth = ((setup.poly[0] * self.ttd**2) + (setup.poly[1] * self.ttd)) - self.hieght # try 2nd poly insted of weibull
        else:
            growth = 0
        return growth


    def clod_circumvent(self, setup, clod_bed, hit):
        """method to determine if seed can circumvent the clod it hit
        :param setup: the setup object
        :param clod_bed: list of clod objects
        :param hit: the number of the clod hit (1 indexed)
        """
        self.circumvent += 1                # no attempts made to pass clod
        if self.circumvent == 1:            # only the just when the clod is identifyed
            self.stuck_clod = True          # make seed stuck
            self.clod = clod_bed[hit -1]    # copy clod object into seed
            self.hit_h = (self.clod.pos[2] - self.clod.radi) - self.pos[2] # Record the hight of the clod hit
            self.clod_passable(setup)       # check if clod is passable
        if random.random() > self.clod.radi/setup.min_hit and not self.clod_impassable:       # todo make chance of geting around clod a vereabel
            self.circumvented = True        # marke as passes and not stuck
            self.stuck_clod = False

    def crust_stuck(self, sow_depth, growth, crusty):
        """method to determine if the seed is stuck below the crust
        :param sow_depth: the depth the seed was sown at
        :param growth: the amount the seed has grown in the last day
        :param crusty: if the seedbed is currently crusty
        :returns Emerged bool and stuck bool - if stuck increments a counter
        """
        if self.hieght + growth > sow_depth and not self.emerge:        # check seed for emergence
                    if crusty > 0:
                        if random.random() < crusty:                    # the chance of geting thrugh a solid crist is dermend in the seedbead crusting function
                            self.emerge = True                          # mark as emerged
                            self.stuck_crust = False                    # mark seed as not stuck
                        else:
                            self.stuck_crust = True
                            self.crust_attempt += 1                     # if it cant break the crust then it waits
                    else:
                        self.emerge = True                              # if there is no crust 0 or a wet crust -1 it emerges unhindered





#### other functions:

def real_tt(tt):
    """remove 99999 values from TT
    :param tt: thermal time
    :return: A human readable string
    """
    if tt == 99999:
        out = "Not"
    else:
        out = str(tt)

    return out
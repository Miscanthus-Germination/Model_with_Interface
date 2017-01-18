import Read
import Clods
import Fun
import Seeds
import Write


class Seedbed(object):
    """Class Seedbed the hole seedbed at this time
    :parameter crusty: if this seedbed has a crusty top
    :parameter dry_crust: if this seed bed has a dry crust
    :parameter collisions: a count of collisions # TODO make this work - then use a list of collision objects
    :parameter run_day: the day after sowing that the seedbed is on now
    :parameter seed_tray: a set of instances of class seed in a list
    :parameter clod_bed: a set of instances of class clod in a list
    :parameter all_rain: the total accumulated rainfall so far in the test
    :parameter setup: an instance of the setup class that contains all the info on the sowing from the setup files

    :returns A seedbed object
    """
    crusty = False      # is the seed bead currently crusty
    dry_crust = False   # is the crust currently dry
    collisions = 0      # the number of times a clods or seed collide
    run_day = 0         # the day of the seed bed run
    seed_tray = list()  # a seed tray containing all the seed objects
    clod_bed = list()   # a try of the clods containing all the clod objects
    all_rain = 0        # Total rain fall
    setup = Read.setupSeedbed()  # Read the setup 5 setup files and make an object of all the data

    def __init__(self): # todo define clod limets
        """Initialise an instance of seedbed
        :parameter clod_no: the number of each clod - 1 indexed
        :parameter clod_set: the min size of the clod for a grouped lot of clods
        :parameter clod: the clod in this set
        :parameter clod_lims: an array representing the [L,h,l] for a clod
        :parameter clod_serf_prob: the result of a function call to find where the clod is stuck [False,False,False] for [prob_serf, stuck_serf, stuck_soil]
        :parameter Clod: the class that makes a clod object
        :parameter sd: a seed in this sowing
        :parameter Seed: the class that makes a Seed object
        """
        self.setup.sort_clods()
        clod_no = 0                     # a unique clod number for each clod
        for clod_set in range(0, len(self.setup.clod_nos)):
            for clod in range(0, Clods.clod_numbers(self.setup.clod_nos[clod_set], self.setup.plot_xyz)):
                clod_no += 1            # update for each clod
                Write.run_summ("clod " + str(clod_no))
                clod_lims = Clods.clod_size(self.setup.clod_lims, clod_set)
                radi = (sum(clod_lims) / 3.0)/ 2.0
                clod_serf_prob = Fun.clod_restriction(self.setup.p_serf[clod_set],self.setup.p_stuck_serf[clod_set],self.setup.p_stuck_soil[clod_set])
                self.clod_bed.append(Clods.Clod(clod_no, Fun.position_calc(self.seed_tray, self.clod_bed, self.setup.plot_xyz[2] - self.setup.sow_depth, self.setup.plot_xyz, True, radi, clod_serf_prob), self.setup.plot_xyz[2], clod_lims))
                #print self.clod_bed[clod]

        for sd in range(0, self.setup.no_seeds):
            self.seed_tray.append(Seeds.Seed(sd + 1, self.setup.day_death, self.setup.therm_times, self.setup.base_germ, self.setup.base_elong, self.setup.base_wet,
                                  Fun.position_calc(self.seed_tray, self.clod_bed, self.setup.plot_xyz[2] - self.setup.sow_depth, self.setup.plot_xyz, False)))
            Write.run_summ("seed " + str(sd+1) + " initialised")
            print self.seed_tray[sd]

    def next_day(self, day):
        """Calls other functions to make the next day proceed
        :param day: The day of the year to look up the rainfall
        :returns : objects
        """
        self.run_day += 1
        self.crusty_prob(day)
        Write.Seed_info(self.seed_tray, self.setup.no_seeds, self.setup.sow_depth) # germination info write out
        for sd in range(0, self.setup.no_seeds):
            self.seed_tray[sd].next_day(day, self.setup, self.clod_bed, self.crusty)
            print self.seed_tray[sd]

    def crusty_prob(self, day):
        """returns the probability of the seedling getting through the outer layer of soil
        :param day: The day of the year to look up the rainfall
        :keyword CRc: The rainfall needed cumulatively to produce a crust (default 12mm)
        :keyword DRc1: The recent rainfall needed to produce a crust (default 5mm)
        :keyword DRc2: The recent rainfall needed to make the crust soft and most (default 3.5mm)
        :returns prob: -1 for no crust or the probabilty of going thrugh the crust (1 for wet crust)
        """
        crust = False                                               # default no crust
        self.all_rain += self.setup.enviro_data_rain[day]           # increment total rain fall

        if self.all_rain > self.setup.crc:                          # all rain more than amount of total rain to make a crust
            crust = True
        if self.setup.enviro_data_rain[day] > self.setup.drc1:      # Day rain more than day rain to make a crust
            crust = True
        if crust:
            if self.setup.enviro_data_rain[day] > self.setup.drc2:
                prob = 1                                            # crust is wet end seedling can emerge prob = 1
            else:
                prob = self.setup.p_dry_crust                       # crust is dry emergence depends on seed power
        else:
            prob = -1

        self.crusty = prob

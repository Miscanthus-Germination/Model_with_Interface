import Fun
import random
import math
import Write

class Clod(object):
    # pos = [0,0,0] # x y z
    # size = [0,0,0] # long, mid, short
    # rotation = [0,0,0] # rot x y z
    # serfice = False # center is above serfice
    # below = False # hole clod is below serfice
    def __init__(self, clod_no, pos, depth, clod_lims):
        """
        :param clod_no:
        :param pos:
        :param depth:
        :param clod_lims:
        """
        self.clod_no = clod_no      # clod number set
        self.pos = pos              # Clods position determined by function
        self.size = clod_lims       # todo function will be haer like seed lims ( + ridus high )
        self.radi = (sum(self.size) / float(len(self.size))) / 2
        self.rotation = [random.randint(1, 180), random.randint(1, 180), random.randint(1, 180)]
        self.serfice = 0.5          # clod is partly out of the soil # todo represent this as a %?

        if self.pos[2] >= depth:
            self.serfice = 1        # clod is out of the soil
        if self.pos[2] - self.radi < depth:
            self.serfice = 0        # clod is under the soil

    def __str__(self):
        self.out = "\tClod " + str(self.clod_no)
        self.out = self.out + "\tX-" + str(self.pos[0]) + " Y-" + str(self.pos[1]) + " Z-" + str(self.pos[2])
        self.out = self.out + "\tLong-" + str(self.size[0]) + " Mid-" + str(self.size[1]) + " Tall-" + str(self.size[2])
        self.out = self.out + "\tradi-" + str(self.radi)
        return self.out




def clod_numbers(number, plot_xyz):
    """the inputs ask for the nuber of clods in a 1mater squere down to 4 cm deep
    :param number:
    :param plot_xyz:
    :return:
    """
    number = float(number)
    number = number/1000.0
    number = number/1000.0
    number = number/40.0
    # nu8mber now = clods per sq mm of bed

    vol = plot_xyz[0] * plot_xyz[1] * plot_xyz[2] # volume of this pot
    number = int(math.ceil(number * vol)) # number of clods in this plot

    return number

def clod_size(size, set):
    """the inputs ask for the nuber of clods in a 1mater squere down to 4 cm deep
    :param size:
    :param set:
    :return:
    """
    try:
        size_above = size[set + 1]
    except IndexError:
        size_above = size[set] + size[set]/7.5 #if this is the maximan size there is a max longist side of + 25% minimum

    L = size_above
    h = size[set]
    l = (3 * h + L)/4

    size = [L,h,l]
    return size
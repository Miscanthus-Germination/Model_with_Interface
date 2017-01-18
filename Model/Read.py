import csv
import Write


class setupSeedbed(object): # todo not all components used in model
    day_death = 0.01  # 0.01 todo put this in the r shiny ui so it can be in the spp components

    def __init__(self):
        """
        """
        with open('Model/Temp.Data/Components.sow.csv', 'rb') as csvfile:
            setup_data = csv.DictReader(csvfile)
            for row in setup_data:
                self.no_seeds = convert_int(row['Seeds'],1)
                self.plot_xyz = [convert_int(row['x'],10),convert_int(row['y'],10),convert_int(row['z'],10)]
                self.sow_depth = convert_int(row['SD'],5)
                self.style = convert_int(row['yStyle'],1)
                self.no_days = convert_int(row['Run'],2)
                self.start_day = convert_int(row['Startday'],127)
                self.crc = convert_float(row['CRc'],12.0)
                self.drc1 = convert_float(row['DRc1'],5.0)
                self.drc2 = convert_float(row['DRc2'],3.5)
                self.sow_lines_s = convert_int(row['Sowing.lineS'],0)
                self.sow_lines_e = convert_int(row['Sowing.lineE'],5)
                self.sow_lines_s2 = convert_int(row['Sowing.line2S'],0)
                self.sow_lines_e2 = convert_int(row['Sowing.line2E'],5)

        with open('Model/Temp.Data/ClodLims.csv', 'rb') as csvfile:
            setup_data = csv.DictReader(csvfile)
            self.clod_nos = []
            self.clod_lims = []
            self.p_serf = []
            self.p_stuck_serf = []
            self.p_stuck_soil = []
            for row in setup_data:
                self.clod_nos.append(convert_int(row["No.of.Clods"],1))
                self.clod_lims.append(convert_int(row["Min.Size"],1))
                self.p_serf.append(convert_float(row["P.on.serface"],0.1))
                self.p_stuck_serf.append(convert_float(row["P.stuk.serface"],0.1))
                self.p_stuck_soil.append(convert_float(row["P.stuk.soil"],0.1))
        self.no_clods = sum(self.clod_nos)

        with open('Model/Temp.Data/Components.spp.csv', 'rb') as csvfile:
            setup_data = csv.DictReader(csvfile)
            for row in setup_data:
                self.base_germ = convert_float(row['Tb.germ'],0.0)
                self.base_elong = convert_float(row['Tb.elomg'],0.0)
                self.p_dry_crust = convert_float(row['DryProb'],0.9)
                self.min_hit = convert_int(row['Hit.Size'],5)
                self.stage_two = convert_float(row['a'],50.0)
                self.poly = [convert_float(row['b'],-0.00008),convert_float(row['c'],0.1314)]  # a max lenth of seedling, b grouth per tt?, c shape of curve

        with open('Model/Temp.Data/SeedLims.csv', 'rb') as csvfile:
            setup_data = csv.DictReader(csvfile)
            self.therm_times = []
            for row in setup_data:
                self.therm_times.append([convert_float(row["Frc"],0.1),convert_float(row["tgball"],99999)])

        with open('Model/Temp.Data/WaterLims.csv', 'rb') as csvfile:
            setup_data = csv.DictReader(csvfile)
            self.base_wet = []
            for row in setup_data:
                self.base_wet.append([convert_float(row["Proportion"],1.0),convert_float(row["Water"],1.0)])

        with open('Model/Temp.Data/EnviroData.csv', 'rb') as csvfile:
            enviro_file = csv.DictReader(csvfile)
            self.enviro_data_day = []
            self.enviro_data_temp = []
            self.enviro_data_wat = []
            self.enviro_data_rain = []
            for row in enviro_file:
                self.enviro_data_day.append(convert_int(row["Day"],1))
                self.enviro_data_temp.append(convert_float(row["AvTemp"],5.0))
                self.enviro_data_wat.append(convert_float(row["AvWat"],0.1))
                self.enviro_data_rain.append(convert_float(row["Rainfall"],0.1))
        self.RDepth = self.plot_xyz[2] - self.sow_depth                  # the depth of the sowing from the bottom

    def __str__(self):
        self.out = "Components sow"
        self.out = self.out + "\n\t no seeds:\t" + str(self.no_seeds)
        self.out = self.out + "\n\t Sowing depth:\t" + str(self.sow_depth)
        self.out = self.out + "\n\t plot x,y,z:\t" + str(self.plot_xyz)
        self.out = self.out + "\n\t row style:\t" + str(self.style)
        self.out = self.out + "\n\t no days run:\t" + str(self.no_days)
        self.out = self.out + "\n\t Day of year to start:\t" + str(self.start_day)
        self.out = self.out + "\n\t crc:\t" + str(self.crc)
        self.out = self.out + "\n\t drc1:\t" + str(self.drc1)
        self.out = self.out + "\n\t drc2:\t" + str(self.drc2)
        self.out = self.out + "\n\t sow_lines_s:\t" + str(self.sow_lines_s)
        self.out = self.out + "\n\t sow_lines_e:\t" + str(self.sow_lines_e)
        self.out = self.out + "\n\t sow_lines_s2:\t" + str(self.sow_lines_s2)
        self.out = self.out + "\n\t sow_lines_e2:\t" + str(self.sow_lines_e2)
        self.out = self.out + "\n Clod Lims"
        self.out = self.out + "\n\t no clods - " + str(self.no_clods)
        self.out = self.out + "\n\t numbers     - " + str(self.clod_nos)
        self.out = self.out + "\n\t limits size - " + str(self.clod_lims)
        self.out = self.out + "\n\t prob serf   - " + str(self.p_serf)
        self.out = self.out + "\n\t prob stuck  - " + str(self.p_stuck_serf)
        self.out = self.out + "\n\t p stuck soil- " + str(self.p_stuck_soil)
        self.out = self.out + "\n Components spp"
        self.out = self.out + "\n\t base germ temp:\t" + str(self.base_germ)
        self.out = self.out + "\n\t base elong temp:\t" + str(self.base_elong)
        self.out = self.out + "\n\t base water:\t" + str(self.base_wet)
        self.out = self.out + "\n\t p of emerging through dry crust:\t" + str(self.p_dry_crust)
        self.out = self.out + "\n\t min size of clod to effect:\t" + str(self.min_hit)
        self.out = self.out + "\n\t p of death each day un-germ:\t" + str(self.day_death)
        self.out = self.out + "\n\t weibel a,b,c:\t" + str(self.weibel)
        self.out = self.out + "\n Seed Lims"
        self.out = self.out + "\n\t Thermal times [proportion, thermal time by]\n\t" + str(self.therm_times)

        return self.out

    def sort_clods(self):
        """makes largest clods go first
        """
        self.clod_nos = self.clod_nos[::-1]
        self.clod_lims = self.clod_lims[::-1]
        self.p_serf = self.p_serf[::-1]
        self.p_stuck_serf = self.p_stuck_serf[::-1]
        self.p_stuck_soil = self.p_stuck_soil[::-1]
        # todo make this a better function that takes account of clod sizes

def convert_float(a_string,default):
    """
    :param a_string:
    :param default:
    :return:
    """
    try:
        a_string=float(a_string)
    except ValueError:
        print "ERROR: default float Substitution! - " + str(default)
        a_string=default
    return a_string

def convert_int(a_string,default):
    """
    :param a_string:
    :param default:
    :return:
    """
    try:
        a_string=int(a_string)
    except ValueError:
        print "ERROR: default integer Substitution! - " + str(default)
        a_string=default
    return a_string
# !/usr/bin/python
__author__ = 'dgc1'
# import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D
# from matplotlib import animation
# import subprocess
import datetime as now
import Write
import plot as pt
import Seedbed

Write.run_summ("Model Run Start at " + str(now.datetime.now()), new='w')

plot = Seedbed.Seedbed()                        # setup seed bed

for day in range(0, plot.setup.no_days + 1):
    plot.next_day(day)                          # advance seed bead to the next day

# write end output files
Write.Clod_info(plot.clod_bed, len(plot.clod_bed))
Write.Seed_collide(plot.seed_tray, plot.setup.no_seeds, plot.setup.RDepth)
Write.Make_summ(plot.seed_tray, plot.setup.no_seeds)

Write.run_summ("Model Run Finished at " + str(now.datetime.now()))

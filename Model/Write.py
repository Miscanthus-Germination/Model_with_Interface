import csv
import Fun


def Seed_info(seed_tray, no_seeds, depth):
    """write out seed info file for shiny
    :param seed_tray:
    :param no_seeds:
    :param depth:
    """
    if seed_tray[0].ds_sow == 0:
        with open('Model/Temp.Data/Seed_info.csv', 'w') as csvfile:
            fieldnames = ['i', 'd','STTi','STTid','Gi','TTd','l.t','DG','HLi','Emerge','RanCrust','RanWat']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=',', lineterminator='\n')
            writer.writeheader()

            for sd in range(0, no_seeds):
                if seed_tray[sd].germ:
                    Gi = 1
                else:
                    Gi = 0

                emerge = Fun.emerge_summry(seed_tray, sd)   # calculate what happened to the seed
                writer.writerow({'i':str(seed_tray[sd].seed_no),
                                 'd':str(seed_tray[sd].ds_sow),
                                 'STTi':str(seed_tray[sd].tt_req),
                                 'STTid':str(seed_tray[sd].tt),
                                 'Gi':str(Gi),
                                 'TTd':str(seed_tray[sd].ttd),
                                 'l.t':str(seed_tray[sd].hieght),
                                 'DG':str(seed_tray[sd].ds_germ),
                                 'HLi':str(seed_tray[sd].hieght + depth),
                                 'Emerge':str(emerge),
                                 'RanCrust':str(seed_tray[sd].base_crust),
                                 'RanWat':str(seed_tray[sd].base_wat)
                                 })

    else:
        with open('Model/Temp.Data/Seed_info.csv', 'a') as csvfile:         # append seed info file for shiny
            fieldnames = ['i', 'd','STTi','STTid','Gi','TTd','l.t','DG','HLi','Emerge','RanCrust','RanWat'] # to do not all of theas exist corectly
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=',', lineterminator='\n')

            for sd in range(0, no_seeds):
                if seed_tray[sd].germ:
                    Gi = 1
                else:
                    Gi = 0

                emerge = Fun.emerge_summry(seed_tray, sd)   # calculate what happened to the seed
                writer.writerow({'i':str(seed_tray[sd].seed_no),
                                 'd':str(seed_tray[sd].ds_sow),
                                 'STTi':str(seed_tray[sd].tt_req),
                                 'STTid':str(seed_tray[sd].tt),
                                 'Gi':str(Gi),
                                 'TTd':str(seed_tray[sd].ttd),
                                 'l.t':str(seed_tray[sd].hieght),
                                 'DG':str(seed_tray[sd].ds_germ),
                                 'HLi':str(seed_tray[sd].hieght + depth),
                                 'Emerge':str(emerge),
                                 'RanCrust':str(seed_tray[sd].base_crust),
                                 'RanWat':str(seed_tray[sd].base_wat)
                                 })



def Clod_info(clod_bed, clod_no):
    """write out clod info file for shiny
    :param clod_bed:
    :param clod_no:
    """
    with open('Model/Temp.Data/Clod_info.csv', 'w') as csvfile:
        fieldnames = ['L', 'h','l','center.1.','center.2.','center.3.','oriant.1.','oriant.2.','Stuck']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=',', lineterminator='\n')
        writer.writeheader()

        for sd in range(0, clod_no):
            writer.writerow({'L':str(clod_bed[sd].size[0]),
                             'h':str(clod_bed[sd].size[1]),
                             'l':str(clod_bed[sd].size[2]),
                             'center.1.':str(clod_bed[sd].pos[0]),
                             'center.2.':str(clod_bed[sd].pos[1]),
                             'center.3.':str(clod_bed[sd].pos[2]),
                             'oriant.1.':str(clod_bed[sd].rotation[0]),
                             'oriant.2.':str(clod_bed[sd].rotation[1]),
                             'Stuck':str(clod_bed[sd].serfice)
                             })



def Seed_collide(seed_tray, no_seeds, Depth):
    """write out seed collide file for shiny
    :param seed_tray:
    :param no_seeds:
    :param Depth:
    """
    with open('Model/Temp.Data/Seed_cloide.csv', 'w') as csvfile:
        fieldnames = ['x', 'y','z','ID','Gi','Hight','Emerge','Hit','Hit.H', 'Hit.oriant', 'Hit.size', 'Hit.stik']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=',', lineterminator='\n')
        writer.writeheader()

        for sd in range(0, no_seeds):
            if seed_tray[sd].germ:
                Gi = 1
            else:
                Gi = 0

            emerge = Fun.emerge_summry(seed_tray, sd)   # calculate what happened to the seed
            writer.writerow({'x':str(seed_tray[sd].pos[0]),
                             'y':str(seed_tray[sd].pos[1]),
                             'z':str(seed_tray[sd].pos[2]),
                             'ID':str(seed_tray[sd].seed_no),
                             'Gi':str(Gi),
                             'Hight':str(seed_tray[sd].hieght + Depth),
                             'Emerge':str(emerge),
                             'Hit':str(seed_tray[sd].clod.clod_no),
                             'Hit.H':str(seed_tray[sd].hit_h),
                             'Hit.oriant':str(seed_tray[sd].clod.rotation[0]),
                             'Hit.size':str(seed_tray[sd].clod.radi),
                             'Hit.stik':str(seed_tray[sd].clod.serfice)
                             })



def Make_summ(seed_tray, no_seeds):
    """write out summary file for shiny
    :param seed_tray:
    :param no_seeds:
    """
    with open('Model/Temp.Data/summ.csv', 'w') as csvfile:
        fieldnames = ['seeds', 'No.Germed','No.NGermed','No.hitClod','No.NRound','No.Round','No.Emerge','No.NEmerge','No.StopedCrust', 'No.StopedClod', 'No.NuTT.E', 'No.Dead', 'No.NuTT.G']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames, delimiter=',', lineterminator='\n')
        writer.writeheader()

        writer.writerow({'seeds':str(no_seeds),                                                                         # Number of seeds
                         'No.Germed':str(sum(p.germ for p in seed_tray)),                                               # Number greminated
                         'No.NGermed':str(sum(p.germ == False for p in seed_tray)),                                     # Number not greminated
                         'No.hitClod':str(sum(p.clod.clod_no != 0 and p.clod_impassable for p in seed_tray)),               # Number hit impassable clod
                         'No.NRound':str(str(sum(p.stuck_clod and p.circumvent != 0 for p in seed_tray))),              # Number did't go round passable clod
                         'No.Round':str(str(sum(p.circumvented for p in seed_tray))),                                   # Number go round passable clod
                         'No.Emerge':str(sum(p.emerge for p in seed_tray)),                                             # Number emerge
                         'No.NEmerge':str(sum(p.emerge == False for p in seed_tray)),                                   # Number not emerge
                         'No.StopedCrust':str(sum(p.stuck_crust for p in seed_tray)),                                   # Number stuck under crust
                         'No.StopedClod':str(sum(p.clod.clod_no != 0 for p in seed_tray)),                                  # Number intracted with clod
                         'No.NuTT.E':str(sum(p.germ and not p.dead and not p.emerge and p.clod.clod_no == 0 for p in seed_tray)),   # Number haven't germinated yet (<tt)
                         'No.Dead':str(sum(p.dead for p in seed_tray)),                                                 # Number dead
                         'No.NuTT.G':str(sum(p.tt_req != 99999 and not p.germ and not p.dead for p in seed_tray))       # Number haven't emerged yet (<tt)
                         })


def run_summ(error_text, line="\n", new='a'):
    """Write error summary file for shiny
    :param error_text:
    :param line:
    :param new:
    """
    errorfile = open('Model/Temp.Data/.lastruninfo.txt', new) #opens file with name of "test.txt"
    errorfile.write(error_text + line)
    errorfile.close()

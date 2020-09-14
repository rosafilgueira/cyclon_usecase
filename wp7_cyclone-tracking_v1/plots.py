
import matplotlib.pyplot as plt
import matplotlib.patches
import matplotlib as mpl
from mpl_toolkits.axes_grid1 import make_axes_locatable
import cartopy.feature as cfeature
import cartopy.crs as ccrs
import os
import sys
import numpy as np
import pandas as pd

import cyclonetrackprod.tracks_read as tracks_read
import cyclonetrackprod.tracks_products as tracks_products
import cyclonetrackprod.tracks_density as tracks_density
import cyclonetrackprod.tracks_stddev as tracks_stddev
import cyclonetrackprod.tracks_tools as tracks_tools

filename = sys.argv[1]
minlon = float(sys.argv[2])
maxlon = float(sys.argv[3])
minlat = float(sys.argv[4])
maxlat = float(sys.argv[5])

domain = {
    'lon_min': -90,
    'lon_max': 90,
    'lat_min': -90,
    'lat_max': 90,
    'zradius': 3.0e+5,
    'ires': 4,
    'resolution': 1.5
    }

boundaries = [minlon, minlat, maxlon, maxlat]

if os.environ.get('CARTOPY_USER_BACKGROUNDS') is None:
  os.environ["CARTOPY_USER_BACKGROUNDS"] = "./"

df = tracks_read.readfile(filename)

#tracks_products.colortendencies(df, "Cyclones Tracks", "cyclone_tracks.png", boundaries)

df_1000 = tracks_read.filter_upperbound(df, 'Pressure', 1000)
tracks_products.map_density(df_1000, "Total Density. Filter: 1000 hPa", "total_density_1000", domain, boundaries)
#tracks_products.map_monthly_density(df_1000, "monthly_density_1000", domain, boundaries)
#tracks_products.map_seasonal_density(df_1000, "seasonal_density_1000", domain, boundaries)


#!/usr/bin/env python

"""
 ***************************************************************************
 *   Copyright (C) 2011 Aaron Lindsay                                      *
 *   aaron.lindsay@vt.edu                                                  *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.           *
 ***************************************************************************
"""

import sys
from math import sqrt

def main():
    mean,std,mn,mx = stats("results/c")
    print "Average time in C: "+str(mean)+" ticks (stddev: "+str(std)+", min: "+str(mn)+", max: "+str(mx)+")"
    mean,std,mn,mx = stats("results/java")
    print "Average time in Java: "+str(mean)+" ticks (stddev: "+str(std)+", min: "+str(mn)+", max: "+str(mx)+")"

def stats(filename):
    ifile = open(filename)
    times = []
    mx = 0
    mn = -1
    for line in ifile:
        time = int(line.strip())
        if time > mx:
            mx = time
        if mn == -1 or time < mn:
            mn = time
        times.append(time)
    ifile.close();
    mean,std = meanstdv(times)
    return mean,std,mn,mx

"""
This function was found at
http://www.phys.uu.nl/~haque/computing/WPark_recipes_in_python.html
"""
def meanstdv(x):
    n, mean, std = len(x), 0, 0
    for a in x:
        mean = mean + a
    mean = mean / float(n)
    for a in x:
        std = std + (a - mean)**2
    std = sqrt(std / float(n-1))
    return mean, std

if __name__ == "__main__":
    main();

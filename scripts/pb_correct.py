#!/usr/bin/env python

import sys

from nucio import *

from seqio import fastaIterator

from operator import itemgetter
from itertools import groupby, repeat, izip_longest, imap, count, chain
from collections import namedtuple
from cov import getMarkedRanges
from misc import create_enum
import copy


if not len(sys.argv) == 7:
    print "pb_correct.py in.fa in.snps in.showcoords clr_id(float) min_read_length out_prefix"
    sys.exit(1)

CLR_ID_CUTOFF = float(sys.argv[4])
MIN_READ_LENGTH = int(sys.argv[5])

PileupEntry = namedtuple("PileupEntry", ["index","base","snps","utg","clr"])
CovStat = {"COVERED":"COVERED", "UNCOVERED":"UNCOVERED", "JOINED":"JOINED"}

class CoverageRange:
    def __init__(self, b, e, pid, covstat):
        self.begin = b
        self.end = e
        self.pctid = pid
        self.covstat = covstat

    def __repr__(self):
        return "CoverageRange(%d,%d,%f,%s)" % (self.begin,self.end,
                                               self.pctid, self.covstat)

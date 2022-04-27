#!/usr/bin/env python
import sys
import os
from itertools import starmap, chain, imap
from operator import itemgetter
from seqio import iteratorFromExtension, recordToString, fastaRecordToString, seqlen
from nucio import fileIterator, openerFromExtension
from args import parseArgs, getHelpStr, argflag, CLArgument
from misc import defdef
description = ("Usage: partition.py [-options] "
               "<reads_per_file (int)> <files_per_dir (int)> <input.{fa,fq}> [input2.{fa,fq} ...]")
argument_list = [["sameformat", "samefmt", argflag, False,
                  ("Output files will be in the same format "
                   "as the input files. By default they are converted "
                   "to fasta.")],
                 ["minlen", "minlen", int, 1,
                  ("Only output reads that are greater than or equal to 'minlen' "
                   "Default: 1")]]
arguments = map(CLArgument._make, argument_list)
if not len(sys.argv) > 1:
    sys.exit(getHelpStr(description,arguments) + "\n")
(p_arg_map, args_remaining) = parseArgs(sys.argv[1:], arguments)

if not len(args_remaining) >= 3:
    sys.exit(getHelpStr(description,arguments) + "\n")
def pstr(num):
return "%04d" % num

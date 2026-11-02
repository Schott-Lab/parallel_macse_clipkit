#!/bin/bash

# By: Ryan Schott
# Mutiple sequence codon alingment pipeline using MACSE (https://www.agap-ge2pop.org/macse/macse-documentation/)
# and CLIPKIT (https://github.com/jlsteenwyk/clipkit)
# The exclamation marks (!) are autmotically replaced with gaps (-) in the "macse_trim" file
# Parallelized using gnu parallel (https://www.gnu.org/software/parallel/)
# Usage: bash parallel_prank_clip.sh *.fas
# Or: bash parallel_prank_clip.sh file1.fas file2.fas file3.fas ...

parallel -j 4 "macse -prog trimNonHomologousFragments -seq {} -out_trim_info {.}_output_stats.csv && \
	macse -prog alignSequences -seq {.}_NT.fas && \
	macse -prog refineAlignment -align {.}_NT_NT.fas -optim 1 && \
	sed 's/\!/n/g' {.}_NT_NT_NT.fas > {.}_macse_trim.fas && \
	clipkit {.}_macse_trim.fas -o {.}_macse_clip.fas --codon" ::: $@

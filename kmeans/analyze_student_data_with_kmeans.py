#!/usr/bin/env python

from kmeans import Point, run_kmeans
from kmeans_varying_k import run_kmeans_varying_k
from normalize_data import normalize
import sys, csv, numpy

def main(args):
    if len(args[1:]) != 1:
        print 'usage: %s <students-filename>' % args[0]
        sys.exit(1)

    with open(args[1], 'rU') as f:
        reader = csv.reader(f)
        header = reader.next()

        data = [line for line in reader]

    for index,feature in enumerate(header):
        print 'Do you want to analyze "{0}"? [y/N]'.format(feature),
        if raw_input().lower() in ['y','yes']:
            points = [Point(datapoint[index]) for datapoint in data]
            #normalize(points)

            #run_kmeans(points, num_clusters=3, num_iterations=100)
            run_kmeans(points, num_clusters=5, num_iterations=10)
            #run_kmeans_varying_k(points)


if __name__ == '__main__':
    main(sys.argv)

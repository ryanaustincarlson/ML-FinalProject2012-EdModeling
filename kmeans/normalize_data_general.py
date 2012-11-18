from kmeans import *
import sys, numpy, os

def normalize(points):
    for ftr_index in range(len(points[0].features)):
        ftrs = [point.features[ftr_index] for point in points]

        ftr_avg = numpy.average(ftrs)
        ftr_std = numpy.std(ftrs)

        for point in points:
            point.features[ftr_index] = (point.features[ftr_index] - ftr_avg) / ftr_std

def main(args):
    if len(args[1:]) != 1:
        print 'usage: %s <points-filename>' % args[0]
        sys.exit(1)
        
    points_filename = args[1]
    points = Point.load_points(points_filename)

    normalize(points)
    
    (basename, extension) = os.path.splitext(points_filename)
    outfilename = basename + '-normalized' + extension
    Point.write_points(points, outfilename)
        
if __name__ == '__main__':
    main(sys.argv)

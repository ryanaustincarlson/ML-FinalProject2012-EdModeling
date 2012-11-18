from kmeans import *
import sys, numpy, os

def normalize(points):
    vals = [point.feature for point in points]
    val_avg = numpy.average(vals)
    val_std = numpy.std(vals)

    for point in points:
        point.feature = (point.feature - val_avg) / val_std

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

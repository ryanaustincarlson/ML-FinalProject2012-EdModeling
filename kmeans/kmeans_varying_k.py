from kmeans import *

def plot_stats(list_of_stats):
    import matplotlib.pyplot as plt
    import matplotlib.axes as pla
    """
    list_of_stats: list of objects with type namedtuple => Stats
    """
    
    plt.scatter(range(1,len(list_of_stats)+1),
                list_of_stats
                )
    
    plt.show()

def run_kmeans_varying_k(points, initialization_function=randomly_initialize_centroids, distance_function=Point.sqrtdist):
    best_min = []
    for k in range(1,10+1):
        final_centroids = []
        final_assignments = []
        for iteration in range(1,101):
            (centroids, assignments) = get_best_centroids(\
                    points, k, initialization_function, distance_function)
            final_centroids.append( centroids )
            final_assignments.append( assignments )
            print 'k: %d, iteration: %d\r' % (k, iteration),
            sys.stdout.flush()
        print
        stats = centroid_stats(points, final_centroids, final_assignments, \
                               distance_function)
        print 'Min Sum of Squares:', stats.min
        print 'Average Sum of Squares:', stats.avg
        print 'Standard Deviation Sum of Squares:', stats.std
        best_min.append( stats.min )
    
    plot_stats(best_min)

def main(args):
    if len(args[1:]) != 1 and len(args[1:]) != 2:
        print 'usage: %s <points-filename> <use-sqrt=1,0 default:0>' % args[0]
        sys.exit(1)
    
    points_filename = args[1]    
    points = Point.load_points(points_filename)
    
    initialization_function = randomly_initialize_centroids
    distance_function = Point.distance
    try:
        if args[2] == '1':
            distance_function = Point.sqrtdist
    except:
        pass
    
    run_kmeans_varying_k(points, initialization_function, distance_function)
        



if __name__ == '__main__':
    main(sys.argv)

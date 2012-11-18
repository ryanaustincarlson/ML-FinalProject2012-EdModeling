#!/usr/bin/env python

import sys, math, csv, random, itertools, numpy
from pprint import pprint

class Point:
    def __init__(self, feature):
        self.feature = float(feature)

    def getX(self):
        return self.feature

    def getY(self):
        return 0 

    @staticmethod
    def distance(p1, p2):
        return (p1.feature - p2.feature)**2

    @staticmethod
    def sqrtdist(p1, p2):
        return math.fabs(p1.feature - p2.feature)
        #return math.sqrt(Point.distance(p1, p2))
    
    @staticmethod
    def load_points(filename):
        return [Point(features[0]) for features in csv.reader(open(filename, 'rU'))]
    
    @staticmethod
    def write_points(points, filename):
        with open(filename, 'w') as f:
            writer = csv.writer(f)
            for point in points:
                writer.writerow(point.features)
    
    def __repr__(self):
        return '{0}'.format(self.features)
    
def randomly_initialize_centroids(points, k):
    return random.sample(points, k)

def kmeanspp_initialize_centroids(points, k, distfcn=Point.distance):
    centroids = random.sample(points, 1)
    for j in range(1,k):
        distances = [] # each datapoint's distance from the nearest cluster center
        for point in points:
            min_dist = sys.maxint
            for centroid in centroids:
                dist = distfcn(point, centroid)
                if dist < min_dist:
                    min_dist = dist
            distances.append(min_dist)
        
        # TODO: try to make runtime take forever :) see if it makes any difference
        distances_sum = float(sum(distances))
        distance_probs = map(lambda x: x / distances_sum, distances)
        
        # we want to randomly select the next centroid randomly 
        # with probability distribution given by distance_probs
        
        # so first group the indices (which point the probability is associated with) 
        # with each probability, because we're going to sort by probability
        distance_probs = zip(distance_probs, range(len(distance_probs)))
        
        # now sort by probability, with largest probabilities first
        distance_probs = sorted(distance_probs, reverse=True)
        #distance_probs = sorted(distance_probs)
        
        total = 0
        target = random.uniform(0,1)
        for prob,index in distance_probs:
            total += prob
            if total > target:
                break
        
        # the next centroid is given by the index where the sampling stopped
        #print index
        
        #(prob, index) = distance_probs[0] ## THIS MAKES EVERYTHING NICE
        centroids.append( points[index] ) 
        
    return centroids
                
                

def get_cluster_assignments(points, clusters, distfcn=Point.distance):
    assignments = []
    for point in points:
        min_dist = sys.maxint
        best_cluster = None
        for index, cluster in enumerate(clusters):
            dist = distfcn(point, cluster)
            if dist < min_dist:
                min_dist = dist
                best_cluster = index
        assignments.append(best_cluster)
    return assignments

def get_cluster_centroids(points, assignments):
    centroids = []
    for cluster_index in sorted(set(assignments)):
        point_indices_in_this_cluster = [index for index,cluster in enumerate(assignments) if cluster == cluster_index]
        
        vals = [points[i].feature for i in point_indices_in_this_cluster]
        centroids.append( Point(numpy.average(vals)) )
        
    return centroids

def get_best_centroids(points, num_clusters, initialize_fcn, distfcn=Point.distance):
    init_centroids = initialize_fcn(points, num_clusters)
        
    old_assignments = None
    centroids = init_centroids
    while True:
        assignments = get_cluster_assignments(points, centroids, distfcn)
        #print assignments
        
        centroids = get_cluster_centroids(points, assignments)
        #print centroids
        
        if assignments == old_assignments:
            return (centroids, assignments) 
        
        old_assignments = assignments
        
def plot(points, centroids):
    import matplotlib.pyplot as plt
    import matplotlib.axes as pla

    plt.scatter([point.getX() for point in points],
                [point.getY() for point in points],
                marker='o',
                color='grey'
                ) 
     
    centroids = list(itertools.chain.from_iterable(centroids)) # flatten centroids
    plt.scatter([point.getX() for point in centroids],
                [point.getY() for point in centroids],
                marker='x',
                linewidths='2'
                )

    #plt.vlines([.67,1.24,1.72,3], -.02, .02) # hints_req
    #plt.vlines([.83,1.51,2.41,3.95], -.02, .02) # num_errors
    #plt.vlines([2.3,5.2,9,15.5], -.02, .02) # minSpent
    #plt.vlines([.618,.658,.728,.825], -.02, .02) # IncCor
    #plt.vlines([.0195,.043,.109,.211], -.02, .02) # IncHint
    #plt.vlines([.116,.144,.203,.296], -.02, .02) # IncInc
    plt.vlines([.015,.036,.067,.157], -.02, .02) # NumBOH


    
    plt.show()
    
def centroid_stats(points, centroids, assignments, distfcn=Point.distance):
    import numpy, collections
    """
    calculate the min, mean, and std dev of within-cluster 
    sums of squares (the dist functions)
    
    centroids: list of lists, where each nested list 
               contains a set of best centroids
    """
    
    def sum_of_squares(centroid_set, assignment_set, distfcn):
        return sum([distfcn(point, centroid_set[assignment]) for \
                point,assignment in zip(points, assignment_set)])
    
    sos_vals = []
    for centroid_set, assignment_set in zip(centroids, assignments):
        sos_vals.append( sum_of_squares(centroid_set, assignment_set, distfcn) )
    
    minimum = min(sos_vals)
    average = numpy.average(sos_vals)
    std = numpy.std(sos_vals) 
    
    Stats = collections.namedtuple('Stats', ['min','avg','std'])
    return Stats(minimum, average, std)
    
def run_kmeans(points, num_clusters, num_iterations=200, initialization_function=randomly_initialize_centroids):
    final_centroids = []
    final_assignments = []
    for iteration in range(1,num_iterations+1):
        (centroids, assignments) = get_best_centroids(points, num_clusters, initialization_function)
        final_centroids.append( centroids )
        final_assignments.append( assignments )
        print 'iteration: %d\r' % iteration,
        sys.stdout.flush()
    print
        
    stats = centroid_stats(points, final_centroids, final_assignments)
    print 'Min Sum of Squares:', stats.min
    print 'Average Sum of Squares:', stats.avg
    print 'Standard Deviation Sum of Squares:', stats.std    
    
    plot(points, final_centroids)

def main(args):
    if len(args[1:]) != 4:
        print 'usage: %s <points-filename> <num-clusters> <num-iterations> <random|k++>' % args[0]
        sys.exit(1)
        
    points_filename = args[1]
    num_clusters = int(args[2])
    num_iterations = int(args[3])
    if (args[4] == 'random'):
        initialization_function = randomly_initialize_centroids
    elif (args[4] == 'k++'):
        initialization_function = kmeanspp_initialize_centroids
    else:
        print 'No valid initialization function found. Exiting.'
        sys.exit(2)
    
    points = Point.load_points(points_filename)
    
    #points = points[:100]
    #points = random.sample(points, 3)
    
    run_kmeans(points, num_clusters, num_iterations, initialization_function)
    

if __name__ == '__main__':
    main(sys.argv)


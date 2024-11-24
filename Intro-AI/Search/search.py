# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util


class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print("Start:", problem.getStartState())
    print("Is the start a goal?", problem.isGoalState(problem.getStartState()))
    print("Start's successors:", problem.getSuccessors(problem.getStartState()))
    """
    
    # Marking visited nodes
    visited = set()
    # Keeping track of path as we expand
    parentHierarchy = {}
    # Keeping track of actions
    actions = {}

    # Set up problem with start state
    startState = problem.getStartState()
    stack = util.Stack()
    stack.push(startState)
    visited.add(startState)

    # Typical DFS algo
    while (not stack.isEmpty()):
        currNode = stack.pop()
        if (problem.isGoalState(currNode)):
            break
        neighbors = problem.getSuccessors(currNode)
        for neighbor in neighbors:
            if (not neighbor[0] in visited):
                parentHierarchy[neighbor[0]] = currNode
                stack.push(neighbor[0])
                actions[neighbor[0]] = neighbor[1]
        visited.add(currNode)


    # Retrace steps to build list of actions
    ret = []
    while (currNode != startState):
        ret.append(actions[currNode])
        currNode = parentHierarchy[currNode]
    ret.reverse()
    return ret


def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""

     # Marking visited nodes
    visited = []

    # Set up problem with start state
    startState = problem.getStartState()
    queue = util.Queue()
    check = []
    check.append((startState, None))
    queue.push(check)

    # Typical search algo
    while (not queue.isEmpty()):
        currPath = queue.pop()
        node = currPath[-1][0]
        if node in visited:  
            continue
        visited.append(node)

        if (problem.isGoalState(node)):
            break

        neighbors = problem.getSuccessors(node)
        for neighbor in neighbors:
            if (neighbor[0] not in visited):
                newPath = currPath[:]
                newPath.append((neighbor[0], neighbor[1]))

                queue.push(newPath)
        
    ret = []
    currPath = currPath[1:]
    for dir in currPath:
       ret.append(dir[1])
    return ret 
   

def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    
    # Marking visited nodes
    visited = set()
    # Keep track of cost
    costs = {}

    # Set up problem with start state
    startState = problem.getStartState()
    priorityQueue = util.PriorityQueue()
    check = []
    check.append((startState, None))
    priorityQueue.push(check, 0)
    costs[startState] = 0

    # Typical search algo
    while (not priorityQueue.isEmpty()):
        currPath = priorityQueue.pop()
        node = currPath[-1][0]
        if node in visited:  
            continue
        visited.add(node)

        if (problem.isGoalState(node)):
            break

        neighbors = problem.getSuccessors(node)
        for neighbor in neighbors:
            if (neighbor[0] not in visited):
                newPath = currPath[:]
                newPath.append((neighbor[0], neighbor[1]))
                currCost = neighbor[2] + costs[node]
                costs[neighbor[0]] = currCost
                priorityQueue.push(newPath, currCost)
        
    ret = []
    currPath = currPath[1:]
    for dir in currPath:
       ret.append(dir[1])
    return ret        


def nullHeuristic(state, problem=None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic=nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
     # Marking visited nodes
    visited = []
    # Keep track of cost

    # Set up problem with start state
    startState = problem.getStartState()
    priorityQueue = util.PriorityQueue()
    check = []
    check.append((startState, None, 0))
    priorityQueue.push(check, 0)

    # Typical search algo
    while (not priorityQueue.isEmpty()):
        currPath = priorityQueue.pop()
        node = currPath[-1][0]
        if node in visited:  
            continue
        visited.append(node)

        if (problem.isGoalState(node)):
            break

        neighbors = problem.getSuccessors(node)
        for neighbor in neighbors:
            if (neighbor[0] not in visited):
                currCost = neighbor[2] + currPath[-1][2]
                newPath = currPath[:]
                newPath.append((neighbor[0], neighbor[1], currCost))
                priorityQueue.push(newPath, currCost + heuristic(neighbor[0], problem))
        
    ret = []
    currPath = currPath[1:]
    for dir in currPath:
       ret.append(dir[1])
    return ret        
    


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch

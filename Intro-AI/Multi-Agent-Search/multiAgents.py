# multiAgents.py
# --------------
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


from util import manhattanDistance
from game import Directions
import random, util

from game import Agent

class ReflexAgent(Agent):
    """
    A reflex agent chooses an action at each choice point by examining
    its alternatives via a state evaluation function.

    The code below is provided as a guide.  You are welcome to change
    it in any way you see fit, so long as you don't touch our method
    headers.
    """


    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {NORTH, SOUTH, WEST, EAST, STOP}
        """
        # Collect legal moves and successor states
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]
    
    def evaluationFunction(self, currentGameState, action):
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()
        newScaredTimes = [ghostState.scaredTimer for ghostState in newGhostStates]

        ## Shortest distance to the nearest food.
        foodDistances = [manhattanDistance(newPos, food) for food in newFood.asList()]
        closestFoodDistance = min(foodDistances) if foodDistances else 1

        ## Do not get too close to ghosts
        scaredDistances = []
        activeDistances = []
        for ghost in newGhostStates:
            distance = manhattanDistance(newPos, ghost.getPosition())
            if ghost.scaredTimer > 0:
                scaredDistances.append(distance)
            else:
                activeDistances.append(distance)

        ## Do not get too close to ghosts
        if activeDistances:
            minActiveDistance = min(activeDistances)
            if minActiveDistance < 2:
                ghostPenalty = -200
            else:
                ghostPenalty = -1 / minActiveDistance
        else:
            ghostPenalty = 0

        ## Promote hunting of scared ghosts
        scaredBonus = 200 / min(scaredDistances) if scaredDistances else 0

        score = successorGameState.getScore()
        return score + 1 / closestFoodDistance + scaredBonus + ghostPenalty

def scoreEvaluationFunction(currentGameState):
    """
    This default evaluation function just returns the score of the state.
    The score is the same one displayed in the Pacman GUI.

    This evaluation function is meant for use with adversarial search agents
    (not reflex agents).
    """
    return currentGameState.getScore()


class MultiAgentSearchAgent(Agent):
    """
    This class provides some common elements to all of your
    multi-agent searchers.  Any methods defined here will be available
    to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

    You *do not* need to make any changes here, but you can if you want to
    add functionality to all your adversarial search agents.  Please do not
    remove anything, however.

    Note: this is an abstract class: one that should not be instantiated.  It's
    only partially specified, and designed to be extended.  Agent (game.py)
    is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
    Your minimax agent (question 2)
    """

    # def minimax(self, agent, state, depth):
    #         if (state.isLose() or state.isWin() or depth == self.depth):
    #             return self.evaluationFunction(state)
            
    #         ## Maximize pacman
    #         if agent == 0:
    #             pacmanVal = [self.minimax(1, state.generateSuccessor(0, action), depth) for action in state.getLegalActions(0)]
    #             return max(pacmanVal)
    #         else:
    #             nextAgent = agent + 1
    #             if nextAgent >= state.getNumAgents():
    #                 nextAgent = 0
    #                 depth += 1
    #             ghostVal = [self.minimax(nextAgent, state.generateSuccessor(agent, action), depth) for action in state.getLegalActions(agent)]
    #             return min(ghostVal)

    def minimax(self, state, depth, agent):
        if state.isWin() or state.isLose() or depth == self.depth:
            return self.evaluationFunction(state)
        
        maximizing = True if agent == 0 else False

        if maximizing:
            return self.maximizeValue(state, depth, agent)
        else:
            return self.minimizeValue(state, depth, agent)
        

    def maximizeValue(self, state, depth, agent):
        v = -float('inf')
        bestAction = Directions.STOP

        for action in state.getLegalActions(0):
            currState = state.generateSuccessor(agent, action)
            newVal = self.minimax(currState, depth, 1)
            if newVal > v:
                v = newVal
                bestAction = action
        
        if depth == 0:
            return bestAction
        return v

    def minimizeValue(self, state, depth, agent):
        v = float('inf')
        nextAgent = agent + 1
        if nextAgent >= state.getNumAgents():
            nextAgent = 0
            depth += 1
        
        for action in state.getLegalActions(agent):
            currState = state.generateSuccessor(agent, action)
            v = min(v, self.minimax(currState, depth, nextAgent))
        return v

    

    def getAction(self, gameState):
        """
        Returns the minimax action from the current gameState using self.depth
        and self.evaluationFunction.

        Here are some method calls that might be useful when implementing minimax.

        gameState.getLegalActions(agentIndex):
        Returns a list of legal actions for an agent
        agentIndex=0 means Pacman, ghosts are >= 1

        gameState.generateSuccessor(agentIndex, action):
        Returns the successor game state after an agent takes an action

        gameState.getNumAgents():
        Returns the total number of agents in the game

        gameState.isWin():
        Returns whether or not the game state is a winning state

        gameState.isLose():
        Returns whether or not the game state is a losing state

        """

        return self.minimax(gameState, 0, 0)
        
                
                
class AlphaBetaAgent(MultiAgentSearchAgent):
    """
    Your minimax agent with alpha-beta pruning (question 3)
    """
            

    def minimaxPruning(self, agentIndex, gameState, depth, alpha, beta):
        # Check for terminal states: win, lose, or maximum depth reached
        if gameState.isWin() or gameState.isLose() or depth == self.depth:
            return self.evaluationFunction(gameState)
        
        isMaximizingAgent = (agentIndex == 0) 

        if isMaximizingAgent:
            return self.maxValue(gameState, agentIndex, depth, alpha, beta)
        else:
            return self.minValue(gameState, agentIndex, depth, alpha, beta)

    def maxValue(self, gameState, agentIndex, depth, alpha, beta):
        v = -float('inf')
        for action in gameState.getLegalActions(agentIndex):
            successorState = gameState.generateSuccessor(agentIndex, action)
            newVal =  self.minimaxPruning(1, successorState, depth, alpha, beta)
            if newVal > v:
                v = newVal
                bestAction = action
            ## v = max(v, self.minimaxPruning(1, successorState, depth, alpha, beta))
            # if v >= beta:
            #     return v
            alpha = max(alpha, v)
            #print((successorState.state, alpha, beta))
            if beta < alpha:
                break
        if depth == 0:
            return bestAction
        return v

    def minValue(self, gameState, agentIndex, depth, alpha, beta):
        v = float('inf')
        nextAgent = agentIndex + 1
        if nextAgent >=  gameState.getNumAgents():
            nextAgent = 0
            depth += 1
        for action in gameState.getLegalActions(agentIndex):
            successorState = gameState.generateSuccessor(agentIndex, action)
            v = min(v, self.minimaxPruning(nextAgent, successorState, depth, alpha, beta))
            # if v <= alpha:
            #     return v
            beta = min(beta, v)
           # print((successorState.state, alpha, beta))
            if beta < alpha:
                break
        return v



    def getAction(self, gameState):
        """
        Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"


        value = self.minimaxPruning(0, gameState, 0, -float('inf'), float('inf'))
        return value
        

class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """

    def expectimax(self, agentIndex, gameState, depth):
        # Check for terminal states: win, lose, or maximum depth reached
        if gameState.isWin() or gameState.isLose() or depth == self.depth:
            return self.evaluationFunction(gameState)
        
        isMaximizingAgent = (agentIndex == 0) 

        if isMaximizingAgent:
            return self.maxValue(gameState, agentIndex, depth)
        else:
            return self.expecValue(gameState, agentIndex, depth)

    def maxValue(self, gameState, agentIndex, depth):
        v = -float('inf')
        for action in gameState.getLegalActions(agentIndex):
            successorState = gameState.generateSuccessor(agentIndex, action)
            newVal =  self.expectimax(1, successorState, depth)
            if newVal > v:
                v = newVal
                bestAction = action
        if depth == 0:
            return bestAction
        return v

    def expecValue(self, gameState, agentIndex, depth):
        v = 0.0
        nextAgent = agentIndex + 1
        if nextAgent >=  gameState.getNumAgents():
            nextAgent = 0
            depth += 1
        for action in gameState.getLegalActions(agentIndex):
            successorState = gameState.generateSuccessor(agentIndex, action)
            #v += min(v, self.expectimax(nextAgent, successorState, depth))
            v += float(self.expectimax(nextAgent, successorState, depth))
        return v / len(gameState.getLegalActions(agentIndex))

    def getAction(self, gameState):
        """
        Returns the expectimax action using self.depth and self.evaluationFunction

        All ghosts should be modeled as choosing uniformly at random from their
        legal moves.
        """

        value = self.expectimax(0, gameState, 0)
        return value
        

def betterEvaluationFunction(currentGameState):
    """
    Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
    evaluation function (question 5).

    See comments below in code for explanations
    """

    newPos = currentGameState.getPacmanPosition()
    newFood = currentGameState.getFood()
    newGhostStates = currentGameState.getGhostStates()

    
    ## Shortest distance to the nearest food.
    foodDistances = [manhattanDistance(newPos, food) for food in newFood.asList()]
    closestFoodDistance = min(foodDistances) if foodDistances else 1

    ## Do not get too close to ghosts
    scaredDistances = []
    activeDistances = []
    for ghost in newGhostStates:
        distance = manhattanDistance(newPos, ghost.getPosition())
        if ghost.scaredTimer > 0:
            scaredDistances.append(distance)
        else:
            activeDistances.append(distance)

    ## Encouraging hunting pellets -- multiply by negative #
    powerPelletsLeft = len(currentGameState.getCapsules())


    ## Do not get too close to ghosts
    if activeDistances:
        minActiveDistance = min(activeDistances)
        if minActiveDistance < 2:
            ghostPenalty = -200
        else:
            ghostPenalty = -1 / minActiveDistance
    else:
        ghostPenalty = 0

    ## Promote hunting of scared ghosts
    scaredBonus = 200 / min(scaredDistances) if scaredDistances else 0

    score = currentGameState.getScore()
    return score + 1 / closestFoodDistance + scaredBonus + ghostPenalty + (-1 * powerPelletsLeft)


better = betterEvaluationFunction

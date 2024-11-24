import nn

class PerceptronModel(object):
    def __init__(self, dimensions):
        """
        Initialize a new Perceptron instance.

        A perceptron classifies data points as either belonging to a particular
        class (+1) or not (-1). dimensions is the dimensionality of the data.
        For example, dimensions=2 would mean that the perceptron must classify
        2D points.
        """
        self.w = nn.Parameter(1, dimensions)

    def get_weights(self):
        """
        Return a Parameter instance with the current weights of the perceptron.
        """
        return self.w

    def run(self, x):
        """
        Calculates the score assigned by the perceptron to a data point x.

        Inputs:
            x: a node with shape (1 x dimensions)
        Returns: a node containing a single number (the score)
        """

        score = nn.DotProduct(x, self.w)
        return score

    def get_prediction(self, x):
        """
        Calculates the predicted class for a single data point x.

        Returns: 1 or -1
        """
        score = nn.as_scalar(self.run(x))
        if score < 0: 
            return -1
        else: 
            return 1

    def train(self, dataset):
        """
        Train the perceptron until convergence.
        """

        batch_size = 1
        flag = True
        while(flag):
            flag = False
            for x, y in dataset.iterate_once(batch_size):
                prediction = self.get_prediction(x)
                if (prediction != nn.as_scalar(y)):
                    flag = True
                    self.w.update(x, nn.as_scalar(y))

class RegressionModel(object):
    def __init__(self):
        self.learning_rate = 0.1  
        self.batch_size = 50
        self.w1 = nn.Parameter(1, 100)
        self.b1 = nn.Parameter(1, 100)
        self.w2 = nn.Parameter(100, 50)
        self.b2 = nn.Parameter(1, 50)
        
        self.w3 = nn.Parameter(50, 1)

    def run(self, x):
        x1 = nn.ReLU(nn.AddBias(nn.Linear(x, self.w1), self.b1))
        x2 = nn.ReLU(nn.AddBias(nn.Linear(x1, self.w2), self.b2))
        predicted_y = nn.Linear(x2, self.w3)
        return predicted_y

    def get_loss(self, x, y):
        predicted_y = self.run(x)
        return nn.SquareLoss(predicted_y, y)

    def train(self, dataset):
        while True:
            total_loss = 0
            examples_processed = 0  
            for x, y in dataset.iterate_once(self.batch_size):
                loss = self.get_loss(x, y)
                gradients = nn.gradients(loss, [self.w1, self.b1, self.w2, self.b2, self.w3])

                self.w1.update(gradients[0], -self.learning_rate)
                self.b1.update(gradients[1], -self.learning_rate)
                self.w2.update(gradients[2], -self.learning_rate)
                self.b2.update(gradients[3], -self.learning_rate)
                self.w3.update(gradients[4], -self.learning_rate)
                
                total_loss += nn.as_scalar(loss) * self.batch_size  
                examples_processed += self.batch_size  

            average_loss = total_loss / examples_processed
            # print("Average loss:", average_loss)
            if average_loss < 0.02:
                break


class DigitClassificationModel(object):
    def __init__(self):
        self.learning_rate = 0.3  
        self.batch_size = 100  
        self.w1 = nn.Parameter(784, 256)
        self.b1 = nn.Parameter(1, 256)
        self.w2 = nn.Parameter(256, 128)
        self.b2 = nn.Parameter(1, 128)
        self.w3 = nn.Parameter(128, 64)
        self.b3 = nn.Parameter(1, 64)
        self.w4 = nn.Parameter(64, 10)  


    def run(self, x):
 
        x1 = nn.ReLU(nn.AddBias(nn.Linear(x, self.w1), self.b1))
        x2 = nn.ReLU(nn.AddBias(nn.Linear(x1, self.w2), self.b2))
        x3 = nn.ReLU(nn.AddBias(nn.Linear(x2, self.w3), self.b3))
        logits = nn.Linear(x3, self.w4)  
        return logits

    def get_loss(self, x, y):
        logits = self.run(x)
        return nn.SoftmaxLoss(logits, y)

    def train(self, dataset):
        while True:
            for x, y in dataset.iterate_once(self.batch_size):
                loss = self.get_loss(x, y)
                gradients = nn.gradients(loss, [self.w1, self.b1, self.w2, self.b2, self.w3, self.b3, self.w4])

                self.w1.update(gradients[0], -self.learning_rate)
                self.b1.update(gradients[1], -self.learning_rate)
                self.w2.update(gradients[2], -self.learning_rate)
                self.b2.update(gradients[3], -self.learning_rate)
                self.w3.update(gradients[4], -self.learning_rate)
                self.b3.update(gradients[5], -self.learning_rate)
                self.w4.update(gradients[6], -self.learning_rate)
            
            validation_accuracy = dataset.get_validation_accuracy()
            print("Validation accuracy:", validation_accuracy)
            if validation_accuracy > 0.975:  # Target threshold
                break


class LanguageIDModel(object):
    """
    A model for language identification at a single-word granularity.

    (See RegressionModel for more information about the APIs of different
    methods here. We recommend that you implement the RegressionModel before
    working on this part of the project.)
    """
    def __init__(self):
        # Our dataset contains words from five different languages, and the
        # combined alphabets of the five languages contain a total of 47 unique
        # characters.
        # You can refer to self.num_chars or len(self.languages) in your code
        self.num_chars = 47
        self.batch_size = 200
        self.languages = ["English", "Spanish", "Finnish", "Dutch", "Polish"]


        "*** YOUR CODE HERE ***"
        self.num_chars = 47  # Total unique characters
        self.languages = ["English", "Spanish", "Finnish", "Dutch", "Polish"]
        self.hidden_size = 128  

        self.W_initial = nn.Parameter(self.num_chars, self.hidden_size)
        self.b_initial = nn.Parameter(1, self.hidden_size)

        self.W = nn.Parameter(self.num_chars, self.hidden_size)
        self.W_hidden = nn.Parameter(self.hidden_size, self.hidden_size)
        self.b = nn.Parameter(1, self.hidden_size)
        self.W_output = nn.Parameter(self.hidden_size, len(self.languages))
        self.b_output = nn.Parameter(1, len(self.languages))

    def run(self, xs):
        """
        Runs the model for a batch of examples.

        Although words have different lengths, our data processing guarantees
        that within a single batch, all words will be of the same length (L).

        Here `xs` will be a list of length L. Each element of `xs` will be a
        node with shape (batch_size x self.num_chars), where every row in the
        array is a one-hot vector encoding of a character. For example, if we
        have a batch of 8 three-letter words where the last word is "cat", then
        xs[1] will be a node that contains a 1 at position (7, 0). Here the
        index 7 reflects the fact that "cat" is the last word in the batch, and
        the index 0 reflects the fact that the letter "a" is the inital (0th)
        letter of our combined alphabet for this task.

        Your model should use a Recurrent Neural Network to summarize the list
        `xs` into a single node of shape (batch_size x hidden_size), for your
        choice of hidden_size. It should then calculate a node of shape
        (batch_size x 5) containing scores, where higher scores correspond to
        greater probability of the word originating from a particular language.

        Inputs:
            xs: a list with L elements (one per character), where each element
                is a node with shape (batch_size x self.num_chars)
        Returns:
            A node with shape (batch_size x 5) containing predicted scores
                (also called logits)
        """
        "*** YOUR CODE HERE ***"
        h = nn.ReLU(nn.AddBias(nn.Linear(xs[0], self.W_initial), self.b_initial))
        for x in xs[1:]:
            z = nn.Add(nn.Linear(x, self.W), nn.Linear(h, self.W_hidden))
            h = nn.ReLU(nn.AddBias(z, self.b))
        logits = nn.AddBias(nn.Linear(h, self.W_output), self.b_output)
        return logits

    def get_loss(self, xs, y):
        """
        Computes the loss for a batch of examples.

        The correct labels `y` are represented as a node with shape
        (batch_size x 5). Each row is a one-hot vector encoding the correct
        language.

        Inputs:
            xs: a list with L elements (one per character), where each element
                is a node with shape (batch_size x self.num_chars)
            y: a node with shape (batch_size x 5)
        Returns: a loss node
        """
        "*** YOUR CODE HERE ***"
        logits = self.run(xs)
        return nn.SoftmaxLoss(logits, y)


    def train(self, dataset):
        """
        Trains the model.
        """
        "*** YOUR CODE HERE ***"
        learning_rate = 0.3
        parameters = [self.W_initial, self.b_initial, self.W, self.W_hidden, self.b, self.W_output, self.b_output]  # Parameters list
        for epoch in range(20): 
            total_loss = 0
            for xs, y in dataset.iterate_once(self.batch_size):
                loss = self.get_loss(xs, y)
                gradients = nn.gradients(loss, parameters)
                for param, grad in zip(parameters, gradients):
                    param.update(grad, -learning_rate)
                total_loss += nn.as_scalar(loss)
            print('Epoch', epoch, 'with total loss', total_loss)

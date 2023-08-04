# NeuronalNetwork
My try on neuronal networks using sample data

Datahandler creates a semi random dataset. 

The Matrix class can save two dimensional matrixes and has some functions for them:

-fillMatrix(float)              fills every field of the matrix with the same number

-fillDiagonal(float)            fills only the diagonal with a number

-printMatrix()                  prints Matrix onto the console.

-fillMatrix()                   fills Matrix with all 0

-fillMatrixRandom(float,float)  filld every field of the matrix with a random value between 2 values

-getColumn(int)                 returns a whole column through all rows

-getRow(int)                    ""

-addValueField(int,int,float,float,float)  adds a value to one field inside the matrix inside a boundary

-transponierenMatrix()          switches rows and columns

-mul(float)                     multiplies every field with the same parameter

-mulRandom(float,float)         multiplies a paramater with some random fields

-addPara(float)                 addValueField without the border

-addParaRandom(float)           addValueField but with random values

-addParaRandomSome(....)        same as before, but with random chance to fill too.

-mirrorVer()                    mirrors vertically

-mirrorHor()                    "" horizontally

-switchRows(int,int)            switches 2 rows

-switchColumns(int,int)         "" columns

-fillMatrixArray(float[])       fills Matrix with a given array

-clone()                        makes a clone(copy) from itself and returns it

-scaleMul(matrix,matrix)        scalarMultiplicates 2 matrixes

-addMat                         adds 2 matrixes

-subMat                         ""

-changeRows                     adds or deletes number of rows

-changeColumns                  ""


-changeRowColumn                ""

printAllMatrix(matrix[])        prints multiple matrixes in array

----------------------------------------------------------------------------------------------------------------------------------------------

aiHandler
handles all ai relevant stuff. 
Costs are calculated here, as well as killing old brains and making new brain babies.


testAI()                        tests all brains with all data and calculates the smallest cost in this generation

runAI()                         thats what is called in the draw function. everything is called here

resetBrains()                   kills Brains, clones best brains and changes weights per random

testVsBest()                    tests the alltimebest VS the best in this run. 

updateBest(brain,brain)         if a new best is found, then we take the difference in the weights and bias' and try to see if the brain can still be a bit enhanced.

drawDecisionBorder()            draws rects on the screen to see what the AI thinks about different combinations

testData(int,int)               calculates cost for a brain of the rooster with a given data from the dataset

findCost(int, brain)            costfunction




----------------------------------------------------------------------------------------------------------------------------------------------
Brain class the good stuff
each Brain has multiple matrixes.
Hiddenlayers and the size of the hidden layers are given to the create the brain
It creates weight matrixes and bias matrixes as well as input and output matrixes.


fillBias(float)                fills all Bias matrixes with -value to +value

fillWeights(float,float)       fills random values for all weights

fillWeights()                  fills all weights with 0

calcOutput()                   calculates output Matrix

updateWeightsRandom(float,float)  updates weigths per random inside a given range

mulWeightsAll(float)           multiplies all weights by a given value

mulBiasAll(float)              multiplies all Bias by a given value

updateBiasRandom(float,float)  updates all bias per random with a given value inside given bounds

updateMatrixRandom(matrix,f,f,f,f)  updates only a given matrix with a random value and a given chance to update

mulMatrixRandom(m,f)           ""

applyActivationFunction(m,f)  after bias is added to weights * inputs, the value is given to an activation function

activationFunction            multiple activation functions are available, just change the variable in the class to switch. I run good with sigmoid and tanh

printBrain()                  prints weights and bias values in the console

clone()                       clones the complete brain

writeBrain()                  writes weights and bias to a txt file

combineBrains(b,b,f)          combines two brains with given chances which values to take

drawKI                        draws brain as dots and lines

resizeBrainSize(i,i,i,i)      can expand the size of the brain (inputs, outputs, hidden layers, size) might be a bit buggy.

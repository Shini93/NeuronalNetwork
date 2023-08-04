/*********************************************
 *contains one Matrix with floats
 'Can calculate some basic atrix transformations
 ***********************************************/
class Matrix implements Cloneable {
  int row;
  int column;
  float[][] matrix;

  Matrix(int r, int c) {
    row = r;
    column = c;
    matrix = new float[r][c];
    fillMatrix();
  }

  Matrix(int r, int c, float fill) {
    row = r;
    column = c;
    matrix = new float[r][c];
    fillMatrix(fill);
  }

  //------------------------------------------------------------------------------------------------------------
  //fills every part of Matrix with the same value
  void fillMatrix(float fillMatrix) {
    for (int r = 0; r< row; r++)
      for ( int c = 0; c < column; c++)
        matrix[r][c] = fillMatrix;
  }

  //------------------------------------------------------------------------------------------------------------
  //fills diagnoal with same value only
  void fillDiagonal(float fill) {
    for ( int d = 0; d < min(row, column); d++)
      matrix[d][d] = fill;
  }

  //------------------------------------------------------------------------------------------------------------
  //prints matrix in console
  void printMatrix() {
    for ( int r = 0; r < row; r++) {
      for ( int c = 0; c < column; c ++) {
        print(matrix[r][c] + "  ");
      }
      print("\n");
    }
    println("");
  }

  //------------------------------------------------------------------------------------------------------------
  //fills matrix with 0
  void fillMatrix() {
    fillMatrix(0);
  }

  //------------------------------------------------------------------------------------------------------------
  //fills matrix with random values between 2 numbers
  void fillMatrixRandom(float ran0, float ran1) {
    for (int r = 0; r< row; r++) {
      for ( int c = 0; c < column; c++) {
        float fillMatrix = random(ran0, ran1);
        matrix[r][c] = fillMatrix;
      }
    }
  }

  //------------------------------------------------------------------------------------------------------------
  //returns given column as array
  float[] getColumn(int c) {
    float[] chosenColumn = new float[row];
    for ( int i = 0; i < row; i++)
      chosenColumn[i] = matrix[i][c];
    return chosenColumn;
  }

  //------------------------------------------------------------------------------------------------------------
  //returns given row as array
  float[] getRow(int r) {
    float[] chosenRow = new float[column];
    for ( int i = 0; i < column; i++)
      chosenRow[i] = matrix[r][i];
    return chosenRow;
  }

  void addValueField(int r, int c, float val, float min, float max){
    float v = matrix[r][c];
    matrix[r][c] = min(max(v + val , min) , max);
  }

  //------------------------------------------------------------------------------------------------------------
  //transpunates itself ( needed to reverse this, if it is only needed for one calculation
  void transponierenMatrix() {
    float[][] dummyMatrix = new float[column][row];
    for (int i = 0; i < column; i++) {
      dummyMatrix[i] = getColumn(i);
    }
    int dummy = column;
    column = row;
    row = dummy;
    matrix = dummyMatrix;
  }


  //------------------------------------------------------------------------------------------------------------
  //multiplies every cell with same parameter
  void mul(float parameter) {
    for ( int r = 0; r < row; r++)
      for (int c = 0; c < column; c++)
        matrix[r][c] *= parameter;
  }

  //------------------------------------------------------------------------------------------------------------
  //multiplies every cell with same parameter
  void mulRandom(float parameter, float ran) {
    for ( int r = 0; r < row; r++)
      for (int c = 0; c < column; c++)
        if(random(1) < ran)
          matrix[r][c] *= parameter;
  }

  //------------------------------------------------------------------------------------------------------------
  //Adds every cell with same parameter
  void addPara(float parameter) {
    for ( int r = 0; r < row; r++)
      for (int c = 0; c < column; c++)
        matrix[r][c] += parameter;
  }

  //------------------------------------------------------------------------------------------------------------
  //multiplies every cell with same parameter
  void addParaRandom(float lower, float upper, float min, float max) {
    for ( int r = 0; r < row; r++)
      for (int c = 0; c < column; c++) {
        matrix[r][c] += random(lower, upper);
        if (matrix[r][c] > max)
          matrix[r][c] = max;
        else if ( matrix[r][c] < min)
          matrix[r][c] = min;
      }
  }

  //------------------------------------------------------------------------------------------------------------
  //multiplies every cell with same parameter
  void addParaRandomSome(float chance, float lower, float upper, float min, float max) {
    for ( int r = 0; r < row; r++)
      for (int c = 0; c < column; c++) {
        if(random(1) > chance)
          continue;
        matrix[r][c] += random(lower, upper);
        if (matrix[r][c] > max)
          matrix[r][c] = max;
        else if ( matrix[r][c] < min)
          matrix[r][c] = min;
      }
  }

  //------------------------------------------------------------------------------------------------------------
  //mirrors matrix vertically
  void mirrorVer() {
    Matrix dummy = new Matrix(row, column);
    for ( int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        dummy.matrix[r][c] = matrix[r][column - c- 1];
      }
    }
    matrix = dummy.matrix;
  }

  //------------------------------------------------------------------------------------------------------------
  //mirrors matrix horizontally
  void mirrorHor() {
    Matrix dummy = new Matrix(row, column);
    for ( int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        dummy.matrix[r][c] = matrix[row-r-1][c];
      }
    }
    matrix = dummy.matrix;
  }

  //------------------------------------------------------------------------------------------------------------
  //swaps 2 given rows.
  void switchRows(int r1, int r2) {
    for ( int c = 0; c < column; c++) {
      float dummy = matrix[r1][c];
      matrix[r1][c] = matrix[r2][c];
      matrix[r2][c] = dummy;
    }
  }

  //------------------------------------------------------------------------------------------------------------
  //swaps 2 given columns
  void switchCols(int c1, int c2) {
    for ( int r = 0; r < row; r++) {
      float dummy = matrix[r][c1];
      matrix[r][c1] = matrix[r][c2];
      matrix[r][c2] = dummy;
    }
  }

  //------------------------------------------------------------------------------------------------------------
  //fillsMatrix for the arary given
  void fillMatrixArray(float[] fill) {
    for ( int r = 0; r < row; r++) {
      for (int c = 0; c < column; c++) {
        if (r*column+c > fill.length )
          return;
        matrix[r][c] = fill[r*column+c];
      }
    }
  }

  Matrix clone() {
    Matrix m2 = new Matrix(row, column);
    for (int r = 0; r < row; r++) {
      for ( int c = 0; c < column; c ++) {
        m2.matrix[r][c] = matrix[r][c];
      }
    }
    return m2;
  }
}


//------------------------------------------------------------------------------------------------------------
//multiplies 2 matrixs together and returns new matrix as solution
Matrix scalaMul(Matrix m1, Matrix m2) {
  if (m1.column < m2.column && m2.row > m1.column) {
    Matrix dummy = m1;
    m1 = m2;
    m2 = dummy;
  }
  Matrix m3 = new Matrix(m1.row, m2.column);

  for ( int r = 0; r < m1.row; r++) {
    for ( int c = 0; c < m2.column; c++) {
      float save = 0;
      for ( int z = 0; z < m2.row; z++) {
        save+= m1.matrix[r][z]*
          m2.matrix[z][c];
      }
      m3.matrix[r][c] = save;
    }
  }
  return m3;
}

//------------------------------------------------------------------------------------------------------------
//Adds 2 Matrixs together and returns new matrix as solution
Matrix addMat(Matrix m1, Matrix m2) {
  Matrix m3 = new Matrix(m1.row, m1.column);
  if (m1.row != m2.row || m1.column != m2.column) {
    println("Error, matrix missmatch for adding Matrixes");
    return m3;
  }
  for ( int r = 0; r < m1.row; r++) {
    for ( int c = 0; c < m1.column; c++) {
      m3.matrix[r][c] = m1.matrix[r][c] + m2.matrix[r][c];
    }
  }
  return m3;
}

//------------------------------------------------------------------------------------------------------------
//Subtracts 2 matrixs
Matrix subMat(Matrix m1, Matrix m2) {
  m2.mul(-1);
  Matrix m3 = addMat(m1, m2);
  return m3;
}

//------------------------------------------------------------------------------------------------------------
//changes rows of a given Matrix
Matrix changeRows(Matrix m1, int rows) {
  Matrix m3 = new Matrix(rows, m1.column);
  for ( int r = 0; r < rows; r++) {
    for ( int c = 0; c < m1.column; c++) {
      if (r < m1.row)
        m3.matrix[r][c] = m1.matrix[r][c];
      else
        m3.matrix[r][c] = 0;
    }
  }
  return m3;
}

//------------------------------------------------------------------------------------------------------------
//changes columns of a given Matrix
Matrix changeColumns(Matrix m1, int columns) {
  Matrix m3 = new Matrix(m1.row, columns);
  for ( int r = 0; r < m1.row; r++) {
    for ( int c = 0; c < columns; c++) {
      if (c < m1.column)
        m3.matrix[r][c] = m1.matrix[r][c];
      else
        m3.matrix[r][c] = 0;
    }
  }
  return m3;
}

//------------------------------------------------------------------------------------------------------------
//changes rows or  columns of a given Matrix
Matrix changeRowColumn(Matrix m1, int rows, int columns) {
  Matrix m3 = changeRows(m1, rows);
  Matrix m4 = changeColumns(m3, columns);
  return m4;
}

void printAllMatrix(Matrix[] matrix) {
  for (Matrix m : matrix) {
    m.printMatrix();
    println("-----------------------");
  }
}

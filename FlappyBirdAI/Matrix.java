
import java.util.Arrays;

public class Matrix {
    int rows, cols;
    float[][] data;
    int[] shape = new int[2];

    Matrix(int rows, int cols){
        this.rows = rows;
        this.cols = cols;
        data = new float[this.rows][this.cols];
        shape[0] = rows;
        shape[1] = cols;
    }

    Matrix(int[] shape){
        this.rows = shape[0];
        this.cols = shape[1];
        data = new float[this.rows][this.cols];
        this.shape[0] = rows;
        this.shape[1] = cols;
    }

    Matrix(float[][] data){
        rows = data.length;
        cols = data[0].length;
        this.data = new float[rows][cols];
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                 this.data[i][j] = data[i][j];
            }
        }
        shape[0] = rows;
        shape[1] = cols;
    }

    Matrix(Matrix other){
        rows = other.rows;
        cols = other.cols;
        shape[0] = rows;
        shape[1] = cols;
        data = new float[rows][cols];
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                data[i][j] = other.data[i][j];
            }
        }
    }

    Matrix copy(){
        return new Matrix(this);
    }

    static Matrix copy(Matrix matrix){
        return new Matrix(matrix);
    }

    void print(){
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                System.out.print(data[i][j] + " ");
            }
            System.out.println(' ');
        }
    }

    int[] invShape(){
        return new int[]{cols, rows};
    }

    int[] shape(){
        return new int[]{rows, cols};
    }

    void add(Matrix other){
        if(Arrays.equals(this.shape, other.shape)){
            for (int i = 0; i < rows; i++){
                for (int j = 0; j < cols; j++){
                    this.data[i][j] += other.data[i][j];
                }
            }
        } else {
            System.out.println("could not add incorrect matrix addition");
        }
    }

    static Matrix add(Matrix a, Matrix b){
        if(Arrays.equals(a.shape, b.shape)){
            Matrix c = new Matrix(a.shape);
            for(int i = 0; i < c.rows; i++){
                for(int j = 0; j < c.cols; j++){
                    c.data[i][j] = a.data[i][j] + b.data[i][j];
                }
            }
            return c;
        } else {
            System.out.println("could not add incorrect matrix addition");
            return  null;
        }
    }

    static Matrix radd(Matrix a, Matrix b){
        if(a.rows == b.rows){
            Matrix c = new Matrix(a.shape);
            for(int i = 0; i < c.rows; i++){
                for(int j = 0; j < c.cols; j++){
                    c.data[i][j] = a.data[i][j] + b.data[i][0];
                }
            }
            return c;
        } else {
            System.out.println("could not add incorrect matrix addition");
            return  null;
        }
    }

    void sub(Matrix other){
        if(Arrays.equals(this.shape, other.shape)){
            for (int i = 0; i < rows; i++){
                for (int j = 0; j < cols; j++){
                    this.data[i][j] -= other.data[i][j];
                }
            }
        } else {
            System.out.println("could not subtract incorrect matrix subtraction");
        }
    }

    static Matrix sub(Matrix a, Matrix b){
        if(Arrays.equals(a.shape, b.shape)){
            Matrix c = new Matrix(a.shape);
            for(int i = 0; i < c.rows; i++){
                for(int j = 0; j < c.cols; j++){
                    c.data[i][j] = a.data[i][j] - b.data[i][j];
                }
            }
            return c;
        } else {
            System.out.println("could not subtract incorrect matrix subtraction");
            return  null;
        }
    }

    void mul(Matrix other){
        if(Arrays.equals(this.shape, other.shape)){
            for (int i = 0; i < rows; i++){
                for (int j = 0; j < cols; j++){
                    this.data[i][j] *= other.data[i][j];
                }
            }
        } else {
            System.out.println("could not multiply incorrect matrix Hadamard product");
        }
    }

    void mul(float value){
        for (int i = 0; i < rows; i++){
            for (int j = 0; j < cols; j++){
                this.data[i][j] *= value;
            }
        }
    }

    static Matrix mul(Matrix a, Matrix b){
        if(Arrays.equals(a.shape, b.shape)){
            Matrix c = new Matrix(a.shape);
            for(int i = 0; i < c.rows; i++){
                for(int j = 0; j < c.cols; j++){
                    c.data[i][j] = a.data[i][j] * b.data[i][j];
                }
            }
            return c;
        } else {
            System.out.println("could not multiply incorrect matrix Hadamard product");
            return  null;
        }
    }

    static Matrix mul(Matrix matrix, float value){
        Matrix c = new Matrix(matrix.shape);
        for(int i = 0; i < c.rows; i++){
            for(int j = 0; j < c.cols; j++){
                c.data[i][j] = matrix.data[i][j] * value;
            }
        }
        return c;
    }

    void transpose(){
        float[][] temp = new float[cols][rows];
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                temp[j][i] = data[i][j];
            }
        }
        data = temp;
        int t = rows;
        rows = cols;
        cols = t;
        shape[0] = rows;
        shape[1] = cols;
    }

    static Matrix transpose(Matrix matrix){
        Matrix temp = new Matrix(matrix.invShape());
        for(int i = 0; i < matrix.rows; i++){
            for(int j = 0; j < matrix.cols; j++){
                temp.data[j][i] = matrix.data[i][j];
            }
        }
        return temp;
    }

    void Sigmoid(){
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                float x = this.data[i][j];
                this.data[i][j] = 1/(1+(float)Math.exp(-x));
            }
        }
    }

    void dSigmoid(){
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                float y = this.data[i][j];
                this.data[i][j] = y*(1-y);
            }
        }
    }

    static Matrix Sigmoid(Matrix matrix){
        Matrix temp = new Matrix(matrix.shape);
        for (int i = 0; i < matrix.rows; i++) {
            for (int j = 0; j < matrix.cols; j++) {
                float x = matrix.data[i][j];
                temp.data[i][j] = 1/(1+(float)Math.exp(-x));
            }
        }
        return temp;
    }

    static Matrix dSigmoid(Matrix matrix){
        Matrix temp = new Matrix(matrix.shape);
        for (int i = 0; i < matrix.rows; i++) {
            for (int j = 0; j < matrix.cols; j++) {
                float y = matrix.data[i][j];
                temp.data[i][j] = y*(1-y);
            }
        }
        return temp;
    }

    static Matrix toMatrix(float[] data){
        Matrix temp = new Matrix(data.length, 1);
        for(int i = 0; i < data.length; i++){
            temp.data[i][0] = data[i];
        }
        return temp;
    }

    static Matrix toMatrix(float[] data, int[] shape){
        Matrix temp = new Matrix(shape);
        for(int i = 0; i < shape[0]; i++){
            for(int j = 0; j < shape[1]; j++) {
                temp.data[i][j] = data[i + j*shape[0]];
            }
        }
        return temp;
    }

    float[] toArray(){
        float[] temp = new float[rows * cols];
        int index = 0;
        for(int j = 0; j < cols; j++){
            for(int i = 0; i < rows; i++){
                temp[index] = data[i][j];
                index++;
            }
        }
        return temp;
    }

    static float[] toArray(Matrix matrix){
        float[] temp = new float[matrix.rows * matrix.cols];
        int index = 0;
        for(int j = 0; j < matrix.cols; j++){
            for(int i = 0; i < matrix.rows; i++){
                temp[index] = matrix.data[i][j];
                index++;
            }
        }
        return temp;
    }

    void dot(Matrix other){
        System.out.println(this.cols + ", " + other.rows);
        if(this.cols == other.rows){
            float[][] data = new float[this.rows][other.cols];
            for (int i = 0; i < this.rows; i++){
                for(int j = 0; j < other.cols; j++){
                    for(int k = 0; k < this.cols; k++){
                        data[i][j] += this.data[i][k] * other.data[k][j];
                    }
                }
            }
            this.data = data;
            this.cols = other.cols;
            shape[1] = this.cols;
        } else {
            System.out.println("could not multiply incorrect matrix multiplication");
        }
    }

    static Matrix dot(Matrix a, Matrix b){
        if(a.cols == b.rows){
            Matrix temp = new Matrix(a.rows, b.cols);
            for (int i = 0; i < a.rows; i++){
                for(int j = 0; j < b.cols; j++){
                    for(int k = 0; k < a.cols; k++){
                        temp.data[i][j] += a.data[i][k] * b.data[k][j];
                    }
                }
            }
            return temp;
        } else {
            System.out.println("could not multiply incorrect matrix multiplication");
            return null;
        }
    }

    void random(){
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                this.data[i][j] = (float)(Math.random()*2 - 1);
            }
        }
    }

    void random(float min, float max){
        for(int i = 0; i < rows; i++){
            for(int j = 0; j < cols; j++){
                this.data[i][j] = (float)(Math.random()*(max - min) + min);
            }
        }
    }
}

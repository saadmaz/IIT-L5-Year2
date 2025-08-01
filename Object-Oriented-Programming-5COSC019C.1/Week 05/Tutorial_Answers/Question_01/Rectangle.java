package Tutorial_Answers.Question_01;

public class Rectangle extends GeometricObject {
    protected double length, width;

    public Rectangle() { this(1.0, 1.0, "white", false); }
    public Rectangle(double length, double width) { this(length, width, "white", false); }
    public Rectangle(double length, double width, String colour, boolean filled) {
        super(colour, filled);
        this.length = length;
        this.width = width;
    }
    public void setLength(double length) { this.length = length; }
    public void setWidth(double width) { this.width = width; }
    public double getLength() { return length; }
    public double getWidth() { return width; }
    @Override
    public double getArea() { return length * width; }
    @Override
    public double getPerimeter() { return 2 * (length + width); }
    @Override
    public String getShape() { return "Rectangle"; }
}
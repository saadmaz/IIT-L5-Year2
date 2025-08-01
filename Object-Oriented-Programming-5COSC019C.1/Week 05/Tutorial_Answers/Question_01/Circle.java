package Tutorial_Answers.Question_01;

public class Circle extends GeometricObject {
    protected double radius;

    public Circle() { this(1.0, "white", false); }
    public Circle(double radius) { this(radius, "white", false); }
    public Circle(double radius, String colour, boolean filled) {
        super(colour, filled);
        this.radius = radius;
    }
    public void setRadius(double radius) { this.radius = radius; }
    public double getRadius() { return radius; }
    @Override
    public double getArea() { return Math.PI * radius * radius; }
    @Override
    public double getPerimeter() { return 2 * Math.PI * radius; }
    @Override
    public String getShape() { return "Circle"; }
}
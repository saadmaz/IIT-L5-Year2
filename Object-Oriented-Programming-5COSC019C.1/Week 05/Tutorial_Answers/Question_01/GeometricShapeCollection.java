package Tutorial_Answers.Question_01;

import java.util.ArrayList;
import java.util.Scanner;

public class GeometricShapeCollection implements ShapeCollection {
    private ArrayList<GeometricObject> shapeList;
    private int numObject;

    public GeometricShapeCollection(int listLength) {
        this.numObject = listLength;
        shapeList = new ArrayList<>();
    }

    @Override
    public void addShape(GeometricObject shape) {
        if (shapeList.size() < numObject) {
            shapeList.add(shape);
        } else {
            System.out.println("No more space in the list");
        }
    }

    @Override
    public void printShapeList() {
        for (GeometricObject shape : shapeList) {
            System.out.println("Shape = " + shape.getShape() +
                ", Area = " + shape.getArea() +
                ", Perimeter = " + shape.getPerimeter() +
                ", " + shape.toString());
        }
    }

    @Override
    public boolean runMenu() {
        Scanner s = new Scanner(System.in);
        System.out.println("To Add a new shape press 1");
        System.out.println("To print the list of the shapes press 2");
        System.out.println("To exit press 3");
        int choice = s.nextInt();
        s.nextLine(); // Clear buffer

        switch (choice) {
            case 1:
                System.out.println("Press 1 if you want to add a Circle");
                System.out.println("Press 2 if you want to add a Rectangle");
                System.out.println("Press 3 if you want to add a Square");
                int choice2 = s.nextInt();
                s.nextLine(); // Clear buffer

                System.out.println("Enter the color of your shape:");
                String colour = s.nextLine();
                System.out.println("Is it filled? (y/n):");
                String isFilled = s.nextLine();
                boolean filled = isFilled.equalsIgnoreCase("y");

                switch (choice2) {
                    case 1:
                        System.out.println("Insert the radius:");
                        double radius = s.nextDouble();
                        addShape(new Circle(radius, colour, filled));
                        break;
                    case 2:
                        System.out.println("Insert the length:");
                        double length = s.nextDouble();
                        System.out.println("Insert the width:");
                        double width = s.nextDouble();
                        addShape(new Rectangle(length, width, colour, filled));
                        break;
                    case 3:
                        System.out.println("Insert the side:");
                        double side = s.nextDouble();
                        addShape(new Square(side, colour, filled));
                        break;
                }
                break;

            case 2:
                printShapeList();
                break;

            case 3:
                return true;
        }
        return false;
    }

    public static void main(String[] args) {
        ShapeCollection sys = new GeometricShapeCollection(10);
        boolean exit = false;
        while (!exit) {
            exit = sys.runMenu();
        }
    }
}
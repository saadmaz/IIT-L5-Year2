// 3) What happens if an image file is not present when you use getResource? Handle the exception.

import javax.swing.ImageIcon;

public class Question03 {
    public void loadImage() {
        try {
            // Tries to load an image that might not exist
            ImageIcon imageIconOne = new ImageIcon(getClass().getResource("one.png"));
        } catch (NullPointerException e) {
            // Handles the error if the resource is missing
            System.out.println("Image one not found");
        }
    }
}

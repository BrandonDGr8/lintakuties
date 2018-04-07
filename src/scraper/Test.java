package scraper;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class Test {
	public static void main(String[] args) throws FileNotFoundException {
		Scanner sc = new Scanner(new File("noisewords.txt"));
		sc.close();
	}
}

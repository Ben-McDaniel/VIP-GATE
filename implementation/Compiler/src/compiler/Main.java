package compiler;

public class Main {
	public static void main(String[] args) {
		Compiler c = new Compiler();
		
		c.addCCode("int sumN(int n){\n"
				+ "int sum = newProc(4, 5);\n"
				+ "return 0;\n"
				+ "}\n"
				+ "int newProc(int m, int n){\n"
				+ "}\n");
		c.compile();
		System.out.println(c.sidCode);
	}
}

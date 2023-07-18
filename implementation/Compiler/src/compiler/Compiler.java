package compiler;
import java.util.HashMap;
import java.util.Map.Entry;
import java.util.Stack;

public class Compiler {
	Environment e = new Environment();
	String cCode = "";
	String sidCode = "";
	HashMap<String, Integer> procedures = new HashMap<String, Integer>();
	Integer PC = 0;
	Stack<Loop> loops = new Stack<Loop>();
	int breakNum = 0;
	int loopNum = 0;
	
	void addCCode(String s) {
		cCode = s;
	}
	
	void compile() {
		String[] lines = cCode.split("\\n");
		String[] lineBreakdown = lines[0].split("[ (){]+");
		sidCode += "lui t0, 192\n"
				+ "addi t0, 0\n"
				+ "lw arg0, 0(t0)\n"
				+ "add t2, zero, zero\n"
				+ "addi t2, " + lineBreakdown[1] +"\n"
				+ "jalr ra, 0(t2)\n"
				+ "add 0,0,0\n"
				+ "lui t0, 192\n"
				+ "addi t0, 2\n"
				+ "sw arg0, 0(t0)\n";
		PC += 20;
		e.addVariable(lineBreakdown[3]);
		sidCode += lineBreakdown[1];
		sidCode += ":\n";
		sidCode += "add t0, 0, arg0\n";
		PC += 2;
		procedures.put(lineBreakdown[1], PC);
		//now i can actually start writing the procedure based on what's in the code
		
		for(int j = 1; j < lines.length; j++) {
			String line = lines[j];
			String[] breakdown = line.split("[ ;]+");

			//finishing an if statement or loop
			if(breakdown[0].length() == 0 || breakdown[0].compareTo("{") == 0) {
				//do nothing
			}else if(breakdown[0].compareTo("}") == 0) {
				if(loops.size() > 0) {
					Loop l = loops.pop();
					if(l instanceof compiler.whileLoop) {
						sidCode += "tst 0, 0\n";
						sidCode += "beq " + l.name + "\n";
						PC += 4;
						loopNum++;
					}else if(l instanceof compiler.forLoop) {
						sidCode += l.forLoopOp + e.getReg(l.forLoopVar) + "," + l.forLoopNum + "\n";
						sidCode += "tst 0, 0\n";
						sidCode += "beq " + l.name + "\n";
						PC += 6;
						loopNum++;
					}else {
						sidCode += "Break" + breakNum + ":\n";
						breakNum++;
					}
				}
			//variable reassignment
			}else if(e.containsVar(breakdown[0]) || e.containsVar(breakdown[0].substring(breakdown[0].length()-2, breakdown[0].length()))){
				if(breakdown.length == 1 && breakdown[0].length() >= 3) {
					if(breakdown[0].substring(breakdown[0].length()-2, breakdown[0].length()).compareTo("++") == 0) {
						sidCode += "addi " + e.getReg(breakdown[0].substring(0, breakdown[0].length()-2)) + ", 1\n";
						PC += 2;
					}else if(breakdown[0].substring(breakdown[0].length()-2, breakdown[0].length()).compareTo("--") == 0){
						sidCode += "addi " + e.getReg(breakdown[0].substring(0, breakdown[0].length()-2)) + ", -1\n";
						PC += 2;
					}
				}else if(breakdown.length == 3){
					if(isInteger(breakdown[2])) {
						sidCode += "addi " + e.getReg(breakdown[0]) + ", " + breakdown[2] + "\n";
						PC += 2;
					}else {
						sidCode += "add " + e.getReg(breakdown[0]) + ", " + e.getReg(breakdown[2]) + ", 0\n";
						PC += 2;
					}
				}else {
					if(breakdown[breakdown.length-1].endsWith(")")) {
						String fnName = "";
						if(breakdown.length == 3) {
							String[] fnBreakDown = breakdown[2].split("[()]+");
							fnName = fnBreakDown[0];
							if(isInteger(fnBreakDown[1])) {
								sidCode += "add arg0, 0, 0\n";
								sidCode += "addi arg0, " + fnBreakDown[1] + "\n";
								PC += 4;
							}else {
								sidCode += "add arg0, 0, " + e.getReg(fnBreakDown[1]) + "\n";
							}
						}else {
							String[] fnBreakDown1 = breakdown[2].split("[(,]+");
							fnName = fnBreakDown1[0];
							if(isInteger(fnBreakDown1[1])) {
								sidCode += "add arg0, 0, 0\n";
								sidCode += "addi arg0, " + fnBreakDown1[1] + "\n";
								PC += 4;
							}else {
								sidCode += "add arg0, 0, " + e.getReg(fnBreakDown1[1]) + "\n";
							}
							String[] fnBreakDown2 = breakdown[3].split("[)]");
							if(isInteger(fnBreakDown2[0])) {
								sidCode += "add arg1, 0, 0\n";
								sidCode += "addi arg1, " + fnBreakDown2[0] + "\n";
								PC += 4;
							}else {
								sidCode += "add arg1, 0, " + e.getReg(fnBreakDown2[0]) + "\n";
							}
						}
						//save vars on the stack
						sidCode += "addi sp, -2\n";
						sidCode += "sw ra, 0(sp)\n";
						PC += 4;
						sidCode += "addi sp, -" + (e.getNumRegs() * 2) + "\n";
						PC += 2;
						for(int i = 0; i < e.getNumRegs(); i++) {
							sidCode += "sw t" + i + ", " + i + "(sp)\n";
							PC += 2;
						}
						//call the procedure
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + fnName + "change\n";
						sidCode += "jalr ra, 0(15)\n";
						PC+=6;
						//load the vars back
						for(int i = 0; i < e.getNumRegs(); i++) {
							sidCode += "lw t" + i + ", " + i + "(sp)\n";
							PC += 2;
						}
						sidCode += "addi sp, " + (e.getNumRegs() * 2) + "\n";
						PC += 2;
						sidCode += "addi sp, 2\n";
						sidCode += "lw ra, 0(sp)\n";
						PC += 4;
						//do the rest of the expression
						sidCode += "add " + e.getReg(breakdown[1]) + ", 0, arg0\n";
					}else {
					switch (breakdown[3].charAt(0)) {
					case('+'):
						if(isInteger(breakdown[2])) {
							if(isInteger(breakdown[4])) {
								sidCode += "addi " + e.getReg(breakdown[0]) + ", " + breakdown[2] + "\n";
								sidCode += "addi " + e.getReg(breakdown[0]) + ", " + breakdown[4] + "\n";
								PC += 4;
							}else {
								sidCode += "add 15, 0, " + e.getReg(breakdown[4])+ "\n";
								sidCode += "addi 15, " + e.getReg(breakdown[2]) + "\n";
								sidCode += "add " + e.getReg(breakdown[0]) + ", 15, 0\n";
								PC += 6;
							}
						}else {
							if(isInteger(breakdown[4])) {
								sidCode += "add 15, 0, " + e.getReg(breakdown[2])+ "\n";
								sidCode += "addi 15, " +breakdown[4] + "\n";
								sidCode += "add " + e.getReg(breakdown[0]) + ", 15, 0\n";
								PC += 6;
							}else {
								sidCode += "add " + e.getReg(breakdown[0]) + ", " + e.getReg(breakdown[4]) +"," + e.getReg(breakdown[2]) + "\n";
								PC += 2;
							}
						}
					break;
					case('-'):
						if(isInteger(breakdown[2])) {
							if(isInteger(breakdown[4])) {
								sidCode += "addi " + e.getReg(breakdown[0]) + ", " + breakdown[2] + "\n";
								sidCode += "addi " + e.getReg(breakdown[0]) + ", -" + breakdown[4] + "\n";
								PC += 4;
							}else {
								sidCode += "add 15, 0, " + e.getReg(breakdown[4])+ "\n";
								sidCode += "addi 15, -" + e.getReg(breakdown[2]) + "\n";
								sidCode += "add " + e.getReg(breakdown[0]) + ", 15, 0\n";
								PC += 6;
							}
						}else {
							if(isInteger(breakdown[4])) {
								sidCode += "add 15, 0, " + e.getReg(breakdown[2])+ "\n";
								sidCode += "addi 15, -" + breakdown[4] + "\n";
								sidCode += "add " + e.getReg(breakdown[0]) + ", 15, 0\n";
								PC += 6;
							}else {
								sidCode += "sub " + e.getReg(breakdown[0]) + ", " + e.getReg(breakdown[2]) + ", " + e.getReg(breakdown[4]) + "\n";
								PC += 2;
							}
						}
					break;
					}
				}
			}
			}
			//if statement
			else if(breakdown[0].substring(0, 2).compareTo("if") == 0) {
				String first = breakdown[0].substring(3, breakdown[0].length());
				loops.push(new ifStatement(breakNum));
				breakNum++;
				if(breakdown[1].compareTo("==") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + first;
						sidCode += "blt Break" + breakNum + "\n";
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi " + breakdown[2] + ", 15\n";
						sidCode += "tst 15, " + first;
						sidCode += "blt Break" + breakNum + "\n";
						PC += 16;
					}else {
						sidCode += "tst "+ breakdown[2] + ", " + first + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						sidCode += "tst " + first + ", " + breakdown[2] + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}
				}else if(breakdown[1].compareTo("!=") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + first + "\n";
						sidCode += "beq Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst "+ breakdown[2] + ", " + first + "\n";
						sidCode += "beq Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo(">=") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst " + e.getReg(first) + ", 15\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(first) + ", " + e.getReg(breakdown[2]) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo(">") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + e.getReg(first) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(breakdown[2]) + ", " + e.getReg(first) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo("<=") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + e.getReg(first) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(breakdown[2]) + ", " + e.getReg(first) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo("<") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst " + e.getReg(first) + ", 15\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(first) + ", " + e.getReg(breakdown[2]) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 4;
					}
				}
			}
			//assigning a variable
			else if(breakdown[0].compareTo("int") == 0) {
				if(breakdown[2].compareTo("=") == 0) {
						e.addVariable(breakdown[1]);
						sidCode += "add " + e.getReg(breakdown[1]) + ", zero, zero\n";
						PC += 2;
						if(breakdown.length == 4 || breakdown.length == 5) {
							//procedure call
							if(breakdown[breakdown.length-1].endsWith(")")) {
								String fnName = "";
								if(breakdown.length == 4) {
									String[] fnBreakDown = breakdown[3].split("[()]+");
									fnName = fnBreakDown[0];
									if(isInteger(fnBreakDown[1])) {
										sidCode += "add arg0, 0, 0\n";
										sidCode += "addi arg0, " + fnBreakDown[1] + "\n";
										PC += 4;
									}else {
										sidCode += "add arg0, 0, " + e.getReg(fnBreakDown[1]) + "\n";
									}
								}else {
									String[] fnBreakDown1 = breakdown[3].split("[(,]+");
									fnName = fnBreakDown1[0];
									if(isInteger(fnBreakDown1[1])) {
										sidCode += "add arg0, 0, 0\n";
										sidCode += "addi arg0, " + fnBreakDown1[1] + "\n";
										PC += 4;
									}else {
										sidCode += "add arg0, 0, " + e.getReg(fnBreakDown1[1]) + "\n";
									}
									String[] fnBreakDown2 = breakdown[4].split("[)]");
									if(isInteger(fnBreakDown2[0])) {
										sidCode += "add arg1, 0, 0\n";
										sidCode += "addi arg1, " + fnBreakDown2[0] + "\n";
										PC += 4;
									}else {
										sidCode += "add arg1, 0, " + e.getReg(fnBreakDown2[0]) + "\n";
									}
								}
								//save vars on the stack
								sidCode += "addi sp, -2\n";
								sidCode += "sw ra, 0(sp)\n";
								PC += 4;
								sidCode += "addi sp, -" + (e.getNumRegs() * 2) + "\n";
								PC += 2;
								for(int i = 0; i < e.getNumRegs(); i++) {
									sidCode += "sw t" + i + ", " + i + "(sp)\n";
									PC += 2;
								}
								//call the procedure
								sidCode += "add 15, 0, 0\n";
								sidCode += "addi 15, " + fnName + "change\n";
								sidCode += "jalr ra, 0(15)\n";
								PC+=6;
								//load the vars back
								for(int i = 0; i < e.getNumRegs(); i++) {
									sidCode += "lw t" + i + ", " + i + "(sp)\n";
									PC += 2;
								}
								sidCode += "addi sp, " + (e.getNumRegs() * 2) + "\n";
								PC += 2;
								sidCode += "addi sp, 2\n";
								sidCode += "lw ra, 0(sp)\n";
								PC += 4;
								//do the rest of the expression
								sidCode += "add " + e.getReg(breakdown[1]) + ", 0, arg0\n";
							}else if(isInteger(breakdown[3])) {
								sidCode += "addi " + e.getReg(breakdown[1]) + ", " + breakdown[3] + "\n";
								PC += 2;
							}else {
								sidCode += "add " + e.getReg(breakdown[1]) + ", zero, " + e.getReg(breakdown[3]) + "\n";
								PC += 2;
							}
						}else {
							switch (breakdown[4].charAt(0)) {
								case('+'):
									if(isInteger(breakdown[3])) {
										if(isInteger(breakdown[5])) {
											sidCode += "addi " + e.getReg(breakdown[1]) + ", " + breakdown[3] + "\n";
											sidCode += "addi " + e.getReg(breakdown[1]) + ", " + breakdown[5] + "\n";
											PC += 4;
										}else {
											sidCode += "add 15, 0, " + e.getReg(breakdown[5])+ "\n";
											sidCode += "addi 15, " + e.getReg(breakdown[3]) + "\n";
											sidCode += "add " + e.getReg(breakdown[1]) + ", 15, 0\n";
											PC += 6;
										}
									}else {
										if(isInteger(breakdown[5])) {
											sidCode += "add 15, 0, " + e.getReg(breakdown[3])+ "\n";
											sidCode += "addi 15, " +breakdown[5] + "\n";
											sidCode += "add " + e.getReg(breakdown[1]) + ", 15, 0\n";
											PC += 6;
										}else {
											sidCode += "add " + e.getReg(breakdown[1]) + ", " + e.getReg(breakdown[5]) +"," + e.getReg(breakdown[3]) + "\n";
											PC += 2;
										}
									}
								break;
								case('-'):
									if(isInteger(breakdown[3])) {
										if(isInteger(breakdown[5])) {
											sidCode += "addi " + e.getReg(breakdown[1]) + ", " + breakdown[3] + "\n";
											sidCode += "addi " + e.getReg(breakdown[1]) + ", -" + breakdown[5] + "\n";
											PC += 4;
										}else {
											sidCode += "add 15, 0, " + e.getReg(breakdown[5])+ "\n";
											sidCode += "addi 15, -" + e.getReg(breakdown[3]) + "\n";
											sidCode += "add " + e.getReg(breakdown[1]) + ", 15, 0\n";
											PC += 6;
										}
									}else {
										if(isInteger(breakdown[5])) {
											sidCode += "add 15, 0, " + e.getReg(breakdown[3])+ "\n";
											sidCode += "addi 15, -" + breakdown[5] + "\n";
											sidCode += "add " + e.getReg(breakdown[1]) + ", 15, 0\n";
											PC += 6;
										}else {
											sidCode += "sub " + e.getReg(breakdown[1]) + ", " + e.getReg(breakdown[3]) + ", " + e.getReg(breakdown[5]) + "\n";
											PC += 2;
										}
									}
								break;
							}
						}
				}else {
					// new procedure
					String[] procBreakdown = line.split("[ (){]+");
					e = new Environment();
					if(procBreakdown[3].contains(",")) {
						e.addVariable(procBreakdown[3].substring(0, procBreakdown[3].length()-1));
						e.addVariable(procBreakdown[5]);
						sidCode += procBreakdown[1];
						sidCode += ":\n";
						procedures.put(procBreakdown[1], PC);
						sidCode += "add t0, 0, arg0\n";
						sidCode += "add t1, 0, arg1\n";
						PC += 4;
					}else {
						e.addVariable(procBreakdown[3]);
						sidCode += procBreakdown[1];
						sidCode += ":\n";
						procedures.put(procBreakdown[1], PC);
						sidCode += "add t0, 0, arg0\n";
						PC += 2;
					}
				}
			}
			//for
			else if(breakdown[0].substring(0, 3).compareTo("for") == 0) {
				forLoop loop = new forLoop();
				String first = breakdown[1];
				e.addVariable(first);
				loop.forLoopVar = first;
				if(isInteger(breakdown[3])) {
					sidCode += "add " + e.getReg(first) + ", 0, 0\n";
					sidCode += "addi " + e.getReg(first) + ", " + breakdown[3] + "\n";
					PC += 4;
				}else {
					sidCode += "add " + e.getReg(first) + ", 0, " + e.getReg(breakdown[3]) + "\n";
					PC += 2;
				}
				sidCode += "Loop" + loopNum + ":\n";
				loop.name = "Loop" + loopNum;
				if(breakdown[7].length() == first.length() + 2) {
					if(breakdown[7].charAt(breakdown[7].length()-1) == '+') {
						loop.forLoopOp = "addi ";
						loop.forLoopNum = 1;
					}else if(breakdown[7].charAt(breakdown[7].length()-1) == '-') {
						loop.forLoopOp = "addi ";
						loop.forLoopNum = -1;
					}
				}else if(breakdown[8].compareTo("+=") == 0) {
					loop.forLoopOp = "addi "; 
					loop.forLoopNum = Integer.parseInt(breakdown[9]);
				}else if(breakdown[8].compareTo("-=") == 0) {
					loop.forLoopOp = "addi "; 
					loop.forLoopNum = Integer.parseInt(breakdown[9]) * -1;
				}
				if(breakdown[5].compareTo("==") == 0) {
					if(isInteger(breakdown[6])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[6] + "\n";
						sidCode += "tst 15, " + first;
						sidCode += "blt Break" + breakNum + "\n";
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi " + breakdown[6] + ", 15\n";
						sidCode += "tst 15, " + first;
						sidCode += "blt Break" + breakNum + "\n";
						PC += 16;
					}else {
						sidCode += "tst "+ breakdown[6] + ", " + first + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						sidCode += "tst " + first + ", " + breakdown[6] + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}
				}else if(breakdown[5].compareTo("!=") == 0) {
					if(isInteger(breakdown[6])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[6] + "\n";
						sidCode += "tst 15, " + first + "\n";
						sidCode += "beq Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst "+ breakdown[6] + ", " + first + "\n";
						sidCode += "beq Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[5].compareTo(">=") == 0) {
					if(isInteger(breakdown[6])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[6] + "\n";
						sidCode += "tst " + e.getReg(first) + ", 15\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(first) + ", " + e.getReg(breakdown[6]) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[5].compareTo(">") == 0) {
					if(isInteger(breakdown[6])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[6] + "\n";
						sidCode += "tst 15, " + e.getReg(first) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(breakdown[6]) + ", " + e.getReg(first) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[5].compareTo("<=") == 0) {
					if(isInteger(breakdown[6])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[6] + "\n";
						sidCode += "tst 15, " + e.getReg(first) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(breakdown[6]) + ", " + e.getReg(first) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[5].compareTo("<") == 0) {
					if(isInteger(breakdown[6])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[6] + "\n";
						sidCode += "tst " + e.getReg(first) + ", 15\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(first) + ", " + e.getReg(breakdown[6]) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 4;
					}
				}
			//while
			}else if(breakdown[0].substring(0, 5).compareTo("while") == 0){
				loops.push(new whileLoop("Loop" + loopNum));
				loopNum++;
				String first = breakdown[0].substring(5, breakdown[0].length());
				sidCode += "Loop" + loopNum + ":\n";
				if(breakdown[1].compareTo("==") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + first;
						sidCode += "blt Break" + breakNum + "\n";
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi " + breakdown[2] + ", 15\n";
						sidCode += "tst 15, " + first;
						sidCode += "blt Break" + breakNum + "\n";
						PC += 16;
					}else {
						sidCode += "tst "+ breakdown[2] + ", " + first + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						sidCode += "tst " + first + ", " + breakdown[2] + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}
				}else if(breakdown[1].compareTo("!=") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + first + "\n";
						sidCode += "beq Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst "+ breakdown[2] + ", " + first + "\n";
						sidCode += "beq Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo(">=") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst " + e.getReg(first) + ", 15\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(first) + ", " + e.getReg(breakdown[2]) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo(">") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + e.getReg(first) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(breakdown[2]) + ", " + e.getReg(first) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo("<=") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst 15, " + e.getReg(first) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(breakdown[2]) + ", " + e.getReg(first) + "\n";
						sidCode += "blt Break" + breakNum + "\n";
						PC += 4;
					}
				}else if(breakdown[1].compareTo("<") == 0) {
					if(isInteger(breakdown[2])) {
						sidCode += "add 15, 0, 0\n";
						sidCode += "addi 15, " + breakdown[2] + "\n";
						sidCode += "tst " + e.getReg(first) + ", 15\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 8;
					}else {
						sidCode += "tst " + e.getReg(first) + ", " + e.getReg(breakdown[2]) + "\n";
						sidCode += "bge Break" + breakNum + "\n";
						PC += 4;
					}
				}
			}
			//return
			else if(breakdown[0].compareTo("return") == 0) {
				if(breakdown.length == 2) {
					if(isInteger(breakdown[1])) {
						sidCode += "add arg0, 0, 0\n";
						sidCode += "addi arg0, " + breakdown[1] + "\n";
						PC += 4;
					}else {
						sidCode += "add arg0, 0, " + e.getReg(breakdown[1]) + "\n";
						PC += 2;
					}
				}else {
					switch (breakdown[2].charAt(0)) {
					case('+'):
						if(isInteger(breakdown[1])) {
							if(isInteger(breakdown[3])) {
								sidCode += "addi arg0, " + breakdown[1] + "\n";
								sidCode += "addi arg0, " + breakdown[3] + "\n";
								PC += 4;
							}else {
								sidCode += "add 15, 0, " + e.getReg(breakdown[3])+ "\n";
								sidCode += "addi 15, " + e.getReg(breakdown[1]) + "\n";
								sidCode += "add arg0, 15, 0\n";
								PC += 6;
							}
						}else {
							if(isInteger(breakdown[3])) {
								sidCode += "add 15, 0, " + e.getReg(breakdown[1])+ "\n";
								sidCode += "addi 15, " +breakdown[3] + "\n";
								sidCode += "add arg0, 15, 0\n";
								PC += 6;
							}else {
								sidCode += "add arg0, " + e.getReg(breakdown[3]) +"," + e.getReg(breakdown[1]) + "\n";
								PC += 2;
							}
						}
					break;
					case('-'):
						if(isInteger(breakdown[1])) {
							if(isInteger(breakdown[3])) {
								sidCode += "addi arg0, " + breakdown[1] + "\n";
								sidCode += "addi arg0, -" + breakdown[3] + "\n";
								PC += 4;
							}else {
								sidCode += "add 15, 0, " + e.getReg(breakdown[3])+ "\n";
								sidCode += "addi 15, -" + e.getReg(breakdown[1]) + "\n";
								sidCode += "add arg0, 15, 0\n";
								PC += 6;
							}
						}else {
							if(isInteger(breakdown[4])) {
								sidCode += "add 15, 0, " + e.getReg(breakdown[1])+ "\n";
								sidCode += "addi 15, -" + breakdown[3] + "\n";
								sidCode += "add arg0, 15, 0\n";
								PC += 6;
							}else {
								sidCode += "sub arg0, " + e.getReg(breakdown[1]) + ", " + e.getReg(breakdown[3]) + "\n";
								PC += 2;
							}
						}
					break;
					}
				}
				sidCode += "jalr 0, 0(ra)\n";
				PC += 2;
			}
		}
		
		//change
		for(Entry<String, Integer> e: procedures.entrySet()) {
			String find = e.getKey();
			find += "change";
			System.out.println(find);
			sidCode = sidCode.replaceAll(find, e.getValue().toString());
		}
	}
	
	public static boolean isInteger(String s) {
	    try { 
	        Integer.parseInt(s); 
	    } catch(NumberFormatException e) { 
	        return false; 
	    } catch(NullPointerException e) {
	        return false;
	    }
	    // only got here if we didn't return false
	    return true;
	}
}

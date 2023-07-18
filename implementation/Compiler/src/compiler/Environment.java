package compiler;
import java.util.HashMap;

public class Environment {
	private HashMap<String, Integer> variables = new HashMap<String, Integer>();
	void addVariable(String var) {
		for(int i = 3; i < 10; i++) {
			if(!variables.containsValue(i)) {
				variables.put(var, i);
				break;
			}
		}
	}
	
	int getReg(String var) {
		return variables.get(var);
	}

	boolean containsVar(String var){
		return variables.containsKey(var);
	}
	
	int getNumRegs() {
		return variables.size();
	}
}

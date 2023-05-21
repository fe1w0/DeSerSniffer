class Taint {

	String name = "Taint";

	public static int source(){
		return 1;
	}

	public static String tranform(int id){
		if (id == 1){
			return "One";
		}
	}

	public void maybeEvil(String str){
		System.out.println("Evil" + str);
	}
}

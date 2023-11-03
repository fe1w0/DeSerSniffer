package sources.dynamic;

/**
* @author fe1w0
* @date 2023/10/12 15:42
* @Project example
*/

import sources.demo.EvilObject;

public class Reflect {

    String reflectString;

    public void handleMethod(String code) {
        exec(code);
    }

    public Object getObject(String code) {
        return (Object) code;
    }

    public void exec(String code) {
        Object tmpObject = getObject(code);
        tmpObject.hashCode();
        EvilObject evilObject = new EvilObject();
        evilObject.evil(code);
    }
}

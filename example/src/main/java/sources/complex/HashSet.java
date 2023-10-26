package sources.complex;

import java.util.Map;

/**
 * @author fe1w0
 * @date 2023/10/25 18:25
 * @Project example
 */
public class HashSet {
    private final Map map;

    private final Object key;

    public HashSet(Map map, Object key) {
        this.map = map;
        this.key = key;
    }

    public Object getValue(){
        return map.get(key);
    }
}

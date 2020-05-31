public class Utils {
	
    /**
     * Returns random integer between 0 and range (inclusive)
     */
    public static Integer getRandomInteger(Integer range)
    {
        Double result = -1;
        while (result <= 0)
        {
            result = math.random() * (range);
        }
		return result.intValue();
    }
    
    /**
     * Returns random Integer between minNum and maxNum (inclusive)
     */ 
    public static Integer getRandomInteger(Integer minNum, Integer maxNum)
    {
        Integer result = -1;
        while(result < minNum || result > maxNum)
        {
            result = getRandomInteger(maxNum+1);
        }
        return result;
    }
    
    /* 
     * Returns a set of numElementsToPull Integers between 0 and listSize (inclusive)
     */
    public static Set<Integer> getRandomIndices(Integer listSize, Integer numElementsToPull)
    {
        Set<Integer> result = new Set<Integer>();
        while(result.size() < numElementsToPull)
        {
            result.add(getRandomInteger(listSize));
        }
        return result;
    }
    
    /* 
     * Return a list of numOfElements random Objects from objs
     *
    public static List<Object> getRandomElements(List<Object> objs, Integer numOfElements, SObjectType objectType)
    {
        List<SObject> castRecords = (List<SObject>)Type.forName(listType).newInstance();
        List<Object> result = new List<Object>();
        
        Set<Integer> indices = getRandomIndices(objs.size(), numOfElements);
        for(Integer index : indices)
        {
            result.add(objs[index]);
        }
        
        return result;
    }
    
    /* 
     * Return a list of numOfElements random Objects from objs
     *
    public static Object getRandomElement(List<Object> objs)
    {
        return objs[getRandomInteger(objs.size() - 1)];
    }
    */

    
    /*
     * Simply prints a list of the passed list
     */
    public static void printList(List<Object> objs)
    {
        for(Object obj : objs)
        {
            System.debug(obj);
        }
    }
    
}
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
    
        /**
     * Returns random Decimal between 0 and range (inclusive)
     */
    public static Decimal getRandomDecimal(Decimal range)
    {
        Decimal result = -1;
        while (result < 0)
        {
            result = math.random() * (range);
        }
		return result;
    }
    
    /**
     * Returns random Integer between minNum and maxNum (inclusive)
     */ 
    public static Decimal getRandomDecimal(Decimal minNum, Decimal maxNum)
    {
        Decimal result = -1;
        while(result < minNum || result > maxNum)
        {
            result = getRandomDecimal(maxNum);
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
     * Return either 1 or -1. 50/50 chance either way... in theory
     */ 
    public static Integer getRandomSign()
    {
        if (Math.random() > 0.5)
        {
            return 1;
        }
        else
        {
            return -1;
        }
        
    }
    
}
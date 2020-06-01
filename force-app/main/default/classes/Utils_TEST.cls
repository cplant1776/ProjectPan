@isTest
public class Utils_TEST {
    
    private static Integer MIN_RAND_NUM_VALUE = 2;
    private static Integer MAX_RAND_NUM_VALUE = 6;
    private static Decimal MIN_RAND_DEC_VALUE = 0.2;
    private static Decimal MAX_RAND_DEC_VALUE = 0.6;
    
    private static Integer NUM_OF_GENERATED_INDICES = 10;
    
    @isTest
    private static void doesGetRandomIntegerReturnProperRange()
    {  
        for(Integer i=0; i < 100; i++)
        {
            // Generate random int and check if its in correct range
            Integer randInt = Utils.getRandomInteger(MIN_RAND_NUM_VALUE, MAX_RAND_NUM_VALUE);
            System.assert(randInt >= MIN_RAND_NUM_VALUE && randInt <= MAX_RAND_NUM_VALUE);
        }
    }

    @isTest
    private static void doesGetRandomDecimalReturnProperRange()
    {
        for(Integer i=0; i < 100; i++)
        {
            // Generate random int and check if its in correct range
            Decimal randDec = Utils.getRandomDecimal(MIN_RAND_DEC_VALUE, MAX_RAND_DEC_VALUE);
            System.assert(randDec >= MIN_RAND_DEC_VALUE && randDec <= MAX_RAND_DEC_VALUE);
        }
    }
    
    @isTest
    private static void doesGetRandomIndicesReturnProperRange()
    {
        Set<Integer> indices = Utils.getRandomIndices(NUM_OF_GENERATED_INDICES, NUM_OF_GENERATED_INDICES);
        
        // Ensure result contains all indices: [0-(NUM_OF_GENERATED_INDICES-1)]
        for(Integer i=0; i < NUM_OF_GENERATED_INDICES; i++)
        {
            System.assert(indices.Contains(i));
            indices.remove(i);
        }
        
        // Ensure no indices outside of range
        System.assertEquals(0, indices.size());
    }

    @isTest
    static void doesGetRandomSignReturnProperValues()
    {
        for(Integer i=0; i < 100; i++)
        {
            Integer randSign = Utils.getRandomSign();
            System.assert(randSign == -1 || randSign == 1);
        }
    }
    
    /*
    @isTest
    private static void doesGetRandomElementPullSingleValueFromList()
    {
        List<String> input = new List<String>{'hello', 'world', '!'};
            String randElm = (String)Utils.getRandomElement(input);
        System.assert(input.contains(randElm));
    }
    
    @isTest
    private static void doesGetRandomElementsPullProperValuesFromList()
    {
        Integer numOfElements = 2;
        List<String> input = new List<String>{'hello', 'world', '!'};
            List<String> randElms = (List<String>)Utils.getRandomElements(input, numOfElements);
        
        System.assertEquals(numOfElements, randElms.size());
        for(String s : randElms)
        {
            System.assert(input.contains(s));
        }
        
    }
    */
}
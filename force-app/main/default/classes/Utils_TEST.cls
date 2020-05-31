@isTest
public class Utils_TEST {
    
    private static Integer MIN_RAND_INT_VALUE = 2;
    private static Integer MAX_RAND_INT_VALUE = 6;
    private static Integer NUM_OF_GENERATED_INDICES = 10;
    
    @isTest
    private static void doesGetRandomIntegerReturnProperRange()
    {
        // Bools to ensure range is inclusive
        Boolean maxNumWasReturned = False;
        Boolean minNumWasReturned = False;
        
        for(Integer i=0; i < 100; i++)
        {
            // Generate random int and check if its in correct range
            Integer randInt = Utils.getRandomInteger(MIN_RAND_INT_VALUE, MAX_RAND_INT_VALUE);
            System.assert(randInt >= MIN_RAND_INT_VALUE && randInt <= MAX_RAND_INT_VALUE);
            
            // If min or max value generated, toggle Boolean
            if(randInt == MIN_RAND_INT_VALUE)
                minNumWasReturned = True;
            if(randInt == MAX_RAND_INT_VALUE)
                maxNumWasReturned = True;
        }
        
        System.assert(minNumWasReturned && maxNumWasReturned);
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
}
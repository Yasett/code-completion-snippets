import com.google.common.base.CaseFormat;
import com.google.common.base.CharMatcher;
import com.google.common.base.Charsets;
import com.google.common.base.Joiner;
import com.google.common.base.Optional;
import com.google.common.hash.HashCode;
import com.google.common.hash.HashFunction;
import com.google.common.hash.Hashing;
import com.google.common.base.Splitter;
import com.google.common.cache.CacheBuilder;
import com.google.common.cache.CacheLoader;
import com.google.common.cache.LoadingCache;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.ContiguousSet;
import com.google.common.collect.DiscreteDomain;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Multimap;
import com.google.common.collect.Ordering;
import com.google.common.collect.Range;
import com.google.common.collect.Sets;
import com.google.common.collect.Sets.SetView;
import com.google.common.collect.Table;
import com.google.common.collect.Tables;
import com.google.common.graph.GraphBuilder;
import com.google.common.graph.MutableGraph;
import com.google.common.graph.MutableValueGraph;
import com.google.common.graph.ValueGraphBuilder;
import com.google.common.io.Files;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;


public class Guava {

	/*Filter digits and special characters from a String*/
	public void digitMatcher(){
		String input = "El identificador del recibo es 19210/10";
		CharMatcher charMatcher = CharMatcher.DIGIT.or(CharMatcher.is('/'));
		String output = charMatcher.retainFrom(input);
		System.out.println(output);
	}

	/*Filter uppercase letters from a String*/
	public void charMatcherUppercase(){
		String input = "sample text";
		CharMatcher charMatcher = CharMatcher.JAVA_LOWER_CASE.or(CharMatcher.WHITESPACE).negate();
		String output = charMatcher.retainFrom(input);
		System.out.println(output);
	}
	
	/*Filter specific letters and whitespaces from a String*/
	public void charMatcher(){
		String input = "sample text";
		CharMatcher charMatcher = CharMatcher.inRange('m', 's').or(CharMatcher.is('a').or(CharMatcher.WHITESPACE));
		String output = charMatcher.retainFrom(input);
		System.out.println(output);
	}

	/*Join array elements*/
	public void joinElements(){
		String[] ordinals = {"Primero", null, "Tercero", "Cuarto", null, "Sexto"};
		String union = Joiner.on(", ").skipNulls().join(ordinals);
		System.out.println(union);
	}
	
	/*Join HashMap elements*/
	public void Hashmap(){
		Map<Integer, String> map = new HashMap<Integer, String>();
		map.put(1, "First");
		map.put(2, "Second");
		map.put(3, "Third");
		String union = Joiner.on(", ").withKeyValueSeparator(" -> ").join(map);
		System.out.println(union);
	}
	
	/*Create and transpose a table*/
	public void transposeTable(){
		Table<Integer, String, String> table = HashBasedTable.create();
		table.put(1, "a", "1a");
		table.put(1, "b", "1b");
		table.put(2, "a", "2a");
		table.put(2, "b", "2b");

		Table<String, Integer, String> transposed = Tables.transpose(table);
	}
	
	/*Sort a list of integers*/
	public void sortList(){
		List<Integer> numbers = new ArrayList<Integer>();
	      
	      numbers.add(new Integer(5));
	      numbers.add(new Integer(2));
	      numbers.add(new Integer(15));

	      Ordering<Integer> order = Ordering.natural();
	      Collections.sort(numbers,order);
	}
	
	/*Get maximum and minimum from a list of integers*/
	public void getMaxMin(){
		List<Integer> numbers = new ArrayList<Integer>();
	      
	      numbers.add(new Integer(5));
	      numbers.add(new Integer(2));
	      numbers.add(new Integer(15));

	      Ordering<Integer> ordering = Ordering.natural();
	      int min = ordering.min(numbers);
	      int max = ordering.max(numbers);
	}
	
	/*Iterate through range elements*/
	public void showRange() {
		Range<Integer> range = Range.closed(0, 9);
				
		for (int value : ContiguousSet.create(range, DiscreteDomain.integers())) {
			System.out.print(value + " ");
		}
	}
	
	/*Get upper and lower bounds from a range*/
	public void maxMinRange() {
		Range<Integer> rango = Range.open(0, 9);
				
		int lowerBound = rango.lowerEndpoint();
		int upperBound = rango.upperEndpoint();
	}
	
	/*Save objects in cache memory*/
	public void cachingUtilities() {		
		Map<Integer, String> map = new HashMap<Integer, String>();
		map.put(1, "First");
		map.put(2, "Second");
		map.put(3, "Third");
		
		 LoadingCache<Integer, String> cache = 
		         CacheBuilder.newBuilder()
		            .maximumSize(100) // can save up to 100 elements 
		            .expireAfterAccess(30, TimeUnit.MINUTES) // expires after 30 minutes of access
		            .build(new CacheLoader<Integer, String>(){ 
		               @Override
		               public String load(Integer id) throws Exception {
		                  return map.get(1);
		               } 
		            });
		try {
			System.out.println(cache.get(1));
		} catch (ExecutionException e) {
			// TODO: Handle exception
		}
	}
	
	/*Create and iterate a multimap*/
	public void multimap() {
		Multimap<String, String> multimap = ArrayListMultimap.create();

		multimap.put("Group1", "A");
		multimap.put("Group1", "B");
		multimap.put("Group2", "C");		

		for (String value : multimap.get("Group1")) {
			System.out.println(value);
		}
	}
	
	/*Find the intersection of two sets*/
	public void setIntersection() {
		Set<Integer> oddNumbers = new TreeSet<Integer>();
		for (int i = 1; i <= 9; i += 2) {
			oddNumbers.add(i);
		}
		Set<Integer> primeNumbers = ImmutableSet.of(2, 3, 5, 7);

		SetView<Integer> intersection = Sets.intersection(primeNumbers, oddNumbers); // 3, 5, 7
	}
	
	/*Split a String*/
	public void splitText() {
		String texto = " a,b ,,   c ";
		Iterable<String> subtexts = Splitter.on(',').trimResults().omitEmptyStrings().split(texto);

		for (String s : subtexts) {
			System.out.println(s);
		}
	}
	
	/*Write on a File*/
	public void writeFile() {
		String fileName = "D://file_path.ext";
        File file = new File(fileName);
        
        String content = "sample text";
        
        try {
			Files.write(content.getBytes(), file);
		} catch (IOException e) {
			// TODO: Handle exception
		}
	}
	
	/*Join two sets*/
	public void setUnion() {
		Set<Integer> oddNumbers = new TreeSet<Integer>();
		for (int i = 1; i <= 9; i += 2) {
			oddNumbers.add(i);
		}
		Set<Integer> primeNumbers = ImmutableSet.of(2, 3, 5, 7);

		SetView<Integer> union = Sets.union(primeNumbers, oddNumbers); // 2, 3, 5, 7, 1, 9	
	}
	
	/*Read all the lines from a file at a time*/
	public void readAllLines() {
		String fileName = "D://file_path.ext";

		try {
			List<String> lines = Files.readLines(new File(fileName), Charsets.UTF_8);
			for (String line : lines) {
				System.out.println(line);
			}
		} catch (IOException e) {
			// TODO: Handle exception
		}		
	}
	
	/*Generate the hash of a String*/
	public void hash() {
		HashFunction hf = Hashing.md5();
		String text = "Text to Hash";
		HashCode hc = hf.hashString(text, Charsets.UTF_8);
		System.out.println(hc.toString());
	}
	
	/*Reverse the order of a collection*/
	public void sortListReverse(){
		List<Integer> numbers = new ArrayList<Integer>();
	      
	      numbers.add(new Integer(5));
	      numbers.add(new Integer(2));
	      numbers.add(new Integer(15));

	      Ordering<Integer> orden = Ordering.natural();
	      Collections.sort(numbers, orden.reverse());	      
	}
	
	/*Verify if a list is ordered*/
	public void verifyIsOrdered(){
		List<Integer> numeros = new ArrayList<Integer>();
	      
	      numeros.add(new Integer(5));
	      numeros.add(new Integer(2));
	      numeros.add(new Integer(15));

	      Ordering<Integer> orden = Ordering.natural();
	      boolean isOrdered = orden.isOrdered(numeros);
	      System.out.println(isOrdered);
	}
	
	/*Convert between case formats*/
	public static void formatCase() {
		String text = "SampleText";
		System.out.println(CaseFormat.UPPER_CAMEL.to(CaseFormat.LOWER_HYPHEN, text));
	}
	
	/*Handle null values with Optional*/
	public void optional() {
		Optional<String> fromNull = Optional.fromNullable(null);
		if (fromNull.isPresent()) {
			System.out.println(fromNull.get());
		} else {
			System.out.println("Value is null");
		}
	}
	
	/*Create a mutable graph*/
	public void createMutableGraph() {
		MutableGraph<Integer> graph = GraphBuilder.directed().build();
		graph.addNode(1);
		graph.putEdge(2, 3);  // also adds nodes 2 and 3, if not already present

		Set<Integer> successorsOfTwo = graph.successors(2); // returns {3}
	}
	
	/*Create a mutable value graph*/
	public void createMutableValueGraph() {
		MutableValueGraph<Integer, Double> weightedGraph = ValueGraphBuilder.directed().build();
		weightedGraph.addNode(1);
		weightedGraph.putEdgeValue(2, 3, 1.5);  // also adds nodes 2 and 3, if not already present
		weightedGraph.putEdgeValue(3, 5, 1.5);  // edge values (like Map values) do not need to be unique
	}
	
	/*Check if graph contains element*/
	public void verifyElementInGraph() {
		MutableGraph<Integer> graph = GraphBuilder.directed().build();
		//Adds 1 and 2 as nodes of this graph, and put an edge between them
		graph.putEdge(1, 2);  
		boolean isNodePresent = graph.nodes().contains(1);
	}
	
	/*Calculate factorial of an integer*/
	public void calculateFactorial() {
		int factorial = IntMath.factorial(4);
	}
}

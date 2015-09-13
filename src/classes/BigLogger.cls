public with sharing class BigLogger {

	private Enum OutputType {SETUP,CONSOLE}

	public static String getBigCharString(String strIn){
		List<BigChar> chars = fetchBigChars(strIn);

	    String theString = '\r\n\r\n';
	    
	    for (Integer i = 0; i < chars[0].character.size(); i++){
	        
	        for (Integer j = 0; j < chars.size(); j++){
	            //System.debug(chars[j].character.size());
	            //System.debug(j);
	            //System.debug(chars.size());
	            //System.debug(i);
	            theString = theString + chars[j].character[i];
	            
	        }
	        
	        theString = theString + '\r\n';
	        
	    }

	    return theString;
	}

	public static List<BigChar> fetchBigChars(String charString){
		List<BigChar> lsBigChars = new List<BigChar>();
		Map<String,String> bigChars = new Map<String,String>();
		bigChars.put('32','{"character":["      ","      ","      ","      "]}');
		bigChars.put('48','{"character":[" dP*Yb   ","dP   Yb  ","Yb   dP  "," YbodP   "]}');
		bigChars.put('49','{"character":["  .d  ",".d88  ","  88  ","  88  "]}');
		bigChars.put('50','{"character":["oP*Yb.  ","*\' dP\'  ","  dP\'   ",".d8888  "]}');
		bigChars.put('51','{"character":["88888  ","  .dP  ","o `Yb  ","YbodP  "]}');
		bigChars.put('52','{"character":["  dP88   "," dP 88   ","d888888  ","    88   "]}');
		bigChars.put('53','{"character":["888888  ","88oo.*  ","   `8b  ","8888P\'  "]}');
		bigChars.put('54','{"character":["  dP\'    ",".d8\'     ","8P***Yb  ","`YboodP  "]}');
		bigChars.put('55','{"character":["888888P  ","    dP   ","   dP    ","  dP     "]}');
		bigChars.put('56','{"character":[".dP*o.  ","`8b.d\'  ","d\'`Y8b  ","`bodP\'  "]}');
		bigChars.put('57','{"character":["dP**Yb  ","Ybood8  ","  .8P\'  "," .dP\'   "]}');
		bigChars.put('65','{"character":["   db     ","  dPYb    "," dP__Yb   ","dP****Yb  "]}');
		bigChars.put('66','{"character":["88**Yb  ","88__dP  ","88**Yb  ","88oodP  "]}');
		bigChars.put('67','{"character":[" dP**b8  ","dP   `*  ","Yb       "," YboodP  "]}');
		bigChars.put('68','{"character":["8888b.   "," 8I  Yb  "," 8I  dY  ","8888Y*   "]}');
		bigChars.put('69','{"character":["888888  ","88__    ","88**    ","888888  "]}');
		bigChars.put('70','{"character":["888888  ","88__    ","88**    ","88      "]}');
		bigChars.put('71','{"character":[" dP**b8  ","dP   `*  ","Yb  *88  "," YboodP  "]}');
		bigChars.put('72','{"character":["88  88  ","88  88  ","888888  ","88  88  "]}');
		bigChars.put('73','{"character":["88  ","88  ","88  ","88  "]}');
		bigChars.put('74','{"character":[" 88888  ","    88  ","o.  88  ","*bodP\'  "]}');
		bigChars.put('75','{"character":["88  dP  ","88odP   ","88*Yb   ","88  Yb  "]}');
		bigChars.put('76','{"character":["88      ","88      ","88  .o  ","88ood8  "]}');
		bigChars.put('77','{"character":["8b    d8  ","88b  d88  ","88YbdP88  ","88 YY 88  "]}');
		bigChars.put('78','{"character":["88b 88  ","88Yb88  ","88 Y88  ","88  Y8  "]}');
		bigChars.put('79','{"character":[" dP*Yb   ","dP   Yb  ","Yb   dP  "," YbodP   "]}');
		bigChars.put('80','{"character":["88**Yb  ","88__dP  ","88***   ","88      "]}');
		bigChars.put('81','{"character":[" dP*Yb   ","dP   Yb  ","Yb b dP  "," `*YoYo  "]}');
		bigChars.put('82','{"character":["88**Yb  ","88__dP  ","88*Yb   ","88  Yb  "]}');
		bigChars.put('83','{"character":[".dP*Y8  ","`Ybo.*  ","o.`Y8b  ","8bodP\'  "]}');
		bigChars.put('84','{"character":["888888   ","  88    ","  88    ","  88    "]}');
		bigChars.put('85','{"character":["88   88  ","88   88  ","Y8   8P  ","`YbodP\'  "]}');
		bigChars.put('86','{"character":["Yb    dP  "," Yb  dP   ","  YbdP    ","   YP     "]}');
		bigChars.put('87','{"character":["Yb        dP  "," Yb  db  dP   ","  YbdPYbdP    ","   YP  YP     "]}');
		bigChars.put('88','{"character":["Yb  dP  "," YbdP   "," dPYb   ","dP  Yb  "]}');
		bigChars.put('89','{"character":["Yb  dP  "," YbdP   ","  8P    "," dP     "]}');
		bigChars.put('90','{"character":["8888P  ","  dP   "," dP    ","d8888  "]}');

		for (Integer chr: charString.getChars()){
			System.debug('value for char num: ' + chr);
			String charStrKey = String.valueOf(chr);
			BigChar thisChar = (BigChar) JSON.deserialize(bigChars.get(charStrKey),BigChar.class);
			lsBigChars.add(thisChar);

		}

		return lsBigChars;
	}

	public static void debug(String message){
		System.debug(getBigCharString(message));
	}

	//public static void debug(String message, OutputType outputTo){

	//}
	//public BigLogger() {
		
	//}

	public static BigLogger.BigChar getBigCharFromString(String jsonBigChar){
		BigChar ltr = (BigChar) JSON.deserialize(jsonBigChar, BigChar.class);
		return ltr;
	}

	public class Letter{
		public List<String> letter;
	}

	public class BigChar{
		public Integer order;
		public List<String> character;
	}
}
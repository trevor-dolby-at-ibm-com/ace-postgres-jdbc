package test.ace.postgres;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.ibm.broker.javacompute.MbJavaComputeNode;
import com.ibm.broker.plugin.MbException;
import com.ibm.broker.plugin.MbMessage;
import com.ibm.broker.plugin.MbMessageAssembly;
import com.ibm.broker.plugin.MbOutputTerminal;
import com.ibm.broker.plugin.MbService;
import com.ibm.broker.plugin.MbUserException;

public class TimerFlow_JavaCompute extends MbJavaComputeNode {

	public void outputToServiceLog(String one, String two, String three, String four)
	{
    	String[] inserts = new String[3];
    	inserts[0] = one;
    	inserts[1] = two;
    	inserts[2] = three;
    	
    	try {
			MbService.logInformation("class", "method", "BIPmsgs", "8099", four, inserts);
		} catch (java.lang.Throwable jlt) {
			jlt.printStackTrace();
		}
    	//System.out.println(""+one+": "+two+"  -  "+three+" : "+four);
	}
	public void evaluate(MbMessageAssembly inAssembly) throws MbException {
		MbOutputTerminal out = getOutputTerminal("out");
		MbOutputTerminal alt = getOutputTerminal("alternate");

		MbMessage inMessage = inAssembly.getMessage();
		MbMessageAssembly outAssembly = null;
		try {
			// create new message as a copy of the input
			MbMessage outMessage = new MbMessage(inMessage);
			outAssembly = new MbMessageAssembly(inAssembly, outMessage);
			// ----------------------------------------------------------
			// Add user code below
			String selectResult = "";

		    Connection conn = getJDBCType4Connection("PostgresJDBC", JDBC_TransactionType.MB_TRANSACTION_AUTO);

		    // Example of using the Connection to create a java.sql.Statement  
		    Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,
		                                          ResultSet.CONCUR_READ_ONLY);
		    ResultSet rs = stmt.executeQuery("SELECT count(*) from pg_tables");
		    if ( rs.first() )
		    {
		      selectResult = rs.getString(1);
		    }
		    outputToServiceLog("Database statement", "SELECT count(*) from pg_tables", "result", selectResult);
			// End of user code
			// ----------------------------------------------------------
		} catch (MbException e) {
			// Re-throw to allow Broker handling of MbException
			throw e;
		} catch (RuntimeException e) {
			// Re-throw to allow Broker handling of RuntimeException
			throw e;
		} catch (Exception e) {
			// Consider replacing Exception with type(s) thrown by user code
			// Example handling ensures all exceptions are re-thrown to be handled in the flow
			throw new MbUserException(this, "evaluate()", "", "", e.toString(), null);
		}
		// The following should only be changed
		// if not propagating message to the 'out' terminal
		out.propagate(outAssembly);

	}
}

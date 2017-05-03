
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

 
public class Server {

    public static void main(String[] args) throws IOException {
        int filesize=6022386; 
        long start = System.currentTimeMillis();
        int bytesNum;
        int currentByteNum = 0;
        ServerSocket servsock = new ServerSocket(8000);
        while (true) {
		    System.out.println("Waiting for a connection:");
		    Socket sock = servsock.accept();
		    System.out.println("Receiving image");
		    byte [] bytearray  = new byte [filesize];
		    InputStream inputStream = sock.getInputStream();
		    FileOutputStream fos = new FileOutputStream("C://Users//sgspe//Documents//Virtual Machines//Shared folder//Pic.jpg"); // destination path and name of file
		    BufferedOutputStream bos = new BufferedOutputStream(fos);
		    bytesNum = inputStream.read(bytearray,0,bytearray.length);
		    currentByteNum = bytesNum;
		    
		    while(bytesNum > -1){
		       bytesNum = inputStream.read(bytearray, currentByteNum, (bytearray.length-currentByteNum));
		       if(bytesNum >= 0){
		    	   currentByteNum += bytesNum;
		       }
		    }
		    
		    bos.write(bytearray, 0 , currentByteNum);
		    bos.flush();
		    long end = System.currentTimeMillis();
		    System.out.println(end-start);
		    bos.close();
		    sock.close();
		    new DataBase();
		}
    }
}

class DataBase
{		
	    
        public DataBase() {
        	  try
              {
	              	Class.forName("com.mysql.jdbc.Driver");
	                Connection connection = DriverManager.getConnection("jdbc:mysql://localhost/picdb","root","");
	                System.out.println("Connected to the database");
	                insertImage(connection,"C://Users//sgspe//Documents//Virtual Machines//Shared folder//Pic.jpg");
	                //getImage(connection);       
              }
              catch (Exception e)
              {
                      e.printStackTrace();
              }
            
        }
 
        public void insertImage(Connection connection,String imagePath)
        {
                String query;
                int imgSize;
                PreparedStatement prepStatment;
                try
                {
                        File file = new File(imagePath);
                        FileInputStream fis = new FileInputStream(file);
                        imgSize = (int)file.length();
                        query = ("insert into pic VALUES(?,?,?)");
                        prepStatment = connection.prepareStatement(query);
                        prepStatment.setInt(1, imgSize);
                        prepStatment.setString(2,file.getName());
                        prepStatment.setBinaryStream(3, fis, imgSize); 
                        prepStatment.executeUpdate();
                        System.out.println("Sent Image!");
                }
                catch (Exception e)
                {
                        e.printStackTrace();
                }
        }
 
        public void getImage(Connection connection)
        {
                 byte[] fileIn;
                 String query;
                 try
                 {
                         query = "select img from pic";
                         Statement statement = connection.createStatement();
                         ResultSet result = statement.executeQuery(query);
                         if (result.next())
                        {
                                  fileIn = result.getBytes(1);
                                  OutputStream outputFile = new FileOutputStream("C:\\Users\\sgspe\\Documents\\Virtual Machines\\Shared folder\\" + "image.jpg");
                                  outputFile.write(fileIn);
                                  outputFile.close();
                                  System.out.println("Received Image from database");
                        }        
                 }
                 catch (Exception e)
                 {
                         e.printStackTrace();
                 }
        }
};
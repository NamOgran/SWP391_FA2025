package DBConnect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    protected Connection connection;

    public DBConnect() {
        try {
            // SQL Server JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // URL cho SQL Server
            String url = "jdbc:sqlserver://NAM;databaseName=gio_swp391;encrypt=false;";
            String username = "sa";         // đổi lại user của bạn
            String password = "sa";     // đổi lại password thực tế

            connection = DriverManager.getConnection(url, username, password);
            System.out.println("Connected to SQL Server successfully.");
        } catch (ClassNotFoundException e) {
            System.err.println("SQL Server JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException ex) {
            System.err.println("Cannot connect to SQL Server.");
            ex.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }
}

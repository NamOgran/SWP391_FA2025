package DBconnect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBconnect {

    protected Connection connection;

    public DBconnect() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=gio_swp391;encrypt=true;trustServerCertificate=true";
            String username = "sa";
            String password = "123456";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("cannot connect to db");
        }
    }

    // ✅ Thêm hàm getter này:
    public Connection getConnection() {
        return connection;
    }
}

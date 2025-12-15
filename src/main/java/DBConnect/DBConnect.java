package DBConnect;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {

    protected Connection connection;

    public DBConnect() {
        try {
            // Nạp driver JDBC của Microsoft SQL Server
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            String host = "localhost"; // hoặc "yourservername.database.windows.net"
            String port = "1433";
            String database = "gio_swp391";
            String username = "sa"; // hoặc user admin Azure của bạn
            String password = "123"; // thay bằng mật khẩu thật

            // 🔹 Cấu hình chuỗi kết nối JDBC
            String url = "jdbc:sqlserver://" + host + ":" + port
                       + ";databaseName=" + database
                       + ";encrypt=true"
                       + ";trustServerCertificate=true"; // nếu dùng local hoặc Docker

            // 🔹 Kết nối
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

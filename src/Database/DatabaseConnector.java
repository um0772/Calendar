package Database;

import java.sql.*;

public class DatabaseConnector {
    public static Connection getConnection() {
        String url = "jdbc:mysql://localhost:3306/sharecalendar?&serverTimezone=Asia/Seoul";
        String userid = "root";
        String pwd = "root";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, userid, pwd);
        } catch(ClassNotFoundException e) {
            e.printStackTrace();
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

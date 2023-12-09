package Database;

import java.sql.*;

public class DatabaseConnector {
    public static Connection getConnection() {
        String url = "jdbc:mysql://localhost:3306/sharecalendar?&serverTimezone=Asia/Seoul";
        String userid = "root";
        String pwd = "tjrrbtjrrb13!";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, userid, pwd);
        } catch(ClassNotFoundException e) {
            System.err.println("JDBC 드라이버 로드 실패: " + e.getMessage());
            e.printStackTrace();
        } catch(SQLException e) {
            System.err.println("데이터베이스 연결 실패: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}

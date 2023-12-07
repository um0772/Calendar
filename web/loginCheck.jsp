<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DatabaseConnector" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Check</title>
</head>
<body>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        con = DatabaseConnector.getConnection();
        String sql = "SELECT user_PW FROM User WHERE user_name = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, username);

        rs = pstmt.executeQuery();

        if (rs.next()) {
            String storedPassword = rs.getString("user_PW");
            if (password.equals(storedPassword)) {
                // 로그인 성공: 캘린더 페이지로 리디렉션
                response.sendRedirect("calendar.jsp");
            } else {
                // 로그인 실패: 경고 메시지와 함께 로그인 페이지로 돌아감
                out.println("<script>alert('로그인 실패했습니다.'); history.back();</script>");
            }
        } else {
            // 사용자 이름이 존재하지 않음
            out.println("<script>alert('존재하지 않는 사용자입니다.'); history.back();</script>");
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException ex) {}
        if(pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
        if(con != null) try { con.close(); } catch(SQLException ex) {}
    }
%>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="Database.DatabaseConnector" %> <!-- DatabaseConnector 클래스 임포트 -->
<!DOCTYPE html>
<html>
<head>
    <title>회원가입</title>
    <script type="text/javascript">
        function showMessage(message) {
            alert(message);
        }
    </script>
</head>
<body>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm-password");
    String team = request.getParameter("team");
    String teamPassword = request.getParameter("Group-password");

    boolean hasError = false;
    String errorMessage = "";
    String successMessage = "회원가입이 완료되었습니다!";

    if (username == null || username.trim().isEmpty()) {
        hasError = true;
        errorMessage += "사용자 이름을 입력해주세요.\\n";
    }

    Pattern pattern = Pattern.compile("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$");
    Matcher matcher = pattern.matcher(email);
    if (email == null || email.trim().isEmpty() || !matcher.matches()) {
        hasError = true;
        errorMessage += "유효한 이메일 주소를 입력해주세요.\\n";
    }

    if (password == null || password.length() < 8) {
        hasError = true;
        errorMessage += "비밀번호는 8자 이상이어야 합니다.\\n";
    }

    if (!password.equals(confirmPassword)) {
        hasError = true;
        errorMessage += "비밀번호가 일치하지 않습니다.\\n";
    }

    //팀 비밀번호 확인
    if (team.equals("developer") && !"dd".equals(teamPassword)) {
        hasError = true;
        errorMessage += "개발자 팀의 비밀번호가 일치하지 않습니다.\\n";
    }

    if (team.equals("designer") && !"ss".equals(teamPassword)) {
        hasError = true;
        errorMessage += "디자이너 팀의 비밀번호가 일치하지 않습니다.\\n";
    }

    if (team.equals("manager") && !"mm".equals(teamPassword)) {
        hasError = true;
        errorMessage += "매니저 팀의 비밀번호가 일치하지 않습니다.\\n";
    }

    if (!hasError) {
        Connection con = null;
        PreparedStatement pstmt_user = null;
        PreparedStatement pstmt_team = null;

        try {
            // 데이터베이스 연결
            con = DatabaseConnector.getConnection();

            // User 테이블에 정보 저장
            String sql_user = "INSERT INTO User (user_name, user_email, user_PW) VALUES (?, ?, ?)";
            pstmt_user = con.prepareStatement(sql_user, Statement.RETURN_GENERATED_KEYS);
            pstmt_user.setString(1, username);
            pstmt_user.setString(2, email);
            pstmt_user.setString(3, password); // 비밀번호 해시 처리 필요
            int userResult = pstmt_user.executeUpdate();

            // 회원가입 성공 또는 실패에 따른 메시지 출력
            // 회원가입 성공 또는 실패 메시지 출력
            if (userResult > 0) {
                successMessage = "회원가입이 완료되었습니다. 로그인 페이지로 이동합니다.";
                out.println("<script type='text/javascript'>showMessage('" + successMessage + "'); window.location.href = 'login.jsp';</script>");
            } else {
                errorMessage = "회원가입에 실패했습니다. 다시 시도해주세요.";
                out.println("<script type='text/javascript'>showMessage('" + errorMessage + "');</script>");
            }
        } catch(Exception e) {
            e.printStackTrace();
            errorMessage = "데이터베이스 처리 중 오류가 발생했습니다.";
            out.println("<script type='text/javascript'>showMessage('" + errorMessage + "');</script>");
        } finally {
            // 리소스 정리
            if(pstmt_user != null) try { pstmt_user.close(); } catch(SQLException ex) {}
            if(pstmt_team != null) try { pstmt_team.close(); } catch(SQLException ex) {}
            if(con != null) try { con.close(); } catch(SQLException ex) {}
        }
    } else {
        // 에러 메시지 출력
        out.println("<script type='text/javascript'>showMessage('" + errorMessage + "'); history.back();</script>");
    }
%>
</body>
</html>
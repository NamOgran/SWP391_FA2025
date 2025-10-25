<%@ page import="java.sql.*" %>
<%@ page import="DBconnect.DBconnect" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
    <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'>
    <style>
        body {
            font-family: 'Quicksand', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 900px;
            width: 100%;
            margin: 20px;
            animation: fadeIn 0.6s ease-out;
        }
        h1 {
            text-align: center;
            color: #6b4f4f;
            margin-bottom: 20px;
        }
        h2 {
            color: #8a6e5b;
            border-bottom: 2px solid #e0d3d3;
            padding-bottom: 5px;
        }
        .status {
            text-align: center;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .success { color: green; }
        .error { color: red; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 15px 0;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background: #f0e6e6;
            color: #6b4f4f;
        }
        tr:nth-child(even) { background-color: #f9f9f9; }
        pre {
            background: #f2f2f2;
            padding: 10px;
            border-radius: 8px;
            overflow-x: auto;
        }
        button {
            display: block;
            margin: 20px auto 0;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #a0816c 0%, #8a6e5b 100%);
            color: white;
            cursor: pointer;
            font-size: 1em;
            transition: 0.3s;
        }
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.2);
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🧪 Database Connection Test</h1>
        <%
            try {
                DBconnect db = new DBconnect();
                Connection conn = db.getConnection();

                if (conn != null && !conn.isClosed()) {
        %>
                    <div class="status success">✅ Connection Successful!</div>
                    <p><strong>Database:</strong> gio_swp391</p>
                    <p><strong>Driver:</strong> com.microsoft.sqlserver.jdbc.SQLServerDriver</p>

                    <!-- ===== CATEGORY TABLE ===== -->
                    <h2>📂 Table: category</h2>
                    <table>
                        <tr>
                            <th>category_id</th>
                            <th>type</th>
                            <th>gender</th>
                        </tr>
                        <%
                            String sql1 = "SELECT * FROM category";
                            Statement st1 = conn.createStatement();
                            ResultSet rs1 = st1.executeQuery(sql1);
                            while (rs1.next()) {
                        %>
                        <tr>
                            <td><%= rs1.getInt("category_id") %></td>
                            <td><%= rs1.getString("type") %></td>
                            <td><%= rs1.getString("gender") %></td>
                        </tr>
                        <%
                            }
                            rs1.close();
                            st1.close();
                        %>
                    </table>

                    <!-- ===== PROMO TABLE ===== -->
                    <h2>💸 Table: promo</h2>
                    <table>
                        <tr>
                            <th>promo_id</th>
                            <th>promo_percent</th>
                            <th>start_date</th>
                            <th>end_date</th>
                        </tr>
                        <%
                            String sql2 = "SELECT * FROM promo";
                            Statement st2 = conn.createStatement();
                            ResultSet rs2 = st2.executeQuery(sql2);
                            while (rs2.next()) {
                        %>
                        <tr>
                            <td><%= rs2.getInt("promo_id") %></td>
                            <td><%= rs2.getInt("promo_percent") %> %</td>
                            <td><%= rs2.getDate("start_date") %></td>
                            <td><%= rs2.getDate("end_date") %></td>
                        </tr>
                        <%
                            }
                            rs2.close();
                            st2.close();
                            conn.close();
                        %>
                    </table>
        <%
                } else {
        %>
                    <div class="status error">❌ Connection Failed!</div>
        <%
                }
            } catch (Exception e) {
        %>
                <div class="status error">⚠️ Connection Error!</div>
                <pre><%= e.getMessage() %></pre>
        <%
            }
        %>

        <button onclick="window.location.reload()">🔄 Test Again</button>
    </div>
</body>
</html>

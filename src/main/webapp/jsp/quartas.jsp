<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>QUARTAS</title>
<style>
.container {
	width: 100%;
	max-width: 50rem;
	margin: 0 auto;
}
#menu ul {
    padding:0px;
    margin:0px;
    background-color:#EDEDED;
    list-style:none;
    font-size: 18px;
}

#menu ul li {
	display: inline;
}

#menu ul li a {
	font-size: 18px;
    padding: 2px 10px;
    display: inline-block;
    background-color:#EDEDED;
    color: #333;
    text-decoration: none;
    border-bottom:3px solid #EDEDED;
}

#menu ul li a:hover {
	font-size: 18px;
    background-color:#D6D6D6;
    color: #6D6D6D;
    border-bottom:3px solid #EA0000;
}
</style>
</head>
<body>
	<jsp:include page = "menu.jsp" />
	<div class="container">
	      <table>
	       <tr>
           		<th>TimeA</th>
           		<th>TimeB</th>
           </tr>
          <c:forEach items='${jogos}' var = 'j'>
               <tr>
                    <td><c:out value="${j.getNome().get(0)}"/></td>
                    <td><c:out value="${j.getNome().get(1)}"/></td>
               <tr>
          </c:forEach>
          </table>
	</div>
</body>
</html>
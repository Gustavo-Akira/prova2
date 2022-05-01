<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Jogos</title>
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
		<form action="jogos" method="post">
			<button>Carregar Jogos</button>
		</form>
		<div>
				<table>
					<tr>
						<th>TimeA</th>
						<th>TimeB</th>
						<th>Gols do Time A</th>
						<th>Gols do time B</th>
						<th>Dia Do Jogo</th>
					</tr>
					<c:forEach items="${ jogos }" var="j">
					<tr>
						<td><c:out value="${ j.getTimeA()}"></c:out></td>
						<td><c:out value="${ j.getTimeB()}"></c:out></td>
						<td><c:out value="${ j.getGolsTimeA() }"></c:out></td>
						<td><c:out value="${ j.getGolsTimeB() }"></c:out></td>
						<td><c:out value="${ j.getDiaDoJogo() }"></c:out></td>
					</tr>
					</c:forEach>
				</table>
			
		</div>
	</div>
</body>
</html>
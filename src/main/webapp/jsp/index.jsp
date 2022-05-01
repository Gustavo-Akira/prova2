<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>GRUPOS</title>
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
		<c:if test="${ empty grupos}">
			<h1>N�O H� GRUPOS NO MOMENTO</h1>
		 </c:if>
			<c:forEach items="${ grupos }" var="g">
				<c:out value="${ g.getNome() }"></c:out>
				<table>
					<tr>
						<th>Nome dos times</th>
					 </tr>
					<c:forEach items="${ g.getTimes() }" var="times">
						<tr>
							<td>
								<c:out value="${ times.getNome() }"></c:out>
							</td>
						</tr>
					</c:forEach>
				</table>
			</c:forEach>
			
			<div>
				<form action="grupos" method="post">
					<button>GERAR GRUPOS</button>
				</form>
			</div>
			
	</div>
</body>
</html>
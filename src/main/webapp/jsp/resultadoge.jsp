<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
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
    <c:choose>
    	<c:when test="${!times.isEmpty()}">
            <figure>
                            <table class="is-geral-results">
                                <caption>Times</caption>
                                <thead>
                                    <tr>
                                        <th scope="col">Time</th>
                                        <th scope="col">Jogos disputados</th>
                                        <th scope="col">Vitórias</th>
                                        <th scope="col">Empates</th>
                                        <th scope="col">Derrotas</th>
                                        <th scope="col">Gols Marcados</th>
                                        <th scope="col">Gols Sofridos</th>
                                        <th scope="col">Saldo de gols</th>
                                        <th scope="col">Pontos</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="resultado" items="${times}">
                                        <c:choose>
                                            <c:when test="${rebaixados.contains(resultado.getTime())}">
                                                <tr style="color:red">
                                                                                                   <td>${resultado.getTime()}</td>
                                                                                                   <td>${resultado.getJogosDisputados()}</td>
                                                                                                   <td>${resultado.getVitorias()}</td>
                                                                                                   <td>${resultado.getEmpates()}</td>
                                                                                                   <td>${resultado.getDerrotas()}</td>
                                                                                                   <td>${resultado.getGolsMarcados()}</td>
                                                                                                   <td>${resultado.getGolsSofridos()}</td>
                                                                                                   <td>${resultado.getSaldoDeGols()}</td>
                                                                                                   <td>${resultado.getPontos()}</td>
                                                                                               </tr>
                                            </c:when>
                                            <c:otherwise>
                                               <tr>
                                                   <td>${resultado.getTime()}</td>
                                                   <td>${resultado.getJogosDisputados()}</td>
                                                   <td>${resultado.getVitorias()}</td>
                                                   <td>${resultado.getEmpates()}</td>
                                                   <td>${resultado.getDerrotas()}</td>
                                                   <td>${resultado.getGolsMarcados()}</td>
                                                   <td>${resultado.getGolsSofridos()}</td>
                                                   <td>${resultado.getSaldoDeGols()}</td>
                                                   <td>${resultado.getPontos()}</td>
                                               </tr>
                                            </c:otherwise>
                                        </c:choose>

                                    </c:forEach>
                                </tbody>
                            </table>
                        </figure>
    				</c:when>
    				<c:otherwise>
    					<p>Sem classificação ainda.</p>
    				</c:otherwise>
    			</c:choose>
</body>
</html>
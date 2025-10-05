<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>사용자 관리 - 비밀번호 초기화</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
</head>
<body class="bg-page">
<jsp:include page="/WEB-INF/views/components/header.jsp"/>
<main class="container-1200 d-flex gap-24 py-4">
    <jsp:include page="/WEB-INF/views/components/sidebar.jsp"/>
    <section class="flex-1 card-white p-4 shadow-sm">
        <h4 class="fw-bold mb-3">비밀번호 초기화</h4>
        <button id="resetBtn" class="btn btn-warning"><i class="bi bi-key"></i> 초기화</button>
        <p id="result" class="mt-3 text-danger fw-bold"></p>
    </section>
</main>
<jsp:include page="/WEB-INF/views/components/footer.jsp"/>
<script src="<c:url value='/vendor/jquery/jquery-3.7.1.min.js'/>"></script>
<script>
    const id = ${userId};
    $("#resetBtn").click(function(){
        $.post("<c:url value='/api/admin/reset-password'/>", { username: id }, function(msg){
            $("#result").text(msg);
        });
    });
</script>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>계정 추가</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <link rel="icon" href="<c:url value='/favicon.ico'/>"/>
</head>
<body class="bg-page">

<jsp:include page="/WEB-INF/views/components/header.jsp"/>

<main class="container-1200 d-flex gap-24 py-4">
    <jsp:include page="/WEB-INF/views/components/sidebar.jsp"/>
    <section class="flex-1 card-white p-4 shadow-sm">
        <div class="d-flex justify-content-between mb-3">
            <h4 class="fw-bold">계정 생성</h4>
            <a href="<c:url value='/auth/user-list'/>" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-arrow-left"></i> 목록으로
            </a>
        </div>

        <form id="createAccountForm" class="needs-validation" novalidate>
            <div class="mb-3">
                <label class="form-label">권한</label>
                <select name="role" class="form-select" required>
                    <option value="">선택하세요</option>
                    <option value="ADMIN">관리자</option>
                    <option value="PROFESSOR">교수</option>
                    <option value="STUDENT">학생</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">소속학과 ID</label>
                <input type="number" name="deptId" class="form-control"/>
                <div class="form-text">※ 관리자 계정일 경우 비워도 됩니다.</div>
            </div>
            <div class="mb-3">
                <label class="form-label">이메일</label>
                <input type="email" name="email" class="form-control" required/>
            </div>
            <div class="mb-3">
                <label class="form-label">이름</label>
                <input type="text" name="name" class="form-control" required/>
            </div>
            <button type="submit" class="btn btn-navy">
                <i class="bi bi-save"></i> 생성
            </button>
        </form>

        <div id="resultMsg" class="mt-3"></div>
    </section>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp"/>

<script src="<c:url value='/js/vendor/jquery/jquery-3.7.1.min.js'/>"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $("#createAccountForm").on("submit", function(e){
        e.preventDefault();

        $.ajax({
            url: "<c:url value='/api/admin/create-account'/>",
            type: "POST",
            data: $(this).serialize(),
            success: function(res){
                // Controller에서 "계정 생성 완료, 로그인 ID: xxx 임시 비밀번호: yyy" 반환
                $("#resultMsg").html(
                    `<div class="alert alert-success">
                        <i class="bi bi-check-circle"></i> ${res}
                    </div>`
                );
                $("#createAccountForm")[0].reset();
            },
            error: function(err){
                $("#resultMsg").html(
                    `<div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle"></i> ${err.responseText}
                    </div>`
                );
            }
        });
    });
</script>
</body>
</html>

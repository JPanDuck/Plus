<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>사용자 삭제</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
</head>
<body class="bg-page">

<jsp:include page="/WEB-INF/views/components/header.jsp"/>

<main class="py-4">
    <div class="container-600">
        <div class="card-white p-4 shadow-sm text-center">
            <h4 class="mb-3">사용자 삭제</h4>
            <p>정말로 이 사용자를 삭제하시겠습니까?</p>
            <div class="mt-3">
                <button class="btn btn-danger" id="confirmDelete">삭제</button>
                <a href="<c:url value='/admin/user/user-list'/>" class="btn btn-secondary">취소</a>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/views/components/footer.jsp"/>

<script src="<c:url value='/js/vendor/jquery/jquery-3.7.1.min.js'/>"></script>
<script>
    const params = new URLSearchParams(window.location.search);
    const userId = params.get("id");

    $("#confirmDelete").on("click", function(){
        $.ajax({
            url: "<c:url value='/api/admin/delete-user/'/>" + userId,
            type: "DELETE",
            success: () => {
                alert("삭제 완료");
                window.location.href = "<c:url value='/admin/user/user-list'/>";
            },
            error: () => alert("삭제 실패")
        });
    });
</script>
</body>
</html>

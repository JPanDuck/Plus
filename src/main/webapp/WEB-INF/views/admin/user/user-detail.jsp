<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>사용자 상세보기</title>
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
        <h4 class="fw-bold mb-3">사용자 상세보기</h4>
        <div id="userDetail"></div>
        <hr/>
        <div class="d-flex gap-2">
            <button class="btn btn-outline-primary" id="btnEdit"><i class="bi bi-pencil"></i> 편집</button>
            <button class="btn btn-outline-warning" id="btnReset"><i class="bi bi-key"></i> 비밀번호 초기화</button>
            <button class="btn btn-outline-danger" id="btnDelete"><i class="bi bi-trash"></i> 삭제</button>
        </div>
    </section>
</main>
<jsp:include page="/WEB-INF/views/components/footer.jsp"/>
<script src="<c:url value='/js/vendor/jquery/jquery-3.7.1.min.js'/>"></script>
<script>
    const userId = new URLSearchParams(window.location.search).get("id");
    function loadDetail(){
        $.get("<c:url value='/api/admin/user/all'/>", function(users){
            const u = users.find(x=>x.id==userId);
            if(!u){ $("#userDetail").html("<div class='alert alert-danger'>사용자를 찾을 수 없습니다.</div>"); return;}
            $("#userDetail").html(`
            <p><b>ID:</b> ${u.id}</p>
            <p><b>이름:</b> ${u.name}</p>
            <p><b>이메일:</b> ${u.email}</p>
            <p><b>권한:</b> ${u.roleEntity.roleName}</p>
            <p><b>상태:</b> ${u.status||'-'}</p>
        `);
        });
    }
    $("#btnReset").on("click", ()=> {
        $.post("<c:url value='/api/admin/reset-password'/>", {username:userId})
            .done(res=>alert(res)).fail(err=>alert(err.responseText));
    });
    $("#btnDelete").on("click", ()=>{
        if(confirm("삭제하시겠습니까?")){
            $.ajax({url:"<c:url value='/api/admin/delete-user/'/>"+userId, type:"DELETE"})
                .done(()=>{ alert("삭제 완료"); location.href="<c:url value='/admin/user/list'/>"; })
                .fail(err=>alert(err.responseText));
        }
    });
    $("#btnEdit").on("click", ()=>{
        // 간단히 상태변경/수정은 Ajax 예시만
        const newStatus = prompt("새 상태 입력 (재학중/휴학중/졸업):");
        if(newStatus){
            $.ajax({url:"<c:url value='/api/admin/update-user/'/>"+userId+"/status", type:"PUT", data:{status:newStatus}})
                .done(res=>{ alert(res); loadDetail(); })
                .fail(err=>alert(err.responseText));
        }
    });
    $(function(){ loadDetail(); });
</script>
</body>
</html>

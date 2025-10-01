<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>공지사항 상세보기</title>

    <style>
        .urgent{
            color: #007bff;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div>
    <c:if test="${notice.isUrgent == 1}">
        <span class="urgent">중요</span>
    </c:if>
    <h3>${notice.title}</h3>
    <p>생성일: ${notice.createdAtStr}</p>
    <p>조회수: ${notice.viewCount}</p>
    <div>
        <p>${notice.content}</p>
    </div>
</div>

<hr>

<a href="/notices/">목록으로</a>

<!--관리자만 볼 수 있는 버튼-->
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <button onclick="location.href='/notices/edit/${notice.id}'">수정</button>
    <button onclick="deleteNotice(${notice.id})">삭제</button>
</sec:authorize>

<script>
    function deleteNotice(id) {
        if (confirm('정말 삭제하시겠습니까?')){
            fetch(`/api/notices/${id}`, {
                method: 'DELETE'
            }).then(response => {
                if(response.ok){
                    alert('삭제되었습니다.');
                    window.location.href = '/notices';
                }else{
                    alert('삭제 실패했습니다.');
                }
            });
        }
    }
</script>

</body>
</html>

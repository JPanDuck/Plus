<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>공지사항 수정</title>
</head>
<body>
<!--폼 submit 방식일 경우 : fetch 삭제 / action="/notices/edit" method="post" 로 변경-->
<form id="editForm">
    <input type="hidden" id="id" name="id" value="${notice.id}">

    <label for="title">제목: </label><br>
    <input type="text" id="title" name="title" value="${notice.title}">
    <br><br>

    <label for="content">내용: </label><br>
    <textarea id="content" name="content" rows="10" cols="50">${notice.content}</textarea>
    <br><br>

    <label for="isUrgent">중요: </label>
    <input type="hidden" name="isUrgent" value="0">
    <input type="checkbox" id="isUrgent" name="isUrgent" value="1" <c:if test="${notice.isUrgent == 1}">checked</c:if>>
    <br><br>

    <label for="deadline">미리알림: </label><br>
    <input type="date" id="deadline" name="deadline" value="${notice.deadlineStr}">
    <br><br>

    <label for="startDate">시작일: </label><br>
    <input type="date" id="startDate" name="startDate" value="${notice.startDateStr}">
    <br><br>

    <label for="endDate">종료일: </label><br>
    <input type="date" id="endDate" name="endDate" value="${notice.endDateStr}">
    <br><br>

    <button type="submit">수정 완료</button>
    <button type="button" onclick="history.back()">취소</button>
</form>

<script>
    document.getElementById('editForm').addEventListener('submit', function (event){
        event.preventDefault();

        const noticeId = document.getElementById('id').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;
        const isUrgent = document.getElementById('isUrgent').checked ? 1 : 0;
        const deadline = document.getElementById('deadline').value;
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        const data = {
            id: noticeId,
            title: title,
            content: content,
            isUrgent: isUrgent,
            deadline: deadline,
            startDate: startDate,
            endDate: endDate
        };

        fetch(`/api/notices/${noticeId}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        })
        .then(response => {
            if(response.ok){
                alert('공지사항 수정이 완료되었습니다.');
                window.location.href = `/notices/detail/${noticeId}`;
            }else {
                alert('수정 실패했습니다.');
            }
        })
        .catch(error => {
            console.log('네트워크 오류: ', error);
        });
    });
</script>

</body>
</html>

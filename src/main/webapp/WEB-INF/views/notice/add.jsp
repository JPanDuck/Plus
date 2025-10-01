<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>공지사항 생성</title>
</head>
<body>
<form id="addForm" action="/notices/add" method="post">
    <label for="title">제목: </label><br>
    <input type="text" id="title" name="title" required><br><br>

    <label for="content">내용: </label><br>
    <textarea id="content" name="content" rows="10" cols="50" required></textarea><br><br>

    <label for="isUrgent">중요: </label>
    <input type="hidden" name="isUrgent" value="0">
    <input type="checkbox" id="isUrgent" name="isUrgent" value="1"><br><br>

    <label for="deadline">미리알림: </label><br>
    <input type="date" id="deadline" name="deadline"><br><br>

    <label for="startDate">시작일: </label><br>
    <input type="date" id="startDate" name="startDate" required><br><br>

    <label for="endDate">종료일: </label><br>
    <input type="date" id="endDate" name="endDate" required><br><br>

    <button type="submit">작성</button>
</form>

<script>
    document.getElementById('addForm').addEventListener('submit', function (event){
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;

        if(startDate !== "" && endDate !== "" && startDate > endDate){
            alert('종료일은 시작일 이후로 설정 부탁드립니다.');
            event.preventDefault(); //폼 제출 막기
        }
    })
</script>
</body>
</html>

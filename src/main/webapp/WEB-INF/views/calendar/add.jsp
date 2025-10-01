<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>새 학사일정 추가</title>
</head>
<body>
<div class="container">
    <h1>새 학사일정 추가</h1>
    <c:if test="${not empty message}">
        <div class="alert">
            <c:out value="${message}" />
        </div>
    </c:if>
    <form action="/calendar/save" method="post">
        <div class="form-group">
            <label for="content">내용:</label>
            <textarea id="content" name="content" required></textarea>
        </div>
        <div class="form-group">
            <label for="startDate">시작 날짜:</label>
            <input type="date" id="startDate" name="startDate" required>
        </div>
        <div class="form-group">
            <label for="endDate">종료 날짜:</label>
            <input type="date" id="endDate" name="endDate" required>
        </div>
        <div class="buttons">
            <button type="submit" class="submit-btn">저장</button>
            <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
        </div>
    </form>
</div>
</body>
</html>

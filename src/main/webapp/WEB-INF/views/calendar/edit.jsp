<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>학사일정 수정</title>
</head>
<body>
<div class="container">
  <h1>학사일정 수정</h1>
  <c:if test="${not empty message}">
    <div class="alert">
      <c:out value="${message}" />
    </div>
  </c:if>
  <form action="/calendar/update/${calendar.id}" method="post">
    <input type="hidden" name="id" value="${calendar.id}">
    <div class="form-group">
      <label for="content">일정 내용:</label>
      <input type="text" id="content" name="content" value="${calendar.content}" required>
    </div>
    <div class="form-group">
      <label for="startDate">시작 날짜:</label>
      <input type="date" id="startDate" name="startDate" value="${calendar.startDate}" required>
    </div>
    <div class="form-group">
      <label for="endDate">종료 날짜:</label>
      <input type="date" id="endDate" name="endDate" value="${calendar.endDate}" required>
    </div>
    <div class="buttons">
      <button type="submit" class="submit-btn">수정</button>
      <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
    </div>
  </form>
</div>
</body>
</html>

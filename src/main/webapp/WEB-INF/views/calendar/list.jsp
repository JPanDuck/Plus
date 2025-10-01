<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>학사일정 목록</title>
</head>
<body>
<div class="container">
    <h1>학사일정</h1>
    <c:if test="${not empty message}">
        <div class="alert">
            <c:out value="${message}" />
        </div>
    </c:if>
    <div class="add-link">
        <a href="/calendar/add">새 일정 추가</a>
    </div>
    <ul class="calendar-list">
        <c:forEach var="calendar" items="${calendars}">
            <li class="calendar-item">
                <div>
                    <h2><c:out value="${calendar.content}"/></h2>
                    <p><c:out value="${calendar.startDate}"/> - <c:out value="${calendar.endDate}"/></p>
                </div>
                <div class="actions">
                    <a href="/calendar/edit/${calendar.id}">수정</a>
                    <form action="/calendar/delete/${calendar.id}" method="post" style="display:inline;">
                        <button type="submit">삭제</button>
                    </form>
                </div>
            </li>
        </c:forEach>
    </ul>
</div>
</body>
</html>

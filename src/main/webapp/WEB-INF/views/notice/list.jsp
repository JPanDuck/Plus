<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<html>
<head>
    <title>공지사항 목록</title>

    <style>
        .important{
            color: #007bff;
            font-weight: bold;
        }
    </style>
</head>
<body>
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <a href="/notices/add">공지사항 추가</a>
</sec:authorize>

<table>
    <thead>
        <tr>
            <th>제목</th>
            <th>생성일</th>
            <th>조회수</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="notice" items="${noticeList}">
            <tr>
                <td class="${notice.isUrgent eq 1 ? 'urgent' : ''}">
                    <c:if test="${notice.isUrgent eq 1}">
                        <span class="important">중요</span>
                    </c:if>
                    <a href="/notices/detail/${notice.id}">${notice.title}</a>
                </td>
                <td>${notice.createdAtStr}</td>
                <td>${notice.viewCount}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>

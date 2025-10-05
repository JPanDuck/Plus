<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>알림 목록</title>
    <style>
        .resolved {
            background-color: #f2f2f2;
        }
        .unread{
            background-color: #e6f7ff;
        }
    </style>
</head>
<body>
<table>
    <thead>
        <tr>
            <th>유형</th>
            <th>제목</th>
            <th>상태</th>
            <th>생성일</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="noti" items="${notifications}">
            <tr class="${noti.isResolved eq 1 ? 'resolved' : 'unread'}">
                <td>${noti.notiType}</td>
                <td>${noti.title}</td>
                <td>${noti.isResolved eq 1 ? '읽음' : '안읽음'}</td>
                <td>${noti.createdAtStr}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<script>
    document.addEventListener('DOMContentLoaded', function (){
        const unreadRows = document.querySelectorAll('tr.unread');

        unreadRows.forEach(row => {
            row.addEventListener('click', function() {
                const notiId = this.dataset.notiId;

                fetch(`/api/notifications/${notiId}/read`, {
                    method: 'PUT'
                })
                    .then(response => {
                        if(response.ok){
                            this.classList.remove('unread');
                            this.classList.add('resolved');

                            const statusCell = this.querySelector('td:nth-child(3)');
                            statusCell.textContent = '읽음';
                        }else {
                            console.error('알림 상태 변경 실패');
                        }
                    })
                    .catch(error => {
                        console.error('네트워크 오류:', error);
                    });
            });
        });
    });
</script>
</body>
</html>

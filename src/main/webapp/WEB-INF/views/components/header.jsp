<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // 실제 구현 시 세션/토큰에서 사용자 정보 불러오기
    String userName = "admin";
    String userRole = "관리자";
    int unreadNotifications = 2; // 미확인 알림 수
%>

<header class="app-header bg-header border-bottom">
    <div class="container-1200 d-flex align-items-center justify-content-between gap-3">

        <!-- 좌: 로고 (파비콘 + 시스템명) -->
        <a href="<c:url value='/index'/>" class="d-flex align-items-center gap-2 text-decoration-none">
            <img src="<c:url value='/favicon-32x32.png'/>" alt="Logo" width="32" height="32"/>
            <div>
                <div class="brand-title">학사정보관리시스템</div>
                <div class="brand-sub">University Management System</div>
            </div>
        </a>

        <!-- 우: 알림 / 로그아웃 / 프로필 -->
        <div class="d-flex align-items-center gap-2">
            <!-- 알림 -->
            <button class="icon-pill" title="알림">
                <i class="bi bi-bell"></i>
                <% if (unreadNotifications > 0) { %>
                <span class="badge-dot"><%= unreadNotifications %></span>
                <% } %>
            </button>

            <!-- 로그아웃 -->
            <a href="#" id="logoutA" onclick="logout()"
               class="btn btn-white rounded-pill h-40 px-3 d-flex align-items-center gap-1">
                <i class="bi bi-box-arrow-right"></i><span>로그아웃</span>
            </a>

            <!-- 사용자 프로필 -->
            <div class="btn btn-white rounded-pill h-40 px-2 d-flex align-items-center gap-2">
                <div class="avatar">U</div>
                <div class="text-start lh-1">
                    <div class="text-navy fw-600 small"><%= userName %></div>
                    <div class="text-gray-500 xsmall"><%= userRole %></div>
                </div>
            </div>
        </div>
    </div>
</header>


<script>
    function logout() {
        localStorage.removeItem("accessToken");
        localStorage.removeItem("refreshToken");

        // 접속기록 남기기 위한 POST 요청
        fetch('/api/auth/logout', {
            method: 'POST'
        })
            .then(response => {
                // 로그아웃 성공 시 로그인 페이지로 이동
                window.location.href = '<c:url value="/auth/login"/>';
            })
            .catch(error => {
                console.error('로그아웃 API 호출 오류: ', error);
                alert("로그아웃 처리중 오류 발생했으나, 로컬 인증 정보 삭제 완료");
                window.location.href = '<c:url value="/auth/login"/>';
            });
    }
</script>

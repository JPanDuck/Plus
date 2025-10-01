<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>학사정보관리시스템 - 대시보드</title>

    <!-- 폰트/부트스트랩 -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>"/>
    <link rel="icon" href="data:,">
</head>
<body class="bg-page">

<%-- 헤더 --%>
<%@ include file="/WEB-INF/views/components/header.jsp" %>

<main class="py-4">
    <div class="container-1200 d-flex gap-24">

        <%-- 사이드바 --%>
        <%@ include file="/WEB-INF/views/components/sidebar.jsp" %>

        <section class="flex-1 d-flex flex-column gap-24">

            <%-- 대시보드 카드 --%>
                <div class="row g-3">
                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card-white p-20 card-filter-item">
                            <div class="text-gray-600 xsmall mb-1">재학생 수</div>
                            <div class="fs-24 fw-700" id="studentCount">1,234명</div>
                            <div class="xsmall text-gray-500 mt-2" id="studentUpdate">업데이트: 2025-10-01 12:00</div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card-white p-20 card-filter-item">
                            <div class="text-gray-600 xsmall mb-1">교수 수</div>
                            <div class="fs-24 fw-700">87명</div>
                            <div class="xsmall text-gray-500 mt-2">업데이트: 2025-10-01 12:00</div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card-white p-20 card-filter-item">
                            <div class="text-gray-600 xsmall mb-1">개설 강좌</div>
                            <div class="fs-24 fw-700">156개</div>
                            <div class="xsmall text-gray-500 mt-2">업데이트: 2025-10-01 12:00</div>
                        </div>
                    </div>

                    <div class="col-12 col-md-6 col-lg-3">
                        <div class="card-white p-20 card-filter-item">
                            <div class="text-gray-600 xsmall mb-1">공지사항</div>
                            <div class="fs-24 fw-700">12건</div>
                            <div class="xsmall text-gray-500 mt-2">업데이트: 2025-10-01 12:00</div>
                        </div>
                    </div>
                </div>


        </section>
    </div>
</main>

<%-- 푸터 --%>
<%@ include file="/WEB-INF/views/components/footer.jsp" %>

<!-- 스크립트 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // ✅ 공통 fetch wrapper
    async function apiFetch(url, options = {}) {
        const token = localStorage.getItem("accessToken");
        if (!token) {
            alert("로그인이 필요합니다.");
            window.location.href = "<c:url value='/auth/login'/>";
            return;
        }
        return fetch(url, {
            ...options,
            headers: {
                ...(options.headers || {}),
                "Content-Type": "application/json",
                "Authorization": `Bearer ${token}`
            }
        });
    }

    // ✅ 로그 모니터링 버튼 동작
    document.getElementById('logMonitorBtn').addEventListener('click', async function () {
        try {
            const res = await apiFetch("<c:url value='/api/admin/logs/monitor'/>", { method: "GET" });
            if (!res.ok) throw new Error(res.status + " " + res.statusText);
            window.location.href = "<c:url value='/auth/log-monitor'/>";
        } catch (err) {
            alert("API 호출 오류: " + err.message);
            if (err.message.includes("403")) {
                window.location.href = "<c:url value='/auth/login'/>";
            }
        }
    });
</script>
</body>
</html>

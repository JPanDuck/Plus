<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>학사일정</title>

  <!-- ✅ Bootstrap -->
  <link rel="stylesheet" href="/static/vendor/bootstrap/css/bootstrap.css"/>

  <!-- ✅ FullCalendar CSS -->
  <link rel="stylesheet" href="/static/vendor/fullcalendar/daygrid/main.min.css"/>

  <!-- ✅ Bootstrap Icons (아이콘 복구용) -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"/>

  <!-- ✅ 공통 스타일 -->
  <link rel="stylesheet" href="/static/css/style.css"/>

  <style>
    /* 이 페이지에서만 컨테이너 폭 1200px */
    .page-calendar { --container: 1200px; }

    /* 달력 위, 세부사항 아래 */
    .cal-wrap{
      display:grid;
      grid-template-columns:1fr;
      gap:16px;
      min-width:0; /* grid 컨텍스트에서 자식 잘림 방지 */
    }

    /* 그리드/카드/캘린더 내부 요소가 잘리지 않도록 */
    .container-1200, .card-white, .fc { min-width:0; overflow:visible; }

    .month-list .item{display:flex;gap:12px;padding:10px 12px;border-bottom:1px solid var(--gray-200)}
    .month-list .date {
      width: 200px;
      color: var(--gray-700);
      font-weight: 700;
      white-space: nowrap;     /* 한 줄로 고정 */
    }

    .fc .fc-toolbar-title {
      text-align: center;
      flex: 1;                  /* 남은 공간 다 차지 */
    }

    .fc .fc-daygrid-event{
      white-space: normal;
      height: fit-content;
      font-weight: 500;
      padding: 2px 4px;
      font-size: 13px;
      margin: 1px;
    }
  </style>
</head>
<body class="bg-page page-calendar">
<jsp:include page="/mapper/header.jsp" />

<main class="py-4">
  <div class="container-1200 d-flex gap-24">
    <jsp:include page="/mapper/sidebar.jsp" />

    <section class="flex-1">
      <div class="card-white p-20">
        <div class="fw-700 fs-5 mb-3">학사일정</div>

        <div class="cal-wrap">
          <div id="calendar"></div>
          <div>
            <div class="fw-700 mb-2" id="monthTitle">이달의 학사일정</div>
            <div id="monthList" class="month-list card-white p-0"></div>
          </div>
        </div>
      </div>
    </section>
  </div>
</main>

<jsp:include page="/mapper/footer.jsp" />

<!-- ✅ jQuery (공통 UI load에 필요) -->
<script src="/static/js/vendor/jquery/jquery-3.7.1.min.js"></script>

<!-- ✅ FullCalendar: 순서 중요 (core → daygrid → locales) -->
<script src="/static/js/vendor/fullcalendar/core/index.global.min.js"></script>
<script src="/static/js/vendor/fullcalendar/daygrid/index.global.min.js"></script>
<script src="/static/js/vendor/fullcalendar/core/locales/ko.global.min.js"></script>
<script>
  // 샘플 이벤트 (추후 API 연동으로 교체)
  const ALL_EVENTS = [
    { title:"제2학기 개강", start:"2025-09-01" },
    { title:"수강신청 정정", start:"2025-09-03", end:"2025-09-05" },
    { title:"수강포기 신청", start:"2025-09-22", end:"2025-09-24" },
    { title:"복수전공 신청", start:"2025-09-24", end:"2025-09-26" },
    { title:"제2학기 1/4 시점", start:"2025-09-26" }
  ];

  let calendar;

  function buildMonthList(currentDate){
    const y = currentDate.getFullYear(), m = currentDate.getMonth();
    const start = new Date(y, m, 1), next = new Date(y, m+1, 1);

    const items = ALL_EVENTS.map(ev=>{
      const s = new Date(ev.start);
      const e = ev.end ? new Date(ev.end) : new Date(ev.start);
      if (e < start || s >= next) return null;
      return { s, e, title: ev.title };
    }).filter(Boolean).sort((a,b)=> a.s - b.s);

    const list = document.getElementById("monthList");
    list.innerHTML = "";
    if(!items.length){
      list.innerHTML = '<div class="p-3 text-gray-500 small">이달의 일정이 없습니다.</div>';
      return;
    }
    const dd = d => String(d.getDate()).padStart(2,'0');
    const mm = d => String(d.getMonth()+1).padStart(2,'0');

    items.forEach(it=>{
      const dateStr = it.s.toDateString()===it.e.toDateString()
              ? `${mm(it.s)}.${dd(it.s)}`
              : `${mm(it.s)}.${dd(it.s)} ~ ${mm(it.e)}.${dd(it.e)}`;
      const row = document.createElement("div");
      row.className = "item";
      row.innerHTML = `<div class="date">${dateStr}</div><div class="title">${it.title}</div>`;
      list.appendChild(row);
    });
  }

  function paintDots(view){
    const monthStart = view.currentStart;
    const nextMonthStart = view.currentEnd;
    document.querySelectorAll("#calendar .fc-daygrid-day").forEach(cell=>{
      cell.classList.remove("has-dot");
      const dateStr = cell.getAttribute("data-date");
      if(!dateStr) return;
      const d = new Date(dateStr);
      if(!(d >= monthStart && d < nextMonthStart)) return;
      const has = ALL_EVENTS.some(ev=>{
        const s = new Date(ev.start);
        const e = ev.end ? new Date(ev.end) : new Date(ev.start);
        return d >= s && d <= e;
      });
      if(has) cell.classList.add("has-dot");
    });
  }

  function bumpSizeSoon() {
    if (!calendar) return;
    requestAnimationFrame(() => {
      calendar.updateSize();
      setTimeout(() => calendar.updateSize(), 0);
    });
  }

  document.addEventListener("DOMContentLoaded", function(){
    const el = document.getElementById("calendar");
    calendar = new FullCalendar.Calendar(el, {
      initialView: "dayGridMonth",
      headerToolbar: { left: "prev,next today", center: "title", right: "" },
      locale: "ko",
      events: ALL_EVENTS,
      height: "auto",
      contentHeight: "auto",
      expandRows: true,
      datesSet(info){
        const d = info.view.currentStart;
        document.getElementById("monthTitle").textContent =
                `${d.getFullYear()}년 ${d.getMonth()+1}월 학사일정`;
        buildMonthList(d);
        paintDots(info.view);
      }
    });
    calendar.render();
    bumpSizeSoon();
  });

  // 이제 JSP include로 처리되므로 jQuery 로드는 불필요함
  window.addEventListener("load", bumpSizeSoon);
  window.addEventListener("resize", () => calendar && calendar.updateSize());
</script>
</body>
</html>

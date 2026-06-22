<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>예약 현황</title>
<style>
:root {
  --ac:    #4F46E5;
  --ac-lt: #EEF2FF;
  --top:   #0F172A;
  --br:    #E2E8F0;
  --t1:    #0F172A;
  --t2:    #475569;
  --t3:    #94A3B8;
  --ok:    #16A34A;
  --ok-lt: #F0FDF4;
  --no:    #DC2626;
  --no-lt: #FEF2F2;
  --warn:  #EA580C;
  --warn-lt:#FFF7ED;
}
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
body {
  font-family: -apple-system, 'Pretendard', 'Inter', 'Malgun Gothic', sans-serif;
  background: #F1F5F9;
  color: var(--t1);
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  font-size: 13px;
  -webkit-font-smoothing: antialiased;
}

/* ── Topbar ── */
.topbar {
  height: 56px;
  background: var(--top);
  display: flex;
  align-items: center;
  padding: 0 20px;
  gap: 16px;
  flex-shrink: 0;
}
.tb-brand {
  display: flex; align-items: center; gap: 9px;
  color: #F1F5F9; font-size: 14px; font-weight: 700;
  letter-spacing: -.02em;
}
.tb-brand-icon {
  width: 30px; height: 30px;
  background: var(--ac); border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  font-size: 15px;
}
.tb-div { width: 1px; height: 22px; background: #1E293B; }
.tb-lbl { font-size: 10px; color: #475569; font-weight: 600; text-transform: uppercase; letter-spacing: .06em; }
.tb-sel {
  background: #1E293B; border: 1px solid #334155; color: #E2E8F0;
  font-size: 13px; font-weight: 500; padding: 5px 10px;
  border-radius: 8px; outline: none; cursor: pointer; min-width: 160px;
}
.tb-sel:hover { border-color: #475569; }
.tb-sel:focus { border-color: var(--ac); }
.tb-spacer { flex: 1; }
.tb-back {
  display: flex; align-items: center; gap: 6px;
  padding: 6px 14px; border: 1px solid #334155; border-radius: 8px;
  background: transparent; color: #CBD5E1; font-size: 13px; cursor: pointer;
  transition: all .15s;
}
.tb-back:hover { background: #1E293B; border-color: #475569; color: #fff; }

/* ── Sub-controls bar ── */
.subbar {
  background: #fff;
  border-bottom: 1px solid var(--br);
  display: flex;
  align-items: center;
  padding: 10px 20px;
  gap: 12px;
  flex-wrap: wrap;
}
.date-nav { display: flex; align-items: center; gap: 6px; }
.nav-btn {
  width: 30px; height: 30px;
  border: 1px solid var(--br); border-radius: 7px;
  background: #fff; cursor: pointer; font-size: 16px; color: var(--t2);
  display: flex; align-items: center; justify-content: center;
  transition: all .15s;
}
.nav-btn:hover { background: var(--ac-lt); border-color: var(--ac); color: var(--ac); }
#date-label {
  font-size: 14px; font-weight: 700; color: var(--t1);
  min-width: 200px; text-align: center;
}
.today-btn {
  padding: 5px 12px; border: 1px solid var(--ac); border-radius: 7px;
  background: var(--ac-lt); color: var(--ac); font-size: 12px; font-weight: 600;
  cursor: pointer; transition: all .15s;
}
.today-btn:hover { background: var(--ac); color: #fff; }
.sub-spacer { flex: 1; }
.view-tabs {
  display: flex; gap: 2px;
  background: #F1F5F9; border-radius: 9px; padding: 3px;
}
.view-btn {
  padding: 5px 14px; border: none; border-radius: 7px;
  background: transparent; color: var(--t2);
  font-size: 13px; font-weight: 500; cursor: pointer; transition: all .15s;
}
.view-btn.active {
  background: #fff; color: var(--ac); font-weight: 700;
  box-shadow: 0 1px 4px rgba(0,0,0,.1);
}

/* ── Legend ── */
.legend {
  display: flex; align-items: center; gap: 16px;
  padding: 8px 20px;
  background: #F8FAFC;
  border-bottom: 1px solid var(--br);
  font-size: 12px; color: var(--t2);
}
.leg-item { display: flex; align-items: center; gap: 6px; }
.leg-dot { width: 12px; height: 12px; border-radius: 3px; }
.leg-dot.avail   { background: var(--ok-lt);   border: 1px solid #86efac; }
.leg-dot.booked  { background: var(--no-lt);   border: 1px solid #fca5a5; }
.leg-dot.nowork  { background: #F1F5F9;         border: 1px solid #CBD5E1; }

/* ── Calendar wrap ── */
.cal-wrap {
  flex: 1;
  overflow: auto;
  padding: 16px 20px 32px;
}

/* ── Resource table ── */
.res-table {
  border-collapse: collapse;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 1px 4px rgba(0,0,0,.06);
  min-width: 600px;
  width: 100%;
}
.res-table th, .res-table td { border: 1px solid #E2E8F0; }

/* Frozen space-name column */
.res-table .space-col {
  width: 190px; min-width: 190px;
  padding: 8px 14px;
  background: #F8FAFC;
  position: sticky; left: 0; z-index: 10;
  border-right: 2px solid #CBD5E1;
}
.res-table th.space-col {
  background: #F1F5F9;
  font-size: 11px; font-weight: 700; color: var(--t3);
  text-transform: uppercase; letter-spacing: .05em;
}

/* Space name in row */
.sp-inner { display: flex; align-items: center; gap: 8px; }
.sp-badge {
  padding: 2px 7px; border-radius: 5px;
  font-size: 10px; font-weight: 700; flex-shrink: 0;
}
.badge-desk    { background: var(--ac-lt); color: var(--ac); }
.badge-meeting { background: #FEF3C7;      color: #D97706; }
.sp-name { font-size: 13px; font-weight: 600; color: var(--t1); }
.sp-sub  { font-size: 11px; color: var(--t3); margin-top: 1px; }

/* Time header cells */
.time-hdr {
  text-align: center; padding: 8px 6px;
  background: #F8FAFC; color: var(--t2);
  font-size: 11px; font-weight: 700;
  white-space: nowrap; min-width: 72px;
}
.time-hdr.is-today { color: var(--ac); background: var(--ac-lt); }
.time-hdr.is-weekend { color: var(--t3); }

/* Data cells */
.slot-cell {
  cursor: pointer; height: 46px;
  text-align: center; vertical-align: middle;
  transition: filter .1s;
  min-width: 72px;
}
.slot-cell:hover { filter: brightness(.94); }
.slot-cell.avail  { background: var(--ok-lt); }
.slot-cell.booked { background: var(--no-lt); }
.slot-cell.nowork { background: #F8F9FC; cursor: default; }
.slot-cell.nowork:hover { filter: none; }

.cell-inner {
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  height: 100%; padding: 2px 4px;
  font-size: 12px; font-weight: 600; gap: 1px;
}
.slot-cell.avail  .cell-inner { color: var(--ok); }
.slot-cell.booked .cell-inner { color: var(--no); }
.slot-cell.nowork .cell-inner { color: #CBD5E1; }
.cell-sub { font-size: 10px; font-weight: 400; }

/* Section separator row */
.sep-row td {
  background: #F1F5F9;
  font-size: 11px; font-weight: 700; color: var(--t2);
  text-transform: uppercase; letter-spacing: .08em;
  padding: 7px 14px;
  border-top: 2px solid #CBD5E1;
}

/* ── Tooltip ── */
.cal-tip {
  position: fixed; z-index: 9999;
  background: #1E293B; color: #fff;
  border-radius: 10px; padding: 11px 15px;
  font-size: 12px; line-height: 1.65;
  pointer-events: none;
  opacity: 0; transition: opacity .12s;
  max-width: 230px;
  box-shadow: 0 8px 24px rgba(0,0,0,.25);
}
.cal-tip.show { opacity: 1; }
.tip-title { font-weight: 700; font-size: 13px; margin-bottom: 4px; color: #F1F5F9; }
.tip-row   { display: flex; align-items: flex-start; gap: 6px; color: #94A3B8; }
.tip-row b { color: #E2E8F0; }
.tip-avail { color: #86EFAC; font-weight: 700; }

/* ── Empty / Loading ── */
.state-msg {
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  min-height: 260px; color: var(--t3); gap: 10px;
}
.state-msg .icon { font-size: 40px; }
.state-msg p { font-size: 14px; }
</style>
</head>
<body>

<!-- Topbar -->
<div class="topbar">
  <div class="tb-brand">
    <div class="tb-brand-icon">🏢</div>
    스마트오피스
  </div>
  <div class="tb-div"></div>
  <div>
    <div class="tb-lbl">사무실</div>
    <select class="tb-sel" id="layout-sel" onchange="onLayoutChange()">
      <option value="">— 선택 —</option>
    </select>
  </div>
  <div class="tb-spacer"></div>
  <button class="tb-back" onclick="goToMap()">← 지도 보기</button>
</div>

<!-- Sub-controls -->
<div class="subbar">
  <div class="date-nav">
    <button class="nav-btn" onclick="movePrev()">&#8249;</button>
    <span id="date-label"></span>
    <button class="nav-btn" onclick="moveNext()">&#8250;</button>
  </div>
  <button class="today-btn" onclick="goToday()">오늘</button>
  <div class="sub-spacer"></div>
  <div class="view-tabs">
    <button class="view-btn active" data-view="hour"  onclick="setView('hour')">시간</button>
    <button class="view-btn"        data-view="day"   onclick="setView('day')">일</button>
    <button class="view-btn"        data-view="week"  onclick="setView('week')">주</button>
    <button class="view-btn"        data-view="month" onclick="setView('month')">월</button>
  </div>
</div>

<!-- Legend -->
<div class="legend">
  <div class="leg-item"><div class="leg-dot avail"></div><span>예약 가능</span></div>
  <div class="leg-item"><div class="leg-dot booked"></div><span>예약됨</span></div>
  <div class="leg-item"><div class="leg-dot nowork"></div><span>비업무</span></div>
  <span style="flex:1"></span>
  <span id="result-count" style="color:#94A3B8;font-size:12px;"></span>
</div>

<!-- Calendar -->
<div class="cal-wrap" id="cal-wrap">
  <div class="state-msg">
    <div class="icon">🏢</div>
    <p>위에서 사무실을 선택하세요</p>
  </div>
</div>

<!-- Tooltip -->
<div class="cal-tip" id="cal-tip"></div>

<script>
var currentView = 'hour';
var currentDate = new Date();
var layoutId    = '';
var spaces      = [];
var bookings    = [];
var tip         = document.getElementById('cal-tip');

/* ═══════════════ Init ═══════════════ */
(function init() {
  var params = new URLSearchParams(location.search);
  layoutId = params.get('layout') || '';
  loadLayouts();
  updateDateLabel();
  if (layoutId) loadAndRender();
})();

function goToMap() {
  location.href = '/itsm/sample/so_book.jsp' + (layoutId ? '?layout=' + layoutId : '');
}

/* ═══════════════ Layouts ═══════════════ */
function loadLayouts() {
  fetch('/itsm/sample/so/list.jsp')
    .then(function(r) { return r.json(); })
    .then(function(arr) {
      var sel = document.getElementById('layout-sel');
      arr.forEach(function(l) {
        var opt = document.createElement('option');
        opt.value = l.layoutId;
        opt.textContent = l.layoutName;
        if (opt.value === layoutId) opt.selected = true;
        sel.appendChild(opt);
      });
    }).catch(function() {});
}

function onLayoutChange() {
  layoutId = document.getElementById('layout-sel').value;
  history.replaceState(null, '', layoutId ? '?layout=' + layoutId : '?');
  if (layoutId) loadAndRender();
}

/* ═══════════════ View switching ═══════════════ */
function setView(v) {
  currentView = v;
  document.querySelectorAll('.view-btn').forEach(function(b) {
    b.classList.toggle('active', b.dataset.view === v);
  });
  updateDateLabel();
  if (layoutId) loadAndRender();
}

/* ═══════════════ Date navigation ═══════════════ */
function movePrev() {
  shiftDate(-1);
  updateDateLabel();
  if (layoutId) loadAndRender();
}
function moveNext() {
  shiftDate(+1);
  updateDateLabel();
  if (layoutId) loadAndRender();
}
function goToday() {
  currentDate = new Date();
  updateDateLabel();
  if (layoutId) loadAndRender();
}

function shiftDate(dir) {
  var d = currentDate;
  if (currentView === 'hour')  d.setDate(d.getDate()   + dir);
  if (currentView === 'day')   d.setDate(d.getDate()   + dir * 7);
  if (currentView === 'week')  d.setMonth(d.getMonth() + dir);
  if (currentView === 'month') d.setFullYear(d.getFullYear() + dir);
}

function updateDateLabel() {
  var lbl = '';
  var d = currentDate;
  if (currentView === 'hour') {
    lbl = fmtDateKo(d);
  } else if (currentView === 'day') {
    var mon = weekStart(d);
    var sun = new Date(mon); sun.setDate(sun.getDate() + 6);
    lbl = fmtDateKo(mon) + ' ~ ' + fmtDateKo(sun);
  } else if (currentView === 'week') {
    lbl = d.getFullYear() + '년 ' + (d.getMonth()+1) + '월';
  } else {
    lbl = d.getFullYear() + '년';
  }
  document.getElementById('date-label').textContent = lbl;
}

/* ═══════════════ Date range for API ═══════════════ */
function getRange() {
  var d = currentDate;
  if (currentView === 'hour') {
    var s = dstr(d);
    return { start: s, end: s };
  }
  if (currentView === 'day') {
    var mon = weekStart(d);
    var sun = new Date(mon); sun.setDate(sun.getDate() + 6);
    return { start: dstr(mon), end: dstr(sun) };
  }
  if (currentView === 'week') {
    var first = new Date(d.getFullYear(), d.getMonth(), 1);
    var last  = new Date(d.getFullYear(), d.getMonth()+1, 0);
    return { start: dstr(first), end: dstr(last) };
  }
  // month = full year
  return { start: d.getFullYear() + '0101', end: d.getFullYear() + '1231' };
}

/* ═══════════════ Load & Render ═══════════════ */
function loadAndRender() {
  var wrap = document.getElementById('cal-wrap');
  wrap.innerHTML = '<div class="state-msg"><div class="icon">⏳</div><p>불러오는 중...</p></div>';
  var rng = getRange();
  var url = '/itsm/sample/so/bookings.jsp?layout_id=' + encodeURIComponent(layoutId) +
            '&start=' + rng.start + '&end=' + rng.end;
  fetch(url)
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (!data.ok) throw new Error(data.error || '오류');
      spaces   = data.spaces   || [];
      bookings = data.bookings || [];
      var cnt = spaces.length;
      document.getElementById('result-count').textContent =
        cnt > 0 ? '책상 ' + spaces.filter(function(s){return s.type==='DESK';}).length + '개 · 회의실 ' + spaces.filter(function(s){return s.type==='MEETING';}).length + '개' : '';
      if (cnt === 0) {
        wrap.innerHTML = '<div class="state-msg"><div class="icon">📋</div><p>저장된 공간 정보가 없습니다</p></div>';
        return;
      }
      render();
    })
    .catch(function(e) {
      wrap.innerHTML = '<div class="state-msg"><div class="icon">⚠️</div><p>' + e.message + '</p></div>';
    });
}

function render() {
  if (currentView === 'hour')  renderHour();
  else if (currentView === 'day')   renderDay();
  else if (currentView === 'week')  renderWeek();
  else                              renderMonth();
}

/* ═══════════════ Hourly view ═══════════════ */
function renderHour() {
  var d = dstr(currentDate);
  var todayStr = dstr(new Date());
  var HOURS = [8,9,10,11,12,13,14,15,16,17,18,19];

  var tbl = makeTable();
  // Header
  var thead = tbl.createTHead();
  var hr = thead.insertRow();
  addTH(hr, '공간', 'space-col');
  HOURS.forEach(function(h) {
    var th = addTH(hr, pad(h)+':00', 'time-hdr' + (d===todayStr ? ' is-today' : ''));
    th.style.minWidth = '72px';
  });

  var tbody = tbl.createTBody();
  var desks    = spaces.filter(function(s){return s.type==='DESK';});
  var meetings = spaces.filter(function(s){return s.type==='MEETING';});

  if (meetings.length) {
    addSepRow(tbody, '회의실 (' + meetings.length + ')', HOURS.length+1);
    meetings.forEach(function(sp) { appendHourRow(tbody, sp, HOURS, d); });
  }
  if (desks.length) {
    addSepRow(tbody, '책상 (' + desks.length + ')', HOURS.length+1);
    desks.forEach(function(sp) { appendHourRow(tbody, sp, HOURS, d); });
  }

  setTable(tbl);
}

function appendHourRow(tbody, sp, HOURS, d) {
  var tr = tbody.insertRow();
  var td0 = tr.insertCell();
  td0.className = 'space-col';
  td0.innerHTML = spaceCell(sp);

  HOURS.forEach(function(h) {
    var slotS = d + pad(h) + '0000';
    var slotE = d + pad(h >= 23 ? 23 : h+1) + '0000';
    var bks = bookingsFor(sp.id, slotS, slotE);

    var td = tr.insertCell();
    if (bks.length > 0) {
      var bk = bks[0];
      td.className = 'slot-cell booked';
      td.innerHTML = '<div class="cell-inner"><span>●</span><span class="cell-sub">' + esc(bk.empName) + '</span></div>';
      td.dataset.tip = JSON.stringify({ type:'booked', space:sp.name, emp:bk.empName, start:bk.start, end:bk.end, note:bk.note });
      td.addEventListener('click', function() { alertBook(bk); });
    } else {
      td.className = 'slot-cell avail';
      td.innerHTML = '<div class="cell-inner"><span>○</span></div>';
      td.dataset.tip = JSON.stringify({ type:'avail', space:sp.name, hour:pad(h)+':00' });
      (function(sid, sdt) {
        td.addEventListener('click', function() { goToBook(sid, sdt); });
      })(sp.id, slotS);
    }
    td.addEventListener('mousemove', onTipMove);
    td.addEventListener('mouseleave', hideTip);
  });
}

/* ═══════════════ Daily view (week) ═══════════════ */
function renderDay() {
  var mon = weekStart(currentDate);
  var todayStr = dstr(new Date());
  var DAY = ['일','월','화','수','목','금','토'];
  var days = [];
  for (var i = 0; i < 7; i++) {
    var dd = new Date(mon); dd.setDate(dd.getDate() + i);
    days.push(dd);
  }

  var tbl = makeTable();
  var thead = tbl.createTHead();
  var hr = thead.insertRow();
  addTH(hr, '공간', 'space-col');
  days.forEach(function(d) {
    var isToday = dstr(d) === todayStr;
    var isWknd  = d.getDay()===0 || d.getDay()===6;
    var cls = 'time-hdr' + (isToday?' is-today':'') + (isWknd?' is-weekend':'');
    var th = addTH(hr, DAY[d.getDay()] + '<br>' + (d.getMonth()+1)+'/'+ d.getDate(), cls);
    th.innerHTML = DAY[d.getDay()] + '<br>' + (d.getMonth()+1)+'.'+d.getDate();
  });

  var tbody = tbl.createTBody();
  var desks    = spaces.filter(function(s){return s.type==='DESK';});
  var meetings = spaces.filter(function(s){return s.type==='MEETING';});

  function appendDayRow(sp) {
    var tr = tbody.insertRow();
    var td0 = tr.insertCell(); td0.className='space-col'; td0.innerHTML=spaceCell(sp);
    days.forEach(function(d) {
      var isWknd = d.getDay()===0 || d.getDay()===6;
      var ds = dstr(d);
      var bks = bookingsFor(sp.id, ds+'000000', ds+'235959');
      var td = tr.insertCell();
      if (isWknd) {
        td.className = 'slot-cell nowork';
        td.innerHTML = '<div class="cell-inner">—</div>';
      } else if (bks.length > 0) {
        td.className = 'slot-cell booked';
        td.innerHTML = '<div class="cell-inner"><span>' + bks.length + '건</span></div>';
        td.dataset.tip = JSON.stringify({ type:'multi', count:bks.length, space:sp.name, date:fmtDateKo(d) });
        (function(clickDate) {
          td.addEventListener('click', function() { drillDown('hour', clickDate); });
        })(d);
        td.addEventListener('mousemove', onTipMove);
        td.addEventListener('mouseleave', hideTip);
      } else {
        td.className = 'slot-cell avail';
        td.innerHTML = '<div class="cell-inner"><span>가능</span></div>';
        td.dataset.tip = JSON.stringify({ type:'avail', space:sp.name, date:fmtDateKo(d) });
        (function(sid, sdt) {
          td.addEventListener('click', function() { goToBook(sid, sdt+'090000'); });
        })(sp.id, ds);
        td.addEventListener('mousemove', onTipMove);
        td.addEventListener('mouseleave', hideTip);
      }
    });
  }

  if (meetings.length) { addSepRow(tbody, '회의실 (' + meetings.length + ')', 8); meetings.forEach(appendDayRow); }
  if (desks.length)    { addSepRow(tbody, '책상 (' + desks.length + ')', 8); desks.forEach(appendDayRow); }
  setTable(tbl);
}

/* ═══════════════ Weekly view (month) ═══════════════ */
function renderWeek() {
  var y = currentDate.getFullYear(), m = currentDate.getMonth();
  var first = new Date(y, m, 1), last = new Date(y, m+1, 0);
  var weeks = [];
  var w = weekStart(first);
  while (w <= last) { weeks.push(new Date(w)); w = new Date(w); w.setDate(w.getDate()+7); }

  var tbl = makeTable();
  var thead = tbl.createTHead();
  var hr = thead.insertRow();
  addTH(hr, '공간', 'space-col');
  weeks.forEach(function(ws) {
    var we = new Date(ws); we.setDate(we.getDate()+6);
    var th = addTH(hr, '', 'time-hdr');
    th.innerHTML = (ws.getMonth()+1)+'/'+ws.getDate() + '<br>~'+(we.getMonth()+1)+'/'+we.getDate();
  });

  var tbody = tbl.createTBody();
  var desks    = spaces.filter(function(s){return s.type==='DESK';});
  var meetings = spaces.filter(function(s){return s.type==='MEETING';});

  function appendWeekRow(sp) {
    var tr = tbody.insertRow();
    var td0 = tr.insertCell(); td0.className='space-col'; td0.innerHTML=spaceCell(sp);
    weeks.forEach(function(ws) {
      var we = new Date(ws); we.setDate(we.getDate()+6);
      var cnt = bookingsFor(sp.id, dstr(ws)+'000000', dstr(we)+'235959').length;
      var td = tr.insertCell();
      td.className = 'slot-cell ' + (cnt > 0 ? 'booked' : 'avail');
      td.innerHTML = '<div class="cell-inner">' + (cnt > 0 ? cnt+'건' : '') + '</div>';
      td.dataset.tip = JSON.stringify({ type: cnt>0?'multi':'avail', count:cnt, space:sp.name,
        date: fmtDateKo(ws)+'~'+fmtDateKo(we) });
      (function(clickWs) {
        td.addEventListener('click', function() { drillDown('day', clickWs); });
      })(ws);
      td.addEventListener('mousemove', onTipMove);
      td.addEventListener('mouseleave', hideTip);
    });
  }

  if (meetings.length) { addSepRow(tbody, '회의실', weeks.length+1); meetings.forEach(appendWeekRow); }
  if (desks.length)    { addSepRow(tbody, '책상',   weeks.length+1); desks.forEach(appendWeekRow); }
  setTable(tbl);
}

/* ═══════════════ Monthly view (year) ═══════════════ */
function renderMonth() {
  var y = currentDate.getFullYear();
  var MN = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  var nowM = (new Date()).getFullYear()===y ? (new Date()).getMonth() : -1;

  var tbl = makeTable();
  var thead = tbl.createTHead();
  var hr = thead.insertRow();
  addTH(hr, '공간', 'space-col');
  MN.forEach(function(mn, i) {
    addTH(hr, mn, 'time-hdr' + (i===nowM?' is-today':''));
  });

  var tbody = tbl.createTBody();
  var desks    = spaces.filter(function(s){return s.type==='DESK';});
  var meetings = spaces.filter(function(s){return s.type==='MEETING';});

  function appendMonthRow(sp) {
    var tr = tbody.insertRow();
    var td0 = tr.insertCell(); td0.className='space-col'; td0.innerHTML=spaceCell(sp);
    for (var m = 0; m < 12; m++) {
      var ms  = y + pad(m+1) + '01000000';
      var mld = new Date(y, m+1, 0).getDate();
      var me  = y + pad(m+1) + pad(mld) + '235959';
      var cnt = bookingsFor(sp.id, ms, me).length;
      var td = tr.insertCell();
      td.className = 'slot-cell ' + (cnt > 0 ? 'booked' : 'avail');
      td.innerHTML = '<div class="cell-inner">' + (cnt > 0 ? cnt+'건' : '') + '</div>';
      td.dataset.tip = JSON.stringify({ type:cnt>0?'multi':'avail', count:cnt, space:sp.name, date:y+'년 '+MN[m] });
      (function(clickY, clickM) {
        td.addEventListener('click', function() {
          currentDate = new Date(clickY, clickM, 1);
          setView('week');
        });
      })(y, m);
      td.addEventListener('mousemove', onTipMove);
      td.addEventListener('mouseleave', hideTip);
    }
  }

  if (meetings.length) { addSepRow(tbody, '회의실', 13); meetings.forEach(appendMonthRow); }
  if (desks.length)    { addSepRow(tbody, '책상',   13); desks.forEach(appendMonthRow); }
  setTable(tbl);
}

/* ═══════════════ Tooltip ═══════════════ */
function onTipMove(e) {
  var data;
  try { data = JSON.parse(this.dataset.tip || '{}'); } catch(x) { return; }
  var html = '';
  if (data.type === 'booked') {
    html = '<div class="tip-title">' + esc(data.space) + '</div>' +
      '<div class="tip-row">👤&nbsp;<b>' + esc(data.emp) + '</b></div>' +
      '<div class="tip-row">⏰&nbsp;' + fmtTime(data.start) + ' ~ ' + fmtTime(data.end) + '</div>' +
      (data.note ? '<div class="tip-row">📝&nbsp;' + esc(data.note) + '</div>' : '');
  } else if (data.type === 'avail') {
    html = '<div class="tip-title">' + esc(data.space) + '</div>' +
      '<div class="tip-avail">✓ 예약 가능</div>' +
      '<div class="tip-row">' + esc(data.date || data.hour || '') + '</div>';
  } else if (data.type === 'multi') {
    html = '<div class="tip-title">' + esc(data.space) + '</div>' +
      '<div class="tip-row">' + esc(data.date) + '</div>' +
      '<div class="tip-row">예약 <b>' + data.count + '건</b> · 클릭하여 상세</div>';
  }
  tip.innerHTML = html;
  tip.classList.add('show');
  tip.style.left = (e.clientX + 16) + 'px';
  tip.style.top  = (e.clientY - 8)  + 'px';
}
function hideTip() { tip.classList.remove('show'); }

/* ═══════════════ Navigation helpers ═══════════════ */
function drillDown(view, date) {
  currentDate = new Date(date);
  setView(view);
}

function goToBook(spaceId, startDttm) {
  location.href = '/itsm/sample/so_book.jsp' + (layoutId ? '?layout=' + layoutId : '');
}

function alertBook(bk) {
  var msg = '예약 정보\n' +
    '예약자: ' + bk.empName + '\n' +
    '시간: ' + fmtTime(bk.start) + ' ~ ' + fmtTime(bk.end) +
    (bk.note ? '\n메모: ' + bk.note : '');
  alert(msg);
}

/* ═══════════════ Utilities ═══════════════ */
function bookingsFor(spaceId, slotS, slotE) {
  return bookings.filter(function(b) {
    return b.spaceId === spaceId && b.start < slotE && b.end > slotS;
  });
}

function spaceCell(sp) {
  return '<div class="sp-inner">' +
    '<span class="sp-badge badge-' + sp.type.toLowerCase() + '">' +
      (sp.type==='DESK' ? '책상' : '회의실') + '</span>' +
    '<div><div class="sp-name">' + esc(sp.name || sp.id) + '</div>' +
    (sp.dept ? '<div class="sp-sub">' + esc(sp.dept) + '</div>' : '') +
    '</div></div>';
}

function makeTable() {
  var t = document.createElement('table');
  t.className = 'res-table';
  return t;
}

function setTable(tbl) {
  var wrap = document.getElementById('cal-wrap');
  wrap.innerHTML = '';
  wrap.appendChild(tbl);
}

function addTH(row, text, cls) {
  var th = document.createElement('th');
  th.className = cls || '';
  th.innerHTML = text;
  row.appendChild(th);
  return th;
}

function addSepRow(tbody, label, cols) {
  var tr = document.createElement('tr');
  tr.className = 'sep-row';
  var td = document.createElement('td');
  td.colSpan = cols;
  td.textContent = label;
  tr.appendChild(td);
  tbody.appendChild(tr);
}

function pad(n) { return String(n).padStart(2,'0'); }

function dstr(d) {
  return d.getFullYear() + pad(d.getMonth()+1) + pad(d.getDate());
}

function fmtDateKo(d) {
  return d.getFullYear() + '. ' + (d.getMonth()+1) + '. ' + d.getDate() + '.';
}

function fmtTime(s) {
  if (!s || s.length < 12) return s || '';
  return s.substr(8,2) + ':' + s.substr(10,2);
}

function weekStart(d) {
  var c = new Date(d);
  var day = c.getDay();
  var diff = day === 0 ? -6 : 1 - day;
  c.setDate(c.getDate() + diff);
  return c;
}

function esc(s) {
  if (!s) return '';
  return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
</script>
</body>
</html>

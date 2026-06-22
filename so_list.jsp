<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>스마트오피스 — 사무실 목록</title>
<style>
:root { --top:#1C1C1E; --bg:#F5F4F0; --border:#E5E4DF; --txt:#1C1C1E; --txt2:#8E8E93; }
*,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
body { font-family:-apple-system,'Pretendard','Apple SD Gothic Neo','Malgun Gothic',sans-serif;
       background:var(--bg); color:var(--txt); min-height:100vh; }
.topbar { height:50px; background:var(--top); display:flex; align-items:center;
          padding:0 24px; gap:16px; }
.tb-title { font-size:13px; font-weight:600; color:#EBEBF0; }
.tb-sub   { font-size:12px; color:#636366; }
.btn-new  { margin-left:auto; padding:6px 14px; background:#3A3A3C; color:#EBEBF0;
            border:none; border-radius:7px; font-size:12px; cursor:pointer; }
.btn-new:hover { background:#48484A; }
.container { max-width:800px; margin:32px auto; padding:0 20px; }
.sec-title { font-size:11px; font-weight:600; color:var(--txt2); text-transform:uppercase;
             letter-spacing:.5px; margin-bottom:12px; }
.card-list  { display:flex; flex-direction:column; gap:10px; }
.card { background:#fff; border:1px solid var(--border); border-radius:10px;
        padding:16px 20px; display:flex; align-items:center; gap:16px;
        cursor:pointer; text-decoration:none; color:inherit; transition:box-shadow .15s; }
.card:hover { box-shadow:0 2px 12px rgba(0,0,0,.08); }
.card-icon { width:40px; height:40px; border-radius:8px; background:#ECEAE4;
             display:flex; align-items:center; justify-content:center;
             font-size:18px; flex-shrink:0; }
.card-body { flex:1; min-width:0; }
.card-name { font-size:14px; font-weight:500; margin-bottom:3px; }
.card-meta { font-size:11px; color:var(--txt2); }
.card-badge { padding:3px 8px; background:#F0EFEB; border-radius:20px;
              font-size:11px; color:var(--txt2); flex-shrink:0; }
.empty { text-align:center; padding:60px 0; color:var(--txt2); font-size:13px; line-height:1.8; }
.loading { text-align:center; padding:40px 0; color:var(--txt2); font-size:13px; }
</style>
</head>
<body>
<div class="topbar">
  <span class="tb-title">Smart Office</span>
  <span class="tb-sub">사무실 현황</span>
  <button class="btn-new" onclick="location.href='/sample/wizard.jsp'">+ 새 평면도</button>
</div>
<div class="container">
  <div class="sec-title">저장된 사무실</div>
  <div class="card-list" id="list">
    <div class="loading">불러오는 중...</div>
  </div>
</div>
<script>
fetch('/sample/so/list.jsp')
  .then(function(r) { return r.json(); })
  .then(function(data) {
    var el = document.getElementById('list');
    if (!data.length) {
      el.innerHTML = '<div class="empty">저장된 사무실이 없습니다.<br>위의 <b>+ 새 평면도</b> 버튼으로 시작하세요.</div>';
      return;
    }
    el.innerHTML = '';
    data.forEach(function(item) {
      if (item.error) {
        el.innerHTML = '<div class="empty" style="color:#FF3B30">오류: ' + item.error + '</div>';
        return;
      }
      var a = document.createElement('a');
      a.className = 'card';
      a.href = '/sample/so_book.jsp?layout=' + encodeURIComponent(item.layoutId);
      a.innerHTML =
        '<div class="card-icon">🏢</div>' +
        '<div class="card-body">' +
          '<div class="card-name">' + esc(item.layoutName) + '</div>' +
          '<div class="card-meta">' + (item.createdAt || '') + '</div>' +
        '</div>' +
        '<div class="card-badge">' + (item.eleCnt || 0) + '개 요소</div>';
      el.appendChild(a);
    });
  })
  .catch(function(e) {
    document.getElementById('list').innerHTML =
      '<div class="empty" style="color:#FF3B30">API 오류: ' + e.message + '</div>';
  });

function esc(s) {
  return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
</script>
</body>
</html>

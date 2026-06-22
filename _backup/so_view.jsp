<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>스마트오피스 — 평면도 보기</title>
<script src="/sample/fabric.min.js"></script>
<style>
:root { --top:#1C1C1E; --bg:#F5F4F0; --border:#E5E4DF; --cbg:#ECEAE4;
        --side:#FAFAF8; --txt:#1C1C1E; --txt2:#8E8E93; --acc:#6C6860; }
*,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
body { font-family:-apple-system,'Pretendard','Apple SD Gothic Neo','Malgun Gothic',sans-serif;
       background:var(--bg); color:var(--txt); height:100vh; display:flex;
       flex-direction:column; overflow:hidden; }

/* topbar */
.topbar { height:50px; background:var(--top); display:flex; align-items:center;
          padding:0 20px; gap:12px; flex-shrink:0; }
.tb-back { width:28px; height:28px; border-radius:6px; border:1px solid #3A3A3C;
           background:transparent; color:#8E8E93; font-size:14px; cursor:pointer;
           display:flex; align-items:center; justify-content:center; }
.tb-back:hover { background:#2C2C2E; }
.tb-title { font-size:13px; font-weight:600; color:#EBEBF0; }
.tb-meta  { font-size:11px; color:#636366; }

/* layout */
.workspace { flex:1; display:flex; overflow:hidden; }
.canvas-wrap { flex:1; background:var(--cbg); position:relative; overflow:hidden; }
canvas { display:block; }

/* right panel */
.panel { width:260px; flex-shrink:0; background:var(--side);
         border-left:1px solid var(--border); display:flex; flex-direction:column; }
.ph { padding:14px 16px 10px; font-size:11px; font-weight:600;
      color:var(--txt2); text-transform:uppercase; letter-spacing:.5px;
      border-bottom:1px solid var(--border); flex-shrink:0; }

/* element list */
.elist { flex:1; overflow-y:auto; padding:8px; }
.eitem { border:1px solid var(--border); border-radius:8px; margin-bottom:6px;
         overflow:hidden; cursor:pointer; transition:border-color .15s; }
.eitem:hover { border-color:#C4B5A5; }
.eitem.on    { border-color:#3A3530; }
.eitem-head  { display:flex; align-items:center; gap:8px; padding:10px 12px; }
.eitem-badge { padding:2px 7px; border-radius:12px; font-size:10px; font-weight:600;
               background:#EDE5D8; color:#6C5E50; }
.eitem-name  { font-size:12px; font-weight:500; flex:1; min-width:0;
               overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
.eitem-detail { display:none; padding:0 12px 10px; border-top:1px solid var(--border); }
.eitem.on .eitem-detail { display:block; }
.ef-row  { display:flex; align-items:center; gap:8px; margin-top:8px; }
.ef-lbl  { font-size:10px; color:var(--txt2); width:60px; flex-shrink:0; }
.ef-val  { font-size:12px; color:var(--txt); }
.empty-msg { text-align:center; padding:40px 0; color:var(--txt2); font-size:12px; line-height:1.8; }
.loading-msg { text-align:center; padding:40px 0; color:var(--txt2); font-size:12px; }

/* hint */
.hint { position:absolute; bottom:16px; left:50%; transform:translateX(-50%);
        background:rgba(28,28,30,.75); color:#EBEBF0; font-size:11px;
        padding:6px 14px; border-radius:20px; pointer-events:none;
        opacity:1; transition:opacity .5s; }
</style>
</head>
<body>
<div class="topbar">
  <button class="tb-back" onclick="history.back()">←</button>
  <span class="tb-title" id="tb-name">불러오는 중...</span>
  <span class="tb-meta" id="tb-meta"></span>
</div>
<div class="workspace">
  <div class="canvas-wrap" id="cwrap">
    <canvas id="carea"></canvas>
    <div class="hint" id="hint">요소를 클릭하면 상세 정보를 볼 수 있습니다</div>
  </div>
  <div class="panel">
    <div class="ph">요소 목록</div>
    <div class="elist" id="elist">
      <div class="loading-msg">불러오는 중...</div>
    </div>
  </div>
</div>

<script>
var layoutId = (function() {
  var m = location.search.match(/[?&]id=([^&]+)/);
  return m ? decodeURIComponent(m[1]) : null;
})();

if (!layoutId) {
  document.getElementById('tb-name').textContent = '오류: id 파라미터 없음';
}

// ── Canvas 초기화 ──
var wrap = document.getElementById('cwrap');
var ca   = document.getElementById('carea');
var cW   = wrap.clientWidth;
var cH   = wrap.clientHeight;
ca.width  = cW;
ca.height = cH;
var cv = new fabric.Canvas('carea', {
  selection: false,
  hoverCursor: 'default',
  moveCursor: 'default'
});
cv.setWidth(cW);
cv.setHeight(cH);

// ── 데이터 로드 ──
var elementMap = {};  // fabricObj._id → dbRow

fetch('/sample/so/get.jsp?id=' + encodeURIComponent(layoutId))
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (!data.ok) throw new Error(data.error || '알 수 없는 오류');

    var layout = data.layout;
    document.getElementById('tb-name').textContent = layout.layoutName;
    document.getElementById('tb-meta').textContent = layout.createdAt;
    document.title = layout.layoutName + ' — Smart Office';

    // Canvas JSON 로드
    cv.loadFromJSON(layout.canvasJson, function() {
      // 모든 오브젝트 잠금
      cv.getObjects().forEach(function(o) {
        o.selectable = false;
        o.evented    = (o._tool === 'furniture');
        o.hoverCursor = (o._tool === 'furniture') ? 'pointer' : 'default';
      });
      cv.renderAll();
    }, function(o, fabricObj) {
      // 오브젝트별 복원 후처리 — 가구에 _id 있으면 map 등록
      if (o && o._id) {
        fabricObj._id   = o._id;
        fabricObj._name = o._name;
        fabricObj._tool = o._tool;
        fabricObj._preset = o._preset;
      }
    });

    // 요소 목록 (DB에서 온 정보)
    var dbElements = data.elements;

    // 목록 렌더링
    var elEl = document.getElementById('elist');
    if (!dbElements.length) {
      elEl.innerHTML = '<div class="empty-msg">저장된 요소가<br>없습니다</div>';
    } else {
      elEl.innerHTML = '';
      dbElements.forEach(function(el) {
        var div = document.createElement('div');
        div.className = 'eitem';
        div.dataset.id    = el.id;
        div.dataset.fabric = el.fabricId || '';   // canvas _id 매핑용
        div.innerHTML =
          '<div class="eitem-head">' +
            '<span class="eitem-badge">' + esc(typeLabel(el.type)) + '</span>' +
            '<span class="eitem-name">' + esc(el.name || '이름 없음') + '</span>' +
          '</div>' +
          '<div class="eitem-detail">' +
            '<div class="ef-row"><div class="ef-lbl">이름</div><div class="ef-val">' + esc(el.name || '-') + '</div></div>' +
            '<div class="ef-row"><div class="ef-lbl">유형</div><div class="ef-val">' + esc(typeLabel(el.type)) + '</div></div>' +
            '<div class="ef-row"><div class="ef-lbl">수용인원</div><div class="ef-val">' + (el.capacity || 0) + '명</div></div>' +
            '<div class="ef-row"><div class="ef-lbl">부서</div><div class="ef-val">' + esc(el.dept || '-') + '</div></div>' +
          '</div>';

        div.addEventListener('click', function() {
          selectItem(div, el.fabricId || '');
        });
        elEl.appendChild(div);
      });
    }

    // 힌트 자동 숨김
    setTimeout(function() {
      var h = document.getElementById('hint');
      if (h) h.style.opacity = '0';
    }, 3000);
  })
  .catch(function(e) {
    document.getElementById('tb-name').textContent = '오류';
    document.getElementById('elist').innerHTML =
      '<div class="empty-msg" style="color:#FF3B30">' + esc(e.message) + '</div>';
  });

// ── Canvas 클릭: 가구 요소 선택 ──
cv.on('mouse:down', function(e) {
  var obj = e.target;
  if (!obj || obj._tool !== 'furniture') {
    clearSelection();
    return;
  }
  var fabricId = obj._id;
  if (!fabricId) { clearSelection(); return; }
  // data-fabric 속성으로 목록 항목 찾기
  var div = document.querySelector('.eitem[data-fabric="' + fabricId.replace(/"/g, '') + '"]');
  selectItem(div, fabricId);
});

var selectedObj = null;

function selectItem(div, eleId) {
  // 기존 하이라이트 제거
  clearHighlight();
  document.querySelectorAll('.eitem').forEach(function(d) { d.classList.remove('on'); });

  if (!div) return;
  div.classList.add('on');
  div.scrollIntoView({ behavior:'smooth', block:'nearest' });

  // 캔버스에서 해당 fabric _id를 가진 오브젝트 찾아 하이라이트
  cv.getObjects().forEach(function(o) {
    if (o._tool === 'furniture' && o._id === eleId) {
      highlightObj(o);
      selectedObj = o;
    }
  });
  if (!selectedObj) cv.renderAll();
}

function highlightObj(obj) {
  clearHighlight();
  var pad = 10;
  var sw = obj.getScaledWidth(), sh = obj.getScaledHeight();
  var hl = new fabric.Rect({
    left: obj.left, top: obj.top,
    width: sw + pad * 2, height: sh + pad * 2,
    originX: 'center', originY: 'center',
    angle: obj.angle || 0,
    fill: 'rgba(108,104,96,0.08)',
    stroke: '#6C6860', strokeWidth: 2,
    strokeDashArray: [6, 4],
    selectable: false, evented: false, _hl: true
  });
  cv.add(hl);
  cv.renderAll();
}

function clearHighlight() {
  cv.getObjects().filter(function(o) { return o._hl; }).forEach(function(o) { cv.remove(o); });
  cv.renderAll();
}

function clearSelection() {
  document.querySelectorAll('.eitem').forEach(function(d) { d.classList.remove('on'); });
  clearHighlight();
  selectedObj = null;
}

// ── 유형 레이블 ──
function typeLabel(t) {
  var map = {
    desk1: '1인 책상', desk2: '2인 책상',
    meet4: '4인 테이블', meet6: '6인 테이블',
    partition: '파티션', sofa: '소파'
  };
  return map[t] || t || '요소';
}

function esc(s) {
  return String(s || '').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

window.addEventListener('resize', function() {
  cv.setWidth(wrap.clientWidth);
  cv.setHeight(wrap.clientHeight);
  cv.renderAll();
});
</script>
</body>
</html>

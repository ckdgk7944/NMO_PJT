<%@ page contentType="text/html; charset=utf-8" %>
<%@ include file="/xefc/jsp/common/import.jspf" %>
<%@ include file="/xefc/jsp/include/session.jspf" %>
<%
    GlobalConfig gcfg = GlobalConfig.getInstance();
    String colorConfigStr = gcfg.getValue("colortheme.config");
    JSONObject colorConfigObj = (JSONObject) JSONValue.parse(colorConfigStr);

    String primaryMain  = "#4E89AE";
    String primaryDark  = "#30475E";
    String primaryLight = "#dfe7eb";

    if (colorConfigObj != null) {
        if (colorConfigObj.containsKey("primaryMain"))  primaryMain  = colorConfigObj.getString("primaryMain");
        if (colorConfigObj.containsKey("primaryDark"))  primaryDark  = colorConfigObj.getString("primaryDark");
        if (colorConfigObj.containsKey("primaryLight")) primaryLight = colorConfigObj.getString("primaryLight");
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>Smart Office — 평면도 구성</title>
<script src="/sample/fabric.min.js"></script>
<style>
:root {
  --bg:        #F5F4F0;
  --top:       <%= primaryDark %>;
  --side:      #FAFAF8;
  --border:    #E5E4DF;
  --cbg:       #ECEAE4;
  --txt:       #1C1C1E;
  --txt2:      #8E8E93;
  --th:        #F0EFEB;
  --acc:       <%= primaryMain %>;
  --primaryMain:  <%= primaryMain %>;
  --primaryDark:  <%= primaryDark %>;
  --primaryLight: <%= primaryLight %>;
}
*,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
body {
  font-family: -apple-system, 'Pretendard', 'Apple SD Gothic Neo', 'Malgun Gothic', sans-serif;
  background: var(--bg);
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  color: var(--txt);
  -webkit-font-smoothing: antialiased;
}

/* ── Top bar ── */
.topbar {
  height: 50px;
  background: var(--top);
  display: flex;
  align-items: center;
  padding: 0 20px;
  flex-shrink: 0;
  user-select: none;
}
.tb-brand {
  font-size: 12px;
  font-weight: 600;
  color: #EBEBF0;
  letter-spacing: -.2px;
  width: 160px;
  flex-shrink: 0;
}
.tb-brand em { color: #48484A; font-style: normal; font-weight: 400; }

/* Steps */
.steps {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
}
.step {
  display: flex;
  align-items: center;
  gap: 8px;
}
.step-dot {
  width: 22px; height: 22px;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 10px; font-weight: 700;
  flex-shrink: 0;
}
.step.active  .step-dot { background: #fff; color: var(--primaryDark); }
.step.done    .step-dot { background: #30D158; color: #fff; }
.step.pending .step-dot { background: rgba(255,255,255,0.2); color: rgba(255,255,255,0.5); }
.step-name { font-size: 11px; white-space: nowrap; }
.step.active  .step-name { color: #EBEBF0; font-weight: 500; }
.step.done    .step-name { color: rgba(255,255,255,0.5); }
.step.pending .step-name { color: rgba(255,255,255,0.3); }
.step-line {
  width: 32px; height: 1px;
  background: #2C2C2E;
  flex-shrink: 0;
  margin: 0 10px;
}

.tb-right {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 8px;
}
.btn-ghost-dark {
  padding: 5px 12px;
  border: 1px solid #3A3A3C;
  border-radius: 6px;
  background: transparent;
  color: #8E8E93;
  font-size: 11px;
  cursor: pointer;
  font-family: inherit;
  transition: all .15s;
}
.btn-ghost-dark:hover { border-color: #636366; color: #EBEBF0; }

/* ── Main layout ── */
.main { flex: 1; display: flex; overflow: visible; }

/* ── Left sidebar ── */
.sidebar {
  width: 72px;
  background: var(--side);
  border-right: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 10px 0 14px;
  gap: 2px;
  flex-shrink: 0;
  overflow: visible;
}
.tool {
  width: 56px; height: 56px;
  border-radius: 10px;
  border: none;
  background: transparent;
  cursor: pointer;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 3px;
  color: var(--txt2);
  transition: all .1s;
  font-family: inherit;
}
.tool:hover { background: var(--th); color: var(--txt); }
.tool.on { background: var(--acc); color: #FAFAF8; }
.tool svg { flex-shrink: 0; display: block; }
.tool span { display: none; }
.tsep {
  width: 32px; height: 1px;
  background: var(--border);
  margin: 5px 0;
  flex-shrink: 0;
}
/* Hover flyout groups */
.tg { position: relative; width: 100%; display: flex; justify-content: center; }
/* tg-hdr styled like .tool — also carries id for setTool highlight */
.tg-hdr {
  width: 56px; height: 56px;
  border-radius: 10px;
  border: none; background: transparent;
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  color: var(--txt2);
  transition: all .1s;
  font-family: inherit;
  position: relative;
}
.tg-hdr:hover, .tg:hover .tg-hdr { background: var(--th); color: var(--txt); }
.tg-hdr.on { background: var(--acc); color: #FAFAF8; }
/* When a sub-tool in the flyout is active, tint the group header */
.tg:has(.tool.on) .tg-hdr:not(.on) { background: rgba(79,70,229,.1); color: var(--acc); }
/* Dot indicator: shows this button has a flyout */
.tg-hdr::after {
  content: ''; position: absolute;
  right: 8px; bottom: 8px;
  width: 3px; height: 3px; border-radius: 50%;
  background: currentColor; opacity: 0.35;
}
.tg-hdr.on::after { opacity: 0.7; }
.tg-body {
  position: absolute;
  left: 100%;   /* flush against tg right edge — no gap so :hover stays active */
  top: 50%; transform: translateY(-50%);
  flex-direction: row;
  background: var(--panel);
  border: 1px solid var(--border);
  border-radius: 12px;
  padding: 6px;
  gap: 4px;
  display: flex;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.12s ease;
  box-shadow: 4px 4px 20px rgba(0,0,0,0.13);
  z-index: 200;
  white-space: nowrap;
}
.tg:hover .tg-body { opacity: 1; pointer-events: auto; }

/* ── Canvas area ── */
.carea {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--cbg);
  overflow: hidden;
  position: relative;
}
#cwrap {
  position: relative;
  box-shadow: 0 2px 24px rgba(0,0,0,.13);
  line-height: 0;
}
#cwrap canvas { display: block; }

/* Snap / draw hint */
#hint {
  position: absolute;
  top: 10px; left: 50%;
  transform: translateX(-50%);
  background: rgba(28,28,30,.82);
  color: #EBEBF0;
  font-size: 10px;
  padding: 4px 13px;
  border-radius: 20px;
  pointer-events: none;
  opacity: 0;
  transition: opacity .2s;
  white-space: nowrap;
}
#hint.show { opacity: 1; }

/* Snap crosshair drawn on canvas via JS */

/* ── Right panel ── */
.panel {
  width: 216px;
  background: var(--side);
  border-left: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  flex-shrink: 0;
  overflow: hidden;
}
.ph {
  padding: 11px 15px 9px;
  font-size: 9px;
  font-weight: 700;
  color: var(--txt2);
  text-transform: uppercase;
  letter-spacing: .9px;
  border-bottom: 1px solid var(--border);
  flex-shrink: 0;
}
.pb { flex: 1; padding: 14px 15px; overflow-y: auto; }
.pempty {
  color: var(--txt2);
  font-size: 11px;
  line-height: 1.9;
  margin-top: 28px;
  text-align: center;
}
.pobj { display: none; }
.prow { margin-bottom: 13px; }
.plbl {
  font-size: 9px;
  color: var(--txt2);
  text-transform: uppercase;
  letter-spacing: .5px;
  margin-bottom: 4px;
}
.pval { font-size: 13px; font-weight: 500; }
.ptag {
  display: inline-flex;
  align-items: center;
  padding: 3px 9px;
  background: var(--th);
  border-radius: 5px;
  font-size: 11px;
  font-weight: 500;
}
.bdel {
  width: 100%;
  padding: 7px;
  border-radius: 6px;
  border: 1px solid #FFD0D0;
  background: transparent;
  color: #C0392B;
  font-size: 11px;
  cursor: pointer;
  font-family: inherit;
  margin-top: 8px;
  transition: background .15s;
}
.bdel:hover { background: #FFF2F0; }

/* Angle input */
.angle-wrap {
  display: flex;
  align-items: center;
  gap: 6px;
}
.angle-input {
  width: 60px;
  padding: 4px 8px;
  border: 1px solid var(--border);
  border-radius: 5px;
  font-size: 12px;
  font-family: inherit;
  background: white;
  color: var(--txt);
  outline: none;
}
.angle-input:focus { border-color: var(--acc); }
.angle-unit { font-size: 11px; color: var(--txt2); }

/* ── BG image section ── */
.bgsec {
  border-top: 1px solid var(--border);
  padding: 13px 15px;
  flex-shrink: 0;
}
.bgtitle {
  font-size: 9px;
  font-weight: 700;
  color: var(--txt2);
  text-transform: uppercase;
  letter-spacing: .8px;
  margin-bottom: 9px;
}
.bupload {
  width: 100%;
  padding: 8px;
  border: 1.5px dashed var(--border);
  border-radius: 7px;
  background: transparent;
  color: var(--txt2);
  font-size: 11px;
  cursor: pointer;
  font-family: inherit;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  transition: all .15s;
}
.bupload:hover { border-color: var(--acc); color: var(--txt); }
/* bgctrl visibility is controlled by inline style */
.slrow {
  display: flex;
  align-items: center;
  gap: 7px;
  margin-top: 9px;
}
.sllbl { font-size: 10px; color: var(--txt2); white-space: nowrap; }
.slider {
  flex: 1;
  appearance: none;
  height: 3px;
  border-radius: 2px;
  background: var(--border);
  outline: none;
  cursor: pointer;
}
.slider::-webkit-slider-thumb {
  appearance: none;
  width: 13px; height: 13px;
  border-radius: 50%;
  background: var(--txt);
  cursor: pointer;
  border: 2px solid white;
  box-shadow: 0 0 0 1px var(--border);
}
.slval { font-size: 10px; color: var(--txt2); width: 26px; text-align: right; }
.bgbtns { display: flex; gap: 5px; margin-top: 8px; }
.bsm {
  flex: 1;
  padding: 5px 0;
  border-radius: 5px;
  border: 1px solid var(--border);
  background: transparent;
  font-size: 10px;
  color: var(--txt2);
  cursor: pointer;
  font-family: inherit;
  transition: all .15s;
}
.bsm:hover { background: var(--th); color: var(--txt); }
.bsm.red:hover { background: #FFF2F0; border-color: #FFCDD2; color: #C0392B; }

/* ── Setup Wizard ── */
.setup-wz { border-bottom: 1px solid var(--border); padding: 10px 12px 12px; flex-shrink: 0; order: -1; }
.cv-eyedropper, .cv-eyedropper * { cursor: none !important; }
#ex-loupe { position:fixed; pointer-events:none; z-index:9999; border-radius:50%;
  border:2px solid #5B21B6; box-shadow:0 3px 16px rgba(0,0,0,.45); overflow:hidden;
  width:120px; height:120px; display:none; transform:translate(-50%,-50%); }
.wz-step { border: 1px solid var(--border); border-radius: 7px; margin-bottom: 6px; overflow: hidden; }
.wz-head { display: flex; align-items: center; gap: 8px; padding: 8px 10px; cursor: default; user-select: none; }
.wz-head.wz-past { cursor: pointer; }
.wz-head.wz-past:hover { background: var(--th); }
.wz-head.wz-future { opacity: .4; }
.wz-num { width: 19px; height: 19px; border-radius: 50%; background: var(--border); color: var(--txt2); font-size: 9px; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
.wz-num.act { background: #7C3AED; color: #fff; }
.wz-num.done { background: #22c55e; color: #fff; font-size: 12px; }
.wz-title { flex: 1; font-size: 11px; font-weight: 600; color: var(--txt); }
.wz-badge { font-size: 9px; color: var(--txt2); }
.wz-badge.ok { color: #16a34a; font-weight: 600; }
.wz-body { padding: 8px 10px 10px; border-top: 1px solid var(--border); display: flex; flex-direction: column; gap: 7px; }
.wz-next { width: 100%; padding: 7px 0; border-radius: 6px; border: none; background: #7C3AED; color: #fff; font-size: 11px; font-weight: 600; cursor: pointer; font-family: inherit; transition: opacity .15s; }
.wz-next:disabled { opacity: .3; cursor: not-allowed; }
.wz-skip { width: 100%; padding: 5px 0; border-radius: 5px; border: 1px solid var(--border); background: transparent; color: var(--txt2); font-size: 10px; cursor: pointer; font-family: inherit; }
.wz-skip:hover { background: var(--th); color: var(--txt); }
.wz-done-card { background: rgba(34,197,94,.07); border-radius: 7px; padding: 9px 11px; border: 1px solid rgba(34,197,94,.25); margin-bottom: 8px; }
.wz-done-card .wz-dtitle { font-size: 11px; font-weight: 700; color: #15803d; margin-bottom: 3px; }
.wz-done-card .wz-dsub { font-size: 10px; color: var(--txt2); margin-bottom: 7px; }
.wz-reset-btn { width: 100%; padding: 5px 0; border-radius: 5px; border: 1px solid var(--border); background: transparent; color: var(--txt2); font-size: 10px; cursor: pointer; font-family: inherit; }
.wz-reset-btn:hover { background: var(--th); }

/* ── Bottom bar ── */
.bottombar {
  height: 46px;
  background: var(--side);
  border-top: 1px solid var(--border);
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  flex-shrink: 0;
}
.bbinfo {
  font-size: 11px;
  color: var(--txt2);
  display: flex;
  align-items: center;
  gap: 10px;
}
kbd {
  padding: 2px 5px;
  border: 1px solid var(--border);
  border-radius: 3px;
  font-size: 10px;
  font-family: inherit;
  background: var(--bg);
  color: var(--txt2);
}
.bbnext {
  padding: 8px 20px;
  border-radius: 7px;
  border: none;
  background: var(--acc);
  color: #FAFAF8;
  font-size: 12px;
  font-weight: 500;
  cursor: pointer;
  font-family: inherit;
  display: flex;
  align-items: center;
  gap: 7px;
  transition: background .15s;
}
.bbnext:hover { background: var(--primaryDark); }

/* ── Step 2 sidebar (wider + row layout) ── */
.sidebar.s2 { width: 164px; }

/* section draw active state */
.sidebar.s2 .tool.drawing { background: rgba(79,70,229,.12); color: #4F46E5; }

/* Panel: furniture W/H row */
.wh-row { display: flex; gap: 6px; margin-top: 3px; }
.wh-item { display: flex; flex-direction: column; flex: 1; }
.wh-lbl  { font-size: 9px; color: var(--txt2); margin-bottom: 3px; text-transform: uppercase; letter-spacing: .4px; }
.wh-wrap { display: flex; align-items: center; gap: 3px; }
.wh-inp  {
  flex: 1; min-width: 0; padding: 4px 6px;
  border: 1px solid var(--border); border-radius: 5px;
  font-size: 12px; font-family: inherit;
  background: white; color: var(--txt); outline: none; text-align: center;
}
.wh-inp:focus { border-color: var(--acc); }
.wh-unit { font-size: 10px; color: var(--txt2); flex-shrink: 0; }

/* Panel: section name/type rows */
.sec-inp {
  width: 100%; padding: 5px 8px; margin-top: 3px;
  border: 1px solid var(--border); border-radius: 5px;
  font-size: 12px; font-family: inherit;
  background: white; color: var(--txt); outline: none;
}
.sec-inp:focus { border-color: var(--acc); }
.sec-sel {
  width: 100%; padding: 5px 8px; margin-top: 3px;
  border: 1px solid var(--border); border-radius: 5px;
  font-size: 12px; font-family: inherit;
  background: white; color: var(--txt); outline: none; cursor: pointer;
}
.s2-wrap { display:flex; flex-direction:column; align-items:flex-start; width:100%; gap:2px; }
.preset-cat {
  font-size: 9px; font-weight: 700;
  color: var(--txt2); text-transform: uppercase; letter-spacing: .7px;
  padding: 9px 10px 3px; width: 100%;
}
.sidebar.s2 .tool {
  width: 100%; height: 38px; border-radius: 7px;
  flex-direction: row; gap: 8px;
  padding: 0 10px; justify-content: flex-start;
}
.sidebar.s2 .tool span { display: block; font-size: 11px; white-space: nowrap; letter-spacing: 0; }
.tsep-full { width: 100%; height: 1px; background: var(--border); margin: 5px 0; }

/* ── Step 2 object grid ── */
.s2-scroll { overflow-y:auto; width:100%; padding:4px 6px 60px; flex:1 1 0; min-height:0; }
.s2-cat-hdr {
  font-size:9px; font-weight:700; color:var(--txt2);
  text-transform:uppercase; letter-spacing:.7px;
  padding:10px 4px 4px;
}
.s2-grid {
  display:grid; grid-template-columns:repeat(2,1fr); gap:4px; margin-bottom:4px;
}
.s2-grid-1 { display:grid; grid-template-columns:1fr; gap:4px; margin-bottom:4px; }
.s2-btn {
  display:flex; flex-direction:column; align-items:center; justify-content:center;
  gap:3px; padding:7px 4px 6px;
  background:var(--bg2); border:1px solid var(--border);
  border-radius:7px; cursor:pointer; font-size:10px; color:var(--txt);
  line-height:1.2; text-align:center;
  transition:background .12s, border-color .12s;
}
.s2-btn:hover { background:var(--bg3); border-color:var(--acc); }
.s2-btn.on   { background:var(--acc-bg); border-color:var(--acc); color:var(--acc); }
.s2-btn svg  { color:var(--txt2); }
.s2-btn:hover svg, .s2-btn.on svg { color:var(--acc); }
.s2-full-btn {
  display:flex; align-items:center; gap:8px;
  width:100%; padding:0 10px; height:36px;
  background:var(--bg2); border:1px solid var(--border);
  border-radius:7px; cursor:pointer; font-size:11px; color:var(--txt);
  transition:background .12s, border-color .12s;
}
.s2-full-btn:hover { background:var(--bg3); border-color:var(--acc); }
.s2-bottom-bar {
  position:sticky; bottom:0; padding:8px 6px;
  background:var(--bg); border-top:1px solid var(--border);
}
.s2-del-btn {
  width:100%; height:32px; border-radius:7px;
  background:var(--bg2); border:1px solid var(--border);
  display:flex; align-items:center; justify-content:center;
  gap:6px; font-size:11px; color:var(--txt2); cursor:pointer;
  transition:background .12s, color .12s;
}
.s2-del-btn:hover { background:#fee; border-color:#f99; color:#c44; }

/* ── Step 3 element list ── */
.elist { flex: 1; overflow-y: auto; }
.elist-empty { padding: 32px 15px; text-align: center; font-size: 11px; color: var(--txt2); line-height: 1.8; }
.eitem {
  padding: 10px 15px 8px;
  border-bottom: 1px solid var(--border);
  cursor: pointer; transition: background .1s;
}
.eitem:hover { background: var(--th); }
.eitem.on { background: var(--th); }
.eitem-child { padding-left: 28px; }
.eitem-child-arrow { color:var(--txt2); font-size:10px; flex-shrink:0; }
.eitem-orphan-hdr { padding:6px 15px 2px; font-size:10px; font-weight:600; color:var(--txt2); text-transform:uppercase; letter-spacing:.3px; border-top:1px solid var(--border); margin-top:4px; }
.eitem-head { display: flex; align-items: center; gap: 7px; }
.eitem-badge {
  padding: 2px 7px; border-radius: 4px;
  font-size: 9px; font-weight: 700;
  background: #E8E5DF; color: #5C5852; flex-shrink: 0;
}
.eitem-id { font-size: 10px; color: var(--txt2); }
.eitem-form { display: none; padding-top: 9px; }
.eitem.on .eitem-form { display: block; }
.ef-row { margin-bottom: 8px; }
.ef-lbl { font-size: 9px; color: var(--txt2); text-transform: uppercase; letter-spacing: .4px; margin-bottom: 3px; }
.ef-inp {
  width: 100%; padding: 5px 8px;
  border: 1px solid var(--border); border-radius: 5px;
  font-size: 12px; font-family: inherit;
  background: white; color: var(--txt); outline: none;
}
.ef-inp:focus { border-color: var(--acc); }

/* ── Back button ── */
.bb-prev {
  padding: 7px 14px; border-radius: 7px;
  border: 1px solid var(--border); background: transparent;
  color: var(--txt2); font-size: 12px; cursor: pointer;
  font-family: inherit; display: none; align-items: center; gap: 6px;
  transition: all .15s;
}
.bb-prev:hover { background: var(--th); color: var(--txt); }

/* ── Custom Template Modal ── */
.cust-modal-overlay {
  position:fixed; inset:0; background:rgba(0,0,0,.45); z-index:8000;
  display:flex; align-items:center; justify-content:center;
}
.cust-modal {
  background:var(--bg); border:1px solid var(--border); border-radius:12px;
  width:340px; max-height:90vh; overflow-y:auto; padding:20px;
  box-shadow:0 8px 32px rgba(0,0,0,.18);
}
.cust-modal h3 { margin:0 0 14px; font-size:13px; font-weight:700; color:var(--txt); }
.cust-field-row { margin-bottom:10px; }
.cust-field-row label { display:block; font-size:10px; color:var(--txt2); margin-bottom:3px; font-weight:600; }
.cust-field-row input, .cust-field-row select {
  width:100%; padding:5px 8px; border:1px solid var(--border);
  border-radius:6px; background:var(--bg2); color:var(--txt); font-size:11px;
  box-sizing:border-box;
}
.cust-fd-list { margin-bottom:10px; }
.cust-fd-item {
  display:flex; gap:5px; align-items:center; margin-bottom:5px;
}
.cust-fd-item input, .cust-fd-item select {
  flex:1; padding:4px 6px; border:1px solid var(--border);
  border-radius:5px; background:var(--bg2); color:var(--txt); font-size:10px;
}
.cust-fd-del {
  width:20px; height:20px; border:none; background:none;
  color:var(--txt2); cursor:pointer; font-size:14px; border-radius:4px;
  display:flex; align-items:center; justify-content:center; flex-shrink:0;
}
.cust-fd-del:hover { background:#fee; color:#c44; }
.cust-fd-add {
  font-size:10px; color:var(--acc); background:none; border:1px dashed var(--acc);
  border-radius:5px; padding:4px 8px; cursor:pointer; width:100%;
}
.cust-fd-add:hover { background:var(--acc-bg); }
.cust-modal-btns { display:flex; gap:8px; margin-top:16px; }
.cust-modal-btns button {
  flex:1; height:34px; border-radius:7px; font-size:11px; cursor:pointer;
  border:1px solid var(--border); background:var(--bg2); color:var(--txt);
}
.cust-modal-btns .cust-save {
  background:var(--acc); border-color:var(--acc); color:#fff; font-weight:600;
}
.cust-modal-btns .cust-save:hover { opacity:.88; }
.s2-cust-btn {
  display:flex; align-items:center; justify-content:space-between;
  width:100%; padding:0 8px 0 10px; height:36px;
  background:var(--bg2); border:1px solid var(--border);
  border-radius:7px; cursor:pointer; font-size:11px; color:var(--txt);
  transition:background .12s, border-color .12s; box-sizing:border-box;
}
.s2-cust-btn:hover { background:var(--bg3); border-color:var(--acc); }
.s2-cust-btn .cust-x {
  font-size:13px; color:var(--txt2); padding:0 2px; line-height:1;
  background:none; border:none; cursor:pointer; flex-shrink:0;
}
.s2-cust-btn .cust-x:hover { color:#c44; }
.s2-cust-add {
  display:flex; align-items:center; justify-content:center; gap:6px;
  width:100%; height:32px; margin-top:4px;
  background:none; border:1px dashed var(--border);
  border-radius:7px; cursor:pointer; font-size:10px; color:var(--txt2);
  transition:border-color .12s, color .12s;
}
.s2-cust-add:hover { border-color:var(--acc); color:var(--acc); }

/* Toast */
#toast {
  position: fixed;
  bottom: 60px; left: 50%;
  transform: translateX(-50%);
  background: rgba(28,28,30,.88);
  color: #EBEBF0;
  padding: 7px 18px;
  border-radius: 20px;
  font-size: 11px;
  z-index: 9999;
  opacity: 0;
  transition: opacity .22s;
  pointer-events: none;
}

/* ── Undo/Redo buttons ── */
.btn-icon-dark {
  width: 28px; height: 28px;
  border: 1px solid #3A3A3C;
  border-radius: 6px;
  background: transparent;
  color: #8E8E93;
  cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: all .15s;
  flex-shrink: 0;
}
.btn-icon-dark:hover:not(:disabled) { border-color: #636366; color: #EBEBF0; }
.btn-icon-dark:disabled { opacity: .3; cursor: default; }

/* ── Step dots clickable ── */
.step { cursor: pointer; }
.step.pending { cursor: default; }

/* ── Sidebar Step1 ── */
.sidebar { width: 72px; }

/* ── Object list panel ── */
.objlist-wrap {
  border-top: 1px solid var(--border);
  flex-shrink: 0;
  display: flex;
  flex-direction: column;
  max-height: 220px;
  min-height: 0;
}
.objlist-hd {
  padding: 8px 15px 7px;
  font-size: 9px; font-weight: 700;
  color: var(--txt2); text-transform: uppercase; letter-spacing: .9px;
  display: flex; align-items: center; justify-content: space-between;
  cursor: pointer; user-select: none; flex-shrink: 0;
}
.objlist-hd:hover { color: var(--txt); }
.objlist-body {
  flex: 1; overflow-y: auto;
}
.ol-item {
  display: flex; align-items: center;
  padding: 5px 15px 5px 12px;
  gap: 7px;
  cursor: pointer;
  transition: background .1s;
  border-bottom: 1px solid var(--border);
}
.ol-item:last-child { border-bottom: none; }
.ol-item:hover { background: var(--th); }
.ol-item.on { background: rgba(79,70,229,.08); }
.ol-dot {
  width: 8px; height: 8px; border-radius: 50%;
  flex-shrink: 0; background: #C4B5A5;
}
.ol-dot.wall    { background: #3A3530; border-radius: 2px; width:12px; height:4px; }
.ol-dot.door    { background: #8E8E93; }
.ol-dot.window  { background: #7BA7BC; border-radius: 1px; width:12px; height:4px; }
.ol-dot.column  { background: #3A3530; border-radius: 2px; }
.ol-dot.desk    { background: #C4B5A5; border-radius: 2px; }
.ol-dot.section { background: #AAAAAA; border-radius: 2px; width:10px; height:10px; }
.ol-dot.meeting { background: #4F46E5; border-radius: 2px; width:10px; height:10px; }
.ol-dot.group   { background: #7C3AED; border-radius: 2px; width:10px; height:10px; border:1.5px dashed #7C3AED; background:transparent; }
.ol-lbl { font-size: 11px; color: var(--txt); flex: 1; min-width: 0;
          overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.ol-del, .ol-ungrp {
  height: 18px; border-radius: 4px; border: none;
  background: transparent; cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  flex-shrink: 0; opacity: 0; transition: all .1s;
}
.ol-del  { width: 18px; color: var(--txt2); font-size: 13px; }
.ol-ungrp{ padding: 0 5px; color: #7C3AED; font-size: 10px; }
.ol-item:hover .ol-del, .ol-item:hover .ol-ungrp { opacity: 1; }
.ol-del:hover   { background: #FFF2F0; color: #C0392B; }
.ol-ungrp:hover { background: #EDE9FE; }
.ol-item-child  { padding-left: 24px; }
.ol-child-arrow { font-size: 10px; color: var(--txt2); flex-shrink: 0; }
.ol-orphan-hdr  { padding: 4px 12px 2px; font-size: 10px; font-weight: 600; color: var(--txt2); border-top: 1px solid var(--border); margin-top: 2px; }

/* ── Zoom widget ── */
.zoom-widget {
  position: absolute;
  bottom: 14px; right: 14px;
  display: flex; align-items: center;
  gap: 2px;
  background: rgba(255,255,255,.92);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 3px 5px;
  box-shadow: 0 1px 6px rgba(0,0,0,.1);
  z-index: 10;
}
.zoom-btn {
  width: 24px; height: 24px; border: none; background: transparent;
  border-radius: 5px; cursor: pointer; color: var(--txt2);
  display: flex; align-items: center; justify-content: center;
  font-size: 15px; font-weight: 500; transition: background .1s;
}
.zoom-btn:hover { background: var(--th); color: var(--txt); }
.zoom-pct {
  font-size: 11px; color: var(--txt2); min-width: 36px;
  text-align: center; user-select: none;
}

/* ── Bottom bar ── */
.bottombar { justify-content: space-between; }
.bb-left { display: flex; align-items: center; gap: 10px; }
.bb-right { display: flex; align-items: center; gap: 8px; }
.bb-prev { display: flex !important; }
.bb-prev:disabled { opacity: .35; cursor: default; pointer-events: none; }

/* ── Object Library Modal ─────────────────────────────────── */
#olib-overlay{display:none;position:fixed;inset:0;z-index:9000;background:rgba(30,28,24,.45);backdrop-filter:blur(2px)}
#olib-overlay.open{display:flex;align-items:stretch}
#olib-panel{width:700px;max-width:92vw;height:100vh;background:#F4F3EF;display:flex;flex-direction:column;box-shadow:6px 0 40px rgba(0,0,0,.18);overflow:hidden}
#olib-head{padding:22px 24px 0;flex:none}
#olib-title-row{display:flex;align-items:center;justify-content:space-between;margin-bottom:14px}
#olib-title{font-size:18px;font-weight:700;letter-spacing:-.02em;color:#2C2A26}
#olib-close{width:32px;height:32px;border:none;background:#EAE7E0;border-radius:8px;cursor:pointer;display:flex;align-items:center;justify-content:center;color:#6B665D;font-size:18px;line-height:1}
#olib-close:hover{background:#E0DCD4}
#olib-search{display:flex;align-items:center;gap:9px;background:#fff;border:1.5px solid #E3DFD6;border-radius:10px;padding:9px 14px;margin-bottom:13px;box-shadow:0 1px 2px rgba(0,0,0,.04)}
#olib-search svg{flex:none;color:#B6B1A7}
#olib-q{border:none;font-size:14px;width:100%;font-family:inherit;color:#2C2A26;background:transparent}
#olib-q:focus{outline:none}
#olib-chips{display:flex;gap:7px;flex-wrap:nowrap;overflow-x:auto;padding-bottom:13px;scrollbar-width:none}
#olib-chips::-webkit-scrollbar{display:none}
.olib-chip{font-family:inherit;font-size:12.5px;font-weight:600;padding:6px 13px;border-radius:8px;cursor:pointer;white-space:nowrap;background:#fff;color:#6B665D;border:1.5px solid #E3DFD6;transition:all .12s}
.olib-chip.on{background:#2C2A26;color:#fff;border-color:#2C2A26}
#olib-body{flex:1;overflow-y:auto;padding:4px 24px 24px}
.olib-grp{margin-bottom:28px}
.olib-grph{display:flex;align-items:baseline;gap:8px;margin-bottom:11px}
.olib-grph h3{margin:0;font-size:13.5px;font-weight:700;letter-spacing:-.01em;color:#2C2A26}
.olib-grph span{font-size:11.5px;color:#A8A39A}
.olib-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(128px,1fr));gap:10px}
.olib-card{background:#fff;border:1.5px solid #EAE6DD;border-radius:11px;padding:11px 10px 9px;cursor:pointer;transition:border-color .14s,box-shadow .14s,transform .1s;display:flex;flex-direction:column;gap:0}
.olib-card:hover{border-color:#C9C3B6;box-shadow:0 4px 14px rgba(0,0,0,.09);transform:translateY(-2px)}
.olib-thumb{height:72px;display:flex;align-items:center;justify-content:center;margin-bottom:9px;background:#FAF9F6;border-radius:7px;background-image:radial-gradient(#EDEAE1 1px,transparent 1px);background-size:10px 10px;overflow:hidden}
.olib-thumb img{max-width:68px;max-height:60px;width:auto;height:auto;display:block}
.olib-row{display:flex;align-items:center;justify-content:space-between;gap:5px}
.olib-nm{font-size:12.5px;font-weight:600;color:#34322D;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.olib-fp{font-size:10px;font-weight:600;color:#A89B82;background:#F3EFE6;border-radius:4px;padding:2px 5px;flex:none}
#olib-empty{text-align:center;padding:60px 20px;font-size:14px;color:#A8A39A}

/* 라이브러리 열기 버튼 */
.s2-lib-btn{display:flex;align-items:center;gap:8px;width:100%;padding:10px 12px;background:#2C2A26;color:#fff;border:none;border-radius:9px;font-size:13px;font-weight:600;font-family:inherit;cursor:pointer;transition:background .14s;margin-bottom:8px}
.s2-lib-btn:hover{background:#3C3A34}
.s2-lib-btn svg{flex:none;opacity:.8}
/* ── Step 2: Search ── */
.s2-search-wrap{padding:8px 7px 5px;position:relative;flex-shrink:0}
.s2-search-inp{width:100%;padding:7px 28px 7px 28px;border:1px solid var(--border);border-radius:7px;font-size:11.5px;font-family:inherit;background:var(--bg2);color:var(--txt);outline:none;box-sizing:border-box}
.s2-search-inp:focus{border-color:var(--acc)}
.s2-search-ico{position:absolute;left:13px;top:50%;transform:translateY(-50%);color:var(--txt2);pointer-events:none}
.s2-search-clear{position:absolute;right:11px;top:50%;transform:translateY(-50%);background:none;border:none;padding:2px 4px;cursor:pointer;font-size:12px;line-height:1;color:var(--txt2);display:none;border-radius:3px}
.s2-search-clear:hover{color:var(--txt)}
/* ── Step 2: Accordion ── */
.s2-acc-item{border-bottom:1px solid var(--border)}
.s2-acc-hdr{display:flex;align-items:center;justify-content:space-between;width:100%;padding:9px 10px;background:none;border:none;cursor:pointer;font-size:12px;font-weight:600;color:var(--txt);font-family:inherit;text-align:left;transition:background .1s}
.s2-acc-hdr:hover{background:var(--bg3)}
.s2-acc-arrow{font-size:8px;color:var(--txt2);transition:transform .2s;flex-shrink:0}
.s2-acc-item.open .s2-acc-arrow{transform:rotate(90deg)}
.s2-acc-body{display:none;padding:4px 7px 10px}
.s2-acc-item.open .s2-acc-body{display:block}
.s2-sub-hdr{font-size:9px;font-weight:700;color:var(--txt2);text-transform:uppercase;letter-spacing:.5px;padding:8px 0 4px}
.s2-sub-hdr:first-child{padding-top:2px}
/* ── Step 2: Object card grid ── */
.s2-obj-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:5px}
.s2-obj-card{display:flex;flex-direction:column;align-items:center;gap:4px;padding:7px 4px 6px;background:var(--bg2);border:1.5px solid var(--border);border-radius:8px;cursor:pointer;transition:background .12s,border-color .12s;width:100%;font-family:inherit}
.s2-obj-card:hover{background:var(--bg3);border-color:var(--acc)}
.s2-obj-card img{width:40px;height:40px;object-fit:contain}
.s2-obj-card-name{font-size:9.5px;color:var(--txt);text-align:center;line-height:1.3;word-break:keep-all}
.s2-sec-card-dot{width:34px;height:34px;border-radius:6px;flex-shrink:0}
/* ── Step 2: Search results ── */
.s2-search-item{display:flex;align-items:center;gap:9px;padding:6px 4px;border-radius:6px;cursor:pointer;width:100%;border:none;background:none;font-family:inherit;text-align:left;transition:background .1s}
.s2-search-item:hover{background:var(--bg3)}
.s2-search-item img{width:32px;height:32px;object-fit:contain;flex-shrink:0;border-radius:4px;background:var(--bg2)}
.s2-search-name{font-size:11px;color:var(--txt)}
/* ── Step 2: Recent ── */
.s2-recent-row{display:flex;flex-wrap:wrap;gap:4px;padding:2px 0 6px}
.s2-recent-btn{width:44px;height:44px;border-radius:8px;border:1px solid var(--border);background:var(--bg2);display:flex;align-items:center;justify-content:center;cursor:pointer;padding:4px;transition:background .12s,border-color .12s}
.s2-recent-btn:hover{background:var(--bg3);border-color:var(--acc)}
.s2-recent-btn img{width:32px;height:32px;object-fit:contain}
.s2-recent-empty{font-size:10px;color:var(--txt2);padding:2px 0 6px}
/* ── Custom modal: SVG picker ── */
.cust-svg-pick{display:flex;align-items:center;gap:8px;border:1px solid var(--border);border-radius:7px;padding:7px 10px;background:var(--bg2);cursor:pointer;transition:border-color .12s}
.cust-svg-pick:hover{border-color:var(--acc)}
.cust-svg-thumb{width:40px;height:40px;display:flex;align-items:center;justify-content:center;background:#F4F3EF;border-radius:6px;flex-shrink:0}
.cust-svg-thumb img{width:36px;height:36px;object-fit:contain}
.cust-svg-lbl{font-size:11px;color:var(--txt2)}
.cust-svg-lbl.chosen{color:var(--txt);font-weight:600}
</style>
</head>
<body>

<!-- Top bar -->
<div class="topbar">
  <div class="tb-brand">Smart Office <em>/ STEG</em></div>

  <div class="steps">
    <div class="step active" onclick="clickStep(1)">
      <div class="step-dot">1</div>
      <div class="step-name">구조 설계</div>
    </div>
    <div class="step-line"></div>
    <div class="step pending" onclick="clickStep(2)">
      <div class="step-dot">2</div>
      <div class="step-name">요소 배치</div>
    </div>
    <div class="step-line"></div>
    <div class="step pending" onclick="clickStep(3)">
      <div class="step-dot">3</div>
      <div class="step-name">세부 정보</div>
    </div>
  </div>

  <div class="tb-right">
    <select id="load-sel" onchange="loadExisting(this.value)"
            style="background:#2C2C2E;border:1px solid #3A3A3C;color:#EBEBF0;
                   font-size:11px;padding:4px 8px;border-radius:6px;outline:none;cursor:pointer;max-width:160px;">
      <option value="">기존 레이아웃 불러오기</option>
    </select>
    <button class="btn-icon-dark" id="btn-undo" onclick="undo()" title="실행 취소 Ctrl+Z" disabled>
      <svg width="13" height="13" viewBox="0 0 13 13" fill="none"><path d="M2 5.5h6a3 3 0 0 1 0 6H5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M4.5 3L2 5.5 4.5 8" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </button>
    <button class="btn-icon-dark" id="btn-redo" onclick="redo()" title="다시 실행 Ctrl+Y" disabled>
      <svg width="13" height="13" viewBox="0 0 13 13" fill="none"><path d="M11 5.5H5a3 3 0 0 0 0 6h3" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/><path d="M8.5 3L11 5.5 8.5 8" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </button>
    <div style="width:1px;height:16px;background:#3A3A3C;margin:0 2px"></div>
    <button class="btn-icon-dark" onclick="rotateMap('ccw')" title="맵 90° 반시계방향 회전">
      <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
        <path d="M2.5 7A4.5 4.5 0 1 0 4 3.5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M2.5 2v2.5H5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </button>
    <button class="btn-icon-dark" onclick="rotateMap('cw')" title="맵 90° 시계방향 회전">
      <svg width="14" height="14" viewBox="0 0 14 14" fill="none">
        <path d="M11.5 7A4.5 4.5 0 1 1 10 3.5" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
        <path d="M11.5 2v2.5H9" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </button>
    <button class="btn-ghost-dark" onclick="saveDraft()">임시저장</button>
  </div>
</div>

<!-- Main -->
<div class="main">

  <!-- Left: tool palette -->
  <div class="sidebar" id="main-sidebar">

    <!-- Step 1: drawing tools -->
    <div id="s1-tools" style="display:contents">

    <!-- 선택 -->
    <button class="tool on" id="t-select" onclick="setTool('select')" title="선택 V">
      <svg width="20" height="20" viewBox="0 0 15 15" fill="none">
        <path d="M3 1.5L3 12.5L6.2 9.3L8.2 13.5L10 12.7L8 8.5L12 8.5L3 1.5Z" fill="currentColor"/>
      </svg>
    </button>

    <div class="tsep"></div>

    <!-- 선: 클릭=실선(벽), 호버=실선·점선 flyout -->
    <div class="tg">
      <button class="tg-hdr" id="t-wall" onclick="setTool('wall')" title="선 W">
        <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
          <line x1="3" y1="10" x2="17" y2="10" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/>
        </svg>
      </button>
      <div class="tg-body">
        <button class="tool" onclick="setTool('wall')" title="실선">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <line x1="3" y1="10" x2="17" y2="10" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"/>
          </svg>
        </button>
        <button class="tool" id="t-dashed" onclick="setTool('dashed')" title="점선">
          <svg width="20" height="20" viewBox="0 0 20 20" fill="none">
            <line x1="3" y1="10" x2="17" y2="10" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-dasharray="4 3"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- 창문: 단독 버튼 -->
    <button class="tool" id="t-window" onclick="setTool('window')" title="창문 N">
      <svg width="20" height="20" viewBox="0 0 15 15" fill="none">
        <!-- outer frame -->
        <rect x="1.5" y="3" width="12" height="9" rx=".8" stroke="currentColor" stroke-width="1.5"/>
        <!-- center vertical divider -->
        <line x1="7.5" y1="3" x2="7.5" y2="12" stroke="currentColor" stroke-width="1"/>
        <!-- glass tint -->
        <rect x="1.5" y="3" width="12" height="9" rx=".8" fill="currentColor" opacity=".08"/>
      </svg>
    </button>

    <!-- 문: 클릭=단문, 호버=단문·양문 flyout -->
    <div class="tg">
      <button class="tg-hdr" id="t-door" onclick="setTool('door')" title="문 D">
        <svg width="20" height="20" viewBox="0 0 15 15" fill="none">
          <line x1="3" y1="12" x2="10" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          <line x1="3" y1="5" x2="3" y2="12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
          <path d="M10,12 A7,7 0 0,0 3,5" stroke="currentColor" stroke-width="1.2" stroke-dasharray="2.5 2"/>
        </svg>
      </button>
      <div class="tg-body">
        <button class="tool" onclick="setTool('door')" title="단문">
          <svg width="20" height="20" viewBox="0 0 15 15" fill="none">
            <line x1="3" y1="12" x2="10" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            <line x1="3" y1="5" x2="3" y2="12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <path d="M10,12 A7,7 0 0,0 3,5" stroke="currentColor" stroke-width="1.2" stroke-dasharray="2.5 2"/>
          </svg>
        </button>
        <button class="tool" id="t-door2" onclick="setTool('door2')" title="양문">
          <svg width="20" height="20" viewBox="0 0 15 15" fill="none">
            <line x1="2" y1="12" x2="13" y2="12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            <line x1="2" y1="5" x2="2" y2="12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <line x1="13" y1="5" x2="13" y2="12" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
            <path d="M7.5,12 A5.5,5.5 0 0,1 2,6.5" stroke="currentColor" stroke-width="1" stroke-dasharray="2 2"/>
            <path d="M7.5,12 A5.5,5.5 0 0,0 13,6.5" stroke="currentColor" stroke-width="1" stroke-dasharray="2 2"/>
          </svg>
        </button>
      </div>
    </div>

    <!-- 기둥: 단독 버튼 -->
    <button class="tool" id="t-column" onclick="setTool('column')" title="기둥 C">
      <svg width="20" height="20" viewBox="0 0 15 15">
        <rect x="4" y="4" width="7" height="7" fill="currentColor" rx="1"/>
      </svg>
    </button>

    <div class="tsep"></div>

    <button class="tool" onclick="deleteSelected()" title="삭제 Del">
      <svg width="20" height="20" viewBox="0 0 14 14" fill="none">
        <path d="M5.5 2.5h3M2 4h10M3.5 4l.8 7.5h5.4L10.5 4" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </button>

    <div class="tsep-full" style="margin-top:auto"></div>
    </div><!-- /s1-tools -->

    <!-- Step 2: object library -->
    <div id="s2-presets" style="display:none; flex-direction:column; align-items:stretch; width:100%; overflow:hidden; height:100%">

      <!-- 검색 (고정) -->
      <div class="s2-search-wrap">
        <svg class="s2-search-ico" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><line x1="16.5" y1="16.5" x2="22" y2="22"/></svg>
        <input id="s2-search" class="s2-search-inp" type="text" placeholder="검색...">
        <button id="s2-search-clear" class="s2-search-clear" onclick="clearS2Search()">✕</button>
      </div>

      <div class="s2-scroll">
        <!-- 최근 사용 (없으면 숨김) -->
        <div id="s2-recent-sec" style="display:none">
          <div class="s2-cat-hdr">최근 사용</div>
          <div class="s2-recent-row" id="s2-recent-list"></div>
        </div>

        <!-- 검색 결과 -->
        <div id="s2-search-results" style="display:none; padding:4px 2px"></div>

        <!-- 카테고리 아코디언 -->
        <div id="s2-cat-wrap">
          <div class="s2-cat-hdr">카테고리</div>
          <div id="s2-accordions"></div>
        </div>
      </div><!-- /s2-scroll -->

      <div class="s2-bottom-bar">
        <button class="s2-cust-add" style="margin-bottom:6px" onclick="openCustomTemplateModal()">
          <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg> 오브젝트 추가
        </button>
        <button class="s2-del-btn" onclick="deleteSelected()">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M3 6h18M9 3h6M5 6l1 14a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1l1-14"/></svg>
          선택 삭제
        </button>
      </div>
    </div><!-- /s2-presets -->

    <!-- Quick-access flyout (fixed, outside sidebar) -->
    <div id="s2-flyout"></div>

    <!-- Custom Template Modal -->
    <div id="cust-modal-overlay" class="cust-modal-overlay" style="display:none" onclick="if(event.target===this)closeCustomTemplateModal()">
      <div class="cust-modal" onclick="event.stopPropagation()">
        <h3 id="cust-modal-title">오브젝트 추가</h3>
        <div class="cust-field-row">
          <label>베이스 오브젝트</label>
          <div class="cust-svg-pick" onclick="openLibraryModal(_custSvgPickCallback)" id="cust-svg-pick">
            <div class="cust-svg-thumb" id="cust-svg-thumb">
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#BBBBBB" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="9" y1="3" x2="9" y2="21"/><line x1="15" y1="3" x2="15" y2="21"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="3" y1="15" x2="21" y2="15"/></svg>
            </div>
            <span class="cust-svg-lbl" id="cust-svg-lbl">라이브러리에서 선택 →</span>
          </div>
        </div>
        <div class="cust-field-row">
          <label>이름</label>
          <input type="text" id="cust-name" placeholder="예: 마케팅팀 전용 책상">
        </div>
        <div style="font-size:10px; font-weight:600; color:var(--txt2); margin-bottom:5px">속성 필드</div>
        <div class="cust-fd-list" id="cust-fd-list"></div>
        <button class="cust-fd-add" onclick="addCustomFieldRow()">+ 필드 추가</button>
        <div class="cust-modal-btns">
          <button onclick="closeCustomTemplateModal()">취소</button>
          <button class="cust-save" onclick="saveCustomTemplate()">저장</button>
        </div>
      </div>
    </div>

  </div>

  <!-- Canvas -->
  <div class="carea" id="carea">
    <div id="cwrap">
      <canvas id="c"></canvas>
    </div>
    <div id="hint"></div>

    <div class="zoom-widget">
      <button class="zoom-btn" onclick="zoomOut()" title="축소 Ctrl+−">−</button>
      <span class="zoom-pct" id="zoom-pct">100%</span>
      <button class="zoom-btn" onclick="zoomIn()" title="확대 Ctrl+=">+</button>
      <button class="zoom-btn" onclick="fitAll()" title="화면에 맞추기" style="font-size:11px">⊙</button>
    </div>
  </div>

  <!-- Right panel -->
  <div class="panel">
    <!-- Steps 1 & 2: property panel -->
    <div id="panel-normal" style="display:flex; flex-direction:column; height:100%; overflow:hidden">
    <div class="ph">속성</div>
    <div class="pb">
      <div class="pempty" id="pempty">오브젝트를 선택하거나<br>도구를 선택해<br>작업을 시작하세요</div>
      <div class="pobj" id="pobj">
        <div class="prow">
          <div class="plbl">유형</div>
          <div class="pval"><span class="ptag" id="pv-type">—</span></div>
        </div>
        <div class="prow" id="pr-size">
          <div class="plbl">길이</div>
          <div class="pval" id="pv-size">—</div>
        </div>
        <div class="prow" id="pr-stroke" style="display:none">
          <div class="plbl">두께</div>
          <div style="display:flex; align-items:center; gap:7px; margin-top:3px">
            <input type="range" class="slider" id="pv-stroke" min="2" max="24" value="6" step="1" oninput="applyStroke(this.value)">
            <span class="slval" id="pv-stroke-val">6</span>
          </div>
        </div>
        <!-- furniture W/H -->
        <div class="prow" id="pr-wh" style="display:none">
          <div class="plbl">크기</div>
          <div class="wh-row">
            <div class="wh-item">
              <div class="wh-lbl">가로</div>
              <div class="wh-wrap">
                <input class="wh-inp" id="pv-fw" type="number" min="1" step="1" value="80" onchange="applyFurnitureSize()">
                <span class="wh-unit" id="pv-fw-unit">px</span>
              </div>
            </div>
            <div class="wh-item">
              <div class="wh-lbl">세로</div>
              <div class="wh-wrap">
                <input class="wh-inp" id="pv-fh" type="number" min="1" step="1" value="55" onchange="applyFurnitureSize()">
                <span class="wh-unit" id="pv-fh-unit">px</span>
              </div>
            </div>
          </div>
        </div>
        <!-- flip buttons for door / window -->
        <div class="prow" id="pr-flip" style="display:none">
          <div class="plbl">반전</div>
          <div style="display:flex;gap:6px;margin-top:5px">
            <button onclick="flipObject('x')"
              style="flex:1;padding:5px 0;border-radius:5px;border:1px solid var(--border);
                     background:transparent;color:var(--txt);font-size:11px;cursor:pointer;
                     font-family:inherit">↔ 좌우</button>
            <button onclick="flipObject('y')"
              style="flex:1;padding:5px 0;border-radius:5px;border:1px solid var(--border);
                     background:transparent;color:var(--txt);font-size:11px;cursor:pointer;
                     font-family:inherit">↕ 상하</button>
          </div>
        </div>
        <!-- column size -->
        <div class="prow" id="pr-col" style="display:none">
          <div class="plbl">크기</div>
          <div class="wh-row">
            <div class="wh-item">
              <div class="wh-lbl">가로</div>
              <div class="wh-wrap">
                <input class="wh-inp" id="pv-cw" type="number" min="1" step="1" value="18" onchange="applyColumnSize()">
                <span class="wh-unit" id="pv-cw-unit">px</span>
              </div>
            </div>
            <div class="wh-item">
              <div class="wh-lbl">세로</div>
              <div class="wh-wrap">
                <input class="wh-inp" id="pv-ch" type="number" min="1" step="1" value="18" onchange="applyColumnSize()">
                <span class="wh-unit" id="pv-ch-unit">px</span>
              </div>
            </div>
          </div>
        </div>
        <!-- section name / type -->
        <div class="prow" id="pr-sname" style="display:none">
          <div class="plbl">이름</div>
          <input class="sec-inp" id="pv-sname" type="text" placeholder="예: 1회의실" oninput="applySectionName(this.value)">
        </div>
        <div class="prow" id="pr-stype" style="display:none">
          <div class="plbl">구역 유형</div>
          <select class="sec-sel" id="pv-stype" onchange="applySectionType(this.value)">
            <option value="SECTION">일반 구역</option>
            <option value="MEETING">회의실 (예약 가능)</option>
            <option value="REST">휴게 공간</option>
            <option value="OTHER">기타</option>
          </select>
        </div>
        <!-- color picker -->
        <div class="prow" id="pr-color" style="display:none">
          <div class="plbl">색상</div>
          <div style="margin-top:4px">
            <input type="color" id="pv-fill-color" value="#EDE5D8"
              oninput="applyObjColor(this.value)"
              style="width:30px;height:24px;padding:1px 2px;border:1px solid var(--border);
                     border-radius:4px;cursor:pointer;background:white">
          </div>
        </div>
        <div class="prow" id="pr-angle">
          <div class="plbl">각도</div>
          <div class="angle-wrap">
            <input class="angle-input" id="pv-angle" type="number" min="-180" max="360" step="1" value="0" onchange="applyAngleFromPanel(this.value)">
            <span class="angle-unit">°</span>
          </div>
        </div>
        <button class="bdel" onclick="deleteSelected()">삭제</button>
      </div>
    </div>

    <!-- ── Setup Wizard ── -->
    <div id="setup-wizard" class="setup-wz">

      <!-- Done card (shown after all 3 steps complete) -->
      <div id="wz-done" style="display:none">
        <div class="wz-done-card">
          <div class="wz-dtitle">✓ 도면 설정 완료</div>
          <div class="wz-dsub">축척: <span id="wz-done-scale">1칸 = 250 mm</span></div>
          <button class="wz-reset-btn" onclick="wizardReset()">다시 설정</button>
        </div>
      </div>

      <!-- 3 wizard steps -->
      <div id="wz-steps-wrap">
        <!-- Step 1: Upload -->
        <div class="wz-step" id="wz-s1">
          <div class="wz-head" id="wz-h1" onclick="wizardClickHead(1)">
            <span class="wz-num act" id="wz-n1">1</span>
            <span class="wz-title">도면 업로드</span>
            <span class="wz-badge" id="wz-b1"></span>
          </div>
          <div class="wz-body" id="wz-body1">
            <input type="file" id="bgfile" accept="image/*" style="display:none" onchange="onBgFile(event)">
            <button class="bupload" id="bupload" onclick="document.getElementById('bgfile').click()">
              <svg width="13" height="13" viewBox="0 0 13 13" fill="none">
                <path d="M6.5 2v7M4 4.5L6.5 2 9 4.5M2 11h9" stroke="currentColor" stroke-width="1.3" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
              도면 업로드
            </button>
          </div>
        </div>

        <!-- Step 2: Scale calibration -->
        <div class="wz-step" id="wz-s2">
          <div class="wz-head wz-future" id="wz-h2" onclick="wizardClickHead(2)">
            <span class="wz-num" id="wz-n2">2</span>
            <span class="wz-title">축척 설정</span>
            <span class="wz-badge" id="wz-b2">—</span>
          </div>
          <div class="wz-body" id="wz-body2" style="display:none">
            <!-- Draw line -->
            <div id="calib-step1">
              <div style="font-size:10px;color:var(--txt2);line-height:1.75;padding:8px;background:var(--th);border-radius:6px">
                도면 위에서 <strong style="color:var(--txt)">길이를 아는 두 점</strong>을<br>
                클릭해서 선을 그으세요.<br><span style="opacity:.7">(예: 문 폭, 벽 길이)</span>
              </div>
            </div>
            <!-- Enter real length -->
            <div id="calib-step2" style="display:none">
              <div class="slrow" style="margin-bottom:8px">
                <span class="sllbl" style="font-size:10px;color:var(--txt2)"><span id="calib-px-len">—</span>px =</span>
                <input type="number" id="scale-meters" value="5" min="1" step="1"
                  style="width:46px;padding:3px 5px;border:1px solid var(--border);border-radius:5px;
                         font-size:12px;font-family:inherit;background:white;color:var(--txt);outline:none;text-align:center"
                  oninput="updateCalibLabel()">
                <span class="sllbl">m</span>
              </div>
              <div>
                <div style="font-size:10px;color:var(--txt2);margin-bottom:5px">격자 1칸 크기</div>
                <div style="display:flex;align-items:center;gap:4px">
                  <button onclick="adjustGridMm(-10)"
                    style="width:26px;height:26px;border-radius:5px;border:1px solid var(--border);
                           background:transparent;color:var(--txt);font-size:16px;line-height:1;cursor:pointer;font-family:inherit;flex-shrink:0">−</button>
                  <input type="number" id="grid-mm" value="500" min="10" max="10000" step="10"
                    style="flex:1;min-width:0;padding:3px 5px;border:1px solid var(--border);border-radius:5px;
                           font-size:12px;font-family:inherit;background:white;color:var(--txt);outline:none;text-align:center"
                    oninput="onGridMmChange()">
                  <button onclick="adjustGridMm(10)"
                    style="width:26px;height:26px;border-radius:5px;border:1px solid var(--border);
                           background:transparent;color:var(--txt);font-size:16px;line-height:1;cursor:pointer;font-family:inherit;flex-shrink:0">+</button>
                  <span style="font-size:11px;color:var(--txt2);flex-shrink:0">mm</span>
                </div>
              </div>
              <div style="display:flex;gap:6px;margin-top:4px">
                <button onclick="resetCalib()"
                  style="flex:1;padding:6px;border-radius:6px;border:1px solid var(--border);
                         background:transparent;color:var(--txt2);font-size:11px;cursor:pointer;font-family:inherit">다시 그리기</button>
                <button onclick="confirmScale()"
                  style="flex:1;padding:6px;border-radius:6px;border:none;
                         background:var(--txt);color:#FAFAF8;font-size:11px;font-weight:500;cursor:pointer;font-family:inherit">확정</button>
              </div>
            </div>
            <!-- Preview label (updated by updateCalibLabel / onGridMmChange) -->
            <div style="font-size:10px;color:var(--txt2);text-align:center">
              예상: <span id="scale-info">1칸 = 250 mm</span>
            </div>
            <button class="wz-skip" onclick="wizardSkip(2)">축척 건너뛰기</button>
            <button onclick="cancelCalib()"
              style="width:100%;padding:5px 0;border-radius:5px;border:1px solid var(--border);
                     background:transparent;color:var(--txt2);font-size:10px;cursor:pointer;font-family:inherit">← 이전 단계</button>
          </div>
        </div>

        <!-- Step 3: Wall auto-extract -->
        <div class="wz-step" id="wz-s3">
          <div class="wz-head wz-future" id="wz-h3" onclick="wizardClickHead(3)">
            <span class="wz-num" id="wz-n3">3</span>
            <span class="wz-title">벽 자동 추출</span>
            <span class="wz-badge" id="wz-b3">—</span>
          </div>
          <div class="wz-body" id="wz-body3" style="display:none">
            <!-- Click-to-pick prompt (shown initially) -->
            <div id="ex-pick-prompt" style="font-size:11px;color:var(--txt2);padding:2px 0">도면에서 벽을 클릭하면 자동 분석됩니다</div>
            <!-- Picked color row (shown after pick) -->
            <div id="ex-color-row" style="display:none;align-items:center;gap:7px">
              <div id="ex-color-swatch" style="width:22px;height:22px;border-radius:5px;border:1px solid var(--border);background:#b3b3b3;flex-shrink:0"></div>
              <span id="ex-wallcolor-rgb" style="font-size:10px;color:var(--txt2);flex:1">179,179,179</span>
              <button id="ex-eyedrop-btn" onclick="startEyedropper()"
                  style="padding:3px 8px;border:1px solid var(--border);border-radius:4px;background:white;
                         cursor:pointer;font-size:10px;font-family:inherit;color:var(--txt2)">다시 선택</button>
            </div>
            <!-- Sliders -->
            <div style="display:flex;flex-direction:column;gap:2px">
              <div style="display:flex;align-items:center;gap:7px">
                <span style="font-size:10px;color:var(--txt2);width:40px;flex-shrink:0">검출 강도</span>
                <input type="range" id="ex-sens" min="1" max="9" value="5" class="slider" style="flex:1"
                       oninput="document.getElementById('ex-sens-val').textContent=this.value;scheduleRedetect()">
                <span id="ex-sens-val" style="font-size:11px;color:var(--txt);width:12px;text-align:right">5</span>
              </div>
              <div style="display:flex;justify-content:space-between;padding:0 0 0 47px">
                <span style="font-size:9px;color:var(--txt2)">선명한 선만</span>
                <span style="font-size:9px;color:var(--txt2)">연한 선 포함</span>
              </div>
            </div>
            <div style="display:flex;flex-direction:column;gap:2px">
              <div style="display:flex;align-items:center;gap:7px">
                <span style="font-size:10px;color:var(--txt2);width:40px;flex-shrink:0">최소 길이</span>
                <input type="range" id="ex-minlen" min="1" max="9" value="3" class="slider" style="flex:1"
                       oninput="document.getElementById('ex-minlen-val').textContent=this.value;scheduleRedetect()">
                <span id="ex-minlen-val" style="font-size:11px;color:var(--txt);width:12px;text-align:right">3</span>
              </div>
              <div style="display:flex;justify-content:space-between;padding:0 0 0 47px">
                <span style="font-size:9px;color:var(--txt2)">짧은 벽</span>
                <span style="font-size:9px;color:var(--txt2)">긴 벽</span>
              </div>
            </div>
            <!-- Status + confirm (hidden until color picked) -->
            <div id="ex-count" style="display:none;font-size:10px;color:var(--txt2);text-align:center;padding:5px 8px;background:var(--th);border-radius:5px"></div>
            <button id="ex-confirm" onclick="exConfirmAction()" style="display:none;width:100%;padding:8px 0;border-radius:7px;border:none;
                background:linear-gradient(135deg,#7C3AED,#6D28D9);color:#fff;font-size:11px;font-weight:600;cursor:pointer;font-family:inherit">분석 중...</button>
            <!-- Hidden inputs for JS compatibility -->
            <input type="checkbox" id="ex-colormask" checked style="display:none">
            <input type="checkbox" id="ex-ortho" checked style="display:none">
            <input type="checkbox" id="ex-replace" style="display:none">
            <input type="range" id="ex-merge" value="8" style="display:none">
            <input type="number" id="ex-coltol" value="0" style="display:none">
            <input type="color" id="ex-wallcolor" value="#b3b3b3" style="display:none">
            <button class="wz-skip" onclick="wizardSkip(3)">건너뛰기 (도면 없이 그리기)</button>
          </div>
        </div>
      </div><!-- /wz-steps-wrap -->

      <!-- BG controls: always accessible while bgImg exists -->
      <div id="bgctrl" style="display:none;margin-top:8px">
        <div class="slrow">
          <span class="sllbl">투명도</span>
          <input type="range" class="slider" id="bgopa" min="0" max="60" value="30" oninput="setBgOpacity(this.value)">
          <span class="slval" id="bgopa-val">30%</span>
        </div>
        <div class="bgbtns">
          <button class="bsm" id="btn-toggle-bg" onclick="toggleBg()">숨기기</button>
          <button class="bsm red" onclick="removeBg()">제거</button>
        </div>
      </div>
    </div><!-- /setup-wizard -->

    <!-- Object list (steps 1 & 2) -->
    <div class="objlist-wrap" id="objlist-wrap">
      <div class="objlist-hd" onclick="toggleObjList()">
        <span>오브젝트</span>
        <span id="objlist-count" style="font-size:9px;font-weight:400;color:var(--txt2)">0개</span>
      </div>
      <div class="objlist-body" id="objlist-body"></div>
    </div>
    </div><!-- /panel-normal -->

    <!-- Step 3: element list -->
    <div id="panel-step3" style="display:none; flex-direction:column; height:100%; overflow:hidden">
      <div class="ph">요소 목록</div>
      <div class="elist" id="s3-list">
        <div class="elist-empty">배치된 요소가<br>없습니다</div>
      </div>
      <div style="padding:12px 14px; border-top:1px solid var(--border); flex-shrink:0; display:flex; flex-direction:column; gap:8px">
        <div>
          <div class="plabel" style="margin-bottom:4px">사무실 이름</div>
          <input id="so-layout-name" class="pinput" style="width:100%" placeholder="예: 3층 개발팀 사무실" value="">
        </div>
        <button class="bbnext" style="width:100%; justify-content:center" onclick="saveAll()">eGene에 저장</button>
      </div>
    </div><!-- /panel-step3 -->
  </div><!-- /panel -->

</div>

<!-- Bottom bar -->
<div class="bottombar">
  <div class="bb-left">
    <div class="bbinfo" id="bb-info">
      <span id="bb-count">오브젝트 0개</span>
      <span>·</span>
      <span id="bb-hint"><kbd>Shift</kbd> 연속벽 · <kbd>Alt</kbd> 45° 스냅 · <kbd>Del</kbd> 삭제 · <kbd>Esc</kbd> 취소</span>
    </div>
  </div>
  <div class="bb-right">
    <button class="bb-prev" id="bb-prev" onclick="goBack()" disabled>
      <svg width="12" height="12" viewBox="0 0 12 12" fill="none"><path d="M7.5 2.5L3 6l4.5 3.5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></svg>
      이전
    </button>
    <button class="bbnext" id="bb-next" onclick="goNext()">
      <span id="bb-next-label">요소 배치</span>
      <svg width="13" height="13" viewBox="0 0 13 13" fill="none">
        <path d="M5 3.5l4.5 3-4.5 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    </button>
  </div>
</div>

<div id="toast"></div>

<script>
// ── Constants ────────────────────────────────────────────
var GRID     = 20;   // dot grid display interval
var SNAP     = 5;    // drawing snap resolution (finer than display grid)
var SNAP_D   = 18;   // magnetic endpoint snap distance
var DOOR_W   = 64;
var DOOR2_W  = 128;   // double door total width (2 × DOOR_W)
var WIN_W    = 80;
var COL_S    = 18;

// ── State ────────────────────────────────────────────────
var activeTool = 'select';
var doorDouble = false;   // true when double-door tool is active
var wallSt     = { on: false, x1: 0, y1: 0, prev: null };
var _wallHoverPt = null; // snap preview before first wall click
var shiftOn    = false;
var altOn      = false;
var bgImg      = null;
var bgOn       = true;
var pts        = [];   // wall endpoints for magnetic snap
var currentSnapPt = null;   // endpoint currently highlighted (snap target)

// Scale calibration (default: 1 grid(20px) = 250mm → pxPerM = 80)
var pxPerM      = 80;
var scaleModeOn = false;
var calibSt     = { pt1: null, pt2: null, dot1: null, dot2: null, line: null, prev: null, pxLen: 0 };

// Canvas panning
var isPanning  = false;
var lastPanX   = 0;
var lastPanY   = 0;
var spaceDown  = false;

// ── Canvas Setup ─────────────────────────────────────────
var ca  = document.getElementById('carea');
var cW  = ca.clientWidth  - 2;
var cH  = ca.clientHeight - 2;

var cv = new fabric.Canvas('c', {
  width:  cW,
  height: cH,
  backgroundColor: '#FFFFFF',
  selection: true,
  preserveObjectStacking: true
});

// Dot grid via after:render — drawn under objects by drawing before clear via renderCanvas override
// Using a simple approach: overlay very faint dots via after:render (they appear over objects
// but are 1px and very subtle — acceptable for demo)
cv.on('after:render', function() {
  var ctx = cv.getContext();
  var vp  = cv.viewportTransform;
  ctx.save();

  // Dot grid (zoom/pan aware)
  var zoom = vp[0], ox = vp[4], oy = vp[5];
  var gs = GRID * zoom;
  if (gs >= 6) {
    ctx.globalAlpha = Math.min(0.35, 0.12 + zoom * 0.08);
    ctx.fillStyle = '#A0A09A';
    var sx = ((ox % gs) + gs) % gs;
    var sy = ((oy % gs) + gs) % gs;
    for (var x = sx; x < cW + gs; x += gs) {
      for (var y = sy; y < cH + gs; y += gs) {
        ctx.fillRect(Math.round(x) - 0.5, Math.round(y) - 0.5, 1.5, 1.5);
      }
    }
  }

  // Wall endpoint circles — only for selected walls or snap targets
  ctx.globalAlpha = 1;
  cv.getObjects().forEach(function(o) {
    if (o._tool !== 'wall' || o._prev) return;
    var eps = wallEndpointsPt(o);
    var p1  = fabric.util.transformPoint(eps[0], vp);
    var p2  = fabric.util.transformPoint(eps[1], vp);
    var sw = o.strokeWidth || DEF_SW;
    var r  = Math.max(5, sw / 2 + 2);
    var isSelected = (cv.getActiveObject() === o);
    [p1, p2].forEach(function(p) {
      var snapped = currentSnapPt && Math.hypot(p.x - currentSnapPt.x, p.y - currentSnapPt.y) < 2;
      if (!isSelected && !snapped) return;
      ctx.beginPath();
      ctx.arc(p.x, p.y, r, 0, Math.PI * 2);
      ctx.fillStyle   = isSelected ? '#4F46E5' : '#3A3530';
      ctx.fill();
      ctx.strokeStyle = isSelected ? '#ffffff' : '#3A3530';
      ctx.lineWidth   = 2;
      ctx.stroke();
    });
  });

  // Smart snap guides + distance labels
  if (snapState.vLine !== null || snapState.hLine !== null || snapState.dists.length) {
    var toS = function(cx, cy) { return { x: cx*vp[0]+vp[4], y: cy*vp[3]+vp[5] }; };
    ctx.save();
    // Guide lines
    ctx.strokeStyle = 'rgba(220,50,50,0.75)';
    ctx.lineWidth   = 1;
    ctx.setLineDash([5,5]);
    if (snapState.vLine !== null) {
      var sx = snapState.vLine * vp[0] + vp[4];
      ctx.beginPath(); ctx.moveTo(sx, 0); ctx.lineTo(sx, cH); ctx.stroke();
    }
    if (snapState.hLine !== null) {
      var sy = snapState.hLine * vp[3] + vp[5];
      ctx.beginPath(); ctx.moveTo(0, sy); ctx.lineTo(cW, sy); ctx.stroke();
    }
    // Distance brackets
    ctx.setLineDash([]);
    ctx.strokeStyle = 'rgba(0,100,210,0.9)';
    ctx.lineWidth   = 1.5;
    ctx.font        = 'bold 11px -apple-system,sans-serif';
    ctx.textAlign   = 'center';
    ctx.textBaseline = 'middle';
    snapState.dists.forEach(function(d) {
      var CAP = 5;
      if (d.type === 'h') {
        var s1 = toS(d.x1, d.y), s2 = toS(d.x2, d.y);
        if (Math.abs(s2.x - s1.x) < 4) return;
        ctx.strokeStyle = 'rgba(0,100,210,0.9)';
        ctx.beginPath(); ctx.moveTo(s1.x, s1.y-CAP); ctx.lineTo(s1.x, s1.y+CAP); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(s1.x, s1.y); ctx.lineTo(s2.x, s1.y); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(s2.x, s2.y-CAP); ctx.lineTo(s2.x, s2.y+CAP); ctx.stroke();
        var mx = (s1.x+s2.x)/2, tw = ctx.measureText(d.text).width + 8;
        ctx.fillStyle = 'rgba(0,90,200,0.92)'; ctx.beginPath(); ctx.roundRect(mx-tw/2, s1.y-9, tw, 18, 3); ctx.fill();
        ctx.fillStyle = '#fff'; ctx.fillText(d.text, mx, s1.y);
      } else {
        var s1 = toS(d.x, d.y1), s2 = toS(d.x, d.y2);
        if (Math.abs(s2.y - s1.y) < 4) return;
        ctx.strokeStyle = 'rgba(0,100,210,0.9)';
        ctx.beginPath(); ctx.moveTo(s1.x-CAP, s1.y); ctx.lineTo(s1.x+CAP, s1.y); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(s1.x, s1.y); ctx.lineTo(s2.x, s2.y); ctx.stroke();
        ctx.beginPath(); ctx.moveTo(s2.x-CAP, s2.y); ctx.lineTo(s2.x+CAP, s2.y); ctx.stroke();
        var my = (s1.y+s2.y)/2, tw = ctx.measureText(d.text).width + 8;
        ctx.fillStyle = 'rgba(0,90,200,0.92)'; ctx.beginPath(); ctx.roundRect(s1.x-tw/2, my-9, tw, 18, 3); ctx.fill();
        ctx.fillStyle = '#fff'; ctx.fillText(d.text, s1.x, my);
      }
    });
    ctx.restore();
  }

  // Hover snap preview before first wall click
  if (isWallTool(activeTool) && !wallSt.on && _wallHoverPt) {
    var hp = fabric.util.transformPoint({ x: _wallHoverPt.x, y: _wallHoverPt.y }, vp);
    ctx.beginPath();
    ctx.arc(hp.x, hp.y, 5, 0, Math.PI * 2);
    ctx.fillStyle = 'rgba(79,70,229,0.35)';
    ctx.fill();
    ctx.strokeStyle = '#4F46E5';
    ctx.lineWidth = 1.5;
    ctx.stroke();
  }
  // Start-point dot — viewport transform 합성
  if (wallSt.on) {
    var sp = fabric.util.transformPoint({ x: wallSt.x1, y: wallSt.y1 }, vp);
    ctx.beginPath();
    ctx.arc(sp.x, sp.y, 5, 0, Math.PI * 2);
    ctx.fillStyle = '#4F46E5';
    ctx.fill();
    ctx.strokeStyle = '#ffffff';
    ctx.lineWidth = 1.5;
    ctx.stroke();
  }

  ctx.restore();
});

// ── Tool Management ───────────────────────────────────────
function toggleTg(id) {
  var body  = document.getElementById(id);
  var arrow = document.getElementById(id + '-arrow');
  if (!body) return;
  var closing = !body.classList.contains('collapsed');
  body.classList.toggle('collapsed', closing);
  if (arrow) arrow.textContent = closing ? '▸' : '▾';
}

function isWallTool(t) {
  return t === 'wall' || t === 'glass-wall' || t === 'dashed';
}

function getWallStyle() {
  if (activeTool === 'glass-wall') {
    return { stroke: '#5BB8E0', strokeWidth: DEF_SW, fill: 'rgba(91,184,224,0.18)',
             strokeDashArray: null, _wallStyle: 'glass' };
  }
  if (activeTool === 'dashed') {
    return { stroke: '#3A3530', strokeWidth: Math.max(1, DEF_SW - 1),
             strokeDashArray: [8, 5], _wallStyle: 'dashed' };
  }
  return { stroke: '#3A3530', strokeWidth: DEF_SW,
           strokeDashArray: null, _wallStyle: 'solid' };
}

function setTool(t) {
  if (scaleModeOn) { toast('축척 설정 중에는 도구를 사용할 수 없습니다'); return; }
  clearWallSnapPreview();
  doorDouble = (t === 'door2');
  var btnId = t;   // button to highlight
  if (t === 'door2') t = 'door';
  activeTool = t;
  document.querySelectorAll('.tool, .tg-hdr').forEach(function(b) { b.classList.remove('on', 'drawing'); });
  var el = document.getElementById('t-' + btnId);
  if (el) el.classList.add('on');

  cancelWall();
  cancelSection();

  if (t === 'select') {
    cv.selection = true;
    cv.defaultCursor = 'default';
    cv.hoverCursor   = 'move';
    cv.forEachObject(function(o) {
      if (o._bg || o._prev) return;
      if (o._tool === 'wall') {
        // Walls must NOT enter rubber-band ActiveSelection (containsWall blocks rotation),
        // but DO need evented=true so custom endpoint/body drag handlers can detect them.
        o.selectable = false;
        o.evented    = true;
        return;
      }
      var sel;
      if (currentStep === 2) {
        sel = (o._tool === 'furniture' || o._tool === 'section');
      } else {
        sel = (o._tool && o._tool !== 'furniture' && o._tool !== 'section');
      }
      o.selectable = sel;
      o.evented    = sel;
    });
    cv.renderAll();
  } else {
    cv.selection = false;
    cv.defaultCursor = 'crosshair';
    cv.hoverCursor   = 'crosshair';
    cv.discardActiveObject();
    cv.forEachObject(function(o) { o.selectable = false; o.evented = false; });
    cv.renderAll();
    showPanelEmpty();
  }
}

var SECTION_TYPES = [
  { id:'general', label:'일반 구역',      fill:'rgba(100,100,100,0.08)', stroke:'#AAAAAA', badge:'#9E9689' },
  { id:'meeting', label:'회의실',          fill:'rgba(59,130,246,0.08)',  stroke:'#60A5FA', badge:'#3B82F6' },
  { id:'hotdesk', label:'핫데스크 존',     fill:'rgba(245,158,11,0.09)',  stroke:'#FBBF24', badge:'#F59E0B' },
  { id:'lounge',  label:'휴게실',           fill:'rgba(16,185,129,0.09)', stroke:'#6EE7B7', badge:'#10B981' },
  { id:'focus',   label:'집중 업무 구역',   fill:'rgba(139,92,246,0.09)', stroke:'#C4B5FD', badge:'#8B5CF6' },
];
var _pendingSectionType = 'general';

function startSectionDraw(typeId) {
  if (currentStep !== 2) return;
  _pendingSectionType = typeId || 'general';
  activeTool = 'section';
  document.querySelectorAll('.tool, .tg-hdr').forEach(function(b) { b.classList.remove('on', 'drawing'); });
  var stype = SECTION_TYPES.find(function(t){ return t.id === _pendingSectionType; }) || SECTION_TYPES[0];
  // Mark quick row as active
  document.querySelectorAll('.s2-quickrow').forEach(function(r){ r.classList.remove('on'); });
  var qr = document.getElementById('s2-qr-section');
  if (qr) qr.classList.add('on', 'drawing');
  cv.selection = false;
  cv.defaultCursor = 'crosshair';
  cv.hoverCursor   = 'crosshair';
  cv.discardActiveObject();
  cv.forEachObject(function(o) { o.selectable = false; o.evented = false; });
  cv.renderAll();
  showPanelEmpty();
  toast(stype.label + ' 드래그로 범위를 지정하세요 · Esc 취소');
}

function cancelSection() {
  if (sectionSt.prev) { cv.remove(sectionSt.prev); cv.renderAll(); }
  sectionSt = { on: false, x0: 0, y0: 0, prev: null };
}

// ── Snap ─────────────────────────────────────────────────
function sg(v) { return Math.round(v / SNAP) * SNAP; }

function snapPt(x, y) {
  var best = null, bestD = SNAP_D;
  pts.forEach(function(p) {
    var d = Math.hypot(x - p.x, y - p.y);
    if (d < bestD) { bestD = d; best = p; }
  });
  if (best) {
    flashHint('끝점 스냅');
    currentSnapPt = best;
    return { x: best.x, y: best.y };
  }
  currentSnapPt = null;
  return { x: sg(x), y: sg(y) };
}

function snapAngle(x1, y1, x2, y2) {
  if (!altOn) return { x: x2, y: y2 };
  var dx = x2 - x1, dy = y2 - y1;
  var a  = Math.round(Math.atan2(dy, dx) / (Math.PI / 4)) * (Math.PI / 4);
  var d  = Math.hypot(dx, dy);
  return { x: x1 + Math.cos(a) * d, y: y1 + Math.sin(a) * d };
}

var hintTimer;
function flashHint(msg) {
  var el = document.getElementById('hint');
  el.textContent = msg;
  el.classList.add('show');
  clearTimeout(hintTimer);
  hintTimer = setTimeout(function() { el.classList.remove('show'); }, 900);
}

// ── Endpoint Drag (proximity-based) ──────────────────────
var epDragging   = null;  // { wall, idx, otherX, otherY } while dragging endpoint
var bodyDragging = null;  // { wall, sx, sy, ox1, oy1, ox2, oy2, oleft, otop } while dragging wall body
var snapState    = { vLine: null, hLine: null, dists: [] };  // smart snap guides + distance labels
var snapLock     = { x: null, y: null };  // hysteresis: { lockedLeft/Top, guideLine }

function wallEndpointsPt(wall) {
  // Returns canvas-pixel coordinates of both endpoints.
  // calcLinePoints() adds strokeWidth/2 inward offset — we use width/height
  // directly to get exact endpoints. calcTransformMatrix handles pan/zoom/move.
  var xMult = wall.x1 <= wall.x2 ? -1 : 1;
  var yMult = wall.y1 <= wall.y2 ? -1 : 1;
  var m = wall.calcTransformMatrix();
  return [
    fabric.util.transformPoint({ x:  xMult * wall.width / 2, y:  yMult * wall.height / 2 }, m),
    fabric.util.transformPoint({ x: -xMult * wall.width / 2, y: -yMult * wall.height / 2 }, m)
  ];
}

// ── Canvas Events ─────────────────────────────────────────
cv.on('mouse:down', function(e) {
  // Eyedropper: sample pixel from background image
  if (exEyedropper && bgImg) {
    exEyedropper = false;
    cv.defaultCursor = 'default';
    cv.hoverCursor   = 'default';
    cv.setCursor('default');
    if (cv.wrapperEl) cv.wrapperEl.classList.remove('cv-eyedropper');
    hideLoupe();
    document.getElementById('ex-eyedrop-btn').textContent = '다시 선택';
    var p = cv.getPointer(e.e);
    var col = sampleBgColor(p.x, p.y);
    if (col) {
      WALL_COLOR = col;
      var hex = '#' + col.map(function(c) { return c.toString(16).padStart(2, '0'); }).join('');
      document.getElementById('ex-wallcolor').value = hex;
      document.getElementById('ex-wallcolor-rgb').textContent = col.join(',');
      document.getElementById('ex-color-swatch').style.background = hex;
      // 색상 선택 완료 — 상세 UI 표시
      exColorPicked = true;
      document.getElementById('ex-pick-prompt').style.display = 'none';
      document.getElementById('ex-color-row').style.display   = 'flex';
      document.getElementById('ex-count').style.display       = 'block';
      document.getElementById('ex-count').textContent         = '분석 중…';
      document.getElementById('ex-confirm').style.display     = 'block';
      document.getElementById('ex-confirm').textContent       = '분석 중…';
      toast('색상 감지 완료, 분석 중…');
      runDetect();
    } else {
      toast('도면 영역을 클릭해주세요');
      startEyedropper();
    }
    return;
  }
  if (exExtractActive) return;   // wall auto-extract preview lock
  // Calibration line drawing
  if (scaleModeOn) {
    var p = cv.getPointer(e.e);
    if (!calibSt.pt1) {
      calibSt.pt1 = { x: p.x, y: p.y };
      calibSt.dot1 = new fabric.Circle({
        left: p.x, top: p.y, radius: 5,
        fill: '#FF3B30', stroke: '#fff', strokeWidth: 1.5,
        originX: 'center', originY: 'center',
        selectable: false, evented: false, _calib: true
      });
      cv.add(calibSt.dot1);
      cv.renderAll();
      flashHint('두 번째 점을 클릭하세요');
    } else if (!calibSt.pt2) {
      if (calibSt.prev) { cv.remove(calibSt.prev); calibSt.prev = null; }
      calibSt.pt2 = { x: p.x, y: p.y };
      finishCalibLine(calibSt.pt1, calibSt.pt2);
    }
    return;
  }

  // Endpoint drag: check ALL walls (circle is drawn via after:render, extends beyond line hit area)
  // Skip if user clicked on a non-wall selectable object (e.g. door/window resize handle)
  if (activeTool === 'select' && (!e.target || e.target._tool === 'wall' || e.target._prev)) {
    var p   = cv.getPointer(e.e);
    var HIT = 14 / cv.getZoom();
    var walls = cv.getObjects().filter(function(o) { return o._tool === 'wall' && !o._prev; });
    for (var wi = 0; wi < walls.length; wi++) {
      var w  = walls[wi];
      var eps = wallEndpointsPt(w);
      for (var i = 0; i < eps.length; i++) {
        if (Math.hypot(eps[i].x - p.x, eps[i].y - p.y) < HIT) {
          cv.setActiveObject(w);
          // Record the OTHER endpoint position NOW (once) so moveLineEndpoint
          // never needs to re-derive it from a potentially stale/scaled wall.
          var otherEps = wallEndpointsPt(w);
          epDragging = { wall: w, idx: i,
                         otherX: otherEps[1 - i].x, otherY: otherEps[1 - i].y };
          w.lockMovementX = w.lockMovementY = true;
          cv.selection = false;
          cv._groupSelector = null;
          cv.setCursor('crosshair');
          cv.requestRenderAll();
          return;
        }
      }
    }
  }
  // Ctrl/Cmd + drag → pan (higher priority than body drag)
  if ((e.e.ctrlKey || e.e.metaKey) && activeTool === 'select') {
    isPanning = true;
    lastPanX  = e.e.clientX;
    lastPanY  = e.e.clientY;
    cv.setCursor('grabbing');
    return;
  }

  // Wall body drag: click on wall line (not near endpoint) → move whole wall
  if (activeTool === 'select') {
    var pb   = cv.getPointer(e.e);
    var BHIT = 9 / cv.getZoom();
    var walls2 = cv.getObjects().filter(function(o) { return o._tool === 'wall' && !o._prev; });
    for (var bi = 0; bi < walls2.length; bi++) {
      var wb  = walls2[bi];
      var epsb = wallEndpointsPt(wb);
      var ex = epsb[1].x - epsb[0].x, ey = epsb[1].y - epsb[0].y;
      var len2 = ex*ex + ey*ey;
      var t = len2 > 0 ? Math.max(0, Math.min(1, ((pb.x-epsb[0].x)*ex + (pb.y-epsb[0].y)*ey) / len2)) : 0;
      var nearX = epsb[0].x + t*ex, nearY = epsb[0].y + t*ey;
      if (Math.hypot(pb.x - nearX, pb.y - nearY) < BHIT) {
        cv.setActiveObject(wb);
        bodyDragging = { wall: wb, sx: pb.x, sy: pb.y,
          ox1: wb.x1, oy1: wb.y1, ox2: wb.x2, oy2: wb.y2,
          oleft: wb.left, otop: wb.top };
        cv.selection = false;
        cv.setCursor('move');
        cv.requestRenderAll();
        return;
      }
    }
  }

  // Pan: Space held
  if (spaceDown) {
    isPanning = true;
    lastPanX  = e.e.clientX;
    lastPanY  = e.e.clientY;
    cv.setCursor('grabbing');
    return;
  }
  if (activeTool === 'select') return;
  var p  = cv.getPointer(e.e);
  var sp = snapPt(p.x, p.y);
  if (isWallTool(activeTool)) {
    if (!wallSt.on) {
      var _startPt = _wallHoverPt || sp;
      _wallHoverPt = null;
      startWall(_startPt.x, _startPt.y);
    } else {
      _wallHoverPt = null;
      var ap = snapAngle(wallSt.x1, wallSt.y1, sp.x, sp.y);
      finishWall(ap.x, ap.y);
    }
  } else if (activeTool === 'door') {
    var _doorSnap = wallSnapTarget;
    if (!_doorSnap) {
      var _autoSnap = findNearestWall(sp.x, sp.y, 100);
      if (_autoSnap) {
        var _autoW = doorDouble ? DOOR2_W : DOOR_W;
        if (_autoSnap._isVirtual) _autoW = Math.round(_autoSnap.len);
        var _autoGap = calcSnapGap(_autoSnap, _autoW);
        if (_autoGap.ok) {
          _doorSnap = _autoSnap;
          _lastSnapOpenDir = computeOpenDir(_autoSnap, sp.x, sp.y, 1);
        }
      }
    }
    clearWallSnapPreview();
    var _od = _doorSnap ? (_lastSnapOpenDir || 1) : 1;
    if (doorDouble) {
      if (_doorSnap) placeDoubleDoorOnWall(_doorSnap, _od);
      else placeDoubleDoor(sp.x, sp.y);
    } else {
      if (_doorSnap) placeDoorOnWall(_doorSnap, _od);
      else placeDoor(sp.x, sp.y);
    }
  } else if (activeTool === 'window') {
    var _winSnap = wallSnapTarget;
    clearWallSnapPreview();
    if (_winSnap) placeWinOnWall(_winSnap);
    else placeWin(sp.x, sp.y);
  } else if (activeTool === 'column')  placeCol(sp.x, sp.y);
  else if (activeTool === 'section') {
    var gp = cv.getPointer(e.e);
    sectionSt = { on: true, x0: sg(gp.x), y0: sg(gp.y), prev: null };
  }
});

cv.on('mouse:move', function(e) {
  if (exEyedropper) {
    var p = cv.getPointer(e.e);
    updateLoupe(p.x, p.y, e.e.clientX, e.e.clientY);
    return;
  }
  // Door / window wall-snap preview
  if (activeTool === 'door' || activeTool === 'window') {
    var p = cv.getPointer(e.e);
    var snap = findNearestWall(p.x, p.y, 50);
    if (snap) {
      if (snap._isVirtual) {
        // Reject virtual gaps that are too small (window-sized) or too large to be doors
        wallSnapTarget = (snap.len >= 25 && snap.len <= 150) ? snap : null;
      } else {
        var gapW = activeTool === 'window' ? WIN_W : (doorDouble ? DOOR2_W : DOOR_W);
        var gap  = calcSnapGap(snap, gapW);
        wallSnapTarget = gap.ok ? snap : null;
      }
    } else {
      wallSnapTarget = null;
    }
    updateWallSnapPreview(wallSnapTarget, p.x, p.y);
    return;
  }
  // Calibration line preview
  if (scaleModeOn && calibSt.pt1 && !calibSt.pt2) {
    var p = cv.getPointer(e.e);
    if (calibSt.prev) cv.remove(calibSt.prev);
    calibSt.prev = new fabric.Line(
      [calibSt.pt1.x, calibSt.pt1.y, p.x, p.y],
      { stroke: '#FF3B30', strokeWidth: 1.5, strokeDashArray: [6, 3],
        selectable: false, evented: false, _calib: true, opacity: 0.8 }
    );
    cv.add(calibSt.prev);
    cv.renderAll();
    return;
  }

  // Endpoint drag
  if (epDragging) {
    var p  = cv.getPointer(e.e);
    var sp = { x: sg(p.x), y: sg(p.y) };
    var HIT2 = SNAP_D;
    cv.getObjects().forEach(function(o) {
      if (o._tool !== 'wall' || o._prev) return;
      wallEndpointsPt(o).forEach(function(ep, ei) {
        if (o === epDragging.wall && ei === epDragging.idx) return;
        if (Math.hypot(ep.x - p.x, ep.y - p.y) < HIT2) { sp = ep; }
      });
    });
    moveLineEndpoint(epDragging.wall, epDragging.idx, sp.x, sp.y,
                     epDragging.otherX, epDragging.otherY);
    cv.requestRenderAll();
    return;
  }
  // Wall body drag
  if (bodyDragging) {
    var p = cv.getPointer(e.e);
    var dx = Math.round((p.x - bodyDragging.sx) / SNAP) * SNAP;
    var dy = Math.round((p.y - bodyDragging.sy) / SNAP) * SNAP;
    bodyDragging.wall.set({
      x1: bodyDragging.ox1 + dx, y1: bodyDragging.oy1 + dy,
      x2: bodyDragging.ox2 + dx, y2: bodyDragging.oy2 + dy,
      left: bodyDragging.oleft + dx, top: bodyDragging.otop + dy
    });
    bodyDragging.wall.setCoords();
    rebuildPts();
    cv.requestRenderAll();
    return;
  }
  // Section draw preview
  if (sectionSt.on) {
    var p  = cv.getPointer(e.e);
    var x  = sg(p.x), y = sg(p.y);
    var rx = Math.min(sectionSt.x0, x), ry = Math.min(sectionSt.y0, y);
    var rw = Math.abs(x - sectionSt.x0), rh = Math.abs(y - sectionSt.y0);
    if (sectionSt.prev) { cv.remove(sectionSt.prev); sectionSt.prev = null; }
    if (rw > 4 && rh > 4) {
      sectionSt.prev = new fabric.Rect({
        left: rx, top: ry, width: rw, height: rh,
        fill: 'rgba(100,100,100,0.05)', stroke: '#999',
        strokeWidth: 1.5, strokeDashArray: [6, 3],
        selectable: false, evented: false, _prev: true
      });
      cv.add(sectionSt.prev);
    }
    cv.renderAll();
    return;
  }
  if (isPanning) {
    var dx = e.e.clientX - lastPanX;
    var dy = e.e.clientY - lastPanY;
    cv.relativePan(new fabric.Point(dx, dy));
    lastPanX = e.e.clientX;
    lastPanY = e.e.clientY;
    return;
  }
  if (!isWallTool(activeTool)) {
    if (currentSnapPt) { currentSnapPt = null; cv.renderAll(); }
    if (_wallHoverPt) { _wallHoverPt = null; cv.renderAll(); }
    return;
  }
  var p  = cv.getPointer(e.e);
  var sp = snapPt(p.x, p.y);
  if (wallSt.on) {
    _wallHoverPt = null;
    var ap = snapAngle(wallSt.x1, wallSt.y1, sp.x, sp.y);
    updateWallPrev(ap.x, ap.y);
  } else {
    _wallHoverPt = sp;
    cv.renderAll();
  }
});

cv.on('mouse:out', function() {
  if (exEyedropper) hideLoupe();
  clearWallSnapPreview();  // always clear; no-op if empty, safe across rapid tool switches
  if (currentSnapPt) { currentSnapPt = null; cv.renderAll(); }
  if (_wallHoverPt) { _wallHoverPt = null; cv.renderAll(); }
});

cv.on('mouse:up', function(e) {
  if (epDragging) {
    epDragging = null;
    rebuildPts();
    updatePanel();
    cv.selection = true;
    cv.setCursor('default');
    return;
  }
  if (bodyDragging) {
    bodyDragging.wall.setCoords();
    bodyDragging = null;
    rebuildPts();
    updatePanel();
    cv.selection = true;
    cv.setCursor('default');
    cv.renderAll();
    debouncePushHistory();
    return;
  }
  // Section draw finish
  if (sectionSt.on) {
    var p  = cv.getPointer(e.e);
    var x  = sg(p.x), y = sg(p.y);
    var rx = Math.min(sectionSt.x0, x), ry = Math.min(sectionSt.y0, y);
    var rw = Math.abs(x - sectionSt.x0), rh = Math.abs(y - sectionSt.y0);
    if (sectionSt.prev) { cv.remove(sectionSt.prev); }
    sectionSt = { on: false, x0: 0, y0: 0, prev: null };
    if (rw >= 20 && rh >= 20) {
      placeSection(rx, ry, rw, rh);
    } else {
      cv.renderAll();
    }
    return;
  }
  if (isPanning) {
    isPanning = false;
    cv.setCursor(spaceDown ? 'grab' : (activeTool === 'select' ? 'default' : 'crosshair'));
  }
});

cv.on('selection:created', function() { updatePanel(); highlightSectionChildren(); });
cv.on('selection:updated', function() { updatePanel(); highlightSectionChildren(); });
cv.on('selection:cleared', function() { clearSectionChildHL(); showPanelEmpty(); });

function highlightSectionChildren() {
  clearSectionChildHL();
  var obj = cv.getActiveObject();
  if (!obj || obj._tool !== 'section' || !obj._id) return;
  var sid = obj._id;
  cv.getObjects().forEach(function(o) {
    if (o._sectionId !== sid || o._bg || o._prev) return;
    var orig = { stroke: o.stroke, strokeWidth: o.strokeWidth };
    o._secHL = orig;
    o.set({ stroke: '#4F46E5', strokeWidth: 2 });
  });
  cv.renderAll();
}

function clearSectionChildHL() {
  cv.getObjects().forEach(function(o) {
    if (!o._secHL) return;
    o.set({ stroke: o._secHL.stroke, strokeWidth: o._secHL.strokeWidth });
    delete o._secHL;
  });
  cv.renderAll();
}

// ── Smart snap + distance display ────────────────────────
function pxToRealDist(px) {
  if (!pxPerM || px <= 0) return Math.round(px) + 'px';
  var cm = px / pxPerM * 100;
  if (cm >= 100) return parseFloat((cm / 100).toFixed(1)) + 'm';
  return Math.round(cm) + 'cm';
}

// ── Door / window ↔ wall syncing ─────────────────────────

// Compute which side of the wall the cursor is on.
// Returns 1 if cursor is on the "standard" opening side, -1 if opposite.
function computeOpenDir(snap, px, py, prevOd) {
  var rad = snap.angle * Math.PI / 180;
  var odx = -Math.sin(rad), ody = Math.cos(rad);
  var side = odx * (px - snap.projX) + ody * (py - snap.projY);
  var newOd = side >= 0 ? 1 : -1;
  // Hysteresis: require 8px clearance before flipping direction
  if (prevOd && newOd !== prevOd && Math.abs(side) < 8) return prevOd;
  return newOd;
}

// Creates a width-resize control (ml or mr) offset perpendicularly from the wall.
// yOff: pixels in local Y to shift the handle away from the wall line.
function makeWallResizeCtrl(isLeft, yOff) {
  var std = fabric.Object.prototype.controls[isLeft ? 'ml' : 'mr'];
  return new fabric.Control({
    x: isLeft ? -0.5 : 0.5,
    y: 0,
    offsetX: 0,
    offsetY: yOff || 0,
    actionHandler: std.actionHandler,
    getActionName: std.getActionName,
    cursorStyleHandler: std.cursorStyleHandler,
    render: std.render
  });
}

// Store gap endpoint positions in the door's local coordinate system.
// This lets syncDoorWalls compute exact canvas positions after scaling.
function storeDoorLocalGap(grp, pt1canvas, pt2canvas) {
  var m = fabric.util.invertTransform(grp.calcTransformMatrix());
  grp._localPt1 = fabric.util.transformPoint({ x: pt1canvas.x, y: pt1canvas.y }, m);
  grp._localPt2 = fabric.util.transformPoint({ x: pt2canvas.x, y: pt2canvas.y }, m);
}

// Get current canvas positions of gap endpoints from stored local coords.
function getDoorGapPts(grp) {
  if (!grp._localPt1) return null;
  var m = grp.calcTransformMatrix();
  return {
    pt1: fabric.util.transformPoint(grp._localPt1, m),
    pt2: fabric.util.transformPoint(grp._localPt2, m)
  };
}

// Project point onto the infinite line defined by a wall segment (keeps angle intact).
function projectOnWallLine(pt, wallSeg) {
  var dx = wallSeg.x2 - wallSeg.x1, dy = wallSeg.y2 - wallSeg.y1;
  var len2 = dx * dx + dy * dy;
  if (len2 === 0) return { x: wallSeg.x1, y: wallSeg.y1 };
  var t = ((pt.x - wallSeg.x1) * dx + (pt.y - wallSeg.y1) * dy) / len2;
  return { x: wallSeg.x1 + t * dx, y: wallSeg.y1 + t * dy };
}

function syncDoorWalls(door) {
  if (door._isEndpointGap) return; // endpoint-pair gap: walls are independent, don't stretch them
  var gpts = getDoorGapPts(door);
  if (!gpts) return;
  var wL = door._wallL, wR = door._wallR;

  if (door._isVirtualGap) {
    // Virtual-gap door: move the specific gap-endpoint of each original wall
    if (wL && wL.canvas) {
      var lIdx = door._wallLGapIdx != null ? door._wallLGapIdx : 1;
      var lEps = wallEndpointsPt(wL);
      var lGapPt = lEps[lIdx], lOtherPt = lEps[1 - lIdx];
      var d1 = Math.hypot(gpts.pt1.x - lGapPt.x, gpts.pt1.y - lGapPt.y);
      var d2 = Math.hypot(gpts.pt2.x - lGapPt.x, gpts.pt2.y - lGapPt.y);
      var rawL = d1 < d2 ? gpts.pt1 : gpts.pt2;
      var wsL = { x1: lEps[0].x, y1: lEps[0].y, x2: lEps[1].x, y2: lEps[1].y };
      var ptL = projectOnWallLine(rawL, wsL);
      applyWallEp(wL, lIdx, ptL.x, ptL.y, lOtherPt.x, lOtherPt.y);
      wL.setCoords();
    }
    if (wR && wR.canvas) {
      var rIdx = door._wallRGapIdx != null ? door._wallRGapIdx : 0;
      var rEps = wallEndpointsPt(wR);
      var rGapPt = rEps[rIdx], rOtherPt = rEps[1 - rIdx];
      var dr1 = Math.hypot(gpts.pt1.x - rGapPt.x, gpts.pt1.y - rGapPt.y);
      var dr2 = Math.hypot(gpts.pt2.x - rGapPt.x, gpts.pt2.y - rGapPt.y);
      var rawR = dr1 < dr2 ? gpts.pt1 : gpts.pt2;
      var wsR = { x1: rEps[0].x, y1: rEps[0].y, x2: rEps[1].x, y2: rEps[1].y };
      var ptR = projectOnWallLine(rawR, wsR);
      applyWallEp(wR, rIdx, ptR.x, ptR.y, rOtherPt.x, rOtherPt.y);
      wR.setCoords();
    }
  } else {
    // Regular wall-split door: move the stubs' inner endpoints
    var ptL = null, ptR = null;
    if (wL && wL.canvas) {
      var d1 = Math.hypot(gpts.pt1.x - wL.x2, gpts.pt1.y - wL.y2);
      var d2 = Math.hypot(gpts.pt2.x - wL.x2, gpts.pt2.y - wL.y2);
      var rawL = d1 < d2 ? gpts.pt1 : gpts.pt2;
      ptL = projectOnWallLine(rawL, wL);
      applyWallEp(wL, 1, ptL.x, ptL.y, wL.x1, wL.y1);
      wL.setCoords();
    }
    if (wR && wR.canvas) {
      var dr1 = Math.hypot(gpts.pt1.x - wR.x1, gpts.pt1.y - wR.y1);
      var dr2 = Math.hypot(gpts.pt2.x - wR.x1, gpts.pt2.y - wR.y1);
      var rawR = dr1 < dr2 ? gpts.pt1 : gpts.pt2;
      ptR = projectOnWallLine(rawR, wR);
      applyWallEp(wR, 0, ptR.x, ptR.y, wR.x2, wR.y2);
      wR.setCoords();
    }
    // Keep _gapPt1/_gapPt2 in sync so undo/redo snapshots have accurate inner endpoints
    if (ptL) door._gapPt1 = { x: ptL.x, y: ptL.y };
    if (ptR) door._gapPt2 = { x: ptR.x, y: ptR.y };
  }
  // Callers are responsible for rebuildPts() — avoids double rebuild when chained
  cv.requestRenderAll();
}

function restoreGapWalls(door) {
  if (door._isVirtualGap) {
    // Endpoint-pair gap: walls were never modified, just clear refs
    if (door._isEndpointGap) {
      door._wallL = null; door._wallR = null;
      rebuildPts();
      return;
    }
    // Virtual-gap door: restore original gap endpoints, then just detach
    var wL = door._wallL, wR = door._wallR;
    if (wL && wL.canvas && door._wallLOrigPt) {
      var lIdx = door._wallLGapIdx != null ? door._wallLGapIdx : 1;
      var lEps = wallEndpointsPt(wL);
      var lOtherPt = lEps[1 - lIdx];
      applyWallEp(wL, lIdx, door._wallLOrigPt.x, door._wallLOrigPt.y, lOtherPt.x, lOtherPt.y);
      wL.setCoords();
    }
    if (wR && wR.canvas && door._wallROrigPt) {
      var rIdx = door._wallRGapIdx != null ? door._wallRGapIdx : 0;
      var rEps = wallEndpointsPt(wR);
      var rOtherPt = rEps[1 - rIdx];
      applyWallEp(wR, rIdx, door._wallROrigPt.x, door._wallROrigPt.y, rOtherPt.x, rOtherPt.y);
      wR.setCoords();
    }
    door._wallL = null; door._wallR = null;
    rebuildPts();
    return;
  }
  // Regular wall-split door: remove stubs and recreate merged wall
  var wL = door._wallL, wR = door._wallR;
  var ox1, oy1, ox2, oy2;
  // Capture style from whichever stub exists before removing
  var ws = { stroke: '#3A3530', strokeWidth: DEF_SW, strokeDashArray: null, _wallStyle: null };
  var styleRef = (wL && wL.canvas) ? wL : (wR && wR.canvas) ? wR : null;
  if (styleRef) {
    ws.stroke = styleRef.stroke || '#3A3530';
    ws.strokeWidth = styleRef.strokeWidth || DEF_SW;
    ws.strokeDashArray = styleRef.strokeDashArray ? styleRef.strokeDashArray.slice() : null;
    ws._wallStyle = styleRef._wallStyle || null;
  }
  if (wL && wL.canvas) {
    ox1 = wL.x1; oy1 = wL.y1;
    cv.remove(wL);
  } else if (wL && door._gapPt1) {
    ox1 = door._gapPt1.x; oy1 = door._gapPt1.y;
  }
  if (wR && wR.canvas) {
    ox2 = wR.x2; oy2 = wR.y2;
    cv.remove(wR);
  } else if (wR && door._gapPt2) {
    ox2 = door._gapPt2.x; oy2 = door._gapPt2.y;
  }
  if (ox1 !== undefined && ox2 !== undefined) {
    var segOpts = {
      stroke: ws.stroke, strokeWidth: ws.strokeWidth,
      strokeLineCap: 'round', strokeUniform: true,
      selectable: false, evented: false, _tool: 'wall', _wallStyle: ws._wallStyle
    };
    if (ws.strokeDashArray) segOpts.strokeDashArray = ws.strokeDashArray;
    var seg = new fabric.Line([ox1, oy1, ox2, oy2], segOpts);
    cv.add(seg);
    makeWallEditable(seg);
  }
  door._wallL = null; door._wallR = null;
  rebuildPts();
}

var _dragSnapTarget = null;  // wall snap target while dragging door/window

cv.on('object:moving', function(e) {
  var obj = e.target;
  if (obj._tool === 'wall') return;
  // Wall-snap for door/window being dragged
  if (obj._tool === 'door' || obj._tool === 'window') {
    obj._lastAct = 'move';
    // Real-time detach: restore wall immediately when door moves perpendicular past threshold
    if (obj._wallL && obj._wallR && !obj._isVirtualGap && obj._gapPt1 && obj._gapPt2) {
      var _gpts0 = getDoorGapPts(obj);
      if (_gpts0) {
        var _curMidX = (_gpts0.pt1.x + _gpts0.pt2.x) / 2;
        var _curMidY = (_gpts0.pt1.y + _gpts0.pt2.y) / 2;
        var _origMidX = (obj._gapPt1.x + obj._gapPt2.x) / 2;
        var _origMidY = (obj._gapPt1.y + obj._gapPt2.y) / 2;
        var _ddx = _curMidX - _origMidX, _ddy = _curMidY - _origMidY;
        var _wlEps = wallEndpointsPt(obj._wallL);
        var _wdx = _wlEps[1].x - _wlEps[0].x, _wdy = _wlEps[1].y - _wlEps[0].y;
        var _wLen = Math.hypot(_wdx, _wdy);
        if (_wLen > 0) {
          var _perpDist = Math.abs((-_wdy * _ddx + _wdx * _ddy) / _wLen);
          if (_perpDist > 15) {
            restoreGapWalls(obj);
            cv.requestRenderAll();
          }
        }
      }
    }
    // Use wall-attachment edge midpoint as snap reference (not bbox center)
    var gpts = getDoorGapPts(obj);
    var snapRefX = gpts ? (gpts.pt1.x + gpts.pt2.x) / 2 : obj.left;
    var snapRefY = gpts ? (gpts.pt1.y + gpts.pt2.y) / 2 : obj.top;
    var gapW = (obj._tool === 'window') ? WIN_W : (obj._doorDouble ? DOOR2_W : DOOR_W);
    var snap = findNearestWall(snapRefX, snapRefY, 36);
    // Exclude snaps to the door's own adjacent walls (stubs or virtual-gap originals)
    if (snap && !snap._isVirtual && (snap.wall === obj._wallL || snap.wall === obj._wallR)) snap = null;
    // Exclude virtual gap formed by the door's own wall stubs (prevents re-snapping own gap during perpendicular drag)
    if (snap && snap._isVirtual) {
      var sa = snap._wallA, sb = snap._wallB;
      var oL = obj._wallL, oR = obj._wallR;
      var aIsOwn = (oL && sa === oL) || (oR && sa === oR);
      var bIsOwn = (oL && sb === oL) || (oR && sb === oR);
      if (aIsOwn || bIsOwn) snap = null;
    }
    if (snap) {
      var gapWv = snap._isVirtual ? Math.round(snap.len) : gapW;
      var gap = calcSnapGap(snap, gapWv);
      _dragSnapTarget = gap.ok ? snap : null;
    } else {
      _dragSnapTarget = null;
    }
    _clearSnapObjs();
    if (_dragSnapTarget) {
      // Pass door body center for stable open-direction detection
      updateWallSnapPreview(_dragSnapTarget, obj.left, obj.top);
    } else {
      cv.requestRenderAll();
    }
  }
  snapState = { vLine: null, hLine: null, dists: [] };

  var zoom         = cv.getZoom();
  var SNAP_THRESH  = 8  / zoom;
  var RELEASE_THRESH = 16 / zoom;

  var naturalLeft = obj.left;
  var naturalTop  = obj.top;
  var coordsDirty = false;

  // Hysteresis: re-apply existing lock if still within release threshold
  var lockedX = false, lockedY = false;
  if (snapLock.x !== null) {
    if (Math.abs(naturalLeft - snapLock.x.lockedLeft) < RELEASE_THRESH) {
      obj.set('left', snapLock.x.lockedLeft);
      snapState.vLine = snapLock.x.guideLine;
      lockedX = true; coordsDirty = true;
    } else {
      snapLock.x = null;
    }
  }
  if (snapLock.y !== null) {
    if (Math.abs(naturalTop - snapLock.y.lockedTop) < RELEASE_THRESH) {
      obj.set('top', snapLock.y.lockedTop);
      snapState.hLine = snapLock.y.guideLine;
      lockedY = true; coordsDirty = true;
    } else {
      snapLock.y = null;
    }
  }
  if (coordsDirty) obj.setCoords();

  // Search for new snaps only on unlocked axes
  if (!lockedX || !lockedY) {
    var bm = _getObjBounds(obj);
    var ML = bm.left, MR = bm.left + bm.width,  MCX = ML + bm.width  / 2;
    var MT = bm.top,  MB = bm.top  + bm.height, MCY = MT + bm.height / 2;

    var bestDX = null, bestDXD = SNAP_THRESH, bestDXG = null;
    var bestDY = null, bestDYD = SNAP_THRESH, bestDYG = null;

    cv.getObjects().forEach(function(o) {
      if (o === obj || o._bg || o._prev || !o._tool || o._tool === 'wall') return;
      var bo = _getObjBounds(o);
      var OL = bo.left, OR = OL + bo.width,  OCX = OL + bo.width  / 2;
      var OT = bo.top,  OB = OT + bo.height, OCY = OT + bo.height / 2;
      if (!lockedX) {
        [[OL,ML],[OR,ML],[OL,MR],[OR,MR],[OCX,MCX]].forEach(function(p) {
          var d = Math.abs(p[0] - p[1]);
          if (d < bestDXD) { bestDXD = d; bestDX = p[0] - p[1]; bestDXG = p[0]; }
        });
      }
      if (!lockedY) {
        [[OT,MT],[OB,MT],[OT,MB],[OB,MB],[OCY,MCY]].forEach(function(p) {
          var d = Math.abs(p[0] - p[1]);
          if (d < bestDYD) { bestDYD = d; bestDY = p[0] - p[1]; bestDYG = p[0]; }
        });
      }
    });

    if (!lockedX && bestDX !== null) {
      obj.set('left', naturalLeft + bestDX); obj.setCoords();
      snapState.vLine = bestDXG;
      snapLock.x = { lockedLeft: naturalLeft + bestDX, guideLine: bestDXG };
    }
    if (!lockedY && bestDY !== null) {
      obj.set('top', naturalTop + bestDY); obj.setCoords();
      snapState.hLine = bestDYG;
      snapLock.y = { lockedTop: naturalTop + bestDY, guideLine: bestDYG };
    }
  }

  // Distance measurements (always based on final position)
  var nearL = null, nearR = null, nearT = null, nearB = null;
  var bm2 = _getObjBounds(obj);
  var ML2 = bm2.left, MR2 = ML2 + bm2.width, MT2 = bm2.top, MB2 = MT2 + bm2.height;

  cv.getObjects().forEach(function(o) {
    if (o === obj || o._bg || o._prev || !o._tool || o._tool === 'wall') return;
    var bo = _getObjBounds(o);
    var OL = bo.left, OR = OL + bo.width;
    var OT = bo.top,  OB = OT + bo.height;
    var vOvlp = OT < MB2 && OB > MT2;
    var hOvlp = OL < MR2 && OR > ML2;
    if (vOvlp) {
      var midY = Math.max(OT,MT2) + (Math.min(OB,MB2) - Math.max(OT,MT2)) / 2;
      if (OL >= MR2) { var g=OL-MR2; if (!nearR||g<nearR.gap) nearR={gap:g,x1:MR2,x2:OL,midY:midY}; }
      if (OR <= ML2) { var g=ML2-OR; if (!nearL||g<nearL.gap) nearL={gap:g,x1:OR,x2:ML2,midY:midY}; }
    }
    if (hOvlp) {
      var midX = Math.max(OL,ML2) + (Math.min(OR,MR2) - Math.max(OL,ML2)) / 2;
      if (OT >= MB2) { var g=OT-MB2; if (!nearB||g<nearB.gap) nearB={gap:g,y1:MB2,y2:OT,midX:midX}; }
      if (OB <= MT2) { var g=MT2-OB; if (!nearT||g<nearT.gap) nearT={gap:g,y1:OB,y2:MT2,midX:midX}; }
    }
  });

  if (nearL) snapState.dists.push({ type:'h', x1:nearL.x1, x2:nearL.x2, y:nearL.midY, text:pxToRealDist(nearL.gap) });
  if (nearR) snapState.dists.push({ type:'h', x1:nearR.x1, x2:nearR.x2, y:nearR.midY, text:pxToRealDist(nearR.gap) });
  if (nearT) snapState.dists.push({ type:'v', x:nearT.midX, y1:nearT.y1, y2:nearT.y2, text:pxToRealDist(nearT.gap) });
  if (nearB) snapState.dists.push({ type:'v', x:nearB.midX, y1:nearB.y1, y2:nearB.y2, text:pxToRealDist(nearB.gap) });
});

cv.on('object:scaling', function(e) {
  var obj = e.target;
  if (obj._tool === 'door' || obj._tool === 'window') obj._lastAct = 'scale';
  var walls = obj._tool === 'wall' ? [obj]
    : obj.type === 'activeSelection' ? obj.getObjects().filter(function(o) { return o._tool === 'wall'; })
    : [];
  walls.forEach(function(w) { w.set({ scaleX: 1, scaleY: 1 }); w.setCoords(); });
});

cv.on('object:rotating', function(e) {
  var obj = e.target;

  if (obj._tool === 'wall') {
    obj.set('angle', 0);
    obj.setCoords();
    return;
  }

  // ActiveSelection: block if it contains walls, otherwise allow free rotation.
  // Applying angle-snap to an activeSelection mid-drag corrupts child positions.
  if (obj.type === 'activeSelection') {
    var containsWall = obj.getObjects().some(function(o) { return o._tool === 'wall'; });
    if (containsWall) {
      obj.set('angle', 0);
      obj.setCoords();
      cv.renderAll();
    }
    return; // no snap for multi-select — let Fabric handle freely
  }

  var angle   = ((obj.angle % 360) + 360) % 360;
  var isDoorWin = (obj._tool === 'door' || obj._tool === 'window');
  var shiftHeld = e.e && e.e.shiftKey;
  var step    = isDoorWin ? (shiftHeld ? 5 : 15) : 90;
  var thresh  = step <= 5 ? 2 : (step < 45 ? 5 : 8);
  var snapped = Math.round(angle / step) * step;
  if (Math.abs(angle - snapped) < thresh) {
    obj.set('angle', snapped % 360);
    obj.setCoords();
  }
  updatePanel();
});

cv.on('object:modified', function(e) {
  snapState = { vLine: null, hLine: null, dists: [] };
  snapLock  = { x: null, y: null };
  clearWallSnapPreview();

  // Re-snap or wall-sync for moved/scaled door/window
  var tgt = e.target;
  if (tgt && (tgt._tool === 'door' || tgt._tool === 'window')) {
    // Use e.action (Fabric v5) and _lastAct as fallback to determine action type
    var evtAction = e.action || (e.transform && e.transform.action) || '';
    var isScale = /scale/i.test(evtAction) || tgt._lastAct === 'scale';
    var isDrag  = evtAction === 'drag' || evtAction === 'move' || tgt._lastAct === 'move';

    if (_dragSnapTarget && isDrag) {
      // Re-place on new wall: restore original walls, then place on snap target
      var _snapTgt = _dragSnapTarget;
      var _doorDbl = tgt._doorDouble;
      var _toolTgt = tgt._tool;
      restoreGapWalls(tgt);
      cv.remove(tgt);
      var _styleT = tgt._doorStyle;
      if (_toolTgt === 'door') {
        if (_styleT === 'arch') placeArchOnWall(_snapTgt, _lastSnapOpenDir);
        else if (_doorDbl) placeDoubleDoorOnWall(_snapTgt, _lastSnapOpenDir);
        else placeDoorOnWall(_snapTgt, _lastSnapOpenDir);
      } else {
        if (_styleT === 'sliding') placeSlidingDoorOnWall(_snapTgt);
        else placeWinOnWall(_snapTgt);
      }
      _dragSnapTarget = null;
      rebuildPts();
      debouncePushHistory();
      return;
    } else if (isScale) {
      // Resizing: sync adjacent wall endpoints to match new door size
      syncDoorWalls(tgt);
    } else if (isDrag) {
      // Moved without snapping to a wall: restore the original gap walls, detach
      restoreGapWalls(tgt);
      cv.requestRenderAll();
    }
    // If neither scale nor drag detected, do nothing (spurious modified event)
    tgt._lastAct = null;
  }
  _dragSnapTarget = null;

  // Recover any wall that got accidentally rotated or scaled
  // (e.g. via ActiveSelection before our guard fired, or on first load).
  var targets = (e.target && e.target.type === 'activeSelection')
    ? e.target.getObjects()
    : (e.target ? [e.target] : []);
  targets.forEach(function(o) {
    if (o._tool !== 'wall') return;
    var badAngle = Math.abs(o.angle || 0) > 0.01;
    var badScale = Math.abs((o.scaleX || 1) - 1) > 0.01 || Math.abs((o.scaleY || 1) - 1) > 0.01;
    if (!badAngle && !badScale) return;
    // Bake the current visual endpoint positions, then reset transforms to identity
    var eps = wallEndpointsPt(o);
    o.set({
      angle:  0, scaleX: 1, scaleY: 1,
      x1: eps[0].x, y1: eps[0].y,
      x2: eps[1].x, y2: eps[1].y,
      left: (eps[0].x + eps[1].x) / 2,
      top:  (eps[0].y + eps[1].y) / 2,
      width:  Math.abs(eps[1].x - eps[0].x),
      height: Math.abs(eps[1].y - eps[0].y)
    });
    o.setCoords();
    makeWallEditable(o);
  });
  rebuildPts();

  // Re-assign _sectionId when objects move
  var movedTargets = (e.target && e.target.type === 'activeSelection')
    ? e.target.getObjects()
    : (e.target ? [e.target] : []);

  var sectionMoved = movedTargets.some(function(mo) { return mo._tool === 'section'; });
  if (sectionMoved) {
    // Section repositioned: re-evaluate ALL furniture
    cv.getObjects().forEach(function(o) {
      if (o._tool !== 'furniture') return;
      o._sectionId = _findSectionForObj(o);
    });
  } else {
    // Furniture repositioned: re-evaluate only moved objects
    movedTargets.forEach(function(mo) {
      if (!mo._tool || mo._tool === 'wall' || mo._bg || mo._prev) return;
      mo._sectionId = _findSectionForObj(mo);
    });
  }

  updatePanel();
  debouncePushHistory();
  refreshObjList();
});

// ── Wall Utilities ────────────────────────────────────────

function rebuildPts() {
  pts = [];
  cv.getObjects().forEach(function(o) {
    if (o._tool !== 'wall' || o._prev) return;
    var eps = wallEndpointsPt(o);
    pts.push(eps[0], eps[1]);
  });
}


function moveLineEndpoint(wall, idx, x, y, otherX, otherY) {
  // otherX/Y is the pre-recorded opposite endpoint (captured once at drag start).
  // Never re-derive from calcTransformMatrix during drag — if scaleX/Y != 1
  // (from a prior ActiveSelection op) the matrix blows up x1/y1/x2/y2.
  var nx1 = idx === 0 ? x      : otherX;
  var ny1 = idx === 0 ? y      : otherY;
  var nx2 = idx === 0 ? otherX : x;
  var ny2 = idx === 0 ? otherY : y;
  wall.set({
    x1: nx1, y1: ny1, x2: nx2, y2: ny2,
    width:  Math.abs(nx2 - nx1),
    height: Math.abs(ny2 - ny1),
    left:   (nx1 + nx2) / 2,
    top:    (ny1 + ny2) / 2,
    angle:  0, scaleX: 1, scaleY: 1
  });
  wall.setCoords();
  return true;
}

function makeWallEditable(wall) {
  // Always re-apply — Fabric.js does NOT serialize hasControls/lockRotation,
  // so after undo/redo they reset to defaults. The _wallReady guard was
  // preventing re-initialization and causing rotation handles to reappear.
  wall._wallReady    = true;
  wall.hasControls   = false;
  wall.hasBorders    = false;
  wall.lockRotation  = true;
  wall.lockScalingX  = true;
  wall.lockScalingY  = true;
  // Walls move ONLY via endpoint drag, not body drag.
  wall.lockMovementX = true;
  wall.lockMovementY = true;
  // fabric.Line defaults to originX:'left', so getCenterPoint() = left + width/2.
  // All our wall code sets left=(x1+x2)/2 (center), which is only correct for
  // originX:'center' where getCenterPoint() = left directly. Without this fix,
  // getCenterPoint() returns x2 (off by half the length), causing wallEndpointsPt
  // to compute wrong positions → otherX drifts on every new drag → wall flies right.
  wall.originX = 'center';
  wall.originY = 'center';
  wall.left    = (wall.x1 + wall.x2) / 2;
  wall.top     = (wall.y1 + wall.y2) / 2;
  wall.setCoords();
}

function applyWallEp(wall, idx, x, y, otherX, otherY) {
  // Caller must supply the pre-recorded other-endpoint position.
  var nx1 = idx === 0 ? x      : otherX;
  var ny1 = idx === 0 ? y      : otherY;
  var nx2 = idx === 0 ? otherX : x;
  var ny2 = idx === 0 ? otherY : y;
  wall.set({
    x1: nx1, y1: ny1, x2: nx2, y2: ny2,
    width: Math.abs(nx2 - nx1), height: Math.abs(ny2 - ny1),
    left:  (nx1 + nx2) / 2,    top:    (ny1 + ny2) / 2,
    angle: 0, scaleX: 1, scaleY: 1
  });
  wall.setCoords();
}

// ── Wall Drawing ──────────────────────────────────────────
var DEF_SW = 6;  // default wall stroke width

function startWall(x, y) {
  // Don't add a zero-length preview yet — wait until mouse moves
  wallSt = { on: true, x1: x, y1: y, prev: null };
  cv.renderAll();  // redraw to show start-point dot via after:render
}

function updateWallPrev(x2, y2) {
  if (wallSt.prev) { cv.remove(wallSt.prev); wallSt.prev = null; }
  if (Math.hypot(x2 - wallSt.x1, y2 - wallSt.y1) < 3) { cv.renderAll(); return; }
  var ws = getWallStyle();
  var opts = {
    stroke: ws.stroke, strokeWidth: ws.strokeWidth, strokeLineCap: 'round',
    selectable: false, evented: false, opacity: 0.4, _prev: true
  };
  if (ws.strokeDashArray) opts.strokeDashArray = ws.strokeDashArray;
  var prev = new fabric.Line([wallSt.x1, wallSt.y1, x2, y2], opts);
  cv.add(prev);
  wallSt.prev = prev;
  cv.renderAll();
}

function finishWall(x2, y2) {
  if (!wallSt.on) return;
  if (wallSt.prev) { cv.remove(wallSt.prev); wallSt.prev = null; }
  var x1 = wallSt.x1, y1 = wallSt.y1;
  wallSt = { on: false, x1: 0, y1: 0, prev: null };

  if (Math.hypot(x2 - x1, y2 - y1) < 8) { cv.renderAll(); return; }

  var ws = getWallStyle();
  var opts = {
    stroke: ws.stroke, strokeWidth: ws.strokeWidth, strokeLineCap: 'round',
    strokeUniform: true,
    selectable: false, evented: false, _tool: 'wall', _wallStyle: ws._wallStyle
  };
  if (ws.fill) { opts.fill = ws.fill; }
  if (ws.strokeDashArray) opts.strokeDashArray = ws.strokeDashArray;
  var wall = new fabric.Line([x1, y1, x2, y2], opts);
  cv.add(wall);
  makeWallEditable(wall);
  pts.push({ x: x1, y: y1 }, { x: x2, y: y2 });
  countUp();
  debouncePushHistory();

  // Shift held → chain next segment; otherwise end drawing
  if (shiftOn) {
    startWall(x2, y2);
  } else {
    cv.renderAll();
    setTool('select');
  }
}

function cancelWall() {
  if (wallSt.prev) { cv.remove(wallSt.prev); cv.renderAll(); }
  wallSt = { on: false, x1: 0, y1: 0, prev: null };
}

// ── Door ─────────────────────────────────────────────────
// ── Wall-snap placement (door / window) ──────────────────────
var wallSnapTarget    = null;
var wallSnapPreview   = [];  // array of preview Fabric objects
var _lastSnapOpenDir  = 1;   // openDir last computed in preview (used at mouse:down)
var _lastSnapAngle    = 0;   // angle of last wall snap; used for free-cursor ghost

function _clearSnapObjs() {
  wallSnapPreview.forEach(function(o) { cv.remove(o); });
  wallSnapPreview = [];
}
function clearWallSnapPreview() {
  _clearSnapObjs();
  wallSnapTarget = null;
  cv.requestRenderAll();
}

function projectPointOnSegment(px, py, x1, y1, x2, y2) {
  var dx = x2-x1, dy = y2-y1, len2 = dx*dx + dy*dy;
  if (len2 < 1) return { x: x1, y: y1, t: 0, dist: Math.hypot(px-x1, py-y1) };
  var t = Math.max(0, Math.min(1, ((px-x1)*dx + (py-y1)*dy) / len2));
  var qx = x1 + t*dx, qy = y1 + t*dy;
  return { x: qx, y: qy, t: t, dist: Math.hypot(px-qx, py-qy) };
}

function findNearestWall(px, py, threshold) {
  // Gaps between walls take priority over wall surfaces.
  // When cursor is between two walls the gap midpoint can be further than the
  // wall surface, so without this inversion the door always snaps to the wall.
  var gapThresh = threshold * 1.6;
  var vgap  = findVirtualGap(px, py, gapThresh);
  // Endpoint-pair gaps use the base threshold (tighter) and midpoint-distance scoring,
  // so they don't need the expanded range that virtual gaps require.
  var epgap = findEndpointPairGap(px, py, threshold);
  var best = null;
  if (vgap && epgap) {
    var vd = projectPointOnSegment(px, py, vgap.x1, vgap.y1, vgap.x2, vgap.y2).dist;
    var ed = Math.hypot(px - epgap.projX, py - epgap.projY);
    best = (vd <= ed) ? vgap : epgap;
  } else {
    best = vgap || epgap;
  }
  if (best) return best;

  // Fall back to real wall surface snap
  var bestDist = threshold;
  cv.getObjects().forEach(function(o) {
    if (o._tool !== 'wall' || o._prev || o._detPrev) return;
    var eps = wallEndpointsPt(o);
    var proj = projectPointOnSegment(px, py, eps[0].x, eps[0].y, eps[1].x, eps[1].y);
    if (proj.dist < bestDist) {
      bestDist = proj.dist;
      var dx = eps[1].x - eps[0].x, dy = eps[1].y - eps[0].y;
      best = {
        wall: o,
        projX: proj.x, projY: proj.y, t: proj.t,
        angle: Math.atan2(dy, dx) * 180 / Math.PI,
        x1: eps[0].x, y1: eps[0].y, x2: eps[1].x, y2: eps[1].y,
        len: Math.hypot(dx, dy)
      };
    }
  });
  return best;
}

function findVirtualGap(px, py, threshold) {
  var walls = cv.getObjects().filter(function(o) {
    return o._tool === 'wall' && !o._prev && !o._detPrev;
  });
  var eps = [];
  walls.forEach(function(w) {
    var weps = wallEndpointsPt(w);
    var dx = weps[1].x - weps[0].x, dy = weps[1].y - weps[0].y;
    var ang = Math.atan2(dy, dx) * 180 / Math.PI;
    // Store the OTHER endpoint so we can do the gap-facing check in O(1) per pair.
    eps.push({ pt: weps[0], other: weps[1], wall: w, idx: 0, angle: ang });
    eps.push({ pt: weps[1], other: weps[0], wall: w, idx: 1, angle: ang });
  });
  var best = null, bestDist = threshold;
  for (var i = 0; i < eps.length; i++) {
    for (var j = i + 1; j < eps.length; j++) {
      var ea = eps[i], eb = eps[j];
      if (ea.wall === eb.wall) continue;
      // Collinearity check: angle diff mod 180 <= 15 degrees
      var aDiff = ((ea.angle - eb.angle) % 180 + 180) % 180;
      if (aDiff > 90) aDiff = 180 - aDiff;
      if (aDiff > 15) continue;
      var dx = eb.pt.x - ea.pt.x, dy = eb.pt.y - ea.pt.y;
      var gapDist = Math.hypot(dx, dy);
      if (gapDist < 25 || gapDist > 150) continue;
      // Gap-facing check: each endpoint must be the one that FACES the gap.
      // ea.other should be on the opposite side of ea.pt from eb.pt (dot product < 0).
      // If the other end of W1 points TOWARD the gap, ea is the wrong (inner) endpoint.
      // Threshold 0.5 (instead of 1) is more float-safe for very short wall stubs.
      if ((ea.other.x - ea.pt.x) * dx + (ea.other.y - ea.pt.y) * dy > 0.5) continue;
      if ((eb.other.x - eb.pt.x) * (-dx) + (eb.other.y - eb.pt.y) * (-dy) > 0.5) continue;
      var gLen2v = gapDist * gapDist;
      var tRawV  = ((px - ea.pt.x) * dx + (py - ea.pt.y) * dy) / gLen2v;
      if (tRawV < -0.12 || tRawV > 1.12) continue;
      var tCV    = Math.max(0, Math.min(1, tRawV));
      var distV  = Math.hypot(px - (ea.pt.x + tCV * dx), py - (ea.pt.y + tCV * dy));
      if (distV >= bestDist) continue;
      bestDist = distV;
      best = {
        _isVirtual: true, wall: null,
        _wallA: ea.wall, _wallAIdx: ea.idx,
        _wallB: eb.wall, _wallBIdx: eb.idx,
        x1: ea.pt.x, y1: ea.pt.y, x2: eb.pt.x, y2: eb.pt.y,
        angle: Math.atan2(dy, dx) * 180 / Math.PI,
        projX: ea.pt.x + tCV * dx, projY: ea.pt.y + tCV * dy, t: tCV, len: gapDist
      };
    }
  }
  return best;
}

// Snap to gap between any two wall endpoints (no angle constraint — handles perpendicular walls)
function findEndpointPairGap(px, py, threshold) {
  var walls = cv.getObjects().filter(function(o) {
    return o._tool === 'wall' && !o._prev && !o._detPrev;
  });
  var eps = [];
  walls.forEach(function(w) {
    var weps = wallEndpointsPt(w);
    eps.push({ pt: weps[0], other: weps[1], wall: w, idx: 0 });
    eps.push({ pt: weps[1], other: weps[0], wall: w, idx: 1 });
  });
  var minGap = 25, maxGap = 150;
  // Score by distance from cursor to gap MIDPOINT (not projection distance).
  // Users naturally position cursor near the middle of an opening, so the gap
  // whose midpoint is closest to the cursor is the intended one.
  var best = null, bestMidDist = Infinity;
  for (var i = 0; i < eps.length; i++) {
    for (var j = i + 1; j < eps.length; j++) {
      var ea = eps[i], eb = eps[j];
      if (ea.wall === eb.wall) continue;
      var dx = eb.pt.x - ea.pt.x, dy = eb.pt.y - ea.pt.y;
      var gapDist = Math.hypot(dx, dy);
      if (gapDist < minGap || gapDist > maxGap) continue;
      // Gap-facing check: ea.pt must be the wall endpoint CLOSEST to eb.pt (not the far end).
      // This replaces the old dot-product check, which broke for perpendicular walls because
      // the "other" endpoint of a vertical wall has a y-component that matched the reversed
      // gap direction, causing valid right-angle pairs to be incorrectly rejected.
      if (Math.hypot(ea.other.x - eb.pt.x, ea.other.y - eb.pt.y) <= gapDist) continue;
      if (Math.hypot(eb.other.x - ea.pt.x, eb.other.y - ea.pt.y) <= gapDist) continue;
      // Cursor projection must land inside (or just outside) the gap segment.
      var gLen2 = gapDist * gapDist;
      var tRaw  = ((px - ea.pt.x) * dx + (py - ea.pt.y) * dy) / gLen2;
      if (tRaw < -0.15 || tRaw > 1.15) continue;
      // Gate: cursor must be within threshold perpendicularly of the gap line.
      var tC   = Math.max(0, Math.min(1, tRaw));
      var dist = Math.hypot(px - (ea.pt.x + tC * dx), py - (ea.pt.y + tC * dy));
      if (dist >= threshold) continue;
      // Select the gap whose MIDPOINT is nearest to cursor (equidistant-endpoint heuristic).
      var midDist = Math.hypot(px - (ea.pt.x + dx * 0.5), py - (ea.pt.y + dy * 0.5));
      if (midDist >= bestMidDist) continue;
      bestMidDist = midDist;
      best = {
        _isVirtual: true, _isEndpointGap: true, wall: null,
        _wallA: ea.wall, _wallAIdx: ea.idx,
        _wallB: eb.wall, _wallBIdx: eb.idx,
        x1: ea.pt.x, y1: ea.pt.y, x2: eb.pt.x, y2: eb.pt.y,
        angle: Math.atan2(dy, dx) * 180 / Math.PI,
        projX: ea.pt.x + tC * dx, projY: ea.pt.y + tC * dy, t: tC, len: gapDist
      };
    }
  }
  return best;
}

function calcSnapGap(snap, w) {
  var half = w / 2;
  var projDist = snap.t * snap.len;
  var startDist = Math.min(Math.max(0, projDist - half), snap.len - w);
  if (startDist < 0 || snap.len < w) return { ok: false };
  var endDist = startDist + w;
  var ux = (snap.x2 - snap.x1) / snap.len, uy = (snap.y2 - snap.y1) / snap.len;
  return {
    ok: true,
    splitPt1: { x: snap.x1 + startDist * ux, y: snap.y1 + startDist * uy },
    splitPt2: { x: snap.x1 + endDist   * ux, y: snap.y1 + endDist   * uy }
  };
}

function rotVec(x, y, deg) {
  var r = deg * Math.PI / 180;
  return { x: x * Math.cos(r) - y * Math.sin(r), y: x * Math.sin(r) + y * Math.cos(r) };
}

function updateWallSnapPreview(snap, px, py) {
  _clearSnapObjs();
  if (!snap) {
    // Free-cursor ghost: show door/window shape at cursor when tool is active
    if (activeTool === 'door' || activeTool === 'window') {
      var _isD = activeTool === 'door', _isDb = _isD && doorDouble;
      var _w   = _isD ? (_isDb ? DOOR2_W : DOOR_W) : WIN_W;
      var _a   = _lastSnapAngle, _col = 'rgba(80,80,80,0.45)', _gObj;
      if (_isD) {
        var _yd = -_w;
        _gObj = new fabric.Group([
          new fabric.Path('M 0 ' + _yd + ' A ' + _w + ' ' + _w + ' 0 0 1 ' + _w + ' 0',
            { stroke: _col, strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] }),
          new fabric.Line([0, 0, 0, _yd],
            { stroke: _col, strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true }),
          new fabric.Circle({ left: -4, top: -4, radius: 4, fill: _col, stroke: 'none' })
        ], { originX: 'center', originY: 'center', selectable: false, evented: false, opacity: 0.5, angle: _a, _prev: true });
        // Anchor: hinge (circle center at local 0,0) at cursor.
        // Bbox center is at (w/2-2, -w/2+2) from hinge → _off = (-w/2+2, w/2-2).
        var _off = rotVec(-_w / 2 + 2, _w / 2 - 2, _a);
        _gObj.set({ left: px - _off.x, top: py - _off.y });
      } else {
        _gObj = new fabric.Group([
          new fabric.Rect({ left: 0, top: 0, width: _w, height: 8,
            fill: 'rgba(106,170,191,0.2)', stroke: _col, strokeWidth: 1.5 })
        ], { originX: 'center', originY: 'center', selectable: false, evented: false, opacity: 0.5, angle: _a, _prev: true });
        _gObj.set({ left: px, top: py });
      }
      wallSnapPreview.push(_gObj);
      cv.add(_gObj);
    }
    cv.requestRenderAll();
    return;
  }

  _lastSnapAngle = snap.angle;
  var actObj  = cv.getActiveObject();
  var isDoor  = (activeTool === 'door') || (actObj && actObj._tool === 'door');
  var isDbl   = (activeTool === 'door' && doorDouble) || (actObj && !!actObj._doorDouble);
  var w = isDoor ? (isDbl ? DOOR2_W : DOOR_W) : WIN_W;
  // Virtual gap: auto-size to fill gap (floor ensures w <= snap.len, so calcSnapGap is ok)
  if (snap._isVirtual) w = Math.floor(snap.len);
  var angle = snap.angle;
  var gap   = calcSnapGap(snap, w);
  var ok    = !!(gap && gap.ok);
  var col   = ok ? '#4F46E5' : '#aaaaaa';
  var od = ok ? computeOpenDir(snap, px, py, _lastSnapOpenDir) : 1;
  if (ok) _lastSnapOpenDir = od;

  // Gap indicator: white rect that shows where wall will be cut
  if (ok) {
    var midGX = (gap.splitPt1.x + gap.splitPt2.x) / 2;
    var midGY = (gap.splitPt1.y + gap.splitPt2.y) / 2;
    var gapRect = new fabric.Rect({
      width: w, height: DEF_SW + 6,
      fill: 'rgba(255,255,255,0.92)', stroke: '#4F46E5',
      strokeWidth: 1, strokeDashArray: [3, 2],
      originX: 'center', originY: 'center',
      angle: angle, left: midGX, top: midGY,
      selectable: false, evented: false, _prev: true, opacity: 1
    });
    wallSnapPreview.push(gapRect);
    cv.add(gapRect);
  }

  var obj;
  if (isDoor) {
    if (isDbl) {
      // Double door preview (symmetric — both leaves open toward od side)
      var hw = w / 2;
      var yd = hw * od;
      var lsw = od > 0 ? 0 : 1, rsw = od > 0 ? 1 : 0;
      var llf = new fabric.Line([-hw, 0, -hw, yd], { stroke: col, strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true });
      var lac = new fabric.Path('M ' + (-hw) + ' ' + yd + ' A ' + hw + ' ' + hw + ' 0 0 ' + lsw + ' 0 0',
        { stroke: col, strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] });
      var lhg = new fabric.Circle({ left: -hw - 4, top: -4, radius: 4, fill: col, stroke: 'none' });
      var rlf = new fabric.Line([hw, 0, hw, yd], { stroke: col, strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true });
      var rac = new fabric.Path('M ' + hw + ' ' + yd + ' A ' + hw + ' ' + hw + ' 0 0 ' + rsw + ' 0 0',
        { stroke: col, strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] });
      var rhg = new fabric.Circle({ left: hw - 4, top: -4, radius: 4, fill: col, stroke: 'none' });
      obj = new fabric.Group([lac, llf, lhg, rac, rlf, rhg], {
        originX: 'center', originY: 'center',
        selectable: false, evented: false, opacity: 0.6, angle: angle, _prev: true
      });
      var midX = ok ? (gap.splitPt1.x + gap.splitPt2.x) / 2 : snap.projX;
      var midY = ok ? (gap.splitPt1.y + gap.splitPt2.y) / 2 : snap.projY;
      var rOff = rotVec(0, od * hw / 2, angle);
      obj.set({ left: midX + rOff.x, top: midY + rOff.y });
    } else {
      // Single door preview (openDir-aware)
      var yd = w * od;
      var arcSweep = od > 0 ? 0 : 1;
      var arcPath = 'M 0 ' + yd + ' A ' + w + ' ' + w + ' 0 0 ' + arcSweep + ' ' + w + ' 0';
      var leaf = new fabric.Line([0, 0, 0, yd], {
        stroke: col, strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true
      });
      var arc = new fabric.Path(arcPath, {
        stroke: col, strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3]
      });
      var hinge = new fabric.Circle({ left: -4, top: -4, radius: 4, fill: col, stroke: 'none' });
      obj = new fabric.Group([arc, leaf, hinge], {
        originX: 'center', originY: 'center',
        selectable: false, evented: false, opacity: 0.6, angle: angle, _prev: true
      });
      var hingeX = ok ? gap.splitPt1.x : snap.projX;
      var hingeY = ok ? gap.splitPt1.y : snap.projY;
      var r = rotVec(w / 2, od * w / 2, angle);
      obj.set({ left: hingeX + r.x, top: hingeY + r.y });
    }
  } else {
    var h = 8;
    var frame = new fabric.Rect({ left: 0, top: 0, width: w, height: h,
      fill: 'rgba(106,170,191,0.35)', stroke: col, strokeWidth: 1.5 });
    var g1 = new fabric.Line([3, 2.5, w-3, 2.5], { stroke: col, strokeWidth: 0.8 });
    var g2 = new fabric.Line([3, 5.5, w-3, 5.5], { stroke: col, strokeWidth: 0.8 });
    obj = new fabric.Group([frame, g1, g2], {
      originX: 'center', originY: 'center',
      selectable: false, evented: false, opacity: 0.6, angle: angle, _prev: true
    });
    var midX = ok ? (gap.splitPt1.x + gap.splitPt2.x) / 2 : snap.projX;
    var midY = ok ? (gap.splitPt1.y + gap.splitPt2.y) / 2 : snap.projY;
    obj.set({ left: midX, top: midY });
  }

  wallSnapPreview.push(obj);
  cv.add(obj);
  cv.requestRenderAll();
}

function splitWall(snap, pt1, pt2) {
  var origWall = snap.wall;
  cv.remove(origWall);
  var minLen = DEF_SW + 2;
  var wallL = null, wallR = null;
  var addSeg = function(ax, ay, bx, by) {
    if (Math.hypot(bx-ax, by-ay) < minLen) return null;
    var opts = {
      stroke: origWall.stroke || '#3A3530',
      strokeWidth: origWall.strokeWidth || DEF_SW,
      strokeLineCap: 'round', strokeUniform: true,
      selectable: false, evented: false, _tool: 'wall',
      _wallStyle: origWall._wallStyle || null
    };
    if (origWall.strokeDashArray) opts.strokeDashArray = origWall.strokeDashArray.slice();
    var seg = new fabric.Line([ax, ay, bx, by], opts);
    cv.add(seg);
    makeWallEditable(seg);
    return seg;
  };
  wallL = addSeg(snap.x1, snap.y1, pt1.x, pt1.y);
  wallR = addSeg(pt2.x, pt2.y, snap.x2, snap.y2);
  rebuildPts();
  return { wallL: wallL, wallR: wallR };
}

// Draggable endpoint at the leaf's free end: resizes door width (scaleX along wall)
function makeDoorTipCtrl(isLeft, od) {
  return new fabric.Control({
    x: isLeft ? -0.5 : 0.5,
    y: -od * 0.5,
    offsetX: 0, offsetY: 0,
    cursorStyle: 'ew-resize',
    actionHandler: function(eventData, transform, x, y) {
      var target = transform.target;
      var rad = target.angle * Math.PI / 180;
      var wx = Math.cos(rad), wy = Math.sin(rad);
      var along = (x - target.left) * wx + (y - target.top) * wy;
      var halfW = isLeft ? -along : along;
      if (halfW < 20) halfW = 20;
      var ratio = (halfW * 2) / (target._doorW || 1);
      target.set({ scaleX: Math.max(0.1, ratio) });
      return true;
    },
    mouseUpHandler: function(eventData, transform) {
      var target = transform.target;
      var sc = target.scaleX || 1;
      if (Math.abs(sc - 1) > 0.05) {
        var newW = Math.max(40, Math.round((target._doorW || DOOR_W) * Math.abs(sc)));
        target.set({ scaleX: 1 });
        resizeDoorOnWall(target, newW);
      }
      return true;
    },
    render: function(ctx, left, top) {
      ctx.save();
      ctx.beginPath();
      ctx.arc(left, top, 6, 0, Math.PI * 2);
      ctx.fillStyle = '#FAFAF8';
      ctx.fill();
      ctx.strokeStyle = '#4F46E5';
      ctx.lineWidth = 2;
      ctx.stroke();
      ctx.restore();
    }
  });
}

function makeDoorFlipCtrl() {
  return new fabric.Control({
    x: 0.5, y: 0, offsetX: 18,
    cursorStyle: 'pointer',
    render: function(ctx, left, top) {
      var r = 9;
      ctx.save();
      ctx.translate(left, top);
      ctx.beginPath();
      ctx.arc(0, 0, r, 0, Math.PI * 2);
      ctx.fillStyle = '#4F46E5';
      ctx.fill();
      ctx.strokeStyle = '#fff';
      ctx.lineWidth = 1.6;
      ctx.lineCap = 'round';
      // ↔ arrows
      ctx.beginPath();
      ctx.moveTo(-4.5, 0); ctx.lineTo(4.5, 0);
      ctx.moveTo(2.5, -2.5); ctx.lineTo(4.5, 0); ctx.lineTo(2.5, 2.5);
      ctx.moveTo(-2.5, -2.5); ctx.lineTo(-4.5, 0); ctx.lineTo(-2.5, 2.5);
      ctx.stroke();
      ctx.restore();
    },
    mouseUpHandler: function(eventData, transform) {
      flipDoor(transform.target);
      return true;
    }
  });
}

// Build a synthetic snap by finding the wall that passes through (cx, cy).
// Avoids findNearestWall's 50px search radius which can snap to the wrong wall
// and produces rounding differences vs the original gap position.
function _buildWallSnapAt(cx, cy) {
  var best = null, bestDist = 5;
  cv.getObjects().forEach(function(w) {
    if (w._tool !== 'wall' || w._prev) return;
    var p = projectPointOnSegment(cx, cy, w.x1, w.y1, w.x2, w.y2);
    if (p.dist < bestDist) { bestDist = p.dist; best = { wall: w, proj: p }; }
  });
  if (!best) return null;
  var w = best.wall, p = best.proj;
  var len = Math.hypot(w.x2 - w.x1, w.y2 - w.y1);
  return {
    wall: w, x1: w.x1, y1: w.y1, x2: w.x2, y2: w.y2,
    angle: Math.atan2(w.y2 - w.y1, w.x2 - w.x1) * 180 / Math.PI,
    projX: p.x, projY: p.y, t: p.t, len: len
  };
}

function flipDoor(grp) {
  var od      = grp._doorOd || 1;
  var isDbl   = grp._doorDouble;
  var gpts    = getDoorGapPts(grp);
  if (!gpts) return;
  var cx = (gpts.pt1.x + gpts.pt2.x) / 2;
  var cy = (gpts.pt1.y + gpts.pt2.y) / 2;
  var isVirtual = grp._isVirtualGap;
  var snap;
  if (isVirtual) {
    snap = {
      _isVirtual: true,
      x1: gpts.pt1.x, y1: gpts.pt1.y, x2: gpts.pt2.x, y2: gpts.pt2.y,
      angle: grp.angle, projX: cx, projY: cy, len: grp._doorW,
      _wallA: grp._wallL, _wallAIdx: grp._wallLGapIdx,
      _wallB: grp._wallR, _wallBIdx: grp._wallRGapIdx
    };
  }
  restoreGapWalls(grp);
  cv.remove(grp);
  cv.discardActiveObject();
  if (!isVirtual) {
    snap = _buildWallSnapAt(cx, cy);
    if (!snap) { cv.renderAll(); return; }
  }
  if (isDbl) placeDoubleDoorOnWall(snap, -od);
  else       placeDoorOnWall(snap, -od);
  debouncePushHistory();
}

function flipDoorLR(grp) {
  var od = grp._doorOd || 1;
  var isDbl = grp._doorDouble;
  var gpts = getDoorGapPts(grp);
  if (!gpts) return;
  var cx = (gpts.pt1.x + gpts.pt2.x) / 2;
  var cy = (gpts.pt1.y + gpts.pt2.y) / 2;
  var isVirtual = grp._isVirtualGap;
  var snap;
  if (isVirtual) {
    snap = {
      _isVirtual: true,
      x1: gpts.pt2.x, y1: gpts.pt2.y,  // swap endpoints
      x2: gpts.pt1.x, y2: gpts.pt1.y,
      angle: grp.angle + 180,
      projX: cx, projY: cy, len: grp._doorW,
      _wallA: grp._wallL, _wallAIdx: grp._wallLGapIdx,
      _wallB: grp._wallR, _wallBIdx: grp._wallRGapIdx
    };
  }
  restoreGapWalls(grp);
  cv.remove(grp);
  cv.discardActiveObject();
  if (!isVirtual) {
    var orig = _buildWallSnapAt(cx, cy);
    if (!orig) { cv.renderAll(); return; }
    snap = {
      wall: orig.wall,
      projX: orig.projX, projY: orig.projY,
      t: 1 - orig.t,
      angle: orig.angle + 180,
      x1: orig.x2, y1: orig.y2,
      x2: orig.x1, y2: orig.y1,
      len: orig.len
    };
  }
  if (isDbl) placeDoubleDoorOnWall(snap, -od);
  else       placeDoorOnWall(snap, -od);
  debouncePushHistory();
}

function makeDoorFlipLRCtrl() {
  return new fabric.Control({
    x: 0.5, y: 0, offsetX: 46,
    cursorStyle: 'pointer',
    render: function(ctx, left, top) {
      var r = 9;
      ctx.save();
      ctx.translate(left, top);
      ctx.beginPath();
      ctx.arc(0, 0, r, 0, Math.PI * 2);
      ctx.fillStyle = '#059669';
      ctx.fill();
      ctx.strokeStyle = '#fff';
      ctx.lineWidth = 1.6;
      ctx.lineCap = 'round';
      ctx.beginPath();
      ctx.moveTo(0, -5); ctx.lineTo(0, 5);
      ctx.stroke();
      ctx.beginPath();
      ctx.moveTo(-5, 0); ctx.lineTo(-1.5, 0);
      ctx.moveTo(-4.5, -2); ctx.lineTo(-5, 0); ctx.lineTo(-4.5, 2);
      ctx.moveTo(5, 0); ctx.lineTo(1.5, 0);
      ctx.moveTo(4.5, -2); ctx.lineTo(5, 0); ctx.lineTo(4.5, 2);
      ctx.stroke();
      ctx.restore();
    },
    mouseUpHandler: function(eventData, transform) {
      flipDoorLR(transform.target);
      return true;
    }
  });
}

function resizeDoorOnWall(grp, newW) {
  var od = grp._doorOd || 1;
  var isDbl = grp._doorDouble;
  // Use getDoorGapPts (current position) not _gapPt1/_gapPt2 (stale after door move)
  var _curGpts = getDoorGapPts(grp);
  var gapPt1 = _curGpts ? _curGpts.pt1 : grp._gapPt1;
  var gapPt2 = _curGpts ? _curGpts.pt2 : grp._gapPt2;
  var midX, midY;
  if (gapPt1 && gapPt2) {
    midX = (gapPt1.x + gapPt2.x) / 2;
    midY = (gapPt1.y + gapPt2.y) / 2;
  } else {
    midX = grp.left; midY = grp.top;
  }
  var wasVirtual = grp._isVirtualGap;
  var virtualSnap = wasVirtual ? {
    _isVirtual: true,
    x1: gapPt1 ? gapPt1.x : midX - newW / 2,
    y1: gapPt1 ? gapPt1.y : midY,
    x2: gapPt2 ? gapPt2.x : midX + newW / 2,
    y2: gapPt2 ? gapPt2.y : midY,
    angle: grp.angle, projX: midX, projY: midY, len: newW,
    _wallA: grp._wallL, _wallAIdx: grp._wallLGapIdx,
    _wallB: grp._wallR, _wallBIdx: grp._wallRGapIdx
  } : null;
  restoreGapWalls(grp);
  cv.remove(grp);
  cv.discardActiveObject();
  rebuildPts();
  var snap;
  if (wasVirtual) {
    snap = virtualSnap;
  } else {
    // _buildWallSnapAt uses exact gap midpoint — tighter than findNearestWall's 60px radius
    snap = _buildWallSnapAt(midX, midY);
  }
  if (!snap) { cv.renderAll(); return; }
  if (isDbl) placeDoubleDoorOnWall(snap, od, newW);
  else       placeDoorOnWall(snap, od, newW);
  debouncePushHistory();
}

function placeDoorOnWall(snap, od, overrideW) {
  od = od || 1;
  var isVirtual = snap._isVirtual;
  var w = overrideW || (isVirtual ? Math.round(snap.len) : DOOR_W);
  var gap;
  if (isVirtual) {
    gap = { ok: true, splitPt1: { x: snap.x1, y: snap.y1 }, splitPt2: { x: snap.x2, y: snap.y2 } };
  } else {
    gap = calcSnapGap(snap, w);
    if (!gap.ok) { placeDoor(snap.projX, snap.projY); return; }
  }
  var angle = snap.angle;
  var yd = w * od;
  var arcSweep = od > 0 ? 0 : 1;
  var leaf  = new fabric.Line([0, 0, 0, yd], {
    stroke: '#2D2A27', strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true
  });
  var arc = new fabric.Path('M 0 ' + yd + ' A ' + w + ' ' + w + ' 0 0 ' + arcSweep + ' ' + w + ' 0', {
    stroke: '#7E7970', strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3]
  });
  var hinge  = new fabric.Circle({ left: -5, top: -5, radius: 5, fill: '#2D2A27', stroke: 'none' });
  var grp = new fabric.Group([arc, leaf, hinge], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockRotation: false,
    angle: angle, _tool: 'door', _doorW: w, _doorOd: od
  });
  grp.controls = {
    flip: makeDoorFlipCtrl(),
    flipLR: makeDoorFlipLRCtrl()
  };
  var r = rotVec(w / 2, od * w / 2, angle);
  grp.set({ left: gap.splitPt1.x + r.x, top: gap.splitPt1.y + r.y });
  if (isVirtual) {
    grp._wallL = snap._wallA; grp._wallR = snap._wallB;
    grp._wallLGapIdx = snap._wallAIdx; grp._wallRGapIdx = snap._wallBIdx;
    var aEps = wallEndpointsPt(snap._wallA), bEps = wallEndpointsPt(snap._wallB);
    grp._wallLOrigPt = { x: aEps[snap._wallAIdx].x, y: aEps[snap._wallAIdx].y };
    grp._wallROrigPt = { x: bEps[snap._wallBIdx].x, y: bEps[snap._wallBIdx].y };
    grp._isVirtualGap = true;
    if (snap._isEndpointGap) grp._isEndpointGap = true;
  } else {
    var walls = splitWall(snap, gap.splitPt1, gap.splitPt2);
    grp._wallL = walls.wallL; grp._wallR = walls.wallR;
    grp._gapPt1 = { x: gap.splitPt1.x, y: gap.splitPt1.y };
    grp._gapPt2 = { x: gap.splitPt2.x, y: gap.splitPt2.y };
  }
  cv.add(grp);
  grp.setCoords();
  storeDoorLocalGap(grp, gap.splitPt1, gap.splitPt2);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

function placeWinOnWall(snap) {
  var isVirtual = snap._isVirtual;
  var w = isVirtual ? Math.round(snap.len) : WIN_W;
  var h = 8;
  var gap;
  if (isVirtual) {
    gap = { ok: true, splitPt1: { x: snap.x1, y: snap.y1 }, splitPt2: { x: snap.x2, y: snap.y2 } };
  } else {
    gap = calcSnapGap(snap, w);
    if (!gap.ok) { placeWin(snap.projX, snap.projY); return; }
  }
  var angle = snap.angle;
  var midX = (gap.splitPt1.x + gap.splitPt2.x) / 2;
  var midY = (gap.splitPt1.y + gap.splitPt2.y) / 2;
  var frame = new fabric.Rect({ left: 0, top: 0, width: w, height: h,
    fill: '#D8EEF7', stroke: '#3A3530', strokeWidth: 1.5, rx: 0 });
  var g1 = new fabric.Line([3, 2.5, w-3, 2.5], { stroke: '#6AAABF', strokeWidth: 0.8 });
  var g2 = new fabric.Line([3, 5.5, w-3, 5.5], { stroke: '#6AAABF', strokeWidth: 0.8 });
  var grp = new fabric.Group([frame, g1, g2], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockScalingY: true, lockRotation: false,
    angle: angle, _tool: 'window', _winW: w
  });
  grp.controls = { ml: makeWallResizeCtrl(true, 20), mr: makeWallResizeCtrl(false, 20) };
  grp.set({ left: midX, top: midY });
  if (isVirtual) {
    grp._wallL = snap._wallA; grp._wallR = snap._wallB;
    grp._wallLGapIdx = snap._wallAIdx; grp._wallRGapIdx = snap._wallBIdx;
    var aEps = wallEndpointsPt(snap._wallA), bEps = wallEndpointsPt(snap._wallB);
    grp._wallLOrigPt = { x: aEps[snap._wallAIdx].x, y: aEps[snap._wallAIdx].y };
    grp._wallROrigPt = { x: bEps[snap._wallBIdx].x, y: bEps[snap._wallBIdx].y };
    grp._isVirtualGap = true;
  } else {
    var walls = splitWall(snap, gap.splitPt1, gap.splitPt2);
    grp._wallL = walls.wallL; grp._wallR = walls.wallR;
  }
  cv.add(grp);
  grp.setCoords();
  storeDoorLocalGap(grp, gap.splitPt1, gap.splitPt2);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

function placeDoubleDoorOnWall(snap, od, overrideW) {
  od = od || 1;
  var isVirtual = snap._isVirtual;
  var w = overrideW || (isVirtual ? Math.round(snap.len) : DOOR2_W);
  var hw = w / 2;
  var gap;
  if (isVirtual) {
    gap = { ok: true, splitPt1: { x: snap.x1, y: snap.y1 }, splitPt2: { x: snap.x2, y: snap.y2 } };
  } else {
    gap = calcSnapGap(snap, w);
    if (!gap.ok) { placeDoubleDoor(snap.projX, snap.projY); return; }
  }
  var angle = snap.angle;
  var midX = (gap.splitPt1.x + gap.splitPt2.x) / 2;
  var midY = (gap.splitPt1.y + gap.splitPt2.y) / 2;
  var yd = hw * od;
  var lsw = od > 0 ? 0 : 1, rsw = od > 0 ? 1 : 0;
  var llf = new fabric.Line([-hw, 0, -hw, yd], { stroke: '#2D2A27', strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true });
  var lac = new fabric.Path('M ' + (-hw) + ' ' + yd + ' A ' + hw + ' ' + hw + ' 0 0 ' + lsw + ' 0 0',
    { stroke: '#7E7970', strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] });
  var lhg = new fabric.Circle({ left: -hw - 5, top: -5, radius: 5, fill: '#2D2A27', stroke: 'none' });
  var rlf = new fabric.Line([hw, 0, hw, yd], { stroke: '#2D2A27', strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true });
  var rac = new fabric.Path('M ' + hw + ' ' + yd + ' A ' + hw + ' ' + hw + ' 0 0 ' + rsw + ' 0 0',
    { stroke: '#7E7970', strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] });
  var rhg = new fabric.Circle({ left: hw - 5, top: -5, radius: 5, fill: '#2D2A27', stroke: 'none' });
  var grp = new fabric.Group([lac, llf, lhg, rac, rlf, rhg], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockRotation: false,
    angle: angle, _tool: 'door', _doorW: w, _doorDouble: true, _doorOd: od
  });
  grp.controls = {
    flip: makeDoorFlipCtrl(),
    flipLR: makeDoorFlipLRCtrl()
  };
  var rOff = rotVec(0, od * hw / 2, angle);
  grp.set({ left: midX + rOff.x, top: midY + rOff.y });
  if (isVirtual) {
    grp._wallL = snap._wallA; grp._wallR = snap._wallB;
    grp._wallLGapIdx = snap._wallAIdx; grp._wallRGapIdx = snap._wallBIdx;
    var aEps = wallEndpointsPt(snap._wallA), bEps = wallEndpointsPt(snap._wallB);
    grp._wallLOrigPt = { x: aEps[snap._wallAIdx].x, y: aEps[snap._wallAIdx].y };
    grp._wallROrigPt = { x: bEps[snap._wallBIdx].x, y: bEps[snap._wallBIdx].y };
    grp._isVirtualGap = true;
    if (snap._isEndpointGap) grp._isEndpointGap = true;
  } else {
    var walls = splitWall(snap, gap.splitPt1, gap.splitPt2);
    grp._wallL = walls.wallL; grp._wallR = walls.wallR;
    grp._gapPt1 = { x: gap.splitPt1.x, y: gap.splitPt1.y };
    grp._gapPt2 = { x: gap.splitPt2.x, y: gap.splitPt2.y };
  }
  cv.add(grp);
  grp.setCoords();
  storeDoorLocalGap(grp, gap.splitPt1, gap.splitPt2);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

function placeDoubleDoor(cx, cy) {
  var w = DOOR2_W, hw = w / 2;
  var llf = new fabric.Line([-hw, 0, -hw, hw], { stroke: '#2D2A27', strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true });
  var lac = new fabric.Path('M ' + (-hw) + ' ' + hw + ' A ' + hw + ' ' + hw + ' 0 0 0 0 0',
    { stroke: '#7E7970', strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] });
  var lhg = new fabric.Circle({ left: -hw - 4, top: -4, radius: 4, fill: '#2D2A27', stroke: 'none' });
  var rlf = new fabric.Line([hw, 0, hw, hw], { stroke: '#2D2A27', strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true });
  var rac = new fabric.Path('M ' + hw + ' ' + hw + ' A ' + hw + ' ' + hw + ' 0 0 1 0 0',
    { stroke: '#7E7970', strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] });
  var rhg = new fabric.Circle({ left: hw - 4, top: -4, radius: 4, fill: '#2D2A27', stroke: 'none' });
  var grp = new fabric.Group([lac, llf, lhg, rac, rlf, rhg], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    _tool: 'door', _doorW: w, _doorDouble: true
  });
  grp.setPositionByOrigin(new fabric.Point(cx, cy), 'center', 'top');
  grp.setControlsVisibility({ tl:false, tr:false, br:false, bl:false, mt:true, mb:true, ml:true, mr:true, mtr:true });
  cv.add(grp);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

// Standard floor-plan door symbol:
//   - Hinge at top-left (0,0)
//   - Leaf: vertical line going DOWN (door shown OPEN, perpendicular to wall)
//   - Arc: from tip of open leaf (0,w) sweeping CCW to wall position (w,0)
//   - Hinge indicator: small filled circle at (0,0)
//   Use flipX / flipY to change which side the door opens toward.
function placeDoor(cx, cy) {
  var w = DOOR_W;

  // Leaf: door shown open, going upward (matches ghost preview default od=-1)
  var leaf = new fabric.Line([0, 0, 0, -w], {
    stroke: '#2D2A27', strokeWidth: 3, strokeLineCap: 'square', strokeUniform: true
  });

  // Arc: from tip of open leaf (0,-w) CW (sweep=1) to wall position (w,0)
  var arc = new fabric.Path(
    'M 0 ' + (-w) + ' A ' + w + ' ' + w + ' 0 0 1 ' + w + ' 0',
    { stroke: '#7E7970', strokeWidth: 1.2, fill: 'transparent', strokeDashArray: [5, 3] }
  );

  // Hinge indicator: small circle at (0,0)
  var hinge = new fabric.Circle({
    left: -4, top: -4, radius: 4,
    fill: '#2D2A27', stroke: 'none'
  });

  var grp = new fabric.Group([arc, leaf, hinge], {
    originX: 'center', originY: 'center',  // center origin → left/top = center = stable rotation
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockScalingX: true, lockScalingY: true,
    _tool: 'door', _doorW: w
  });
  // Place hinge (local 0,0) at click point. Bbox center is at (w/2-2, -w/2+2) from hinge.
  grp.set({ left: cx + w / 2 - 2, top: cy - (w / 2 - 2) });
  grp.setControlsVisibility({ tl:false, tr:false, br:false, bl:false, mt:false, mb:false, ml:false, mr:false, mtr:true });
  cv.add(grp);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel();
  countUp();
  debouncePushHistory();
  setTool('select');
}

// ── Window ────────────────────────────────────────────────
function placeWin(cx, cy) {
  var w = WIN_W, h = 8;
  // Architectural window symbol: outer frame + two glazing lines
  var frame = new fabric.Rect({
    left: 0, top: 0, width: w, height: h,
    fill: '#D8EEF7', stroke: '#3A3530', strokeWidth: 1.5, rx: 0
  });
  var g1 = new fabric.Line([3, 2.5, w - 3, 2.5], {
    stroke: '#6AAABF', strokeWidth: 0.8
  });
  var g2 = new fabric.Line([3, 5.5, w - 3, 5.5], {
    stroke: '#6AAABF', strokeWidth: 0.8
  });
  var grp = new fabric.Group([frame, g1, g2], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockScalingY: true,
    _tool: 'window', _winW: w
  });
  grp.setPositionByOrigin(new fabric.Point(cx, cy), 'center', 'center');
  grp.setControlsVisibility({ tl:false, tr:false, br:false, bl:false, mt:false, mb:false, ml:false, mr:false, mtr:true });
  cv.add(grp);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel();
  countUp();
  debouncePushHistory();
  setTool('select');
}

// ── Sliding door ─────────────────────────────────────────
function placeSlidingDoor(cx, cy) {
  var w = WIN_W, hw = w / 2, h = 8;
  var outer  = new fabric.Rect({ left: -hw, top: -h/2, width: w, height: h,
    fill: 'transparent', stroke: '#3A3530', strokeWidth: 1.5 });
  var panA = new fabric.Rect({ left: -hw, top: -h/2, width: hw, height: h,
    fill: '#D8EEF7', stroke: '#6AAABF', strokeWidth: 0.8 });
  var panB = new fabric.Rect({ left: 0, top: -h/2, width: hw, height: h,
    fill: 'rgba(216,238,247,0.35)', stroke: '#6AAABF', strokeWidth: 0.8,
    strokeDashArray: [3, 2] });
  var grp = new fabric.Group([outer, panA, panB], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockScalingY: true,
    _tool: 'window', _winW: w, _doorStyle: 'sliding'
  });
  grp.setPositionByOrigin(new fabric.Point(cx, cy), 'center', 'center');
  grp.setControlsVisibility({ tl:false, tr:false, br:false, bl:false, mt:false, mb:false, ml:false, mr:false, mtr:true });
  cv.add(grp);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

function placeSlidingDoorOnWall(snap) {
  var isVirtual = snap._isVirtual;
  var w = isVirtual ? Math.round(snap.len) : WIN_W;
  var hw = w / 2, h = 8;
  var gap;
  if (isVirtual) {
    gap = { ok: true, splitPt1: { x: snap.x1, y: snap.y1 }, splitPt2: { x: snap.x2, y: snap.y2 } };
  } else {
    gap = calcSnapGap(snap, w);
    if (!gap.ok) { placeSlidingDoor(snap.projX, snap.projY); return; }
  }
  var angle = snap.angle;
  var midX = (gap.splitPt1.x + gap.splitPt2.x) / 2;
  var midY = (gap.splitPt1.y + gap.splitPt2.y) / 2;
  var outer = new fabric.Rect({ left: -hw, top: -h/2, width: w, height: h,
    fill: 'transparent', stroke: '#3A3530', strokeWidth: 1.5 });
  var panA  = new fabric.Rect({ left: -hw, top: -h/2, width: hw, height: h,
    fill: '#D8EEF7', stroke: '#6AAABF', strokeWidth: 0.8 });
  var panB  = new fabric.Rect({ left: 0, top: -h/2, width: hw, height: h,
    fill: 'rgba(216,238,247,0.35)', stroke: '#6AAABF', strokeWidth: 0.8, strokeDashArray: [3, 2] });
  var grp = new fabric.Group([outer, panA, panB], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockScalingY: true, lockRotation: false,
    angle: angle, _tool: 'window', _winW: w, _doorStyle: 'sliding'
  });
  grp.controls = { ml: makeWallResizeCtrl(true, 20), mr: makeWallResizeCtrl(false, 20) };
  grp.set({ left: midX, top: midY });
  if (isVirtual) {
    grp._wallL = snap._wallA; grp._wallR = snap._wallB;
    grp._wallLGapIdx = snap._wallAIdx; grp._wallRGapIdx = snap._wallBIdx;
    var aEps = wallEndpointsPt(snap._wallA), bEps = wallEndpointsPt(snap._wallB);
    grp._wallLOrigPt = { x: aEps[snap._wallAIdx].x, y: aEps[snap._wallAIdx].y };
    grp._wallROrigPt = { x: bEps[snap._wallBIdx].x, y: bEps[snap._wallBIdx].y };
    grp._isVirtualGap = true;
    if (snap._isEndpointGap) grp._isEndpointGap = true;
  } else {
    var walls = splitWall(snap, gap.splitPt1, gap.splitPt2);
    grp._wallL = walls.wallL; grp._wallR = walls.wallR;
    grp._gapPt1 = { x: gap.splitPt1.x, y: gap.splitPt1.y };
    grp._gapPt2 = { x: gap.splitPt2.x, y: gap.splitPt2.y };
  }
  cv.add(grp);
  grp.setCoords();
  storeDoorLocalGap(grp, gap.splitPt1, gap.splitPt2);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

// ── Arch ─────────────────────────────────────────────────
function placeArch(cx, cy) {
  var w = DOOR_W, h = w * 0.7;
  var jL  = new fabric.Rect({ left: -w/2, top: 0, width: 4, height: h,
    fill: '#2D2A27', stroke: 'none' });
  var jR  = new fabric.Rect({ left: w/2 - 4, top: 0, width: 4, height: h,
    fill: '#2D2A27', stroke: 'none' });
  var arc = new fabric.Path('M ' + (-w/2) + ' ' + h + ' Q 0 ' + (h - w * 0.55) + ' ' + (w/2) + ' ' + h, {
    stroke: '#2D2A27', strokeWidth: 2.5, fill: 'transparent', strokeLineCap: 'round'
  });
  var grp = new fabric.Group([jL, jR, arc], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockRotation: false,
    _tool: 'door', _doorW: w, _doorStyle: 'arch'
  });
  grp.setPositionByOrigin(new fabric.Point(cx, cy), 'center', 'center');
  grp.setControlsVisibility({ tl:false, tr:false, br:false, bl:false, mt:false, mb:false, ml:false, mr:false, mtr:true });
  cv.add(grp);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

function placeArchOnWall(snap, od) {
  od = od || 1;
  var isVirtual = snap._isVirtual;
  var w = isVirtual ? Math.round(snap.len) : DOOR_W;
  var gap;
  if (isVirtual) {
    gap = { ok: true, splitPt1: { x: snap.x1, y: snap.y1 }, splitPt2: { x: snap.x2, y: snap.y2 } };
  } else {
    gap = calcSnapGap(snap, w);
    if (!gap.ok) { placeArch(snap.projX, snap.projY); return; }
  }
  var angle = snap.angle;
  var h = w * 0.7 * od;
  var jL  = new fabric.Rect({ left: -w/2, top: 0, width: 4, height: h,
    fill: '#2D2A27', stroke: 'none' });
  var jR  = new fabric.Rect({ left: w/2 - 4, top: 0, width: 4, height: h,
    fill: '#2D2A27', stroke: 'none' });
  var arc = new fabric.Path('M ' + (-w/2) + ' ' + h + ' Q 0 ' + (h - w * 0.55 * od) + ' ' + (w/2) + ' ' + h, {
    stroke: '#2D2A27', strokeWidth: 2.5, fill: 'transparent', strokeLineCap: 'round'
  });
  var grp = new fabric.Group([jL, jR, arc], {
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    hasControls: true, hasBorders: true, borderColor: '#4F46E5',
    lockRotation: false,
    angle: angle, _tool: 'door', _doorW: w, _doorStyle: 'arch'
  });
  grp.controls = { ml: makeWallResizeCtrl(true, 0), mr: makeWallResizeCtrl(false, 0) };
  var r = rotVec(w / 2, od * h / 2, angle);
  grp.set({ left: gap.splitPt1.x + r.x, top: gap.splitPt1.y + r.y });
  if (isVirtual) {
    grp._wallL = snap._wallA; grp._wallR = snap._wallB;
    grp._wallLGapIdx = snap._wallAIdx; grp._wallRGapIdx = snap._wallBIdx;
    var aEps = wallEndpointsPt(snap._wallA), bEps = wallEndpointsPt(snap._wallB);
    grp._wallLOrigPt = { x: aEps[snap._wallAIdx].x, y: aEps[snap._wallAIdx].y };
    grp._wallROrigPt = { x: bEps[snap._wallBIdx].x, y: bEps[snap._wallBIdx].y };
    grp._isVirtualGap = true;
    if (snap._isEndpointGap) grp._isEndpointGap = true;
  } else {
    var walls = splitWall(snap, gap.splitPt1, gap.splitPt2);
    grp._wallL = walls.wallL; grp._wallR = walls.wallR;
    grp._gapPt1 = { x: gap.splitPt1.x, y: gap.splitPt1.y };
    grp._gapPt2 = { x: gap.splitPt2.x, y: gap.splitPt2.y };
  }
  cv.add(grp);
  grp.setCoords();
  storeDoorLocalGap(grp, gap.splitPt1, gap.splitPt2);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel(); countUp(); debouncePushHistory();
  setTool('select');
}

// ── Column ────────────────────────────────────────────────
function placeCol(cx, cy) {
  var s = COL_S;
  var col = new fabric.Rect({
    left: cx, top: cy,
    originX: 'center', originY: 'center',
    width: s, height: s,
    fill: '#3A3530', stroke: '#1C1C1E', strokeWidth: 1.5, rx: 2,
    selectable: true, evented: true,
    hasControls: true, hasBorders: true,
    lockRotation: false,
    _tool: 'column'
  });
  cv.add(col);
  cv.setActiveObject(col);
  updatePanel();
  countUp();
  debouncePushHistory();
  setTool('select');
}

function flipObject(axis) {
  var obj = cv.getActiveObject();
  if (!obj) return;
  if (axis === 'x') obj.set('flipX', !obj.flipX);
  else               obj.set('flipY', !obj.flipY);
  cv.renderAll();
  debouncePushHistory();
}

// dir: 'cw' (시계방향 90°) or 'ccw' (반시계방향 90°)
// Canvas coords are y-down: CW means new_x = -(y-cy)+cx, new_y = (x-cx)+cy
function rotateMap(dir) {
  var objs = cv.getObjects().filter(function(o) {
    return !o._prev && !o._calib;
  });
  if (!objs.length) { toast('회전할 오브젝트가 없습니다'); return; }

  var minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
  objs.forEach(function(o) {
    var br = o.getBoundingRect(true);
    minX = Math.min(minX, br.left);
    maxX = Math.max(maxX, br.left + br.width);
    minY = Math.min(minY, br.top);
    maxY = Math.max(maxY, br.top + br.height);
  });
  var cx = (minX + maxX) / 2;
  var cy = (minY + maxY) / 2;
  var sign = (dir === 'cw') ? 1 : -1;

  // Snapshot gap canvas coords BEFORE rotating (while transforms are still valid)
  var _doorGaps = [];
  objs.forEach(function(o) {
    if ((o._tool === 'door' || o._tool === 'window') && o._localPt1) {
      var g = getDoorGapPts(o);
      if (g) _doorGaps.push({ obj: o, pt1: g.pt1, pt2: g.pt2 });
    }
  });

  function rotPt(p) {
    return { x: -sign*(p.y - cy) + cx, y: sign*(p.x - cx) + cy };
  }

  objs.forEach(function(o) {
    if (o._tool === 'wall') {
      var eps = wallEndpointsPt(o);
      var nx1 = -sign*(eps[0].y - cy) + cx,  ny1 = sign*(eps[0].x - cx) + cy;
      var nx2 = -sign*(eps[1].y - cy) + cx,  ny2 = sign*(eps[1].x - cx) + cy;
      o.set({
        x1: nx1, y1: ny1, x2: nx2, y2: ny2,
        width: Math.abs(nx2 - nx1), height: Math.abs(ny2 - ny1),
        left: (nx1 + nx2) / 2, top: (ny1 + ny2) / 2,
        angle: 0, scaleX: 1, scaleY: 1
      });
    } else {
      var cp = o.getCenterPoint();
      var dx = cp.x - cx, dy = cp.y - cy;
      var nx = -sign*dy + cx, ny = sign*dx + cy;
      var newAngle = ((o.angle || 0) + sign*90 + 360) % 360;
      o.set('angle', newAngle);
      o.setPositionByOrigin(new fabric.Point(nx, ny), 'center', 'center');
    }
    o.setCoords();
  });

  // Re-encode gap points in the rotated frame; also update canvas-space anchors
  _doorGaps.forEach(function(d) {
    var newPt1 = rotPt(d.pt1), newPt2 = rotPt(d.pt2);
    storeDoorLocalGap(d.obj, newPt1, newPt2);
    if (d.obj._gapPt1) d.obj._gapPt1 = newPt1;
    if (d.obj._gapPt2) d.obj._gapPt2 = newPt2;
    if (d.obj._wallLOrigPt) d.obj._wallLOrigPt = rotPt(d.obj._wallLOrigPt);
    if (d.obj._wallROrigPt) d.obj._wallROrigPt = rotPt(d.obj._wallROrigPt);
  });

  cv.discardActiveObject();
  rebuildPts();
  cv.renderAll();
  debouncePushHistory();
  toast(dir === 'cw' ? '맵 90° 시계방향 회전' : '맵 90° 반시계방향 회전');
}

function applyColumnSize() {
  var obj = cv.getActiveObject();
  if (!obj || obj._tool !== 'column') return;
  var wVal = parseFloat(document.getElementById('pv-cw').value) || 1;
  var hVal = parseFloat(document.getElementById('pv-ch').value) || 1;
  var wpx  = pxPerM ? wVal / 1000 * pxPerM : wVal;
  var hpx  = pxPerM ? hVal / 1000 * pxPerM : hVal;
  obj.set({ width: Math.max(4, wpx), height: Math.max(4, hpx) });
  obj.setCoords();
  cv.renderAll();
  debouncePushHistory();
}

// ── Panel ─────────────────────────────────────────────────
var LABELS = { wall: '벽', door: '문', window: '창문', column: '기둥' };
var LABELS2 = { door: '양문' };  // override label for objects with _doorDouble
var STYLE_LABELS = { sliding: '미서기문', arch: '아치', solid: '벽', glass: '유리벽', dashed: '점선' };

function updatePanel() {
  var obj = cv.getActiveObject();
  if (!obj) return;
  document.getElementById('pempty').style.display = 'none';
  document.getElementById('pobj').style.display   = 'block';

  var lbl;
  if (obj._tool === 'section') {
    lbl = SECTION_LABELS[obj._sectionType] || '구역';
  } else if (obj._tool === 'furniture') {
    lbl = obj._name || (obj._objDef && OBJECT_DEFS_MAP[obj._objDef] && OBJECT_DEFS_MAP[obj._objDef].label)
                    || (obj._preset && PRESETS[obj._preset] && PRESETS[obj._preset].label) || '가구';
  } else {
    lbl = STYLE_LABELS[obj._doorStyle] || STYLE_LABELS[obj._wallStyle] ||
          (obj._doorDouble && LABELS2[obj._tool]) || LABELS[obj._tool] || '요소';
  }
  document.getElementById('pv-type').textContent = lbl;

  var prSize   = document.getElementById('pr-size');
  var prStroke = document.getElementById('pr-stroke');
  var prFlip   = document.getElementById('pr-flip');
  var prWH     = document.getElementById('pr-wh');
  var prCol    = document.getElementById('pr-col');
  var prSname  = document.getElementById('pr-sname');
  var prStype  = document.getElementById('pr-stype');

  var prAngle  = document.getElementById('pr-angle');
  var prColor  = document.getElementById('pr-color');
  prSize.style.display   = 'none';
  prStroke.style.display = 'none';
  prFlip.style.display   = 'none';
  prWH.style.display     = 'none';
  prCol.style.display    = 'none';
  prSname.style.display  = 'none';
  prStype.style.display  = 'none';
  prAngle.style.display  = 'none';
  prColor.style.display  = 'none';

  if (obj._tool === 'wall') {
    var len = Math.round(Math.hypot((obj.x2 - obj.x1) * obj.scaleX, (obj.y2 - obj.y1) * obj.scaleY));
    if (pxPerM) {
      document.getElementById('pv-size').textContent = Math.round(len / pxPerM * 1000).toLocaleString() + ' mm';
    } else {
      document.getElementById('pv-size').textContent = len + ' px';
    }
    document.getElementById('pr-size').querySelector('.plbl').textContent = '길이';
    prSize.style.display   = 'block';
    var sw = obj.strokeWidth || DEF_SW;
    document.getElementById('pv-stroke').value = sw;
    document.getElementById('pv-stroke-val').textContent = sw;
    prStroke.style.display = 'block';
  } else if (obj._tool === 'door' || obj._tool === 'window') {
    if (obj._tool === 'window') prFlip.style.display = 'block';
    var sizePx = obj._tool === 'door' ? (obj._doorW || DOOR_W) : (obj._winW || WIN_W);
    var sizeLabel = pxPerM ? Math.round(sizePx / pxPerM * 1000) + ' mm' : sizePx + ' px';
    document.getElementById('pv-size').textContent = sizeLabel;
    document.getElementById('pr-size').querySelector('.plbl').textContent = obj._tool === 'door' ? '폭' : '폭';
    prSize.style.display = 'block';
  } else if (obj._tool === 'furniture') {
    prWH.style.display = 'block';
    var wpx = obj.width  * (obj.scaleX || 1);
    var hpx = obj.height * (obj.scaleY || 1);
    var unit = pxPerM ? 'cm' : 'px';
    var wVal = pxPerM ? Math.round(wpx / pxPerM * 100) : Math.round(wpx);
    var hVal = pxPerM ? Math.round(hpx / pxPerM * 100) : Math.round(hpx);
    document.getElementById('pv-fw').value = wVal;
    document.getElementById('pv-fh').value = hVal;
    document.getElementById('pv-fw-unit').textContent = unit;
    document.getElementById('pv-fh-unit').textContent = unit;
  } else if (obj._tool === 'column') {
    prCol.style.display = 'block';
    var wpx = obj.width  * (obj.scaleX || 1);
    var hpx = obj.height * (obj.scaleY || 1);
    var unit = pxPerM ? 'mm' : 'px';
    document.getElementById('pv-cw').value = pxPerM ? Math.round(wpx / pxPerM * 1000) : Math.round(wpx);
    document.getElementById('pv-ch').value = pxPerM ? Math.round(hpx / pxPerM * 1000) : Math.round(hpx);
    document.getElementById('pv-cw-unit').textContent = unit;
    document.getElementById('pv-ch-unit').textContent = unit;
  } else if (obj._tool === 'section') {
    prSname.style.display = 'block';
    prStype.style.display = 'block';
    document.getElementById('pv-sname').value = obj._name || '';
    document.getElementById('pv-stype').value = obj._sectionType || 'SECTION';
  }

  // Color picker — wall shows stroke, others show fill
  if (obj._tool === 'wall') {
    prColor.style.display = 'block';
    document.getElementById('pv-fill-color').value = rgbToHex(obj.stroke || '#3A3530');
  } else if (obj._tool === 'furniture' || obj._tool === 'column' || obj._tool === 'section') {
    prColor.style.display = 'block';
    document.getElementById('pv-fill-color').value = rgbToHex(obj.fill || '#EDE5D8');
  }

  var angleInput = document.getElementById('pv-angle');
  document.getElementById('pr-angle').style.display = '';
  if (obj._tool === 'wall') {
    // Show wall direction angle (read-only: wall angle changes via endpoint drag)
    var deg = Math.round(Math.atan2(obj.y2 - obj.y1, obj.x2 - obj.x1) * 180 / Math.PI);
    angleInput.value    = deg;
    angleInput.disabled = true;
    angleInput.title    = '벽 방향각 (끝점을 드래그해 변경)';
  } else {
    angleInput.value    = Math.round(obj.angle || 0);
    angleInput.disabled = false;
    angleInput.title    = '';
  }
}

function applyStroke(v) {
  var obj = cv.getActiveObject();
  if (!obj || obj._tool !== 'wall') return;
  obj.set('strokeWidth', parseInt(v));
  document.getElementById('pv-stroke-val').textContent = v;
  cv.renderAll();
  debouncePushHistory();
}

function applyFurnitureSize() {
  var obj = cv.getActiveObject();
  if (!obj || obj._tool !== 'furniture') return;
  var wVal = parseFloat(document.getElementById('pv-fw').value) || 1;
  var hVal = parseFloat(document.getElementById('pv-fh').value) || 1;
  var wpx = pxPerM ? wVal / 100 * pxPerM : wVal;
  var hpx = pxPerM ? hVal / 100 * pxPerM : hVal;
  if (obj.type === 'rect') {
    obj.set({ width: Math.max(10, wpx), height: Math.max(10, hpx) });
  } else {
    var curW = obj.width  * (obj.scaleX || 1);
    var curH = obj.height * (obj.scaleY || 1);
    obj.scaleX = (obj.scaleX || 1) * (Math.max(10, wpx) / curW);
    obj.scaleY = (obj.scaleY || 1) * (Math.max(10, hpx) / curH);
  }
  obj.setCoords();
  cv.renderAll();
}

var SECTION_STYLES = {
  SECTION: { fill: 'rgba(100,100,100,0.08)', stroke: '#AAAAAA' },
  MEETING: { fill: 'rgba(79,70,229,0.12)',   stroke: '#4F46E5' },
  REST:    { fill: 'rgba(74,222,128,0.12)',   stroke: '#16A34A' },
  OTHER:   { fill: 'rgba(251,191,36,0.12)',   stroke: '#D97706' }
};
var SECTION_LABELS = {
  SECTION: '일반 구역', MEETING: '회의실', REST: '휴게 공간', OTHER: '기타'
};

function applySectionType(type) {
  var obj = cv.getActiveObject();
  if (!obj || obj._tool !== 'section') return;
  obj._sectionType = type;
  var st = SECTION_STYLES[type] || SECTION_STYLES.SECTION;
  obj.set({ fill: st.fill, stroke: st.stroke });
  document.getElementById('pv-type').textContent = SECTION_LABELS[type] || '구역';
  cv.renderAll();
  debouncePushHistory();
}

function applySectionName(val) {
  var obj = cv.getActiveObject();
  if (!obj || obj._tool !== 'section') return;
  obj._name = val;
  debouncePushHistory();
}

function rgbToHex(color) {
  if (!color || color === 'transparent') return '#000000';
  if (color.charAt(0) === '#') {
    return color.length === 4
      ? '#' + color[1]+color[1]+color[2]+color[2]+color[3]+color[3]
      : color.slice(0,7);
  }
  var m = color.match(/rgba?\((\d+),\s*(\d+),\s*(\d+)/);
  if (!m) return '#000000';
  return '#' + [m[1],m[2],m[3]].map(function(c) {
    return parseInt(c).toString(16).padStart(2,'0');
  }).join('');
}

function darkenHex(hex, factor) {
  var r = Math.round(parseInt(hex.slice(1,3),16) * factor);
  var g = Math.round(parseInt(hex.slice(3,5),16) * factor);
  var b = Math.round(parseInt(hex.slice(5,7),16) * factor);
  return '#' + [r,g,b].map(function(c) {
    return Math.max(0, Math.min(255, c)).toString(16).padStart(2,'0');
  }).join('');
}

function applyObjColor(hex) {
  var obj = cv.getActiveObject();
  if (!obj) return;
  if (obj._tool === 'wall') {
    obj.set('stroke', hex);
  } else if (obj._tool === 'section') {
    var cur = obj.fill || 'rgba(100,100,100,0.08)';
    var am = cur.match(/rgba?\([^)]+,\s*([\d.]+)\)/);
    var alpha = am ? parseFloat(am[1]) : 0.08;
    var r = parseInt(hex.slice(1,3),16), g = parseInt(hex.slice(3,5),16), b = parseInt(hex.slice(5,7),16);
    obj.set('fill', 'rgba('+r+','+g+','+b+','+alpha+')');
    obj.set('stroke', darkenHex(hex, 0.75));
  } else {
    obj.set('fill', hex);
    obj.set('stroke', darkenHex(hex, 0.75));
  }
  cv.renderAll();
  debouncePushHistory();
}

function showPanelEmpty() {
  document.getElementById('pempty').style.display = 'block';
  document.getElementById('pobj').style.display   = 'none';
}

function applyAngleFromPanel(v) {
  var obj = cv.getActiveObject();
  if (!obj || obj._tool === 'wall') return;
  obj.set('angle', parseFloat(v) || 0);
  obj.setCoords();
  if (obj._tool === 'door' || obj._tool === 'window') {
    syncDoorWalls(obj);
    rebuildPts();
  }
  cv.renderAll();
  debouncePushHistory();
}

// ── Counter / Delete ──────────────────────────────────────
function countUp() {
  var n = cv.getObjects().filter(function(o) { return !o._bg && !o._prev; }).length;
  document.getElementById('bb-count').textContent = '오브젝트 ' + n + '개';
  refreshObjList();
}

function deleteSelected() {
  if (scaleModeOn) return;
  var sel = cv.getActiveObjects();
  if (!sel.length) return;
  sel.forEach(function(o) {
    if (o._bg) return;
    if (o._tool === 'door' || o._tool === 'window') restoreGapWalls(o);
    cv.remove(o);
  });
  cv.discardActiveObject();
  cv.renderAll();
  showPanelEmpty();
  countUp();
  debouncePushHistory();
}

// ── Background Image ──────────────────────────────────────
function onBgFile(e) {
  var f = e.target.files[0];
  if (!f) return;
  var rd = new FileReader();
  rd.onload = function(ev) {
    if (bgImg) { cv.remove(bgImg); bgImg = null; }
    fabric.Image.fromURL(ev.target.result, function(img) {
      var sc = Math.min((cW - 40) / img.width, (cH - 40) / img.height, 1);
      img.set({
        left: cW / 2, top: cH / 2,
        originX: 'center', originY: 'center',
        scaleX: sc, scaleY: sc,
        opacity: 0.35,
        selectable: false, evented: false,
        hasControls: false, hasBorders: false,
        _bg: true
      });
      cv.add(img);
      cv.sendToBack(img);
      bgImg = img;
      cv.renderAll();
      wizardBgLoaded();
    });
  };
  rd.readAsDataURL(f);
  e.target.value = '';
}

function setBgOpacity(v) {
  document.getElementById('bgopa-val').textContent = v + '%';
  if (bgImg) { bgImg.set('opacity', parseInt(v) / 100); cv.renderAll(); }
}

function toggleBg() {
  if (!bgImg) return;
  bgOn = !bgOn;
  bgImg.set('opacity', bgOn ? parseInt(document.getElementById('bgopa').value) / 100 : 0);
  document.getElementById('btn-toggle-bg').textContent = bgOn ? '숨기기' : '보이기';
  cv.renderAll();
}

function removeBg() {
  if (!bgImg) return;
  if (!confirm('배경 도면을 제거할까요?')) return;
  if (exExtractActive) exitExtractMode();
  if (scaleModeOn) { clearCalibObjects(); scaleModeOn = false; }
  cv.remove(bgImg);
  bgImg = null;
  bgOn  = true;
  cv.selection = true;
  cv.defaultCursor = 'default';
  document.getElementById('bgctrl').style.display = 'none';
  setTool('select');
  cv.renderAll();
  wizardFullReset();
}

function enterScaleMode() {
  scaleModeOn = true;
  calibSt = { pt1: null, pt2: null, dot1: null, dot2: null, line: null, prev: null, pxLen: 0 };

  bgImg.set({ selectable: false, evented: false, hasControls: false, hasBorders: false });

  cv.selection     = false;
  cv.defaultCursor = 'crosshair';
  cv.hoverCursor   = 'crosshair';
  cv.discardActiveObject();
  cv.forEachObject(function(o) { o.selectable = false; o.evented = false; });
  cv.renderAll();

  document.getElementById('calib-step1').style.display = 'block';
  document.getElementById('calib-step2').style.display = 'none';
  flashHint('두 점을 클릭해서 측정 선을 그으세요');
}

function finishCalibLine(pt1, pt2) {
  var pxLen = Math.round(Math.hypot(pt2.x - pt1.x, pt2.y - pt1.y));
  if (pxLen < 5) { toast('선이 너무 짧습니다. 다시 그려주세요'); resetCalib(); return; }
  calibSt.pxLen = pxLen;

  calibSt.line = new fabric.Line([pt1.x, pt1.y, pt2.x, pt2.y], {
    stroke: '#FF3B30', strokeWidth: 2,
    selectable: false, evented: false, _calib: true
  });
  calibSt.dot2 = new fabric.Circle({
    left: pt2.x, top: pt2.y, radius: 5,
    fill: '#FF3B30', stroke: '#fff', strokeWidth: 1.5,
    originX: 'center', originY: 'center',
    selectable: false, evented: false, _calib: true
  });

  // Midpoint label
  var mx = (pt1.x + pt2.x) / 2, my = (pt1.y + pt2.y) / 2;
  calibSt.lbl = new fabric.Text(pxLen + ' px', {
    left: mx, top: my - 16, originX: 'center',
    fontSize: 10, fill: '#FF3B30', fontWeight: '700',
    selectable: false, evented: false, _calib: true,
    shadow: new fabric.Shadow({ color: '#fff', blur: 4, offsetX: 0, offsetY: 0 })
  });

  cv.add(calibSt.line);
  cv.add(calibSt.dot2);
  cv.add(calibSt.lbl);
  cv.renderAll();

  document.getElementById('calib-px-len').textContent = pxLen;
  document.getElementById('calib-step1').style.display = 'none';
  document.getElementById('calib-step2').style.display = 'block';
  updateCalibLabel();  // pre-fill grid-mm with snapped estimate
  document.getElementById('scale-meters').focus();
  flashHint('거리를 확인하고 격자 크기를 조정하세요');
}

function clearCalibObjects() {
  cv.getObjects().filter(function(o) { return o._calib; }).forEach(function(o) { cv.remove(o); });
  calibSt = { pt1: null, pt2: null, dot1: null, dot2: null, line: null, prev: null, pxLen: 0 };
}

function resetCalib() {
  clearCalibObjects();
  cv.renderAll();
  document.getElementById('calib-step1').style.display = 'block';
  document.getElementById('calib-step2').style.display = 'none';
  flashHint('두 점을 클릭해서 측정 선을 그으세요');
}

function cancelCalib() {
  clearCalibObjects();
  scaleModeOn = false;
  if (bgImg) bgImg.set({ selectable: false, evented: false });
  cv.selection = true;
  cv.defaultCursor = 'default';
  cv.hoverCursor   = 'default';
  // Restore selectable state matching the current editing step (mirrors goToStep logic)
  cv.forEachObject(function(o) {
    if (o._bg || o._prev) return;
    var sel = currentStep === 1 ? (o._tool && o._tool !== 'furniture')
            : currentStep === 2 ? (o._tool === 'furniture' || o._tool === 'section')
            : false;
    o.selectable = !!sel;
    o.evented    = !!sel;
  });
  setTool('select');
  cv.renderAll();
  wizardGoTo(1);
}

function confirmScale() {
  if (!calibSt.pxLen) { toast('먼저 측정 선을 그으세요'); return; }
  var gridMm = parseInt(document.getElementById('grid-mm').value);
  if (!gridMm || gridMm < 10) { toast('격자 크기를 확인하세요'); return; }

  pxPerM = GRID / (gridMm / 1000);

  clearCalibObjects();
  bgImg.set({ selectable: false, evented: false, hasControls: false, hasBorders: false });
  scaleModeOn = false;

  cv.selection = true;
  cv.defaultCursor = 'default';
  cv.forEachObject(function(o) { if (!o._bg) { o.selectable = true; o.evented = true; } });
  cv.renderAll();

  wizardScaleMm = gridMm;
  document.getElementById('scale-info').textContent = '1칸 = ' + gridMm + ' mm';
  toast('축척 확정 — 1칸 = ' + gridMm + ' mm');
  wizardGoTo(3);
}

function updateCalibLabel() {
  if (!calibSt.pxLen) return;
  var m = parseFloat(document.getElementById('scale-meters').value) || 0;
  if (m <= 0) return;
  var rawMm    = GRID / (calibSt.pxLen / m) * 1000;
  var snapped  = Math.round(rawMm / 10) * 10;
  snapped      = Math.max(10, snapped);
  document.getElementById('grid-mm').value = snapped;
  document.getElementById('scale-info').textContent = '1칸 ≈ ' + snapped + ' mm';
}

function adjustGridMm(delta) {
  var inp = document.getElementById('grid-mm');
  var v   = (parseInt(inp.value) || 500) + delta;
  inp.value = Math.max(10, v);
  onGridMmChange();
}

function onGridMmChange() {
  var v = parseInt(document.getElementById('grid-mm').value) || 0;
  if (v > 0) document.getElementById('scale-info').textContent = '1칸 = ' + v + ' mm';
}

// ── Keyboard ──────────────────────────────────────────────
document.addEventListener('keydown', function(e) {
  if (e.key === 'Shift') shiftOn = true;
  if (e.key === 'Alt') { e.preventDefault(); altOn = true; }
  if (e.key === ' ') {
    e.preventDefault();
    if (!spaceDown) { spaceDown = true; cv.setCursor('grab'); }
    return;
  }
  // Ctrl/Cmd shortcuts (work even in inputs for undo/copy)
  if (e.ctrlKey || e.metaKey) {
    switch (e.key.toLowerCase()) {
      case 'z': e.preventDefault(); e.shiftKey ? redo() : undo(); return;
      case 'y': e.preventDefault(); redo(); return;
      case 'c': e.preventDefault(); copySelected(); return;
      case 'v': e.preventDefault(); pasteClipboard(); return;
      case 'a': {
        e.preventDefault();
        var selectables = cv.getObjects().filter(function(o) {
          if (o._bg || o._prev || o._calib) return false;
          return currentStep === 2
            ? (o._tool === 'furniture' || o._tool === 'section')
            : (o._tool && o._tool !== 'furniture' && o._tool !== 'section');
        });
        if (selectables.length === 1) { cv.setActiveObject(selectables[0]); }
        else if (selectables.length > 1) { cv.setActiveObject(new fabric.ActiveSelection(selectables, { canvas: cv })); }
        cv.renderAll(); return;
      }
      case 'd': {
        e.preventDefault();
        if (!cv.getActiveObject()) return;
        copySelected();
        var savedDelta = _pasteDelta;
        _pasteDelta = 0;
        pasteClipboard();
        _pasteDelta = savedDelta;
        return;
      }
      case 'g': {
        e.preventDefault();
        var ao = cv.getActiveObject();
        if (ao && ao.type === 'group' && ao._tool === 'group') {
          // Ctrl+G on existing group → ungroup
          var items = ao._objects.slice();
          var m = ao.calcTransformMatrix();
          cv.discardActiveObject();
          cv.remove(ao);
          items.forEach(function(item) {
            var pt = fabric.util.transformPoint(
              new fabric.Point(item.left || 0, item.top || 0), m);
            item.set({ left: pt.x, top: pt.y, angle: (item.angle||0)+(ao.angle||0) });
            item.setCoords();
            cv.add(item);
          });
          var sel = new fabric.ActiveSelection(items, { canvas: cv });
          cv.setActiveObject(sel); cv.renderAll(); debouncePushHistory();
          refreshObjList();
          toast('그룹 해제');
        } else {
          // Group (not walls)
          var objs = cv.getActiveObjects().filter(function(o) { return o._tool !== 'wall'; });
          if (objs.length < 2) { toast('그룹핑할 오브젝트를 2개 이상 선택하세요'); return; }
          cv.discardActiveObject();
          var grp = new fabric.Group(objs, {
            originX: 'center', originY: 'center',
            selectable: true, evented: true,
            hasControls: true, hasBorders: true,
            _tool: 'group'
          });
          objs.forEach(function(o) { cv.remove(o); });
          cv.add(grp); cv.setActiveObject(grp); cv.renderAll(); debouncePushHistory();
          refreshObjList();
          toast('그룹 생성 (' + objs.length + '개)');
        }
        return;
      }
    }
  }
  var tag = document.activeElement.tagName;
  if (tag === 'INPUT' || tag === 'TEXTAREA') return;
  switch (e.key) {
    case 'Escape':
      cancelWall(); cancelSection();
      if (activeTool === 'section') setTool('select');
      cv.discardActiveObject(); cv.renderAll(); break;
    case 'Delete':
    case 'Backspace': deleteSelected(); break;
    case 'v': case 'V': if (!e.ctrlKey && !e.metaKey) setTool('select'); break;
    case 'w': case 'W': setTool('wall');   break;
    case 'd': case 'D': if (!e.ctrlKey && !e.metaKey) setTool('door'); break;
    case 'n': case 'N': setTool('window'); break;
    case 'c': case 'C': if (!e.ctrlKey && !e.metaKey) setTool('column'); break;
    case 'ArrowLeft': case 'ArrowRight': case 'ArrowUp': case 'ArrowDown': {
      var ao = cv.getActiveObject();
      if (!ao) break;
      e.preventDefault();
      var step = e.shiftKey ? SNAP : 1;
      var dx = e.key === 'ArrowLeft' ? -step : e.key === 'ArrowRight' ? step : 0;
      var dy = e.key === 'ArrowUp'   ? -step : e.key === 'ArrowDown'  ? step : 0;
      // Snapshot gap canvas coords BEFORE moving (transform still valid at this point)
      var _nudgeObjs = ao.type === 'activeSelection' ? ao.getObjects() : [ao];
      var _preMoveGaps = [];
      _nudgeObjs.forEach(function(o) {
        if ((o._tool === 'door' || o._tool === 'window') && o._localPt1) {
          var g = getDoorGapPts(o);
          if (g) _preMoveGaps.push({ obj: o, pt1: g.pt1, pt2: g.pt2 });
        }
      });
      var moveObj = function(o) {
        if (o._tool === 'wall') {
          o.set({ x1: o.x1+dx, y1: o.y1+dy, x2: o.x2+dx, y2: o.y2+dy,
                  left: o.left+dx, top: o.top+dy });
          o.setCoords();
        } else {
          o.set({ left: o.left+dx, top: o.top+dy }); o.setCoords();
        }
      };
      if (ao.type === 'activeSelection') { ao.getObjects().forEach(moveObj); ao.setCoords(); }
      else moveObj(ao);
      // Re-encode local gap in new position and keep stub walls in sync
      _preMoveGaps.forEach(function(d) {
        storeDoorLocalGap(d.obj, { x: d.pt1.x + dx, y: d.pt1.y + dy },
                                  { x: d.pt2.x + dx, y: d.pt2.y + dy });
        syncDoorWalls(d.obj);
      });
      rebuildPts(); cv.renderAll(); debouncePushHistory();
      break;
    }
  }
});
document.addEventListener('keyup', function(e) {
  if (e.key === 'Shift') shiftOn = false;
  if (e.key === 'Alt') altOn = false;
  if (e.key === ' ') {
    spaceDown = false;
    cv.setCursor(activeTool === 'select' ? 'default' : 'crosshair');
  }
});

// #4: Clear endpoint/body drag state when mouse is released outside the canvas.
// cv's 'mouse:up' only fires inside the canvas, so without this the wall stays
// locked (lockMovementX/Y = true) and the drag variables are never reset.
document.addEventListener('mouseup', function() {
  if (epDragging) {
    epDragging.wall.lockMovementX = false;
    epDragging.wall.lockMovementY = false;
    epDragging = null;
    rebuildPts();
    updatePanel();
    cv.selection = true;
    cv.setCursor('default');
    cv.requestRenderAll();
  }
  if (bodyDragging) {
    bodyDragging.wall.setCoords();
    bodyDragging = null;
    rebuildPts();
    updatePanel();
    cv.selection = true;
    cv.setCursor('default');
    debouncePushHistory();
    cv.renderAll();
  }
});

// ── Step Management ───────────────────────────────────────
var currentStep = 1;
var furnitureCnt = 0;
var _placeStagger = 0;  // increments each placement so items don't stack exactly

// ── Icon Library (24×24 stroke paths, MIT-compatible originals) ──────────
var ICON_LIB = {
  'desk':          'M 3 8 h 18 v 10 H 3 z M 6 18 v 2 M 18 18 v 2',
  'desk-study':    'M 3 8 h 18 v 10 H 3 z M 6 18 v 2 M 18 18 v 2 M 3 8 V 5 h 6 M 21 8 V 5 h -6',
  'desk-standing': 'M 3 7 h 18 v 11 H 3 z M 6 18 v 3 M 18 18 v 3 M 3 10 h 18',
  'chair':         'M 8 4 a 4 4 0 0 1 8 0 v 6 H 8 z M 5 10 h 14 v 8 H 5 z M 7 18 v 2 M 17 18 v 2',
  'sofa-1':        'M 4 10 a 2 2 0 0 1 2 -2 h 12 a 2 2 0 0 1 2 2 v 6 H 4 z M 4 10 v 6 h 16 M 4 10 V 7 h 16 v 3',
  'sofa-2':        'M 3 10 a 2 2 0 0 1 2 -2 h 14 a 2 2 0 0 1 2 2 v 6 H 3 z M 3 16 h 18 M 3 10 V 7 h 18 v 3 M 12 8 v 8',
  'sofa-3':        'M 2 10 a 2 2 0 0 1 2 -2 h 16 a 2 2 0 0 1 2 2 v 6 H 2 z M 2 16 h 20 M 2 10 V 7 h 20 v 3 M 8.7 8 v 8 M 15.3 8 v 8',
  'armchair':      'M 6 9 a 3 3 0 0 1 3 -3 h 6 a 3 3 0 0 1 3 3 M 3 9 h 3 v 8 h 12 V 9 h 3 a 1 1 0 0 1 1 1 v 3 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 V 10 a 1 1 0 0 1 1 -1 z M 6 17 v 3 M 18 17 v 3',
  'cabinet':       'M 4 3 h 16 a 1 1 0 0 1 1 1 v 16 a 1 1 0 0 1 -1 1 H 4 a 1 1 0 0 1 -1 -1 V 4 a 1 1 0 0 1 1 -1 z M 4 12 h 16 M 12 3 v 9 M 12 12 v 9 M 9.5 8 h 1 M 14.5 8 h -1 M 9.5 17 h 1 M 14.5 17 h -1',
  'locker':        'M 6 3 h 12 a 1 1 0 0 1 1 1 v 16 a 1 1 0 0 1 -1 1 H 6 a 1 1 0 0 1 -1 -1 V 4 a 1 1 0 0 1 1 -1 z M 6 12 h 12 M 11 8 h 2 M 11 17 h 2',
  'shelf':         'M 2 5 h 20 v 2 H 2 z M 2 12 h 20 v 2 H 2 z M 2 19 h 20 v 2 H 2 z M 5 7 v 5 M 12 7 v 5 M 19 7 v 5',
  'partition':     'M 2 12 h 20',
  'partition-l':   'M 4 4 v 16 h 16',
  'monitor':       'M 2 5 h 20 a 1 1 0 0 1 1 1 v 11 a 1 1 0 0 1 -1 1 H 2 a 1 1 0 0 1 -1 -1 V 6 a 1 1 0 0 1 1 -1 z M 8 20 h 8 M 12 18 v 2',
  'monitor-2':     'M 1 5 h 22 a 1 1 0 0 1 1 1 v 11 a 1 1 0 0 1 -1 1 H 1 a 1 1 0 0 1 -1 -1 V 6 a 1 1 0 0 1 1 -1 z M 7 20 h 10 M 12 18 v 2 M 12 5 v 13',
  'laptop':        'M 4 6 h 16 a 1 1 0 0 1 1 1 v 9 a 1 1 0 0 1 -1 1 H 4 a 1 1 0 0 1 -1 -1 V 7 a 1 1 0 0 1 1 -1 z M 2 16 h 20 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1',
  'printer':       'M 7 4 h 10 a 1 1 0 0 1 1 1 v 4 H 6 V 5 a 1 1 0 0 1 1 -1 z M 4 9 h 16 a 1 1 0 0 1 1 1 v 5 a 1 1 0 0 1 -1 1 h -2 v 4 H 6 v -4 H 4 a 1 1 0 0 1 -1 -1 v -5 a 1 1 0 0 1 1 -1 z M 17 11 h 1 M 8 15 h 8',
  'copier':        'M 7 3 h 10 a 1 1 0 0 1 1 1 v 4 H 6 V 4 a 1 1 0 0 1 1 -1 z M 3 8 h 18 a 1 1 0 0 1 1 1 v 6 a 1 1 0 0 1 -1 1 h -3 v 5 H 6 v -5 H 3 a 1 1 0 0 1 -1 -1 V 9 a 1 1 0 0 1 1 -1 z M 17 10.5 h 1 M 8 13 h 8',
  'scanner':       'M 3 6 h 18 a 1 1 0 0 1 1 1 v 5 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 V 7 a 1 1 0 0 1 1 -1 z M 6 12 v 6 h 12 v -6 M 12 9.5 h 5',
  'server':        'M 3 4 h 18 a 1 1 0 0 1 1 1 v 3 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 V 5 a 1 1 0 0 1 1 -1 z M 3 10 h 18 a 1 1 0 0 1 1 1 v 3 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 v -3 a 1 1 0 0 1 1 -1 z M 3 16 h 18 a 1 1 0 0 1 1 1 v 3 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 v -3 a 1 1 0 0 1 1 -1 z M 17 5.5 h 2 M 17 11.5 h 2 M 17 17.5 h 2',
  'server-rack':   'M 5 3 h 14 a 1 1 0 0 1 1 1 v 16 a 1 1 0 0 1 -1 1 H 5 a 1 1 0 0 1 -1 -1 V 4 a 1 1 0 0 1 1 -1 z M 5 7 h 14 M 5 11 h 14 M 5 15 h 14 M 5 19 h 14 M 15 5 h 2 M 15 9 h 2 M 15 13 h 2 M 15 17 h 2',
  'phone':         'M 6.6 3.8 a 2 2 0 0 1 2.8 0 l 2 2 a 2 2 0 0 1 0 2.8 l -0.5 0.5 a 9 9 0 0 0 4 4 l 0.5 -0.5 a 2 2 0 0 1 2.8 0 l 2 2 a 2 2 0 0 1 0 2.8 l -0.7 0.7 c -1.2 1.2 -3 1.5 -4.5 0.8 A 20 20 0 0 1 5.8 10 c -0.7 -1.5 -0.4 -3.3 0.8 -4.5 z',
  'phone-ip':      'M 8 3 h 8 a 1 1 0 0 1 1 1 v 3 a 1 1 0 0 1 -1 1 H 8 a 1 1 0 0 1 -1 -1 V 4 a 1 1 0 0 1 1 -1 z M 12 8 v 3 M 7 11 h 10 v 2 H 4 a 1 1 0 0 0 -1 1 v 4 a 1 1 0 0 0 1 1 h 16 a 1 1 0 0 0 1 -1 v -4 a 1 1 0 0 0 -1 -1 h -3 v -2 M 9 15 h 2 M 13 15 h 2 M 9 18 h 2 M 13 18 h 2',
  'router':        'M 3 16 h 18 a 1 1 0 0 0 1 -1 v -3 a 1 1 0 0 0 -1 -1 H 3 a 1 1 0 0 0 -1 1 v 3 a 1 1 0 0 0 1 1 z M 5.6 9 a 9 9 0 0 1 12.8 0 M 8.4 11.8 a 5 5 0 0 1 7.2 0 M 12 14 v -2 M 7 19 h 1 M 16 19 h 1',
  'camera':        'M 2 8 a 2 2 0 0 1 2 -2 h 2 l 2 -2 h 8 l 2 2 h 2 a 2 2 0 0 1 2 2 v 9 a 2 2 0 0 1 -2 2 H 4 a 2 2 0 0 1 -2 -2 z M 15 10 h 2 M 12 15 m -3 0 a 3 3 0 1 0 6 0 a 3 3 0 1 0 -6 0',
  'projector':     'M 3 8 h 18 a 1 1 0 0 1 1 1 v 7 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 V 9 a 1 1 0 0 1 1 -1 z M 9.5 11.5 m -2.5 0 a 2.5 2.5 0 1 0 5 0 a 2.5 2.5 0 1 0 -5 0 M 14 10 h 4 M 14 12 h 4 M 14 14 h 4 M 8 17 l -2 4 M 16 17 l 2 4',
  'tv':            'M 2 7 h 20 a 1 1 0 0 1 1 1 v 11 a 1 1 0 0 1 -1 1 H 2 a 1 1 0 0 1 -1 -1 V 8 a 1 1 0 0 1 1 -1 z M 7 4 l 5 3 M 17 4 l -5 3',
  'ups':           'M 8 3 h 8 a 1 1 0 0 1 1 1 v 16 a 1 1 0 0 1 -1 1 H 8 a 1 1 0 0 1 -1 -1 V 4 a 1 1 0 0 1 1 -1 z M 10 6 h 4 M 10 9 h 4 M 12 12 v 5 M 10 14.5 h 4',
  'fridge':        'M 7 2 h 10 a 1 1 0 0 1 1 1 v 18 a 1 1 0 0 1 -1 1 H 7 a 1 1 0 0 1 -1 -1 V 3 a 1 1 0 0 1 1 -1 z M 7 9 h 10 M 10 5 v 2 M 10 12 v 5',
  'microwave':     'M 2 6 h 20 a 1 1 0 0 1 1 1 v 10 a 1 1 0 0 1 -1 1 H 2 a 1 1 0 0 1 -1 -1 V 7 a 1 1 0 0 1 1 -1 z M 18 6 v 12 M 4 9 h 10 v 6 H 4 z M 19 9 h 1 M 19 12 h 1 M 19 15 h 1',
  'coffee':        'M 7 4 h 10 a 1 1 0 0 1 1 1 v 10 a 1 1 0 0 1 -1 1 H 7 a 1 1 0 0 1 -1 -1 V 5 a 1 1 0 0 1 1 -1 z M 6 16 h 12 v 2 a 1 1 0 0 1 -1 1 H 7 a 1 1 0 0 1 -1 -1 z M 10 8 a 1.5 1.5 0 1 1 0 3 M 14 8 a 1.5 1.5 0 1 1 0 3',
  'water':         'M 10 3 h 4 a 1 1 0 0 1 1 1 v 3 h -6 V 4 a 1 1 0 0 1 1 -1 z M 8 7 h 8 v 13 a 1 1 0 0 1 -1 1 H 9 a 1 1 0 0 1 -1 -1 z M 10 12 h 1 M 10 15 h 1 M 13 12 h 1',
  'vending':       'M 5 2 h 14 a 1 1 0 0 1 1 1 v 18 a 1 1 0 0 1 -1 1 H 5 a 1 1 0 0 1 -1 -1 V 3 a 1 1 0 0 1 1 -1 z M 5 16 h 14 M 9 19 h 6 M 8 5 h 8 v 9 H 8 z M 12 7 v 5',
  'trash':         'M 3 6 h 18 M 9 3 h 6 M 5 6 l 1 14 a 1 1 0 0 0 1 1 h 10 a 1 1 0 0 0 1 -1 l 1 -14 M 10 10 v 7 M 14 10 v 7',
  'plant':         'M 12 21 v -7 M 12 14 c 0 0 -4 -2 -5 -6 c 2 -1 5 0 5 6 M 12 14 c 0 0 4 -3 6 -2 c -1 3 -3 4 -6 2 M 8 21 h 8',
  'tree':          'M 12 3 l 5 7 h -3 l 3 5 h -4 v 6 h -2 v -6 H 7 l 3 -5 H 7 z',
  'ac':            'M 3 7 h 18 a 1 1 0 0 1 1 1 v 5 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 V 8 a 1 1 0 0 1 1 -1 z M 7 10 h 10 M 8 14 l -2 5 M 12 14 v 5 M 16 14 l 2 5 M 18 10 h 1',
  'extinguisher':  'M 9 6 a 3 3 0 0 1 6 0 v 11 a 3 3 0 0 1 -6 0 z M 12 6 V 3 M 9 7 H 7 a 2 2 0 0 0 -2 2 v 1 a 1 1 0 0 0 1 1 h 3 M 13 12 h 2',
  'safe':          'M 4 4 h 16 a 1 1 0 0 1 1 1 v 14 a 1 1 0 0 1 -1 1 H 4 a 1 1 0 0 1 -1 -1 V 5 a 1 1 0 0 1 1 -1 z M 12 12 m -3 0 a 3 3 0 1 0 6 0 a 3 3 0 1 0 -6 0 M 12 9 V 7 M 9.9 10 l -1.4 -1.4 M 4 8 v 2 M 20 8 v 2',
  'mailbox':       'M 3 8 h 18 a 1 1 0 0 1 1 1 v 9 a 1 1 0 0 1 -1 1 H 3 a 1 1 0 0 1 -1 -1 V 9 a 1 1 0 0 1 1 -1 z M 3 8 l 9 7 l 9 -7 M 15 13 h -3',
  'whiteboard':    'M 2 4 h 20 a 1 1 0 0 1 1 1 v 13 a 1 1 0 0 1 -1 1 H 2 a 1 1 0 0 1 -1 -1 V 5 a 1 1 0 0 1 1 -1 z M 9 21 l 3 -3 l 3 3 M 6.5 9.5 l 3 3 l 5 -5',
  'screen':        'M 1 4 h 22 a 1 1 0 0 1 1 1 v 13 a 1 1 0 0 1 -1 1 H 1 a 1 1 0 0 1 -1 -1 V 5 a 1 1 0 0 1 1 -1 z M 12 19 v 2 M 9 21 h 6',
  'round-table':   'M 12 12 m -6 0 a 6 6 0 1 0 12 0 a 6 6 0 1 0 -12 0 M 12 3 v 3 M 21 12 h -3 M 12 21 v -3 M 3 12 h 3 M 18.4 5.6 l -2.1 2.1 M 18.4 18.4 l -2.1 -2.1 M 5.6 18.4 l 2.1 -2.1 M 5.6 5.6 l 2.1 2.1',
  'stand-fan':     'M 12 21 v -4 M 9 21 h 6 M 12 8 m -3 0 a 3 3 0 1 0 6 0 a 3 3 0 1 0 -6 0 M 12 8 c -4 0 -5 -4 -2 -5 M 12 8 c 0 -4 4 -5 5 -2 M 12 8 c 4 0 5 4 2 5 M 12 8 c 0 4 -4 5 -5 2 M 12 17 v -6'
};

// ── Object definitions (all furniture / objects) ───────────────────────────
var OBJECT_DEFS = [
  // 책상
  { id:'desk-std',      label:'일반 책상',   cat:'desk',      icon:'desk',         w:80,  h:55,  fill:'#EDE5D8', sk:'#C4B5A5', cap:1, wM:1.4, hM:0.70,
    fieldDefs:[{name:'번호',type:'text'},{name:'담당자',type:'text'},{name:'모니터',type:'number'},{name:'예약가능',type:'checkbox'}] },
  { id:'desk-study',    label:'독서실 책상', cat:'desk',      icon:'desk-study',   w:70,  h:60,  fill:'#EDE5D8', sk:'#C4B5A5', cap:1, wM:1.2, hM:0.75,
    fieldDefs:[{name:'번호',type:'text'},{name:'담당자',type:'text'},{name:'예약가능',type:'checkbox'}] },
  { id:'desk-standing', label:'스탠딩 데스크',cat:'desk',     icon:'desk-standing',w:80,  h:55,  fill:'#E8F0E8', sk:'#8CA88C', cap:1, wM:1.4, hM:0.70,
    fieldDefs:[{name:'번호',type:'text'},{name:'담당자',type:'text'},{name:'예약가능',type:'checkbox'}] },
  // 소파/의자
  { id:'sofa-1',        label:'소파 1인',    cat:'lounge',    icon:'sofa-1',       w:60,  h:60,  fill:'#D8CFC8', sk:'#B8AFA8', cap:1 },
  { id:'sofa-2',        label:'소파 2인',    cat:'lounge',    icon:'sofa-2',       w:120, h:60,  fill:'#D8CFC8', sk:'#B8AFA8', cap:2 },
  { id:'sofa-3',        label:'소파 3인',    cat:'lounge',    icon:'sofa-3',       w:180, h:60,  fill:'#D8CFC8', sk:'#B8AFA8', cap:3 },
  { id:'armchair',      label:'암체어',      cat:'lounge',    icon:'armchair',     w:70,  h:70,  fill:'#D8CFC8', sk:'#B8AFA8', cap:1 },
  // 수납
  { id:'cabinet',       label:'캐비닛',      cat:'storage',   icon:'cabinet',      w:80,  h:40,  fill:'#E0DBD6', sk:'#B0ABA8', cap:0 },
  { id:'locker',        label:'사물함',      cat:'storage',   icon:'locker',       w:40,  h:60,  fill:'#E0DBD6', sk:'#B0ABA8', cap:0 },
  { id:'shelf',         label:'선반',        cat:'storage',   icon:'shelf',        w:100, h:30,  fill:'#E0DBD6', sk:'#B0ABA8', cap:0 },
  // 파티션
  { id:'partition',     label:'파티션 직선', cat:'partition', icon:'partition',    w:120, h:8,   fill:'#C8BFB8', sk:'#9E9590', cap:0 },
  { id:'partition-l',   label:'파티션 L자',  cat:'partition', icon:'partition-l',  w:80,  h:80,  fill:'#C8BFB8', sk:'#9E9590', cap:0 },
  // IT
  { id:'monitor',       label:'모니터',      cat:'it',        icon:'monitor',      w:60,  h:40,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'monitor-2',     label:'듀얼모니터',  cat:'it',        icon:'monitor-2',    w:100, h:40,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'laptop',        label:'노트북',      cat:'it',        icon:'laptop',       w:50,  h:35,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'printer',       label:'프린터',      cat:'it',        icon:'printer',      w:50,  h:55,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'copier',        label:'복사기',      cat:'it',        icon:'copier',       w:70,  h:65,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'scanner',       label:'스캐너',      cat:'it',        icon:'scanner',      w:55,  h:35,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'server',        label:'서버',        cat:'it',        icon:'server',       w:50,  h:80,  fill:'#D0D0D8', sk:'#808098', cap:0 },
  { id:'server-rack',   label:'서버랙',      cat:'it',        icon:'server-rack',  w:60,  h:100, fill:'#D0D0D8', sk:'#808098', cap:0 },
  { id:'phone',         label:'전화기',      cat:'it',        icon:'phone',        w:40,  h:35,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'phone-ip',      label:'IP폰',        cat:'it',        icon:'phone-ip',     w:45,  h:50,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'router',        label:'라우터',      cat:'it',        icon:'router',       w:50,  h:40,  fill:'#D0D0D8', sk:'#808098', cap:0 },
  { id:'camera',        label:'CCTV',        cat:'it',        icon:'camera',       w:35,  h:30,  fill:'#D0D0D8', sk:'#808098', cap:0 },
  { id:'projector',     label:'프로젝터',    cat:'it',        icon:'projector',    w:60,  h:40,  fill:'#E0E0E8', sk:'#9090A0', cap:0 },
  { id:'tv',            label:'TV',          cat:'it',        icon:'tv',           w:120, h:70,  fill:'#D0D0D8', sk:'#808098', cap:0 },
  { id:'ups',           label:'UPS',         cat:'it',        icon:'ups',          w:30,  h:60,  fill:'#D0D0D8', sk:'#808098', cap:0 },
  // 생활/편의
  { id:'fridge',        label:'냉장고',      cat:'appliance', icon:'fridge',       w:60,  h:70,  fill:'#E8E8F0', sk:'#9090A8', cap:0 },
  { id:'microwave',     label:'전자레인지',  cat:'appliance', icon:'microwave',    w:60,  h:40,  fill:'#E8E8F0', sk:'#9090A8', cap:0 },
  { id:'coffee',        label:'커피머신',    cat:'appliance', icon:'coffee',       w:45,  h:55,  fill:'#E8E8F0', sk:'#9090A8', cap:0 },
  { id:'water',         label:'정수기',      cat:'appliance', icon:'water',        w:35,  h:70,  fill:'#E8F0F8', sk:'#8098B0', cap:0 },
  { id:'vending',       label:'자판기',      cat:'appliance', icon:'vending',      w:55,  h:90,  fill:'#E8E8F0', sk:'#9090A8', cap:0 },
  { id:'trash',         label:'쓰레기통',    cat:'appliance', icon:'trash',        w:35,  h:40,  fill:'#E0E0E0', sk:'#909090', cap:0 },
  { id:'stand-fan',     label:'선풍기',      cat:'appliance', icon:'stand-fan',    w:35,  h:40,  fill:'#E8E8F0', sk:'#9090A8', cap:0 },
  // 인테리어
  { id:'plant',         label:'화분',        cat:'decor',     icon:'plant',        w:30,  h:40,  fill:'#E8F4E0', sk:'#80A870', cap:0 },
  { id:'tree',          label:'나무',        cat:'decor',     icon:'tree',         w:50,  h:60,  fill:'#E0F0D8', sk:'#70A060', cap:0 },
  { id:'ac',            label:'에어컨',      cat:'decor',     icon:'ac',           w:90,  h:28,  fill:'#E8F0F8', sk:'#8098B0', cap:0 },
  // 안전/설비
  { id:'extinguisher',  label:'소화기',      cat:'safety',    icon:'extinguisher', w:25,  h:45,  fill:'#F8E0E0', sk:'#C08080', cap:0 },
  { id:'safe',          label:'금고',        cat:'safety',    icon:'safe',         w:45,  h:45,  fill:'#E0E0E0', sk:'#909090', cap:0 },
  { id:'mailbox',       label:'우편함',      cat:'safety',    icon:'mailbox',      w:45,  h:35,  fill:'#E8E0D8', sk:'#B0A898', cap:0 },
  // 회의/발표
  { id:'whiteboard',    label:'화이트보드',  cat:'meeting',   icon:'whiteboard',   w:130, h:22,  fill:'#F8F8F0', sk:'#B0B090', cap:0 },
  { id:'screen',        label:'스크린',      cat:'meeting',   icon:'screen',       w:160, h:22,  fill:'#F0F0F0', sk:'#A0A0A0', cap:0 },
  { id:'round-table',   label:'원형테이블',  cat:'meeting',   icon:'round-table',  w:100, h:100, fill:'#EDE5D8', sk:'#C4B5A5', cap:6,
    fieldDefs:[{name:'이름',type:'text'},{name:'수용인원',type:'number'},{name:'예약가능',type:'checkbox'}] }
];

// ── Object definitions lookup ──────────────────────────────────────────────
var OBJECT_DEFS_MAP = {};
OBJECT_DEFS.forEach(function(d) { OBJECT_DEFS_MAP[d.id] = d; });

var PRESETS = {
  desk1:     { label: '책상',   cap: 1, w: 80,  h: 55, fill: '#EDE5D8', sk: '#C4B5A5', wM: 1.4, hM: 0.70 },
  partition: { label: '파티션', cap: 0, w: 120, h: 8,  fill: '#C8BFB8', sk: '#9E9590', wM: 1.5, hM: 0.05 },
  sofa:      { label: '소파',   cap: 3, w: 120, h: 48, fill: '#D8CFC8', sk: '#B8AFA8', wM: 1.8, hM: 0.80 },
};

var sectionSt = { on: false, x0: 0, y0: 0, prev: null };

function goToStep(n) {
  currentStep = n;

  // Remove any leftover highlight overlays from the previous step
  cv.getObjects().filter(function(o) { return o._hl; }).forEach(function(o) { cv.remove(o); });

  // Step indicator
  document.querySelectorAll('.step').forEach(function(el, i) {
    el.classList.remove('active', 'done', 'pending');
    if      (i + 1 < n)  el.classList.add('done');
    else if (i + 1 === n) el.classList.add('active');
    else                  el.classList.add('pending');
  });

  // Sidebar content
  var sb = document.getElementById('main-sidebar');
  document.getElementById('s1-tools').style.display   = n === 1 ? 'contents' : 'none';
  document.getElementById('s2-presets').style.display = n === 2 ? 'flex'     : 'none';
  if (n === 2) sb.classList.add('s2'); else sb.classList.remove('s2');

  // Right panel
  document.getElementById('panel-normal').style.display = n === 3 ? 'none' : 'flex';
  document.getElementById('panel-step3').style.display  = n === 3 ? 'flex' : 'none';
  // Step 2: hide the floor-plan setup wizard (step-1 content) and show placement hint
  document.getElementById('setup-wizard').style.display = n === 2 ? 'none' : '';
  document.getElementById('pempty').innerHTML = n === 2
    ? '왼쪽 패널에서 가구를 추가하거나<br>캔버스에서 클릭해 선택하세요'
    : '오브젝트를 선택하거나<br>도구를 선택해<br>작업을 시작하세요';
  if (n === 2) { _placeStagger = 0; showPanelEmpty(); }

  // Bottom bar
  var prevBtn = document.getElementById('bb-prev');
  prevBtn.disabled = (n === 1);
  var labels = ['', '요소 배치', '세부 정보', '완료'];
  document.getElementById('bb-next-label').textContent = labels[n] || '완료';
  var hint = document.getElementById('bb-hint');
  hint.innerHTML = n === 1
    ? '<kbd>Shift</kbd>+클릭 연속벽 · <kbd>방향키</kbd> 이동 · <kbd>Shift</kbd>+<kbd>방향키</kbd> 5px · <kbd>Ctrl</kbd>+드래그 팬 · <kbd>Del</kbd> 삭제'
    : n === 2
      ? '<kbd>Ctrl</kbd>+<kbd>A</kbd> 전체선택 · <kbd>Ctrl</kbd>+<kbd>D</kbd> 복제 · <kbd>Ctrl</kbd>+<kbd>G</kbd> 그룹 · <kbd>방향키</kbd> 이동 · <kbd>Del</kbd> 삭제'
      : '항목을 클릭하면 상세 정보를 입력할 수 있습니다';

  // Canvas mode
  cancelWall();
  if (n === 1) {
    // Structure editable, furniture locked
    cv.forEachObject(function(o) {
      if (o._bg || o._prev) return;
      var isStructure = (o._tool && o._tool !== 'furniture');
      o.selectable = isStructure;
      o.evented    = isStructure;
      if (isStructure && o._tool === 'wall') makeWallEditable(o);
    });
    setTool('select');
  } else if (n === 2) {
    // Structure locked, furniture + section selectable
    cv.forEachObject(function(o) {
      if (o._bg || o._prev) return;
      var isInteractive = (o._tool === 'furniture' || o._tool === 'section');
      o.selectable = isInteractive;
      o.evented    = isInteractive;
    });
    setTool('select');
    cv.discardActiveObject();
    cv.renderAll();
    renderAccordions();
    renderRecentObjs();
  } else if (n === 3) {
    // All locked, show element list
    cv.forEachObject(function(o) { o.selectable = false; o.evented = false; });
    cv.discardActiveObject();
    cv.renderAll();
    buildElementList();
  }
  refreshObjList();
}

function goNext() {
  if (currentStep < 3) goToStep(currentStep + 1);
  else saveAll();
}
function goBack() {
  if (currentStep > 1) goToStep(currentStep - 1);
}

// ── Custom Template System ────────────────────────────────
var CUSTOM_STORAGE_KEY = 'egene_custom_templates';
var _custEditId = null; // null = new, string = editing existing

function loadCustomTemplates() {
  try { return JSON.parse(localStorage.getItem(CUSTOM_STORAGE_KEY) || '[]'); }
  catch(e) { return []; }
}
function persistCustomTemplates(list) {
  try { localStorage.setItem(CUSTOM_STORAGE_KEY, JSON.stringify(list)); } catch(e) {}
  // Server API stub — non-blocking
  try {
    fetch('so/customTemplates.jsp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ templates: list })
    });
  } catch(e) {}
}

var _custSvgId = null;
function _custSvgPickCallback(id) {
  _custSvgId = id;
  var def = OLIB_DATA.objs.find(function(o){ return o.id === id; });
  var thumb = document.getElementById('cust-svg-thumb');
  var lbl   = document.getElementById('cust-svg-lbl');
  if (thumb) thumb.innerHTML = '<img src="' + OLIB_IMG[id] + '" alt="">';
  if (lbl)   { lbl.textContent = def ? def.name : id; lbl.className = 'cust-svg-lbl chosen'; }
  if (!document.getElementById('cust-name').value) {
    document.getElementById('cust-name').value = def ? def.name : '';
  }
}

function renderCustomTemplateButtons() {
  var list = loadCustomTemplates();
  var el = document.getElementById('s2-custom-list');
  if (!el) return;
  el.innerHTML = '';
  list.forEach(function(tpl) {
    var btn = document.createElement('button');
    btn.className = 's2-cust-btn';
    var thumb = tpl.svgId && OLIB_IMG && OLIB_IMG[tpl.svgId]
      ? '<img src="' + OLIB_IMG[tpl.svgId] + '" style="width:20px;height:20px;object-fit:contain;flex-shrink:0;border-radius:3px;margin-right:6px" alt="">'
      : '';
    btn.innerHTML =
      thumb +
      '<span style="overflow:hidden;text-overflow:ellipsis;white-space:nowrap;flex:1">' + escHtml(tpl.label) + '</span>' +
      '<button class="cust-x" title="삭제" onclick="deleteCustomTemplate(\'' + tpl.id + '\');event.stopPropagation()">×</button>';
    (function(tid){ btn.addEventListener('click', function() {
      var t = loadCustomTemplates().find(function(x){ return x.id===tid; });
      if (t && t.svgId) placeCustomTemplate(t);
      else placeObject(tid);
    }); })(tpl.id);
    el.appendChild(btn);
  });
}

function placeCustomTemplate(tpl) {
  if (!tpl.svgId) { placeObject(tpl.id); return; }
  var svgStr = OLIB_IMG[tpl.svgId];
  if (!svgStr) return;
  var tile = OLIB_DATA.tile;
  var baseDef = OLIB_DATA.objs.find(function(o){ return o.id === tpl.svgId; });
  var parts = baseDef ? baseDef.fp.split('×') : ['4','2'];
  var targetW = parseInt(parts[0]) * tile;
  var targetH = parseInt(parts[1]) * tile;
  if (pxPerM) { targetW = Math.max(20, Math.round(parseInt(parts[0])*0.5*pxPerM)); targetH = Math.max(12, Math.round(parseInt(parts[1])*0.5*pxPerM)); }
  if (!_OLIB_INSETS[tpl.svgId]) _OLIB_INSETS[tpl.svgId] = _measureSVGInset(svgStr);
  fabric.loadSVGFromURL(svgStr, function(objects, options) {
    var shape = fabric.util.groupSVGElements(objects, options);
    var vp = cv.viewportTransform;
    var cx = (cW/2 - vp[4]) / vp[0];
    var cy = (cH/2 - vp[5]) / vp[3];
    var _sn = (_placeStagger % 6) * GRID; _placeStagger++;
    furnitureCnt++;
    shape.set({
      left: Math.round(cx/GRID)*GRID+_sn, top: Math.round(cy/GRID)*GRID+_sn,
      originX:'center', originY:'center',
      scaleX: targetW/shape.width, scaleY: targetH/shape.height,
      _tool:'furniture', _objDef: tpl.svgId,
      _id: tpl.svgId.toUpperCase().replace(/-/g,'_') + '-' + String(furnitureCnt).padStart(2,'0'),
      _name: tpl.label,
      _fieldDefs: tpl.fieldDefs || [], _fieldValues: {},
      _contentInset: _OLIB_INSETS[tpl.svgId] || null
    });
    cv.add(shape);
    shape._sectionId = _findSectionForObj(shape);
    cv.setActiveObject(shape); cv.renderAll();
    updatePanel(); countUp(); debouncePushHistory();
    addRecentObj(tpl.svgId);
  });
}

function openCustomTemplateModal(editId) {
  _custEditId = editId || null;
  _custSvgId = null;
  var list = loadCustomTemplates();
  var tpl = editId ? list.find(function(t){ return t.id === editId; }) : null;

  document.getElementById('cust-modal-title').textContent = tpl ? '오브젝트 수정' : '오브젝트 추가';
  document.getElementById('cust-name').value = tpl ? tpl.label : '';

  // SVG base picker reset
  var thumb = document.getElementById('cust-svg-thumb');
  var lbl   = document.getElementById('cust-svg-lbl');
  if (tpl && tpl.svgId && OLIB_IMG && OLIB_IMG[tpl.svgId]) {
    _custSvgId = tpl.svgId;
    if (thumb) thumb.innerHTML = '<img src="' + OLIB_IMG[tpl.svgId] + '" alt="">';
    var bd = OLIB_DATA.objs.find(function(o){ return o.id === tpl.svgId; });
    if (lbl) { lbl.textContent = bd ? bd.name : tpl.svgId; lbl.className = 'cust-svg-lbl chosen'; }
  } else {
    if (thumb) thumb.innerHTML = '<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#BBBBBB" stroke-width="1.5"><rect x="3" y="3" width="18" height="18" rx="2"/><line x1="9" y1="3" x2="9" y2="21"/><line x1="15" y1="3" x2="15" y2="21"/><line x1="3" y1="9" x2="21" y2="9"/><line x1="3" y1="15" x2="21" y2="15"/></svg>';
    if (lbl)  { lbl.textContent = '라이브러리에서 선택 →'; lbl.className = 'cust-svg-lbl'; }
  }

  // Field defs
  var fdList = document.getElementById('cust-fd-list');
  fdList.innerHTML = '';
  var fields = tpl ? (tpl.fieldDefs || []) : [];
  fields.forEach(function(f) { addCustomFieldRow(f.name, f.type); });

  document.getElementById('cust-modal-overlay').style.display = 'flex';
}

function closeCustomTemplateModal() {
  document.getElementById('cust-modal-overlay').style.display = 'none';
  _custEditId = null;
  _custSvgId = null;
}

function addCustomFieldRow(name, type) {
  var fdList = document.getElementById('cust-fd-list');
  var row = document.createElement('div');
  row.className = 'cust-fd-item';
  row.innerHTML =
    '<input type="text" placeholder="필드명" value="' + escHtml(name || '') + '">' +
    '<select>' +
      '<option value="text"'     + (type === 'text'     ? ' selected' : '') + '>텍스트</option>' +
      '<option value="number"'   + (type === 'number'   ? ' selected' : '') + '>숫자</option>' +
      '<option value="checkbox"' + (type === 'checkbox' ? ' selected' : '') + '>체크박스</option>' +
    '</select>' +
    '<button class="cust-fd-del" onclick="this.parentElement.remove()">×</button>';
  fdList.appendChild(row);
}

function saveCustomTemplate() {
  var name = (document.getElementById('cust-name').value || '').trim();
  if (!name) { toast('이름을 입력하세요'); return; }
  if (!_custSvgId) { toast('베이스 오브젝트를 선택하세요'); return; }

  var fieldDefs = [];
  document.querySelectorAll('#cust-fd-list .cust-fd-item').forEach(function(row) {
    var fname = row.querySelector('input').value.trim();
    var ftype = row.querySelector('select').value;
    if (fname) fieldDefs.push({ name: fname, type: ftype });
  });

  var list = loadCustomTemplates();
  if (_custEditId) {
    var idx = list.findIndex(function(t){ return t.id === _custEditId; });
    if (idx >= 0) {
      list[idx] = Object.assign(list[idx], { label: name, svgId: _custSvgId, fieldDefs: fieldDefs });
    }
  } else {
    var newId = 'custom_' + Date.now();
    list.push({ id: newId, label: name, svgId: _custSvgId, fieldDefs: fieldDefs });
    OBJECT_DEFS_MAP[newId] = list[list.length - 1];
  }
  persistCustomTemplates(list);

  // Sync entire custom list into OBJECT_DEFS_MAP
  list.forEach(function(t) { OBJECT_DEFS_MAP[t.id] = t; });

  refreshCustomAcc();
  closeCustomTemplateModal();
  toast('템플릿 저장됨: ' + name);
}

function deleteCustomTemplate(id) {
  var list = loadCustomTemplates().filter(function(t){ return t.id !== id; });
  persistCustomTemplates(list);
  delete OBJECT_DEFS_MAP[id];
  refreshCustomAcc();
  toast('템플릿 삭제됨');
}

// Initialize: load custom templates into OBJECT_DEFS_MAP on page load
(function() {
  loadCustomTemplates().forEach(function(t) { OBJECT_DEFS_MAP[t.id] = t; });
})();

// ── Quick Objects & Flyout ────────────────────────────────
var QUICK_CATS = [
  { catKey:'zone', catLabel:'구역',
    items:[
      { key:'section', label:'구역', isSection:true }
    ]
  },
  { catKey:'desk', catLabel:'데스크',
    items:[
      { key:'desk', label:'책상', defaultId:'desk',
        variants:[{id:'desk',label:'1인 책상'},{id:'l-desk',label:'L자 책상'},{id:'standing-desk',label:'스탠딩 책상'},{id:'double-workstation',label:'마주보기 책상'},{id:'bench-desk',label:'벤치 4인'},{id:'bench-desk-6',label:'벤치 6인'},{id:'executive-desk',label:'임원 책상'}] }
    ]
  },
  { catKey:'furniture', catLabel:'가구',
    items:[
      { key:'chair',   label:'의자',       defaultId:'office-chair',
        variants:[{id:'office-chair',label:'사무용 의자'},{id:'chair',label:'기본 의자'},{id:'armchair',label:'안락 의자'},{id:'lounge-chair',label:'라운지 체어'},{id:'stool',label:'스툴'},{id:'bar-stool',label:'바 스툴'}] },
      { key:'sofa',    label:'소파',        defaultId:'sofa-2',
        variants:[{id:'sofa-2',label:'2인 소파'},{id:'sofa-3',label:'3인 소파'},{id:'l-sofa',label:'L자 소파'},{id:'beanbag',label:'빈백'}] },
      { key:'meeting', label:'회의 테이블', defaultId:'conference-table',
        variants:[{id:'conference-table',label:'직사각 테이블'},{id:'round-meeting-table',label:'원형 테이블'},{id:'huddle-table',label:'소회의 테이블'},{id:'conference-table-l',label:'대회의 테이블'},{id:'training-table',label:'교육용 테이블'}] },
      { key:'storage', label:'수납/라커',   defaultId:'lockers',
        variants:[{id:'lockers',label:'사물함'},{id:'cabinet',label:'서랍장'},{id:'bookshelf',label:'책장'},{id:'storage-shelf',label:'선반'},{id:'credenza',label:'로우 캐비닛'}] },
      { key:'board',   label:'화이트보드',  defaultId:'whiteboard',
        variants:[{id:'whiteboard',label:'화이트보드'},{id:'flip-chart',label:'이젤 보드'},{id:'projector-screen',label:'프로젝터 스크린'}] }
    ]
  },
  { catKey:'it', catLabel:'IT·전산',
    items:[
      { key:'server',  label:'서버 랙',      defaultId:'server-rack',
        variants:[{id:'server-rack',label:'서버 랙'},{id:'server-rack-row',label:'서버 랙 열'},{id:'ups',label:'UPS'}] },
      { key:'monitor', label:'모니터/PC',    defaultId:'monitor',
        variants:[{id:'monitor',label:'모니터'},{id:'dual-monitor',label:'듀얼 모니터'},{id:'desktop-pc',label:'데스크탑 PC'},{id:'laptop',label:'노트북'}] },
      { key:'printer', label:'프린터/복합기', defaultId:'copier',
        variants:[{id:'copier',label:'복합기'},{id:'printer',label:'프린터'}] },
      { key:'network', label:'네트워크',      defaultId:'wifi-ap',
        variants:[{id:'wifi-ap',label:'무선 AP'},{id:'router',label:'공유기'},{id:'network-switch',label:'스위치'},{id:'patch-panel',label:'패치 패널'}] },
      { key:'display', label:'디스플레이/AV', defaultId:'tv-screen',
        variants:[{id:'tv-screen',label:'TV'},{id:'video-wall',label:'비디오 월'},{id:'projector',label:'프로젝터'},{id:'cctv',label:'CCTV'},{id:'kiosk',label:'키오스크'}] }
    ]
  },
  { catKey:'deco', catLabel:'환경/데코',
    items:[
      { key:'plant',     label:'화분/식물',  defaultId:'plant',
        variants:[{id:'plant',label:'화분'},{id:'plant-large',label:'대형 화분'},{id:'plant-floor',label:'바닥 식물'},{id:'desk-plant',label:'탁상 화분'},{id:'planter-divider',label:'플랜터 칸막이'}] },
      { key:'partition', label:'파티션',      defaultId:'partition',
        variants:[{id:'partition',label:'파티션'},{id:'glass-partition',label:'유리 파티션'},{id:'acoustic-panel',label:'흡음 패널'}] },
      { key:'amenity',   label:'편의시설',    defaultId:'coffee-machine',
        variants:[{id:'coffee-machine',label:'커피 머신'},{id:'water-cooler',label:'정수기'},{id:'vending-machine',label:'자판기'},{id:'fridge',label:'냉장고'},{id:'microwave',label:'전자레인지'},{id:'fire-extinguisher',label:'소화기'},{id:'first-aid',label:'구급함'},{id:'trash-bin',label:'쓰레기통'}] }
    ]
  }
];

// ── Accordion ────────────────────────────────────────────
function renderAccordions() {
  var el = document.getElementById('s2-accordions');
  if (!el) return;
  el.innerHTML = '';
  QUICK_CATS.forEach(function(cat) {
    el.appendChild(_makeAccItem(cat.catKey, cat.catLabel, function(body) {
      if (cat.catKey === 'zone') {
        _renderZoneAccBody(body);
      } else if (cat.items.length === 1) {
        _renderVariantsGrid(body, cat.items[0].variants || []);
      } else {
        cat.items.forEach(function(sub) {
          var sh = document.createElement('div');
          sh.className = 's2-sub-hdr';
          sh.textContent = sub.label;
          body.appendChild(sh);
          _renderVariantsGrid(body, sub.variants || []);
        });
      }
    }));
  });
  el.appendChild(_makeAccItem('my', '내 오브젝트', _renderCustomAccBody));
}

function _makeAccItem(key, label, fillBodyFn) {
  var item = document.createElement('div');
  item.className = 's2-acc-item';
  item.dataset.cat = key;
  var hdr = document.createElement('button');
  hdr.className = 's2-acc-hdr';
  hdr.innerHTML = '<span>' + escHtml(label) + '</span><span class="s2-acc-arrow">&#9654;</span>';
  hdr.addEventListener('click', function() {
    var wasOpen = item.classList.contains('open');
    document.querySelectorAll('#s2-accordions .s2-acc-item').forEach(function(it){ it.classList.remove('open'); });
    if (!wasOpen) {
      item.classList.add('open');
      var body = item.querySelector('.s2-acc-body');
      if (!body.dataset.rendered) { body.dataset.rendered = '1'; fillBodyFn(body); }
    }
  });
  var body = document.createElement('div');
  body.className = 's2-acc-body';
  item.appendChild(hdr);
  item.appendChild(body);
  return item;
}

function _renderZoneAccBody(body) {
  var grid = document.createElement('div');
  grid.className = 's2-obj-grid';
  SECTION_TYPES.forEach(function(t) {
    var card = document.createElement('button');
    card.className = 's2-obj-card';
    card.innerHTML = '<div class="s2-sec-card-dot" style="background:'+t.badge+';opacity:.85"></div><span class="s2-obj-card-name">'+escHtml(t.label)+'</span>';
    (function(tid){ card.addEventListener('click', function(){ startSectionDraw(tid); }); })(t.id);
    grid.appendChild(card);
  });
  body.appendChild(grid);
}

function _renderVariantsGrid(body, variants) {
  if (!variants.length) return;
  var grid = document.createElement('div');
  grid.className = 's2-obj-grid';
  variants.forEach(function(v) {
    var card = document.createElement('button');
    card.className = 's2-obj-card';
    card.innerHTML = '<img src="'+(OLIB_IMG[v.id]||'')+'" alt=""><span class="s2-obj-card-name">'+escHtml(v.label)+'</span>';
    (function(id){ card.addEventListener('click', function(){ placeLibraryObject(id); }); })(v.id);
    grid.appendChild(card);
  });
  body.appendChild(grid);
}

function _renderCustomAccBody(body) {
  var list = loadCustomTemplates();
  if (list.length) {
    var grid = document.createElement('div');
    grid.className = 's2-obj-grid';
    list.forEach(function(tpl) {
      var imgSrc = tpl.svgId && OLIB_IMG ? (OLIB_IMG[tpl.svgId]||'') : '';
      var card = document.createElement('button');
      card.className = 's2-obj-card';
      card.innerHTML = (imgSrc ? '<img src="'+imgSrc+'" alt="">' : '<div style="width:40px;height:40px;background:var(--bg3);border-radius:5px"></div>') +
        '<span class="s2-obj-card-name">'+escHtml(tpl.label)+'</span>';
      (function(t){ card.addEventListener('click', function(){ if(t.svgId) placeCustomTemplate(t); else placeObject(t.id); }); })(tpl);
      grid.appendChild(card);
    });
    body.appendChild(grid);
  } else {
    var em = document.createElement('div');
    em.style.cssText = 'font-size:10px;color:var(--txt2);padding:4px 0 6px';
    em.textContent = '저장된 오브젝트 없음';
    body.appendChild(em);
  }
}

function refreshCustomAcc() {
  var accItem = document.querySelector('#s2-accordions .s2-acc-item[data-cat="my"]');
  if (!accItem) return;
  var body = accItem.querySelector('.s2-acc-body');
  body.innerHTML = '';
  body.dataset.rendered = '';
  if (accItem.classList.contains('open')) { body.dataset.rendered = '1'; _renderCustomAccBody(body); }
}

// ── Search ────────────────────────────────────────────────
function s2SearchInput(val) {
  var q = (val||'').trim().toLowerCase();
  var resultsEl = document.getElementById('s2-search-results');
  var catWrap   = document.getElementById('s2-cat-wrap');
  var recentSec = document.getElementById('s2-recent-sec');
  if (!q) {
    resultsEl.style.display = 'none';
    catWrap.style.display = '';
    if (recentSec && _loadRecentObjs().length) recentSec.style.display = '';
    return;
  }
  catWrap.style.display = 'none';
  if (recentSec) recentSec.style.display = 'none';
  resultsEl.style.display = 'block';
  resultsEl.innerHTML = '';
  var results = OLIB_DATA.objs.filter(function(o){
    return o.name.toLowerCase().includes(q) ||
      o.id.replace(/-/g,' ').includes(q) ||
      (o.tags||[]).some(function(t){ return String(t).toLowerCase().includes(q); });
  });
  if (!results.length) {
    resultsEl.innerHTML = '<div style="font-size:10px;color:var(--txt2);padding:4px 2px">검색 결과 없음</div>';
    return;
  }
  results.forEach(function(o) {
    var btn = document.createElement('button');
    btn.className = 's2-search-item';
    btn.innerHTML = '<img src="'+(OLIB_IMG[o.id]||'')+'" alt=""><span class="s2-search-name">'+escHtml(o.name)+'</span>';
    (function(id){ btn.addEventListener('click', function(){ placeLibraryObject(id); }); })(o.id);
    resultsEl.appendChild(btn);
  });
}
function clearS2Search() {
  var si = document.getElementById('s2-search');
  if (si) { si.value = ''; si.focus(); s2SearchInput(''); }
  var xb = document.getElementById('s2-search-clear');
  if (xb) xb.style.display = 'none';
}
document.addEventListener('DOMContentLoaded', function(){
  var si = document.getElementById('s2-search');
  if (si) si.addEventListener('input', function(){
    s2SearchInput(this.value);
    var xb = document.getElementById('s2-search-clear');
    if (xb) xb.style.display = this.value ? 'block' : 'none';
  });
});

// ── Recent Objects ────────────────────────────────────────
var RECENT_OBJS_KEY = 'egene_recent_objs_v1';
function _loadRecentObjs() {
  try { return JSON.parse(localStorage.getItem(RECENT_OBJS_KEY) || '[]'); } catch(e) { return []; }
}
function addRecentObj(id) {
  var list = _loadRecentObjs().filter(function(x){ return x !== id; });
  list.unshift(id);
  if (list.length > 5) list.length = 5;
  try { localStorage.setItem(RECENT_OBJS_KEY, JSON.stringify(list)); } catch(e) {}
  renderRecentObjs();
}
function renderRecentObjs() {
  var sec = document.getElementById('s2-recent-sec');
  var el  = document.getElementById('s2-recent-list');
  if (!el) return;
  var list = _loadRecentObjs();
  if (!list.length) { if (sec) sec.style.display = 'none'; return; }
  el.innerHTML = '';
  list.forEach(function(id) {
    var imgSrc = OLIB_IMG ? OLIB_IMG[id] : null;
    if (!imgSrc) return;
    var def = OLIB_DATA ? OLIB_DATA.objs.find(function(o){ return o.id === id; }) : null;
    var btn = document.createElement('button');
    btn.className = 's2-recent-btn';
    btn.title = def ? def.name : id;
    btn.innerHTML = '<img src="' + imgSrc + '" alt="">';
    (function(oid){ btn.onclick = function(){ placeLibraryObject(oid); }; })(id);
    el.appendChild(btn);
  });
  if (sec) sec.style.display = '';
}

// ── Section Placement ─────────────────────────────────────
function placeSection(x, y, w, h) {
  var stype = SECTION_TYPES.find(function(t){ return t.id === _pendingSectionType; }) || SECTION_TYPES[0];
  furnitureCnt++;
  var id = 'SEC-' + String(furnitureCnt).padStart(2, '0');
  var rect = new fabric.Rect({
    left: x, top: y, width: w, height: h,
    fill: stype.fill, stroke: stype.stroke,
    strokeWidth: 1.5, rx: 4,
    selectable: true, evented: true,
    _tool: 'section', _sectionType: stype.id,
    _id: id, _name: stype.id === 'general' ? '' : stype.label, _dept: '', _capacity: 0
  });
  cv.add(rect);
  // Put section behind furniture but above bg
  cv.sendToBack(rect);
  cv.getObjects().filter(function(o) { return o._bg; })
    .forEach(function(o) { cv.sendToBack(o); });

  // Auto-tag objects whose center falls inside the new section
  var tagged = [];
  cv.getObjects().forEach(function(o) {
    if (!o._tool || o._tool === 'wall' || o._tool === 'section' || o._bg || o._prev) return;
    var cp = o.getCenterPoint();
    if (cp.x >= x && cp.x <= x+w && cp.y >= y && cp.y <= y+h) {
      o._sectionId = id;
      tagged.push(o);
    }
  });
  if (tagged.length) {
    // Flash blue stroke to confirm inclusion
    tagged.forEach(function(o) {
      var orig = o.stroke;
      o.set('stroke', '#4F46E5');
      setTimeout(function() { o.set('stroke', orig); cv.renderAll(); }, 900);
    });
    toast(tagged.length + '개 오브젝트가 섹션에 포함됨');
  }

  cv.setActiveObject(rect);
  cv.renderAll();
  updatePanel();
  countUp();
  debouncePushHistory();
  setTool('select');
}

// ── Section membership helper ─────────────────────────────
function _findSectionForObj(obj) {
  var cp = obj.getCenterPoint(); // canvas coords
  var found = null;
  var foundArea = Infinity;
  cv.getObjects().forEach(function(sec) {
    if (sec._tool !== 'section') return;
    // sec uses originX:'left' — left/top are the top-left corner in canvas coords
    var sl = sec.left;
    var st = sec.top;
    var sw = sec.width  * (sec.scaleX || 1);
    var sh = sec.height * (sec.scaleY || 1);
    if (cp.x >= sl && cp.x <= sl + sw && cp.y >= st && cp.y <= st + sh) {
      var area = sw * sh;
      if (area < foundArea) { found = sec._id; foundArea = area; }
    }
  });
  return found;
}

// ── Unified Object Placement ──────────────────────────────
function placeObject(defId) {
  var def = OBJECT_DEFS_MAP[defId];
  if (!def) return;

  var w = def.w, h = def.h;
  if (pxPerM && def.wM) w = Math.max(20, Math.round(def.wM * pxPerM));
  if (pxPerM && def.hM) h = Math.max(12, Math.round(def.hM * pxPerM));

  var vp = cv.viewportTransform;
  var cx = (cW / 2 - vp[4]) / vp[0];
  var cy = (cH / 2 - vp[5]) / vp[3];
  var _sn = (_placeStagger % 6) * GRID; _placeStagger++;

  var items = [];

  // Background
  items.push(new fabric.Rect({
    left: -w / 2, top: -h / 2, width: w, height: h,
    fill: def.fill, stroke: def.sk, strokeWidth: 1.2, rx: 3,
    selectable: false, evented: false
  }));

  // Icon — wrap in Group so Fabric auto-centers around (0,0)
  var iconKey = def.icon;
  if (iconKey && ICON_LIB[iconKey]) {
    var iconPath = new fabric.Path(ICON_LIB[iconKey], {
      fill: 'none', stroke: def.sk, strokeWidth: 1.5,
      strokeLineCap: 'round', strokeLineJoin: 'round',
      selectable: false, evented: false
    });
    var iconScale = Math.min(w, h) * 0.58 / 24;
    var iconGrp = new fabric.Group([iconPath], {
      originX: 'center', originY: 'center',
      left: 0, top: 0,
      scaleX: iconScale, scaleY: iconScale,
      selectable: false, evented: false
    });
    items.push(iconGrp);
  }

  furnitureCnt++;
  var idPfx = defId.toUpperCase().replace(/-/g, '_');
  var grp = new fabric.Group(items, {
    left: Math.round(cx / GRID) * GRID + _sn,
    top:  Math.round(cy / GRID) * GRID + _sn,
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    _tool: 'furniture', _objDef: defId, _preset: defId,
    _id: idPfx + '-' + String(furnitureCnt).padStart(2, '0'),
    _name: def.label, _capacity: def.cap || 0,
    _fieldDefs: JSON.parse(JSON.stringify(def.fieldDefs || [])),
    _fieldValues: {}
  });
  cv.add(grp);
  grp._sectionId = _findSectionForObj(grp);
  cv.setActiveObject(grp);
  cv.renderAll();
  updatePanel();
  countUp();
  debouncePushHistory();
}

// ── Desk Placement (legacy — kept for backward compat) ────
function placeDesk() {
  var cfg = Object.assign({}, PRESETS['desk1']);
  if (pxPerM) {
    cfg.w = Math.max(20, Math.round(cfg.wM * pxPerM));
    cfg.h = Math.max(12, Math.round(cfg.hM * pxPerM));
  }
  furnitureCnt++;
  var id = 'DESK-' + String(furnitureCnt).padStart(2, '0');
  var vp = cv.viewportTransform;
  var cx = (cW / 2 - vp[4]) / vp[0];
  var cy = (cH / 2 - vp[5]) / vp[3];
  var _sn = (_placeStagger % 6) * GRID; _placeStagger++;
  var rect = new fabric.Rect({
    left: Math.round(cx / GRID) * GRID + _sn,
    top:  Math.round(cy / GRID) * GRID + _sn,
    width: cfg.w, height: cfg.h,
    originX: 'center', originY: 'center',
    fill: cfg.fill, stroke: cfg.sk, strokeWidth: 1.2, rx: 3,
    selectable: true, evented: true,
    _tool: 'furniture', _preset: 'desk1',
    _id: id, _name: '책상', _capacity: 1
  });
  cv.add(rect);
  cv.setActiveObject(rect);
  cv.renderAll();
  updatePanel();
  countUp();
  debouncePushHistory();
}

// ── Furniture Placement (sofa / partition) ────────────────
function placePreset(key) {
  var cfg = Object.assign({}, PRESETS[key]);
  if (!cfg) return;
  if (pxPerM && cfg.wM) {
    cfg.w = Math.max(20, Math.round(cfg.wM * pxPerM));
    cfg.h = Math.max(8,  Math.round(cfg.hM * pxPerM));
  }
  furnitureCnt++;
  var id = key.toUpperCase() + '-' + String(furnitureCnt).padStart(2, '0');
  var vp = cv.viewportTransform;
  var cx = (cW / 2 - vp[4]) / vp[0];
  var cy = (cH / 2 - vp[5]) / vp[3];
  var _sn = (_placeStagger % 6) * GRID; _placeStagger++;
  var shape = buildFurnitureShape(key, cfg);
  shape.set({
    left: Math.round(cx / GRID) * GRID + _sn,
    top:  Math.round(cy / GRID) * GRID + _sn,
    originX: 'center', originY: 'center',
    selectable: true, evented: true,
    _tool: 'furniture', _preset: key,
    _id: id, _name: cfg.label, _capacity: cfg.cap
  });
  cv.add(shape);
  cv.setActiveObject(shape);
  cv.renderAll();
  updatePanel();
  countUp();
  debouncePushHistory();
}

function buildFurnitureShape(key, cfg) {
  var w = cfg.w, h = cfg.h;
  var items = [];

  items.push(new fabric.Rect({
    left: -w/2, top: -h/2, width: w, height: h,
    fill: cfg.fill, stroke: cfg.sk, strokeWidth: 1.2, rx: 3
  }));

  if (key === 'sofa') {
    items.push(new fabric.Rect({ left: -w/2, top: -h/2, width: 12, height: h,
      fill: '#C4BCB4', stroke: 'none', rx: 2 }));
    items.push(new fabric.Rect({ left: w/2-12, top: -h/2, width: 12, height: h,
      fill: '#C4BCB4', stroke: 'none', rx: 2 }));
    items.push(new fabric.Rect({ left: -w/2+12, top: -h/2, width: w-24, height: 13,
      fill: '#C8C0B8', stroke: 'none' }));
  }

  return new fabric.Group(items);
}

// ── Step 3 Element List ───────────────────────────────────
function makeElistItem(obj, isChild) {
  var div = document.createElement('div');
  div.className = 'eitem' + (isChild ? ' eitem-child' : '');

  var isSection = (obj._tool === 'section');
  var badgeLabel = isSection
    ? (SECTION_LABELS[obj._sectionType] || '구역')
    : ((obj._objDef && OBJECT_DEFS_MAP[obj._objDef] && OBJECT_DEFS_MAP[obj._objDef].label)
       || (PRESETS[obj._preset] && PRESETS[obj._preset].label) || obj._name || '가구');

  var formHtml = '<div class="eitem-form">' +
    '<div class="ef-row"><div class="ef-lbl">이름</div>' +
      '<input class="ef-inp" data-f="name" value="' + escHtml(obj._name || '') + '"></div>';

  if (isSection) {
    formHtml +=
      '<div class="ef-row"><div class="ef-lbl">구역 유형</div>' +
        '<select class="ef-inp" data-f="stype">' +
          '<option value="SECTION"' + (obj._sectionType === 'SECTION' || !obj._sectionType ? ' selected' : '') + '>일반 구역</option>' +
          '<option value="MEETING"' + (obj._sectionType === 'MEETING' ? ' selected' : '') + '>회의실 (예약 가능)</option>' +
          '<option value="REST"' + (obj._sectionType === 'REST' ? ' selected' : '') + '>휴게 공간</option>' +
          '<option value="OTHER"' + (obj._sectionType === 'OTHER' ? ' selected' : '') + '>기타</option>' +
        '</select></div>';
  }

  if (isSection) {
    formHtml +=
      '<div class="ef-row"><div class="ef-lbl">수용 인원</div>' +
        '<input class="ef-inp" type="number" min="0" data-f="cap" value="' + (obj._capacity || 0) + '"></div>' +
      '<div class="ef-row"><div class="ef-lbl">부서 / 그룹</div>' +
        '<input class="ef-inp" data-f="dept" value="' + escHtml(obj._dept || '') + '"></div>';
  }

  if (!isSection && obj._fieldDefs && obj._fieldDefs.length) {
    var fvals = obj._fieldValues || {};
    obj._fieldDefs.forEach(function(fd, fi) {
      var fkey = 'fv_' + fi;
      var curVal = fvals[fd.name] !== undefined ? fvals[fd.name] : '';
      if (fd.type === 'checkbox') {
        formHtml +=
          '<div class="ef-row"><div class="ef-lbl">' + escHtml(fd.name) + '</div>' +
            '<input class="ef-inp" type="checkbox"' + (curVal ? ' checked' : '') +
            ' data-f="' + fkey + '" data-fname="' + escHtml(fd.name) + '" data-ftype="checkbox" style="width:auto;margin-top:4px"></div>';
      } else {
        formHtml +=
          '<div class="ef-row"><div class="ef-lbl">' + escHtml(fd.name) + '</div>' +
            '<input class="ef-inp" type="' + (fd.type === 'number' ? 'number' : 'text') + '"' +
            ' data-f="' + fkey + '" data-fname="' + escHtml(fd.name) + '" data-ftype="' + fd.type + '"' +
            ' value="' + escHtml(String(curVal)) + '"></div>';
      }
    });
  }

  formHtml += '</div>';

  div.innerHTML =
    '<div class="eitem-head">' +
      (isChild ? '<span class="eitem-child-arrow">↳</span>' : '') +
      '<span class="eitem-badge">' + badgeLabel + '</span>' +
      '<span class="eitem-id">' + (obj._id || '') + '</span>' +
    '</div>' + formHtml;

  div.addEventListener('click', function() {
    var wasOn = div.classList.contains('on');
    document.querySelectorAll('.eitem').forEach(function(d) { d.classList.remove('on'); });
    cv.getObjects().filter(function(o) { return o._hl; }).forEach(function(o) { cv.remove(o); });
    if (!wasOn) { div.classList.add('on'); highlightObj(obj); }
    else { cv.renderAll(); }
  });

  div.querySelectorAll('.ef-inp').forEach(function(inp) {
    inp.addEventListener('input', function() {
      if (inp.dataset.f === 'name')  obj._name = inp.value;
      if (inp.dataset.f === 'cap')   obj._capacity = parseInt(inp.value) || 0;
      if (inp.dataset.f === 'dept')  obj._dept = inp.value;
      if (inp.dataset.f === 'stype') {
        obj._sectionType = inp.value;
        var _st = SECTION_STYLES[inp.value] || SECTION_STYLES.SECTION;
        obj.set({ fill: _st.fill, stroke: _st.stroke });
        cv.renderAll();
      }
      if (inp.dataset.fname) {
        if (!obj._fieldValues) obj._fieldValues = {};
        if (inp.dataset.ftype === 'checkbox') {
          obj._fieldValues[inp.dataset.fname] = inp.checked;
        } else if (inp.dataset.ftype === 'number') {
          obj._fieldValues[inp.dataset.fname] = parseFloat(inp.value) || 0;
          } else {
            obj._fieldValues[inp.dataset.fname] = inp.value;
          }
        }
      });
      inp.addEventListener('change', function() {
        // Also handle checkbox change event (input event may not fire on some browsers)
        if (inp.dataset.fname && inp.dataset.ftype === 'checkbox') {
          if (!obj._fieldValues) obj._fieldValues = {};
          obj._fieldValues[inp.dataset.fname] = inp.checked;
        }
      });
      inp.addEventListener('click', function(ev) { ev.stopPropagation(); });
    });

  return div;
}

function buildElementList() {
  var allItems = cv.getObjects().filter(function(o) {
    return o._tool === 'furniture' || o._tool === 'section';
  });
  var el = document.getElementById('s3-list');
  el.innerHTML = '';

  if (!allItems.length) {
    el.innerHTML = '<div class="elist-empty">배치된 요소가<br>없습니다</div>';
    return;
  }

  var sections = allItems.filter(function(o) { return o._tool === 'section'; });
  var furniture = allItems.filter(function(o) { return o._tool !== 'section'; });

  var sectionMap = {};
  sections.forEach(function(s) { if (s._id) sectionMap[s._id] = s; });

  var grouped = {};
  var orphans = [];
  furniture.forEach(function(f) {
    var sid = f._sectionId;
    if (sid && sectionMap[sid]) {
      if (!grouped[sid]) grouped[sid] = [];
      grouped[sid].push(f);
    } else {
      orphans.push(f);
    }
  });

  sections.forEach(function(sec) {
    el.appendChild(makeElistItem(sec, false));
    (grouped[sec._id] || []).forEach(function(child) {
      el.appendChild(makeElistItem(child, true));
    });
  });

  if (orphans.length) {
    if (sections.length) {
      var hdr = document.createElement('div');
      hdr.className = 'eitem-orphan-hdr';
      hdr.textContent = '미배정';
      el.appendChild(hdr);
    }
    orphans.forEach(function(obj) {
      el.appendChild(makeElistItem(obj, false));
    });
  }
}

function highlightObj(obj) {
  var pad = 8;
  var sw = obj.getScaledWidth(), sh = obj.getScaledHeight();
  var hl = new fabric.Rect({
    left: obj.left, top: obj.top,
    width: sw + pad * 2, height: sh + pad * 2,
    originX: 'center', originY: 'center',
    angle: obj.angle || 0,
    fill: 'transparent', stroke: '#6C6860',
    strokeWidth: 1.5, strokeDashArray: [5, 3],
    selectable: false, evented: false, _hl: true
  });
  cv.add(hl);
  cv.renderAll();
}

function escHtml(s) {
  return String(s).replace(/&/g,'&amp;').replace(/"/g,'&quot;');
}

// ── Save / Next ───────────────────────────────────────────
function saveDraft() {
  var data = cv.toJSON(HIST_KEYS);
  localStorage.setItem('so_draft', JSON.stringify(data));
  toast('임시저장 완료');
}

function saveAll() {
  var layoutName = (document.getElementById('so-layout-name').value || '').trim();
  if (!layoutName) {
    document.getElementById('so-layout-name').focus();
    toast('사무실 이름을 입력하세요');
    return;
  }

  // Out-of-bounds check
  var allObjs = cv.getObjects().filter(function(o) { return !o._bg && !o._prev && !o._calib; });
  if (allObjs.length > 1) {
    var cxs = allObjs.map(function(o) { return o.left || 0; });
    var cys = allObjs.map(function(o) { return o.top  || 0; });
    var sorted = cxs.slice().sort(function(a,b){return a-b;});
    var med = sorted[Math.floor(sorted.length/2)];
    var stray = allObjs.filter(function(o) { return Math.abs((o.left||0) - med) > 5000 || Math.abs((o.top||0) - med) > 5000; });
    if (stray.length && !confirm('화면 밖으로 이탈한 오브젝트가 ' + stray.length + '개 있습니다. 그대로 저장할까요?')) return;
  }

  var elements = cv.getObjects()
    .filter(function(o) { return o._tool === 'furniture' || o._tool === 'section'; })
    .map(function(o) {
      var type;
      if (o._tool === 'section') type = o._sectionType || 'SECTION';
      else type = o._objDef || o._preset || 'DESK';
      return { id: o._id, name: o._name || '', capacity: o._capacity || 0,
               dept: o._dept || '', type: type, sectionId: o._sectionId || null,
               fieldDefs: o._fieldDefs || [], fieldValues: o._fieldValues || {} };
    });

  // Fabric.js JSON에 커스텀 속성 포함
  var canvasJson = JSON.stringify(cv.toJSON(HIST_KEYS));

  var payload = { layoutName: layoutName, canvasJson: canvasJson, elements: elements,
                  layoutId: window._editingLayoutId || null };

  var csrfToken  = (document.querySelector('meta[name="_csrf"]')  || {}).content  || '';
  var csrfHeader = (document.querySelector('meta[name="_csrf_header"]') || {}).content || 'X-CSRF-TOKEN';
  var reqHeaders = { 'Content-Type': 'application/json' };
  if (csrfToken) reqHeaders[csrfHeader] = csrfToken;

  fetch('/sample/so/save.jsp', {
    method: 'POST',
    headers: reqHeaders,
    body: JSON.stringify(payload)
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (!data.ok) throw new Error(data.error || '저장 실패');
    window._editingLayoutId = data.layoutId;
    toast((data.updated ? '수정 완료' : '저장 완료') + ' (' + data.count + '개 요소)');
    setTimeout(function() {
      if (confirm('저장됐어요! 목록 페이지로 이동할까요?')) {
        location.href = '/sample/so_list.jsp';
      }
    }, 800);
  })
  .catch(function(e) {
    toast('오류: ' + e.message);
  });
}

// ── 기존 레이아웃 불러오기 ────────────────────────────────────
window._editingLayoutId = null;

(function loadLayoutList() {
  fetch('/sample/so/list.jsp')
    .then(function(r) { return r.json(); })
    .then(function(list) {
      var sel = document.getElementById('load-sel');
      list.forEach(function(item) {
        if (item.error) return;
        var opt = document.createElement('option');
        opt.value = item.layoutId;
        opt.textContent = item.layoutName;
        sel.appendChild(opt);
      });
    });
})();

function loadExisting(layoutId) {
  if (!layoutId) return;
  if (!confirm('현재 캔버스를 지우고 선택한 레이아웃을 불러올까요?')) {
    document.getElementById('load-sel').value = '';
    return;
  }
  fetch('/sample/so/get.jsp?id=' + encodeURIComponent(layoutId))
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (!data.ok) throw new Error(data.error || '불러오기 실패');
      _histLock = true;
      cv.clear();
      cv.loadFromJSON(data.layout.canvasJson, function() {
        cv.getObjects().forEach(function(o) {
          if (o._tool === 'wall') makeWallEditable(o);
          o.selectable = false; o.evented = false;
        });
        cv.renderAll();
        rebuildPts();
        _histLock = false;
        _history = []; _histIdx = -1;
        pushHistory();
        countUp();
      }, function(o, fabricObj) {
        HIST_KEYS.forEach(function(k) { if (o[k] !== undefined) fabricObj[k] = o[k]; });
      });
      // 이름 복원
      document.getElementById('so-layout-name').value = data.layout.layoutName;
      // 수정 모드 표시
      window._editingLayoutId = layoutId;
      toast('"' + data.layout.layoutName + '" 불러옴 — 수정 후 저장하세요');
      // 카운터 갱신
      var furnitureCount = (data.elements || []).length;
      countUp(furnitureCount);
    })
    .catch(function(e) {
      toast('오류: ' + e.message);
      document.getElementById('load-sel').value = '';
    });
}

// ── Toast ─────────────────────────────────────────────────
var toastTimer;
function toast(msg) {
  var el = document.getElementById('toast');
  el.textContent = msg;
  el.style.opacity = '1';
  clearTimeout(toastTimer);
  toastTimer = setTimeout(function() { el.style.opacity = '0'; }, 2000);
}

// ── Window resize ─────────────────────────────────────────
window.addEventListener('resize', function() {
  var na = document.getElementById('carea');
  cW = na.clientWidth  - 2;
  cH = na.clientHeight - 2;
  cv.setWidth(cW);
  cv.setHeight(cH);
  cv.renderAll();
});

// ── Snap Control ─────────────────────────────────────────
function setSnap(px) {
  SNAP = px;
  [5, 10, 20].forEach(function(v) {
    var btn = document.getElementById('snap-btn-' + v);
    if (!btn) return;
    btn.style.background = (v === px) ? 'var(--txt)' : 'transparent';
    btn.style.color      = (v === px) ? '#FAFAF8'    : 'var(--txt2)';
  });
}

// ── Undo / Redo ───────────────────────────────────────────
var _history    = [];
var _histIdx    = -1;
var _histLock   = false;
var _histTimer;
var HIST_KEYS   = ['_tool','_bg','_prev','_id','_name','_capacity','_dept','_preset','_objDef','_fieldDefs','_fieldValues','_sectionType','_sectionId','_wallReady','_calib','_doorW','_winW','_grouped','_doorDouble','_doorOd','_doorStyle','_wallStyle','_gapPt1','_gapPt2','_isEndpointGap'];

function pushHistory() {
  if (_histLock) return;
  _history = _history.slice(0, _histIdx + 1);
  var snap = JSON.stringify(cv.toJSON(HIST_KEYS));
  if (_history.length && _history[_histIdx] === snap) return;
  _history.push(snap);
  if (_history.length > 50) { _history.shift(); }
  _histIdx = _history.length - 1;
  updateUndoRedoBtns();
}

function debouncePushHistory() {
  if (_histLock) return;
  clearTimeout(_histTimer);
  _histTimer = setTimeout(pushHistory, 80);
}

function restoreHistory(snap) {
  _histLock = true;
  cv.loadFromJSON(JSON.parse(snap), function() {
    cv.getObjects().forEach(function(o) {
      HIST_KEYS.forEach(function(k) { /* already set via reviver */ });
      if (o._tool === 'wall') makeWallEditable(o);
      if (currentStep === 1) {
        var isSt = o._tool && o._tool !== 'furniture' && o._tool !== 'section';
        o.selectable = !!isSt && !o._bg && !o._prev;
        o.evented    = !!isSt && !o._bg && !o._prev;
      } else if (currentStep === 2) {
        var isIn = o._tool === 'furniture' || o._tool === 'section';
        o.selectable = isIn; o.evented = isIn;
      } else {
        o.selectable = false; o.evented = false;
      }
    });
    // Re-link _wallL/_wallR for wall-split doors: loadFromJSON creates new objects
    // so the old references are gone. Match stubs by their inner endpoint ≈ _gapPt1/2.
    var _walls = cv.getObjects().filter(function(w) { return w._tool === 'wall' && !w._prev; });
    cv.getObjects().forEach(function(door) {
      if ((door._tool !== 'door' && door._tool !== 'window') || door._isVirtualGap) return;
      if (!door._gapPt1 || !door._gapPt2) return;
      var p1 = door._gapPt1, p2 = door._gapPt2, TOL = 3;
      _walls.forEach(function(w) {
        if (!door._wallL && Math.hypot(w.x2 - p1.x, w.y2 - p1.y) < TOL) door._wallL = w;
        if (!door._wallR && Math.hypot(w.x1 - p2.x, w.y1 - p2.y) < TOL) door._wallR = w;
      });
      storeDoorLocalGap(door, p1, p2);
    });
    rebuildPts();
    countUp();
    cv.renderAll();
    _histLock = false;
    updateUndoRedoBtns();
  }, function(o, fo) {
    HIST_KEYS.forEach(function(k) { if (o[k] !== undefined) fo[k] = o[k]; });
  });
}

function undo() {
  if (_histIdx <= 0) return;
  _histIdx--;
  restoreHistory(_history[_histIdx]);
}

function redo() {
  if (_histIdx >= _history.length - 1) return;
  _histIdx++;
  restoreHistory(_history[_histIdx]);
}

function updateUndoRedoBtns() {
  document.getElementById('btn-undo').disabled = (_histIdx <= 0);
  document.getElementById('btn-redo').disabled = (_histIdx >= _history.length - 1);
}

// ── Zoom Controls ─────────────────────────────────────────
function zoomIn()  { applyZoom(cv.getZoom() * 1.25); }
function zoomOut() { applyZoom(cv.getZoom() / 1.25); }

function applyZoom(z) {
  z = Math.min(Math.max(z, 0.1), 8);
  var center = new fabric.Point(cW / 2, cH / 2);
  cv.zoomToPoint(center, z);
  updateZoomDisplay();
  cv.renderAll();
}

function fitAll() {
  var objs = cv.getObjects().filter(function(o) { return !o._bg && !o._prev && !o._calib; });
  if (!objs.length) { cv.setViewportTransform([1,0,0,1,0,0]); updateZoomDisplay(); cv.renderAll(); return; }
  var rects = objs.map(function(o) { return o.getBoundingRect(true, true); });
  var cxs   = rects.map(function(b) { return b.left + b.width/2; }).sort(function(a,b){return a-b;});
  var cys   = rects.map(function(b) { return b.top  + b.height/2; }).sort(function(a,b){return a-b;});
  var med   = { x: cxs[Math.floor(cxs.length/2)], y: cys[Math.floor(cys.length/2)] };
  var filtered = rects.filter(function(b) {
    return Math.abs(b.left + b.width/2  - med.x) < 5000 &&
           Math.abs(b.top  + b.height/2 - med.y) < 5000;
  });
  if (!filtered.length) filtered = rects;
  var minX=1e9, minY=1e9, maxX=-1e9, maxY=-1e9;
  filtered.forEach(function(b) {
    minX=Math.min(minX,b.left); minY=Math.min(minY,b.top);
    maxX=Math.max(maxX,b.left+b.width); maxY=Math.max(maxY,b.top+b.height);
  });
  var p  = 40;
  var sc = Math.min((cW-p*2)/(maxX-minX), (cH-p*2)/(maxY-minY));
  sc = Math.min(Math.max(sc, 0.05), 8);
  cv.setViewportTransform([sc,0,0,sc, (cW-(maxX-minX)*sc)/2-minX*sc, (cH-(maxY-minY)*sc)/2-minY*sc]);
  updateZoomDisplay();
  cv.renderAll();
}

function updateZoomDisplay() {
  document.getElementById('zoom-pct').textContent = Math.round(cv.getZoom() * 100) + '%';
}

// Mouse wheel zoom
cv.on('mouse:wheel', function(opt) {
  opt.e.preventDefault(); opt.e.stopPropagation();
  var delta = opt.e.deltaY;
  var z = cv.getZoom() * (delta > 0 ? 0.9 : 1.1);
  z = Math.min(Math.max(z, 0.1), 8);
  cv.zoomToPoint(new fabric.Point(opt.e.offsetX, opt.e.offsetY), z);
  updateZoomDisplay();
});

// ── Copy / Paste ──────────────────────────────────────────
var _clipboard = null;
var _pasteDelta = 0;

function copySelected() {
  var sel = cv.getActiveObjects();
  if (!sel.length) return;
  // Convert relative ActiveSelection coords to absolute canvas coords at copy time
  var activeObj = cv.getActiveObject();
  var baseMatrix = (activeObj && activeObj.type === 'activeSelection')
    ? activeObj.calcTransformMatrix() : null;
  _clipboard = sel.map(function(obj) {
    var absLeft, absTop;
    if (baseMatrix) {
      var pt = fabric.util.transformPoint({ x: obj.left, y: obj.top }, baseMatrix);
      absLeft = pt.x; absTop = pt.y;
    } else {
      absLeft = obj.left || 0; absTop = obj.top || 0;
    }
    return { orig: obj, absLeft: absLeft, absTop: absTop };
  });
  _pasteDelta = 0;
  toast('복사됨 (' + sel.length + '개) · Ctrl+V 로 붙여넣기');
}

function pasteClipboard() {
  if (!_clipboard || !_clipboard.length) return;
  _pasteDelta += 20;
  var delta = _pasteDelta;
  cv.discardActiveObject();
  var newObjs = [];
  var pending = _clipboard.length;

  _clipboard.forEach(function(item) {
    var orig    = item.orig;
    var absLeft = item.absLeft;
    var absTop  = item.absTop;
    orig.clone(function(cloned) {
      furnitureCnt++;
      cloned.set({
        left: absLeft + delta,
        top:  absTop  + delta,
        _id:  (orig._tool === 'furniture' ? 'DESK' : 'OBJ') + '-' + String(furnitureCnt).padStart(2,'0'),
        _name: orig._name || '',
        _capacity: orig._capacity || 0,
        _dept: orig._dept || '',
        _sectionType: orig._sectionType || null,
        _preset: orig._preset || null,
        _tool: orig._tool
      });
      if (orig._tool === 'wall') {
        // x1/y1/x2/y2 are absolute canvas coords — offset them to match new center
        var origCx = (orig.x1 + orig.x2) / 2;
        var origCy = (orig.y1 + orig.y2) / 2;
        var dx = (absLeft + delta) - origCx;
        var dy = (absTop  + delta) - origCy;
        cloned.set({
          x1: orig.x1 + dx, y1: orig.y1 + dy,
          x2: orig.x2 + dx, y2: orig.y2 + dy
        });
        makeWallEditable(cloned);
      }
      cv.add(cloned);
      newObjs.push(cloned);
      pending--;
      if (!pending) {
        if (newObjs.length === 1) {
          cv.setActiveObject(newObjs[0]);
        } else {
          var sel2 = new fabric.ActiveSelection(newObjs, { canvas: cv });
          cv.setActiveObject(sel2);
        }
        cv.renderAll();
        countUp();
        debouncePushHistory();
      }
    }, HIST_KEYS);
  });
}

// ── Step click navigation ─────────────────────────────────
function clickStep(n) {
  if (n === currentStep) return;
  if (n > currentStep + 1) { toast('순서대로 진행해 주세요'); return; }
  goToStep(n);
}

// ── Object list panel ─────────────────────────────────────
var _objlistOpen = true;

function toggleObjList() {
  _objlistOpen = !_objlistOpen;
  document.getElementById('objlist-body').style.display = _objlistOpen ? '' : 'none';
}

function _makeOlRow(obj, isChild) {
  var isSection = obj._tool === 'section';
  var stype = isSection
    ? (SECTION_TYPES.find(function(t){ return t.id === (obj._sectionType || 'general'); }) || SECTION_TYPES[0])
    : null;
  var label = obj._name || (isSection ? (stype ? stype.label : '구역') : ({'furniture':'가구','group':'그룹'}[obj._tool] || '요소'));

  var dotHtml = isSection
    ? '<div class="ol-dot" style="background:' + (stype ? stype.badge : '#AAAAAA') + ';border-radius:2px;width:10px;height:10px;flex-shrink:0"></div>'
    : '<div class="ol-dot ' + (obj._tool === 'group' ? 'group' : 'desk') + '"></div>';

  var row = document.createElement('div');
  row.className = 'ol-item' + (isChild ? ' ol-item-child' : '');
  row.innerHTML =
    (isChild ? '<span class="ol-child-arrow">↳</span>' : '') +
    dotHtml +
    '<span class="ol-lbl">' + escHtml(label) + '</span>' +
    (obj._tool === 'group' ? '<button class="ol-ungrp" title="그룹 해제">풀기</button>' : '') +
    '<button class="ol-del" title="삭제">×</button>';

  row.addEventListener('click', function(e) {
    if (e.target.classList.contains('ol-del') || e.target.classList.contains('ol-ungrp')) return;
    document.querySelectorAll('.ol-item').forEach(function(r) { r.classList.remove('on'); });
    row.classList.add('on');
    if (obj.selectable) {
      cv.setActiveObject(obj); cv.renderAll(); updatePanel();
    } else {
      cv.getObjects().filter(function(o) { return o._hl; }).forEach(function(o) { cv.remove(o); });
      var pad = 8, sw = obj.getScaledWidth ? obj.getScaledWidth() : (obj.width||40);
      var sh  = obj.getScaledHeight ? obj.getScaledHeight() : (obj.height||40);
      cv.add(new fabric.Rect({
        left: obj.left, top: obj.top, width: sw+pad*2, height: sh+pad*2,
        originX:'center', originY:'center', angle: obj.angle||0,
        fill:'transparent', stroke:'#4F46E5', strokeWidth:2,
        strokeDashArray:[5,3], selectable:false, evented:false, _hl:true
      }));
      cv.renderAll();
      setTimeout(function() { cv.getObjects().filter(function(o){return o._hl;}).forEach(function(o){cv.remove(o);}); cv.renderAll(); }, 1500);
    }
  });

  row.querySelector('.ol-del').addEventListener('click', function(e) {
    e.stopPropagation();
    if (!obj._bg) {
      if (obj._tool === 'door' || obj._tool === 'window') restoreGapWalls(obj);
      cv.remove(obj);
    }
    cv.discardActiveObject(); cv.renderAll(); showPanelEmpty(); countUp(); debouncePushHistory();
  });

  var ungrpBtn = row.querySelector('.ol-ungrp');
  if (ungrpBtn) {
    ungrpBtn.addEventListener('click', function(e) {
      e.stopPropagation();
      var items = obj._objects.slice();
      var m = obj.calcTransformMatrix();
      cv.discardActiveObject(); cv.remove(obj);
      items.forEach(function(item) {
        var pt = fabric.util.transformPoint(new fabric.Point(item.left||0, item.top||0), m);
        item.set({ left: pt.x, top: pt.y, angle: (item.angle||0)+(obj.angle||0) });
        item.setCoords(); cv.add(item);
      });
      cv.setActiveObject(new fabric.ActiveSelection(items, { canvas: cv }));
      cv.renderAll(); debouncePushHistory(); refreshObjList();
    });
  }

  return row;
}

function refreshObjList() {
  var wrap = document.getElementById('objlist-wrap');
  var body = document.getElementById('objlist-body');
  var cnt  = document.getElementById('objlist-count');
  if (currentStep === 3) { wrap.style.display = 'none'; return; }
  wrap.style.display = '';
  body.innerHTML = '';

  if (currentStep === 1) {
    var objs = cv.getObjects().filter(function(o) {
      return !o._bg && !o._prev && !o._calib &&
             o._tool && o._tool !== 'furniture' && o._tool !== 'section';
    });
    cnt.textContent = objs.length + '개';
    if (!objs.length) {
      body.innerHTML = '<div style="padding:12px 15px;font-size:10px;color:var(--txt2);text-align:center">없음</div>';
      return;
    }
    var labelMap = { wall:'벽', door:'문', window:'창문', column:'기둥', furniture:'책상', section:'구역', group:'그룹' };
    var dotMap   = { wall:'wall', door:'door', window:'window', column:'column', furniture:'desk', section:'section', group:'group' };
    objs.forEach(function(obj, i) {
      var isSection = obj._tool === 'section';
      var isMeeting = isSection && obj._sectionType === 'MEETING';
      var label = obj._name || (isSection ? (isMeeting ? '회의실' : '구역') : (labelMap[obj._tool] || '요소')) + ' ' + (i+1);
      var dotCls = isMeeting ? 'meeting' : (dotMap[obj._tool] || 'desk');
      var row = document.createElement('div');
      row.className = 'ol-item';
      row.innerHTML = '<div class="ol-dot ' + dotCls + '"></div><span class="ol-lbl">' + escHtml(label) + '</span><button class="ol-del" title="삭제">×</button>';
      row.addEventListener('click', function(e) {
        if (e.target.classList.contains('ol-del')) return;
        document.querySelectorAll('.ol-item').forEach(function(r) { r.classList.remove('on'); });
        row.classList.add('on');
        if (obj.selectable) { cv.setActiveObject(obj); cv.renderAll(); updatePanel(); }
      });
      row.querySelector('.ol-del').addEventListener('click', function(e) {
        e.stopPropagation();
        if (obj._tool === 'door' || obj._tool === 'window') restoreGapWalls(obj);
        cv.remove(obj); cv.discardActiveObject(); cv.renderAll(); showPanelEmpty(); countUp(); debouncePushHistory();
      });
      body.appendChild(row);
    });
    return;
  }

  // Step 2: hierarchical by section
  var allObjs = cv.getObjects().filter(function(o) {
    return o._tool === 'furniture' || o._tool === 'section' || o._tool === 'group';
  });
  cnt.textContent = allObjs.length + '개';
  if (!allObjs.length) {
    body.innerHTML = '<div style="padding:12px 15px;font-size:10px;color:var(--txt2);text-align:center">없음</div>';
    return;
  }

  var sections = allObjs.filter(function(o) { return o._tool === 'section'; });
  var furniture = allObjs.filter(function(o) { return o._tool !== 'section'; });
  var sectionMap = {};
  sections.forEach(function(s) { if (s._id) sectionMap[s._id] = s; });

  var grouped = {}, orphans = [];
  furniture.forEach(function(f) {
    var sid = f._sectionId;
    if (sid && sectionMap[sid]) {
      if (!grouped[sid]) grouped[sid] = [];
      grouped[sid].push(f);
    } else {
      orphans.push(f);
    }
  });

  sections.forEach(function(sec) {
    body.appendChild(_makeOlRow(sec, false));
    (grouped[sec._id] || []).forEach(function(child) {
      body.appendChild(_makeOlRow(child, true));
    });
  });

  if (orphans.length) {
    if (sections.length) {
      var hdr = document.createElement('div');
      hdr.className = 'ol-orphan-hdr';
      hdr.textContent = '미배정';
      body.appendChild(hdr);
    }
    orphans.forEach(function(obj) { body.appendChild(_makeOlRow(obj, false)); });
  }
}

// ════════════════════════════════════════════════════════════
//  도면 → 벽 자동 추출 (순수 JS run-length — 외부 라이브러리/CDN 불필요)
// ════════════════════════════════════════════════════════════
var exExtractActive  = false;
var exDetecting      = false;
var exRedetectTimer  = null;
var exLines          = [];
var exProcScale      = 1;
var exAnalyzed       = false;
var exEyedropper     = false;
var exSavedOpacity   = 1;
var exColorPicked    = false;

function imgPxToCanvas(ix, iy) {
  var m = bgImg.calcTransformMatrix();
  return fabric.util.transformPoint({ x: ix - bgImg.width / 2, y: iy - bgImg.height / 2 }, m);
}

function startWallExtract() {
  if (scaleModeOn)       { toast('축척 설정을 먼저 끝내주세요'); return; }
  if (!bgImg)            { toast('먼저 배경 도면을 업로드하세요'); return; }
  if (currentStep !== 1) { toast('1단계(구조)에서 사용하세요'); return; }
  if (exExtractActive) return;

  exExtractActive = true;
  document.querySelectorAll('.tool, .tg-hdr').forEach(function(b) { b.classList.remove('on', 'drawing'); });
  activeTool = 'select';
  cancelWall();
  cv.selection = false;
  cv.discardActiveObject();
  cv.forEachObject(function(o) { o.selectable = false; o.evented = false; });
  cv.renderAll();

  // 도면 투명도를 원본(1.0)으로 복원 — 스포이드가 실제 픽셀 색상을 볼 수 있도록
  if (bgImg) {
    exSavedOpacity = bgImg.opacity;
    bgImg.set('opacity', 1);
    cv.renderAll();
  }

  exAnalyzed = false;
  exColorPicked = false;
  document.getElementById('ex-pick-prompt').style.display = 'block';
  document.getElementById('ex-color-row').style.display   = 'none';
  document.getElementById('ex-count').style.display       = 'none';
  document.getElementById('ex-confirm').style.display     = 'none';
  flashHint('도면에서 벽을 클릭하면 자동으로 색상이 감지됩니다');
}

var WALL_COLOR = [179, 179, 179];

function applyColorMask(imgData) {
  var cm = document.getElementById('ex-colormask');
  if (!cm || !cm.checked) return;
  var tol = parseInt(document.getElementById('ex-coltol').value);
  if (isNaN(tol)) tol = 2;
  var d = imgData.data, tr = WALL_COLOR[0], tg = WALL_COLOR[1], tb = WALL_COLOR[2];
  for (var i = 0; i < d.length; i += 4) {
    var keep = Math.abs(d[i] - tr) <= tol && Math.abs(d[i+1] - tg) <= tol && Math.abs(d[i+2] - tb) <= tol;
    var v = keep ? 0 : 255;
    d[i] = d[i+1] = d[i+2] = v; d[i+3] = 255;
  }
}

function buildProcImageData() {
  var imgEl = bgImg.getElement();
  var nw = imgEl.naturalWidth  || imgEl.width;
  var nh = imgEl.naturalHeight || imgEl.height;
  var PROC_MAX = 1500;
  exProcScale = Math.min(1, PROC_MAX / Math.max(nw, nh));
  var pw = Math.max(1, Math.round(nw * exProcScale));
  var ph = Math.max(1, Math.round(nh * exProcScale));
  var cm = document.getElementById('ex-colormask');
  if (cm && cm.checked) {
    var full = document.createElement('canvas');
    full.width = nw; full.height = nh;
    var fctx = full.getContext('2d');
    fctx.imageSmoothingEnabled = false;
    fctx.fillStyle = '#fff'; fctx.fillRect(0, 0, nw, nh);
    fctx.drawImage(imgEl, 0, 0);
    var fullData = fctx.getImageData(0, 0, nw, nh);
    applyColorMask(fullData);
    fctx.putImageData(fullData, 0, 0);
    var mtmp = document.createElement('canvas');
    mtmp.width = pw; mtmp.height = ph;
    var mctx = mtmp.getContext('2d');
    mctx.fillStyle = '#fff'; mctx.fillRect(0, 0, pw, ph);
    mctx.drawImage(full, 0, 0, pw, ph);
    return mctx.getImageData(0, 0, pw, ph);
  }
  var tmp = document.createElement('canvas');
  tmp.width = pw; tmp.height = ph;
  var tctx = tmp.getContext('2d');
  tctx.fillStyle = '#fff'; tctx.fillRect(0, 0, pw, ph);
  tctx.drawImage(imgEl, 0, 0, pw, ph);
  return tctx.getImageData(0, 0, pw, ph);
}

function runDetect() {
  if (!exExtractActive) return;
  exDetecting = true;
  document.getElementById('ex-count').textContent = '분석 중…';

  var sens       = parseInt(document.getElementById('ex-sens').value) || 5;
  var minLenVal  = parseInt(document.getElementById('ex-minlen').value) || 3;
  var minMm      = 100 + (minLenVal - 1) * 150;   // 1→100mm … 9→1300mm
  var sc         = bgImg.scaleX || 1;
  var canvasPxPerMm = pxPerM / 1000;
  var minLenProc = Math.max(8, (minMm * canvasPxPerMm / sc) * exProcScale);
  var inkT   = Math.round(60 + sens * 14);
  var maxGap = Math.max(2, Math.round(minLenProc * 0.12));

  var img;
  try { img = buildProcImageData(); }
  catch (err) { exDetecting = false; toast('이미지 분석 실패: ' + err); return; }

  setTimeout(function() {
    if (!exExtractActive) { exDetecting = false; return; }
    onWorkerLines(detectLinesJS(img, Math.round(minLenProc), maxGap, inkT));
  }, 0);
}

function detectLinesJS(img, minLen, maxGap, inkT) {
  var w = img.width, h = img.height, d = img.data;
  var ink = new Uint8Array(w * h);
  for (var i = 0, p = 0; p < ink.length; i += 4, p++) {
    var lum = d[i] * 0.299 + d[i+1] * 0.587 + d[i+2] * 0.114;
    ink[p] = lum < inkT ? 1 : 0;
  }
  var lines = [];
  // 수평: 각 행
  for (var y = 0; y < h; y++) {
    var row = y * w, x = 0;
    while (x < w) {
      if (ink[row + x]) {
        var x0 = x, last = x, gap = 0;
        x++;
        while (x < w) {
          if (ink[row + x]) { last = x; gap = 0; }
          else if (++gap > maxGap) break;
          x++;
        }
        if (last - x0 >= minLen) lines.push([x0, y, last, y]);
      } else x++;
    }
  }
  // 수직: 각 열
  for (var cx = 0; cx < w; cx++) {
    var yy = 0;
    while (yy < h) {
      if (ink[yy * w + cx]) {
        var y0 = yy, lastY = yy, gap2 = 0;
        yy++;
        while (yy < h) {
          if (ink[yy * w + cx]) { lastY = yy; gap2 = 0; }
          else if (++gap2 > maxGap) break;
          yy++;
        }
        if (lastY - y0 >= minLen) lines.push([cx, y0, cx, lastY]);
      } else yy++;
    }
  }
  return lines;
}

function scheduleRedetect() {
  if (!exExtractActive || !exColorPicked) return;
  clearTimeout(exRedetectTimer);
  exRedetectTimer = setTimeout(runDetect, 280);
}

function onWorkerLines(raw) {
  exDetecting = false;
  var ortho      = document.getElementById('ex-ortho').checked;
  var minLenVal  = parseInt(document.getElementById('ex-minlen').value) || 3;
  var minMm      = 100 + (minLenVal - 1) * 150;
  var canvasPxPerMm = pxPerM / 1000;
  var minLenCanvas = minMm * canvasPxPerMm;
  var TOL = 14 * Math.PI / 180;

  var hs = [], vs = [], ds = [];
  raw.forEach(function(L) {
    var a = imgPxToCanvas(L[0] / exProcScale, L[1] / exProcScale);
    var b = imgPxToCanvas(L[2] / exProcScale, L[3] / exProcScale);
    var dx = b.x - a.x, dy = b.y - a.y;
    if (Math.hypot(dx, dy) < minLenCanvas) return;
    var na = Math.abs(Math.atan2(dy, dx));
    var isH = (na <= TOL) || (Math.abs(na - Math.PI) <= TOL);
    var isV = Math.abs(na - Math.PI / 2) <= TOL;
    if (isH)      hs.push({ x1: a.x, y1: a.y, x2: b.x, y2: b.y });
    else if (isV) vs.push({ x1: a.x, y1: a.y, x2: b.x, y2: b.y });
    else          ds.push({ x1: a.x, y1: a.y, x2: b.x, y2: b.y });
  });

  var result = [];
  if (ortho) {
    var mergeRange = parseInt(document.getElementById('ex-merge').value) || 8;
    var bucket = Math.max(mergeRange, DEF_SW);
    var gap    = Math.max(bucket, 250 * canvasPxPerMm);
    result = result.concat(mergeAxis(hs, 'h', bucket, gap, minLenCanvas));
    result = result.concat(mergeAxis(vs, 'v', bucket, gap, minLenCanvas));
    ds.forEach(function(d) { result.push(d); });
  } else {
    result = hs.concat(vs, ds);
  }
  exLines = result;
  drawExtractPreview();
}

function mergeAxis(arr, axis, bucket, gap, minLen) {
  var groups = {};
  arr.forEach(function(s) {
    var cross = axis === 'h' ? (s.y1 + s.y2) / 2 : (s.x1 + s.x2) / 2;
    var key = Math.round(cross / bucket);
    (groups[key] = groups[key] || []).push({ s: s, cross: cross });
  });
  var out = [];
  Object.keys(groups).forEach(function(k) {
    var items = groups[k];
    var totalLen = 0, crossSum = 0;
    var ivs = items.map(function(it) {
      var s = it.s;
      var lo = axis === 'h' ? Math.min(s.x1, s.x2) : Math.min(s.y1, s.y2);
      var hi = axis === 'h' ? Math.max(s.x1, s.x2) : Math.max(s.y1, s.y2);
      var len = hi - lo;
      crossSum += it.cross * len;
      totalLen += len;
      return [lo, hi];
    }).sort(function(a, b) { return a[0] - b[0]; });
    var crossAvg = totalLen > 0 ? crossSum / totalLen : items[0].cross;
    var cur = ivs[0].slice();
    var flush = function(iv) {
      if (iv[1] - iv[0] < minLen) return;
      if (axis === 'h') out.push({ x1: iv[0], y1: crossAvg, x2: iv[1], y2: crossAvg });
      else              out.push({ x1: crossAvg, y1: iv[0], x2: crossAvg, y2: iv[1] });
    };
    for (var i = 1; i < ivs.length; i++) {
      if (ivs[i][0] <= cur[1] + gap) { cur[1] = Math.max(cur[1], ivs[i][1]); }
      else { flush(cur); cur = ivs[i].slice(); }
    }
    flush(cur);
  });
  return out;
}

function clearExtractPreview() {
  cv.getObjects().filter(function(o) { return o._detPrev; }).forEach(function(o) { cv.remove(o); });
}

function drawExtractPreview() {
  clearExtractPreview();
  exLines.forEach(function(L) {
    cv.add(new fabric.Line([L.x1, L.y1, L.x2, L.y2], {
      stroke: '#8B5CF6', strokeWidth: DEF_SW, strokeLineCap: 'round',
      strokeDashArray: [9, 5], opacity: 0.9, strokeUniform: true,
      selectable: false, evented: false, _detPrev: true, _prev: true
    }));
  });
  cv.renderAll();
  exAnalyzed = true;
  var n = exLines.length;
  var countEl = document.getElementById('ex-count');
  countEl.style.display = 'block';
  countEl.textContent = n > 0 ? '벽 ' + n + '개 검출' : '검출 결과 없음 — 슬라이더를 조절해보세요';
  var btn = document.getElementById('ex-confirm');
  btn.style.display = 'block';
  btn.textContent = n === 0 ? '재분석' : '벽 ' + n + '개 적용';
  btn.disabled = false; btn.style.opacity = '1'; btn.style.cursor = 'pointer';
  flashHint(n > 0 ? n + '개 벽 후보 — 슬라이더로 조절 후 확정' : '검출 결과 없음 — 설정을 조정해보세요');
}

function confirmWallExtract() {
  if (!exLines.length) { toast('검출된 벽이 없습니다 — 민감도를 높여보세요'); return; }
  if (document.getElementById('ex-replace').checked) {
    cv.getObjects().filter(function(o) { return o._tool === 'wall' && !o._prev; })
      .forEach(function(o) { cv.remove(o); });
    pts.length = 0;
  }
  clearExtractPreview();
  var added = 0;
  exLines.forEach(function(L) {
    var wall = new fabric.Line([L.x1, L.y1, L.x2, L.y2], {
      stroke: '#3A3530', strokeWidth: DEF_SW, strokeLineCap: 'round',
      strokeUniform: true, selectable: false, evented: false, _tool: 'wall'
    });
    cv.add(wall);
    makeWallEditable(wall);
    pts.push({ x: L.x1, y: L.y1 }, { x: L.x2, y: L.y2 });
    added++;
  });
  exitExtractMode();
  wizardGoTo(4);
  countUp();
  debouncePushHistory();
  toast('벽 ' + added + '개 적용됨 — 필요한 부분을 다듬으세요');
}

function cancelWallExtract() { exitExtractMode(); toast('자동 추출 취소'); }

function exitExtractMode() {
  exExtractActive = false;
  exDetecting = false;
  exAnalyzed = false;
  exEyedropper = false;
  exColorPicked = false;
  if (cv.wrapperEl) cv.wrapperEl.classList.remove('cv-eyedropper');
  hideLoupe();
  clearTimeout(exRedetectTimer);
  clearExtractPreview();
  exLines = [];
  // 저장해 뒀던 도면 투명도 복원
  if (bgImg) {
    bgImg.set('opacity', exSavedOpacity);
  }
  cv.selection = true;
  cv.setCursor('default');
  setTool('select');
  cv.renderAll();
}

function exConfirmAction() {
  if (!exAnalyzed || exLines.length === 0) runDetect();
  else confirmWallExtract();
}

function hideLoupe() {
  var el = document.getElementById('ex-loupe');
  if (el) el.style.display = 'none';
}

function updateLoupe(canvasX, canvasY, clientX, clientY) {
  if (!bgImg) return;
  var loupe = document.getElementById('ex-loupe');
  var lc    = document.getElementById('ex-loupe-cv');
  if (!loupe || !lc) return;
  var W = 120, H = 120, SAMP = 16;
  // 커서가 loupe 정중앙에 오도록
  loupe.style.left = clientX + 'px';
  loupe.style.top  = clientY + 'px';
  loupe.style.display = 'block';
  try {
    var m   = bgImg.calcTransformMatrix();
    var inv = fabric.util.invertTransform(m);
    var pt  = fabric.util.transformPoint({ x: canvasX, y: canvasY }, inv);
    var imgEl = bgImg._originalElement || bgImg.getElement();
    var nw = imgEl.naturalWidth || imgEl.width;
    var nh = imgEl.naturalHeight || imgEl.height;
    var px = Math.round(pt.x + nw / 2);
    var py = Math.round(pt.y + nh / 2);
    var ctx = lc.getContext('2d');
    ctx.imageSmoothingEnabled = false;
    ctx.fillStyle = '#fff';
    ctx.fillRect(0, 0, W, H);
    ctx.drawImage(imgEl, px - SAMP / 2, py - SAMP / 2, SAMP, SAMP, 0, 0, W, H);
    // 십자선 (중앙 가리지 않도록 갭 둠)
    var ps = W / SAMP;  // 픽셀 1개의 크기
    var g  = ps / 2 + 2;
    ctx.strokeStyle = 'rgba(0,0,0,0.35)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.moveTo(W/2, 0);   ctx.lineTo(W/2, H/2 - g);
    ctx.moveTo(W/2, H/2 + g); ctx.lineTo(W/2, H);
    ctx.moveTo(0, H/2);   ctx.lineTo(W/2 - g, H/2);
    ctx.moveTo(W/2 + g, H/2); ctx.lineTo(W, H/2);
    ctx.stroke();
    // 중앙 픽셀 (선택될 픽셀) 강조
    ctx.strokeStyle = '#5B21B6';
    ctx.lineWidth = 1.5;
    ctx.strokeRect(W/2 - ps/2, H/2 - ps/2, ps, ps);
  } catch(e) { /* silent */ }
}

function startEyedropper() {
  if (!bgImg) return;
  exEyedropper = true;
  cv.defaultCursor = 'crosshair';
  cv.hoverCursor   = 'crosshair';
  cv.setCursor('crosshair');
  if (cv.wrapperEl) cv.wrapperEl.classList.add('cv-eyedropper');
  var btn = document.getElementById('ex-eyedrop-btn');
  if (btn) btn.textContent = '클릭 중…';
  flashHint('도면에서 벽 색상을 클릭하세요');
}

function sampleBgColor(canvasX, canvasY) {
  try {
    var m   = bgImg.calcTransformMatrix();
    var inv = fabric.util.invertTransform(m);
    var pt  = fabric.util.transformPoint({ x: canvasX, y: canvasY }, inv);
    // _originalElement = Fabric이 가공하기 전 원본 이미지 요소
    var imgEl = bgImg._originalElement || bgImg.getElement();
    var nw = imgEl.naturalWidth  || imgEl.width;
    var nh = imgEl.naturalHeight || imgEl.height;
    var px = Math.round(pt.x + nw / 2);
    var py = Math.round(pt.y + nh / 2);
    if (px < 0 || py < 0 || px >= nw || py >= nh) return null;
    // 1×1 캔버스에 해당 픽셀만 잘라서 읽기 — 전체 이미지를 그리는 것보다 정확하고 빠름
    var tmp = document.createElement('canvas');
    tmp.width = 1; tmp.height = 1;
    var ctx2 = tmp.getContext('2d');
    ctx2.drawImage(imgEl, px, py, 1, 1, 0, 0, 1, 1);
    var d = ctx2.getImageData(0, 0, 1, 1).data;
    // 반투명 픽셀은 흰 배경으로 합성 (buildProcImageData와 동일한 방식)
    if (d[3] < 255) {
      var a = d[3] / 255;
      return [
        Math.round(d[0] * a + 255 * (1 - a)),
        Math.round(d[1] * a + 255 * (1 - a)),
        Math.round(d[2] * a + 255 * (1 - a))
      ];
    }
    return [d[0], d[1], d[2]];
  } catch(e) { return null; }
}

function onWallColorChange() {
  var hex = document.getElementById('ex-wallcolor').value;
  var r = parseInt(hex.slice(1,3),16);
  var g = parseInt(hex.slice(3,5),16);
  var b = parseInt(hex.slice(5,7),16);
  WALL_COLOR = [r, g, b];
  document.getElementById('ex-wallcolor-rgb').textContent = r+','+g+','+b;
  scheduleRedetect();
}

// ── Setup Wizard ──────────────────────────────────────────
var wizardStep   = 0;  // 0=no image, 1=upload, 2=scale, 3=extract, 4=done
var wizardScaleMm = 250;

function updateWizardUI() {
  var s = wizardStep;
  [1, 2, 3].forEach(function(n) {
    var numEl = document.getElementById('wz-n' + n);
    var badge = document.getElementById('wz-b' + n);
    var head  = document.getElementById('wz-h' + n);
    var body  = document.getElementById('wz-body' + n);
    if (!numEl) return;
    if (s > n) {
      numEl.textContent = '✓'; numEl.className = 'wz-num done';
      badge.textContent = '완료'; badge.className = 'wz-badge ok';
      head.className  = 'wz-head wz-past';
      body.style.display = 'none';
    } else if (s === n) {
      numEl.textContent = n; numEl.className = 'wz-num act';
      badge.textContent = '진행 중'; badge.className = 'wz-badge';
      head.className  = 'wz-head';
      body.style.display = 'flex';
    } else {
      numEl.textContent = n; numEl.className = 'wz-num';
      badge.textContent = '—'; badge.className = 'wz-badge';
      head.className  = 'wz-head wz-future';
      body.style.display = 'none';
    }
  });
  var isDone = s >= 4;
  document.getElementById('wz-done').style.display       = isDone ? 'block' : 'none';
  document.getElementById('wz-steps-wrap').style.display = isDone ? 'none'  : 'block';
  if (isDone) {
    document.getElementById('wz-done-scale').textContent = '1칸 = ' + wizardScaleMm + ' mm';
  }
}

function wizardGoTo(step) {
  if (step === 1) {
    if (exExtractActive) exitExtractMode();
    wizardStep = 1;
    updateWizardUI();
  } else if (step === 2) {
    if (!bgImg) { toast('도면을 먼저 업로드하세요'); return; }
    if (exExtractActive) exitExtractMode();
    wizardStep = 2;
    updateWizardUI();
    enterScaleMode();
  } else if (step === 3) {
    if (!bgImg) return;
    wizardStep = 3;
    updateWizardUI();
    startWallExtract();
    startEyedropper();
  } else if (step === 4) {
    wizardStep = 4;
    updateWizardUI();
  }
}

function wizardClickHead(n) {
  // Allow going back to a completed step
  if (n < wizardStep) wizardGoTo(n);
}

function wizardSkip(step) {
  if (step === 2) {
    if (scaleModeOn) { clearCalibObjects(); scaleModeOn = false; cv.selection = true; cv.defaultCursor = 'default'; setTool('select'); cv.renderAll(); }
    wizardGoTo(3);
  } else if (step === 3) {
    if (exExtractActive) exitExtractMode();
    wizardGoTo(4);
    toast('자동 추출 건너뜀');
  }
}

function wizardBgLoaded() {
  document.getElementById('bgctrl').style.display = 'block';
  var badge = document.getElementById('wz-b1');
  if (badge) { badge.textContent = '업로드 완료'; badge.className = 'wz-badge ok'; }
  // 업로드 완료 시 바로 축척 설정 단계로 진입
  wizardGoTo(2);
}

function wizardReset() {
  if (exExtractActive) exitExtractMode();
  if (scaleModeOn) { clearCalibObjects(); scaleModeOn = false; cv.selection = true; cv.defaultCursor = 'default'; setTool('select'); }
  wizardScaleMm = 250;
  if (bgImg) {
    wizardStep = 1;
    document.getElementById('calib-step1').style.display = 'block';
    document.getElementById('calib-step2').style.display = 'none';
  } else {
    wizardStep = 0;
  }
  updateWizardUI();
}

function wizardFullReset() {
  wizardScaleMm = 250;
  wizardStep = 0;
  var b1 = document.getElementById('wz-b1');
  if (b1) { b1.textContent = ''; b1.className = 'wz-badge'; }
  updateWizardUI();
}

// ── Object Library ──────────────────────────────────────
var OLIB_DATA={"tile":32,"cats":[{"k":"Workstations","n":"워크스테이션"},{"k":"Seating","n":"좌석"},{"k":"Meeting","n":"회의·협업"},{"k":"IT & Devices","n":"IT·장비"},{"k":"Storage","n":"수납"},{"k":"Plants & Decor","n":"식물·데코"},{"k":"Amenities","n":"편의시설"},{"k":"Kitchen & Bath","n":"주방·욕실"},{"k":"Structure","n":"구조·출입"},{"k":"Recreation","n":"휴게·오락"}],"objs":[{"id":"desk","name":"책상","cat":"Workstations","fp":"4×2","tags":["desk","책상","table","단일책상"]},{"id":"desk-chair","name":"업무 책상","cat":"Workstations","fp":"4×3","tags":["workstation","업무","책상","의자","자리"]},{"id":"l-desk","name":"L자 책상","cat":"Workstations","fp":"4×4","tags":["l desk","l자","코너책상","corner"]},{"id":"standing-desk","name":"스탠딩 책상","cat":"Workstations","fp":"4×2","tags":["standing","스탠딩","높이조절","모션데스크"]},{"id":"double-workstation","name":"마주보는 책상","cat":"Workstations","fp":"4×4","tags":["double","마주보는","2인","맞보기","책상"]},{"id":"cubicle","name":"파티션 부스","cat":"Workstations","fp":"4×4","tags":["cubicle","파티션","부스","칸막이","booth"]},{"id":"bench-desk","name":"벤치 데스크 4인","cat":"Workstations","fp":"6×4","tags":["bench","벤치","공유책상","4인","협업책상"]},{"id":"bench-desk-6","name":"벤치 데스크 6인","cat":"Workstations","fp":"6×4","tags":["bench","벤치","6인","공유책상","협업"]},{"id":"executive-desk","name":"임원 책상","cat":"Workstations","fp":"5×3","tags":["executive","임원","대표","desk","이사"]},{"id":"office-chair","name":"사무용 의자","cat":"Seating","fp":"2×2","tags":["office chair","사무","의자","회전의자","task"]},{"id":"gaming-chair","name":"게이밍 의자","cat":"Seating","fp":"2×2","tags":["gaming","게이밍","게임","의자"]},{"id":"chair","name":"의자","cat":"Seating","fp":"2×2","tags":["chair","의자","목재의자","wood"]},{"id":"armchair","name":"안락 의자","cat":"Seating","fp":"3×3","tags":["armchair","안락","1인소파","암체어"]},{"id":"lounge-chair","name":"라운지 체어","cat":"Seating","fp":"3×3","tags":["lounge","라운지","휴게의자","안락"]},{"id":"sofa-2","name":"2인 소파","cat":"Seating","fp":"4×2","tags":["sofa","소파","2인","couch"]},{"id":"sofa-3","name":"3인 소파","cat":"Seating","fp":"5×2","tags":["sofa","소파","3인","couch"]},{"id":"l-sofa","name":"L자 소파","cat":"Seating","fp":"4×4","tags":["l sofa","l자","코너소파","sectional","소파"]},{"id":"bench","name":"벤치","cat":"Seating","fp":"4×1","tags":["bench","벤치","긴의자","복도의자"]},{"id":"waiting-chairs","name":"대기 의자","cat":"Seating","fp":"4×2","tags":["waiting","대기","연결의자","로비","복도"]},{"id":"stool","name":"스툴","cat":"Seating","fp":"2×2","tags":["stool","스툴","등받이없는"]},{"id":"bar-stool","name":"바 스툴","cat":"Seating","fp":"2×2","tags":["bar stool","바스툴","높은의자"]},{"id":"beanbag","name":"빈백","cat":"Seating","fp":"2×2","tags":["beanbag","빈백","쿠션소파"]},{"id":"ottoman","name":"오토만","cat":"Seating","fp":"2×2","tags":["ottoman","오토만","발받침","스툴쿠션"]},{"id":"conference-table","name":"회의 테이블","cat":"Meeting","fp":"6×3","tags":["conference","회의","테이블","미팅"]},{"id":"conference-table-l","name":"대회의 테이블","cat":"Meeting","fp":"8×3","tags":["conference","대회의","large","큰테이블","임원회의"]},{"id":"round-meeting-table","name":"원형 회의 테이블","cat":"Meeting","fp":"4×4","tags":["round","원형","회의","미팅"]},{"id":"huddle-table","name":"소회의 테이블","cat":"Meeting","fp":"4×3","tags":["huddle","소회의","4인","미팅"]},{"id":"training-table","name":"교육용 테이블","cat":"Meeting","fp":"6×3","tags":["training","교육","강의","classroom","책상"]},{"id":"whiteboard","name":"화이트보드","cat":"Meeting","fp":"3×1","tags":["whiteboard","화이트보드","보드","칠판"]},{"id":"flip-chart","name":"이젤 보드","cat":"Meeting","fp":"2×2","tags":["flip chart","이젤","플립차트","전지"]},{"id":"podium","name":"연단","cat":"Meeting","fp":"2×2","tags":["podium","연단","강연대","lectern"]},{"id":"projector-screen","name":"프로젝터 스크린","cat":"Meeting","fp":"4×1","tags":["projector","프로젝터","스크린","빔","beamer"]},{"id":"server-rack","name":"서버 랙","cat":"IT & Devices","fp":"2×2","tags":["server","서버","랙","rack","전산"]},{"id":"server-rack-row","name":"서버 랙 열","cat":"IT & Devices","fp":"4×2","tags":["server","서버","랙열","전산실","데이터센터"]},{"id":"desktop-pc","name":"데스크탑 PC","cat":"IT & Devices","fp":"2×2","tags":["desktop","데스크탑","pc","컴퓨터","본체"]},{"id":"monitor","name":"모니터","cat":"IT & Devices","fp":"2×1","tags":["monitor","모니터","화면","display"]},{"id":"dual-monitor","name":"듀얼 모니터","cat":"IT & Devices","fp":"3×1","tags":["dual","듀얼","모니터","2대"]},{"id":"laptop","name":"노트북","cat":"IT & Devices","fp":"2×2","tags":["laptop","노트북","랩탑","맥북"]},{"id":"printer","name":"프린터","cat":"IT & Devices","fp":"2×2","tags":["printer","프린터","인쇄"]},{"id":"copier","name":"복합기","cat":"IT & Devices","fp":"2×2","tags":["copier","복합기","복사기","mfp","스캐너","프린터"]},{"id":"network-switch","name":"네트워크 스위치","cat":"IT & Devices","fp":"3×1","tags":["switch","스위치","네트워크","허브","랜"]},{"id":"patch-panel","name":"패치 패널","cat":"IT & Devices","fp":"3×1","tags":["patch","패치","패널","랜","케이블"]},{"id":"router","name":"공유기","cat":"IT & Devices","fp":"2×1","tags":["router","공유기","라우터","와이파이","wifi"]},{"id":"wifi-ap","name":"무선 AP","cat":"IT & Devices","fp":"2×2","tags":["wifi","와이파이","ap","무선","access point","공유기"]},{"id":"projector","name":"프로젝터(빔)","cat":"IT & Devices","fp":"2×2","tags":["projector","프로젝터","빔","beamer"]},{"id":"video-wall","name":"비디오 월","cat":"IT & Devices","fp":"4×1","tags":["video wall","비디오월","디스플레이","전광판","사이니지"]},{"id":"tv-screen","name":"TV 화면","cat":"IT & Devices","fp":"3×1","tags":["tv","티비","화면","모니터","사이니지"]},{"id":"desk-phone","name":"유선 전화기","cat":"IT & Devices","fp":"2×2","tags":["phone","전화","유선","데스크폰"]},{"id":"conference-phone","name":"회의용 전화","cat":"IT & Devices","fp":"2×2","tags":["conference phone","회의전화","폴리콤","스피커폰","컨퍼런스"]},{"id":"ups","name":"무정전 전원(UPS)","cat":"IT & Devices","fp":"2×2","tags":["ups","무정전","배터리","전원"]},{"id":"kiosk","name":"키오스크","cat":"IT & Devices","fp":"2×2","tags":["kiosk","키오스크","무인단말","안내"]},{"id":"cctv","name":"CCTV","cat":"IT & Devices","fp":"2×2","tags":["cctv","시시티비","감시카메라","보안","camera"]},{"id":"charging-station","name":"충전 스테이션","cat":"IT & Devices","fp":"2×2","tags":["charging","충전","콘센트","전원","스테이션"]},{"id":"bookshelf","name":"책장","cat":"Storage","fp":"4×1","tags":["bookshelf","책장","책","서가"]},{"id":"cabinet","name":"서랍장","cat":"Storage","fp":"2×2","tags":["cabinet","서랍장","파일","캐비닛","수납"]},{"id":"supply-cabinet","name":"수납 캐비닛","cat":"Storage","fp":"2×2","tags":["supply","수납","캐비닛","문","보관함"]},{"id":"lockers","name":"사물함","cat":"Storage","fp":"3×1","tags":["locker","사물함","락커","보관함"]},{"id":"storage-shelf","name":"선반","cat":"Storage","fp":"3×1","tags":["shelf","선반","적재","보관","랙"]},{"id":"credenza","name":"로우 캐비닛","cat":"Storage","fp":"4×1","tags":["credenza","로우캐비닛","수납장","콘솔"]},{"id":"coat-rack","name":"옷걸이","cat":"Storage","fp":"2×2","tags":["coat","옷걸이","행거","코트"]},{"id":"safe","name":"금고","cat":"Storage","fp":"2×2","tags":["safe","금고","보안","vault"]},{"id":"mail-slots","name":"우편함","cat":"Storage","fp":"3×1","tags":["mail","우편함","메일박스","사서함"]},{"id":"plant","name":"화분","cat":"Plants & Decor","fp":"2×2","tags":["plant","화분","식물","green"]},{"id":"plant-large","name":"대형 화분","cat":"Plants & Decor","fp":"2×2","tags":["plant","대형화분","식물","큰화분"]},{"id":"plant-floor","name":"바닥 식물","cat":"Plants & Decor","fp":"2×2","tags":["floor plant","바닥식물","관엽","대형식물"]},{"id":"desk-plant","name":"탁상 화분","cat":"Plants & Decor","fp":"1×1","tags":["desk plant","탁상화분","작은화분","다육"]},{"id":"planter-divider","name":"플랜터 칸막이","cat":"Plants & Decor","fp":"4×1","tags":["planter","플랜터","칸막이","화단","divider"]},{"id":"rug","name":"러그","cat":"Plants & Decor","fp":"4×3","tags":["rug","러그","카펫","매트"]},{"id":"clock","name":"벽시계","cat":"Plants & Decor","fp":"1×1","tags":["clock","시계","벽시계","time"]},{"id":"partition","name":"파티션","cat":"Plants & Decor","fp":"4×1","tags":["partition","파티션","칸막이","가벽","divider"]},{"id":"glass-partition","name":"유리 파티션","cat":"Plants & Decor","fp":"4×1","tags":["glass","유리","파티션","칸막이","글래스"]},{"id":"acoustic-panel","name":"흡음 패널","cat":"Plants & Decor","fp":"2×1","tags":["acoustic","흡음","방음","패널","펠트"]},{"id":"water-cooler","name":"정수기","cat":"Amenities","fp":"2×2","tags":["water","정수기","냉온수기","워터쿨러"]},{"id":"vending-machine","name":"자판기","cat":"Amenities","fp":"2×2","tags":["vending","자판기","자동판매기","음료"]},{"id":"coffee-machine","name":"커피 머신","cat":"Amenities","fp":"2×2","tags":["coffee","커피","머신","에스프레소"]},{"id":"microwave","name":"전자레인지","cat":"Amenities","fp":"2×1","tags":["microwave","전자레인지","오븐"]},{"id":"fridge","name":"냉장고","cat":"Amenities","fp":"2×2","tags":["fridge","냉장고","refrigerator"]},{"id":"trash-bin","name":"쓰레기통","cat":"Amenities","fp":"1×1","tags":["trash","쓰레기통","휴지통","분리수거"]},{"id":"recycling-bins","name":"분리수거함","cat":"Amenities","fp":"2×1","tags":["recycling","분리수거","재활용","쓰레기"]},{"id":"fire-extinguisher","name":"소화기","cat":"Amenities","fp":"1×1","tags":["fire","소화기","extinguisher","안전"]},{"id":"first-aid","name":"구급함","cat":"Amenities","fp":"1×1","tags":["first aid","구급함","응급","약품","메디컬"]},{"id":"reception-desk","name":"리셉션 데스크","cat":"Amenities","fp":"5×2","tags":["reception","리셉션","안내데스크","프론트"]},{"id":"phone-booth","name":"폰부스","cat":"Amenities","fp":"2×2","tags":["phone booth","폰부스","전화부스","1인부스","집중부스"]},{"id":"kitchen-counter","name":"주방 조리대","cat":"Kitchen & Bath","fp":"4×2","tags":["kitchen","주방","조리대","싱크대","쿡탑"]},{"id":"pantry-counter","name":"탕비실","cat":"Kitchen & Bath","fp":"4×2","tags":["pantry","탕비실","휴게실","커피바","싱크"]},{"id":"sink","name":"싱크대","cat":"Kitchen & Bath","fp":"2×2","tags":["sink","싱크","개수대","세면"]},{"id":"cafeteria-table","name":"구내식당 테이블","cat":"Kitchen & Bath","fp":"6×2","tags":["cafeteria","구내식당","식당","벤치테이블","급식"]},{"id":"toilet","name":"변기","cat":"Kitchen & Bath","fp":"2×3","tags":["toilet","변기","화장실","양변기"]},{"id":"urinal","name":"소변기","cat":"Kitchen & Bath","fp":"2×2","tags":["urinal","소변기","남자화장실"]},{"id":"bathtub","name":"욕조","cat":"Kitchen & Bath","fp":"4×2","tags":["bathtub","욕조","목욕","tub"]},{"id":"shower","name":"샤워부스","cat":"Kitchen & Bath","fp":"2×2","tags":["shower","샤워","샤워부스","욕실"]},{"id":"bathroom-sink","name":"세면대","cat":"Kitchen & Bath","fp":"2×2","tags":["bathroom sink","세면대","세면기","lavatory","화장실"]},{"id":"door","name":"문","cat":"Structure","fp":"2×2","tags":["door","문","출입문","도어"]},{"id":"double-door","name":"양개문","cat":"Structure","fp":"4×2","tags":["double door","양개문","두짝문","출입구"]},{"id":"glass-door","name":"유리문","cat":"Structure","fp":"2×2","tags":["glass door","유리문","자동문","회전문"]},{"id":"sliding-door","name":"미닫이문","cat":"Structure","fp":"3×1","tags":["sliding","미닫이","슬라이딩","자동문"]},{"id":"window","name":"창문","cat":"Structure","fp":"2×1","tags":["window","창문","창","유리창"]},{"id":"stairs","name":"계단","cat":"Structure","fp":"2×4","tags":["stairs","계단","스테어"]},{"id":"elevator","name":"엘리베이터","cat":"Structure","fp":"3×3","tags":["elevator","엘리베이터","승강기","lift"]},{"id":"escalator","name":"에스컬레이터","cat":"Structure","fp":"2×4","tags":["escalator","에스컬레이터","무빙워크"]},{"id":"column","name":"기둥","cat":"Structure","fp":"1×1","tags":["column","기둥","필라","pillar"]},{"id":"turnstile","name":"출입 게이트","cat":"Structure","fp":"2×2","tags":["turnstile","게이트","출입통제","스피드게이트","보안"]},{"id":"nap-pod","name":"수면 캡슐","cat":"Recreation","fp":"4×2","tags":["nap","수면","캡슐","휴식","pod"]},{"id":"ping-pong","name":"탁구대","cat":"Recreation","fp":"6×3","tags":["ping pong","탁구","탁구대","table tennis"]},{"id":"foosball","name":"테이블 축구","cat":"Recreation","fp":"4×2","tags":["foosball","테이블축구","풋볼","오락"]},{"id":"pool-table","name":"당구대","cat":"Recreation","fp":"6×3","tags":["pool","당구","포켓볼","billiard","당구대"]},{"id":"treadmill","name":"러닝머신","cat":"Recreation","fp":"2×4","tags":["treadmill","러닝머신","헬스","운동","gym"]}]};
var OLIB_IMG={"desk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='10' y='12' width='108' height='40' fill='%23BC8A4E' rx='5'%3E%3C/rect%3E%3Crect x='10' y='12' width='108' height='34' fill='%23D7A86B' rx='5'%3E%3C/rect%3E%3Crect x='76' y='18' width='34' height='20' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Ccircle cx='93' cy='28' r='2.4' fill='%239E6F38'%3E%3C/circle%3E%3C/svg%3E","desk-chair":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 96' width='128' height='96'%3E%3Crect x='10' y='8' width='108' height='38' fill='%23BC8A4E' rx='5'%3E%3C/rect%3E%3Crect x='10' y='8' width='108' height='32' fill='%23D7A86B' rx='5'%3E%3C/rect%3E%3Crect x='50' y='12' width='28' height='16' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='60' y='28' width='8' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='49' y='82' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='49' y='59' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='45' y='63' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='78' y='63' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='63' y='63' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","l-desk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 128' width='128' height='128'%3E%3Cpath d='M12,12 H118 V58 H58 V118 H12 Z' fill='%23BC8A4E'%3E%3C/path%3E%3Cpath d='M12,12 H118 V52 H58 V112 H12 Z' fill='%23D7A86B'%3E%3C/path%3E%3Crect x='74' y='18' width='34' height='20' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Ccircle cx='91' cy='28' r='2.4' fill='%239E6F38'%3E%3C/circle%3E%3C/svg%3E","standing-desk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='14' y='50' width='22' height='8' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='92' y='50' width='22' height='8' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='10' y='12' width='108' height='38' fill='%23BC8A4E' rx='5'%3E%3C/rect%3E%3Crect x='10' y='12' width='108' height='32' fill='%23D7A86B' rx='5'%3E%3C/rect%3E%3Crect x='18' y='18' width='14' height='14' fill='%238A9099' rx='3'%3E%3C/rect%3E%3Crect x='20.5' y='20.5' width='9' height='9' fill='%23AEB4BC' rx='2'%3E%3C/rect%3E%3Crect x='22.5' y='22.5' width='5' height='5' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='92' y='18' width='14' height='14' fill='%238A9099' rx='3'%3E%3C/rect%3E%3Crect x='94.5' y='20.5' width='9' height='9' fill='%23AEB4BC' rx='2'%3E%3C/rect%3E%3Crect x='96.5' y='22.5' width='5' height='5' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='50' y='18' width='28' height='16' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='53' y='20.5' width='13' height='6' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='54.5' y='22.3' width='8' height='1.2' fill='rgba(255,255,255,0.75)'%3E%3C/rect%3E%3Cpolygon points='71,22 75,22 73,19.4' fill='%23F4F6F8'%3E%3C/polygon%3E%3Cpolygon points='71,28 75,28 73,30.6' fill='%23AEB4BC'%3E%3C/polygon%3E%3C/svg%3E","double-workstation":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 128' width='128' height='128'%3E%3Crect x='10' y='42' width='108' height='18' fill='%23BC8A4E' rx='5'%3E%3C/rect%3E%3Crect x='10' y='42' width='108' height='12' fill='%23D7A86B' rx='5'%3E%3C/rect%3E%3Crect x='10' y='60' width='108' height='18' fill='%23BC8A4E' rx='5'%3E%3C/rect%3E%3Crect x='10' y='60' width='108' height='12' fill='%23D7A86B' rx='5'%3E%3C/rect%3E%3Crect x='49' y='0' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='49' y='5' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='45' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='78' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='63' y='9' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='49' y='112' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='49' y='89' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='45' y='93' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='78' y='93' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='63' y='93' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='50' y='46' width='28' height='4' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='50' y='70' width='28' height='4' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","cubicle":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 128' width='128' height='128'%3E%3Crect x='8' y='8' width='112' height='9' fill='%237C838D' rx='2'%3E%3C/rect%3E%3Crect x='8' y='8' width='9' height='104' fill='%237C838D' rx='2'%3E%3C/rect%3E%3Crect x='103' y='8' width='9' height='104' fill='%237C838D' rx='2'%3E%3C/rect%3E%3Crect x='22' y='22' width='80' height='30' fill='%23BC8A4E' rx='4'%3E%3C/rect%3E%3Crect x='22' y='22' width='80' height='24' fill='%23D7A86B' rx='4'%3E%3C/rect%3E%3Crect x='54' y='26' width='20' height='12' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='47' y='66' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='47' y='71' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='43' y='75' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='76' y='75' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='61' y='75' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","bench-desk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 128' width='192' height='128'%3E%3Crect x='36' y='38' width='120' height='50' fill='%23BC8A4E' rx='4'%3E%3C/rect%3E%3Crect x='36' y='38' width='120' height='44' fill='%23D7A86B' rx='4'%3E%3C/rect%3E%3Crect x='36' y='61' width='120' height='4' fill='%239E6F38'%3E%3C/rect%3E%3Crect x='64' y='44' width='18' height='10' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='116' y='44' width='18' height='10' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='64' y='74' width='18' height='10' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='116' y='74' width='18' height='10' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='58' y='0' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='58' y='5' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='54' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='87' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='72' y='9' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='110' y='0' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='110' y='5' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='106' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='139' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='124' y='9' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='58' y='120' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='58' y='97' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='54' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='87' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='72' y='101' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='110' y='120' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='110' y='97' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='106' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='139' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='124' y='101' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","bench-desk-6":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 128' width='192' height='128'%3E%3Crect x='20' y='38' width='152' height='50' fill='%23BC8A4E' rx='4'%3E%3C/rect%3E%3Crect x='20' y='38' width='152' height='44' fill='%23D7A86B' rx='4'%3E%3C/rect%3E%3Crect x='20' y='61' width='152' height='4' fill='%239E6F38'%3E%3C/rect%3E%3Crect x='44' y='44' width='16' height='9' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='44' y='74' width='16' height='9' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='92' y='44' width='16' height='9' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='92' y='74' width='16' height='9' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='140' y='44' width='16' height='9' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='140' y='74' width='16' height='9' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='37' y='0' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='37' y='5' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='33' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='66' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='51' y='9' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='37' y='120' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='37' y='97' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='33' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='66' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='51' y='101' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='85' y='0' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='85' y='5' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='81' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='114' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='99' y='9' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='85' y='120' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='85' y='97' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='81' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='114' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='99' y='101' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='133' y='0' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='133' y='5' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='129' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='162' y='9' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='147' y='9' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='133' y='120' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='133' y='97' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='129' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='162' y='101' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='147' y='101' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","executive-desk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 96' width='160' height='96'%3E%3Crect x='28' y='18' width='104' height='48' fill='%237E5430' rx='6'%3E%3C/rect%3E%3Crect x='28' y='18' width='104' height='42' fill='%239A6738' rx='6'%3E%3C/rect%3E%3Crect x='60' y='24' width='40' height='16' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='65' y='94' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='65' y='71' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='61' y='75' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='94' y='75' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='79' y='75' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='45' y='4.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='45' y='-2' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='97' y='4.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='97' y='-2' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3C/svg%3E","office-chair":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='18' y='12' width='28' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='17' y='20' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='11' y='22' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='48' y='22' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='31' y='24' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","gaming-chair":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='18' y='12' width='28' height='9' fill='%23E2574C' rx='4'%3E%3C/rect%3E%3Crect x='17' y='20' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='17' y='22' width='4' height='22' fill='%23E2574C' rx='2'%3E%3C/rect%3E%3Crect x='43' y='22' width='4' height='22' fill='%23E2574C' rx='2'%3E%3C/rect%3E%3Crect x='11' y='24' width='5' height='18' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='48' y='24' width='5' height='18' fill='%2351565E' rx='2'%3E%3C/rect%3E%3C/svg%3E","chair":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='20' y='16' width='24' height='7' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Crect x='20' y='22' width='24' height='24' fill='%23D7A86B' rx='5'%3E%3C/rect%3E%3Crect x='23' y='26' width='18' height='16' fill='%23E6BE8E' rx='3'%3E%3C/rect%3E%3C/svg%3E","armchair":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96' width='96' height='96'%3E%3Crect x='14' y='18' width='68' height='68' fill='%235E656F' rx='14'%3E%3C/rect%3E%3Crect x='14' y='18' width='68' height='16' fill='%23464C54' rx='12'%3E%3C/rect%3E%3Crect x='14' y='30' width='15' height='56' fill='%237C838D' rx='10'%3E%3C/rect%3E%3Crect x='67' y='30' width='15' height='56' fill='%237C838D' rx='10'%3E%3C/rect%3E%3Crect x='32' y='38' width='32' height='42' fill='%237C838D' rx='9'%3E%3C/rect%3E%3C/svg%3E","lounge-chair":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96' width='96' height='96'%3E%3Crect x='14' y='20' width='68' height='64' fill='%235E656F' rx='28'%3E%3C/rect%3E%3Crect x='14' y='20' width='68' height='16' fill='%23464C54' rx='18'%3E%3C/rect%3E%3Ccircle cx='48' cy='54' r='18' fill='%237C838D'%3E%3C/circle%3E%3C/svg%3E","sofa-2":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='12' y='14' width='104' height='44' fill='%235E656F' rx='13'%3E%3C/rect%3E%3Crect x='12' y='14' width='104' height='12' fill='%23464C54' rx='10'%3E%3C/rect%3E%3Crect x='12' y='24' width='15' height='34' fill='%237C838D' rx='8'%3E%3C/rect%3E%3Crect x='101' y='24' width='15' height='34' fill='%237C838D' rx='8'%3E%3C/rect%3E%3Crect x='30' y='30' width='32' height='24' fill='%237C838D' rx='6'%3E%3C/rect%3E%3Crect x='66' y='30' width='32' height='24' fill='%237C838D' rx='6'%3E%3C/rect%3E%3C/svg%3E","sofa-3":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 64' width='160' height='64'%3E%3Crect x='12' y='14' width='136' height='44' fill='%235E656F' rx='13'%3E%3C/rect%3E%3Crect x='12' y='14' width='136' height='12' fill='%23464C54' rx='10'%3E%3C/rect%3E%3Crect x='12' y='24' width='15' height='34' fill='%237C838D' rx='8'%3E%3C/rect%3E%3Crect x='133' y='24' width='15' height='34' fill='%237C838D' rx='8'%3E%3C/rect%3E%3Crect x='30' y='30' width='32' height='24' fill='%237C838D' rx='6'%3E%3C/rect%3E%3Crect x='64' y='30' width='32' height='24' fill='%237C838D' rx='6'%3E%3C/rect%3E%3Crect x='98' y='30' width='32' height='24' fill='%237C838D' rx='6'%3E%3C/rect%3E%3C/svg%3E","l-sofa":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 128' width='128' height='128'%3E%3Cpath d='M12,12 H118 V58 H58 V118 H12 Z' fill='%235E656F'%3E%3C/path%3E%3Crect x='12' y='12' width='106' height='12' fill='%23464C54' rx='8'%3E%3C/rect%3E%3Crect x='12' y='12' width='12' height='106' fill='%23464C54' rx='8'%3E%3C/rect%3E%3Crect x='30' y='30' width='26' height='22' fill='%237C838D' rx='6'%3E%3C/rect%3E%3Crect x='64' y='30' width='40' height='22' fill='%237C838D' rx='6'%3E%3C/rect%3E%3Crect x='30' y='60' width='26' height='52' fill='%237C838D' rx='6'%3E%3C/rect%3E%3C/svg%3E","bench":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='8' width='112' height='16' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Crect x='8' y='8' width='112' height='10' fill='%23D7A86B' rx='3'%3E%3C/rect%3E%3Crect x='34' y='11' width='4' height='10' fill='%239E6F38'%3E%3C/rect%3E%3Crect x='62' y='11' width='4' height='10' fill='%239E6F38'%3E%3C/rect%3E%3Crect x='90' y='11' width='4' height='10' fill='%239E6F38'%3E%3C/rect%3E%3C/svg%3E","waiting-chairs":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='8' y='46' width='112' height='7' fill='%238A9099' rx='3'%3E%3C/rect%3E%3Crect x='14' y='12' width='28' height='6' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='14' y='18' width='28' height='26' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='49' y='12' width='28' height='6' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='49' y='18' width='28' height='26' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='84' y='12' width='28' height='6' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='84' y='18' width='28' height='26' fill='%233C4047' rx='5'%3E%3C/rect%3E%3C/svg%3E","stool":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='18' fill='%23BC8A4E'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='15' fill='%23D7A86B'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='9' fill='%23E6BE8E'%3E%3C/circle%3E%3C/svg%3E","bar-stool":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='15' fill='%233C4047'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='11' fill='%2351565E'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='5' fill='%232B2E34'%3E%3C/circle%3E%3C/svg%3E","beanbag":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='34' r='21' fill='%23F0A04B'%3E%3C/circle%3E%3Ccircle cx='32' cy='30' r='14' fill='rgba(255,255,255,0.16)'%3E%3C/circle%3E%3Cellipse cx='26' cy='40' rx='7' ry='4' fill='rgba(0,0,0,0.06)'%3E%3C/ellipse%3E%3C/svg%3E","ottoman":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='15' y='15' width='34' height='34' fill='%235E656F' rx='10'%3E%3C/rect%3E%3Crect x='19' y='19' width='26' height='26' fill='%237C838D' rx='8'%3E%3C/rect%3E%3Crect x='31' y='19' width='2' height='26' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='19' y='31' width='26' height='2' fill='%23464C54' rx='1'%3E%3C/rect%3E%3C/svg%3E","conference-table":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 96' width='192' height='96'%3E%3Crect x='40' y='30' width='112' height='36' fill='%23BC8A4E' rx='8'%3E%3C/rect%3E%3Crect x='40' y='30' width='112' height='30' fill='%23D7A86B' rx='8'%3E%3C/rect%3E%3Crect x='57' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='57' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='57' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='57' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='87' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='87' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='87' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='87' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='117' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='117' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='117' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='117' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3C/svg%3E","conference-table-l":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 256 96' width='256' height='96'%3E%3Crect x='40' y='30' width='176' height='36' fill='%23BC8A4E' rx='8'%3E%3C/rect%3E%3Crect x='40' y='30' width='176' height='30' fill='%23D7A86B' rx='8'%3E%3C/rect%3E%3Crect x='57' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='57' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='57' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='57' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='99' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='99' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='99' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='99' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='141' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='141' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='141' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='141' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='183' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='183' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='183' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='183' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3C/svg%3E","round-meeting-table":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 128' width='128' height='128'%3E%3Ccircle cx='64' cy='64' r='40' fill='%23BC8A4E'%3E%3C/circle%3E%3Ccircle cx='64' cy='64' r='36' fill='%23D7A86B'%3E%3C/circle%3E%3Crect x='55' y='8.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='55' y='2' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='55' y='104.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='55' y='121' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='7' y='56.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='0.5' y='56.5' width='5' height='15' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='103' y='56.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='122.5' y='56.5' width='5' height='15' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3C/svg%3E","huddle-table":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 96' width='128' height='96'%3E%3Cellipse cx='64' cy='48' rx='40' ry='24' fill='%23BC8A4E'%3E%3C/ellipse%3E%3Cellipse cx='64' cy='48' rx='36' ry='20' fill='%23D7A86B'%3E%3C/ellipse%3E%3Crect x='31' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='31' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='79' y='6.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='79' y='0' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='31' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='31' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='79' y='74.5' width='18' height='15' fill='%233C4047' rx='5'%3E%3C/rect%3E%3Crect x='79' y='91' width='18' height='5' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3C/svg%3E","training-table":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 96' width='192' height='96'%3E%3Crect x='8' y='26' width='176' height='24' fill='%23BC8A4E' rx='4'%3E%3C/rect%3E%3Crect x='8' y='26' width='176' height='18' fill='%23D7A86B' rx='4'%3E%3C/rect%3E%3Crect x='25' y='56' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='25' y='61' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='21' y='65' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='54' y='65' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='39' y='65' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='73' y='56' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='73' y='61' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='69' y='65' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='102' y='65' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='87' y='65' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='121' y='56' width='30' height='8' fill='%232B2E34' rx='4'%3E%3C/rect%3E%3Crect x='121' y='61' width='30' height='26' fill='%233C4047' rx='9'%3E%3C/rect%3E%3Crect x='117' y='65' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='150' y='65' width='5' height='20' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='135' y='65' width='2' height='18' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","whiteboard":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='8' width='80' height='16' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='11' y='10' width='74' height='12' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3Crect x='60' y='18' width='12' height='3' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='74' y='18' width='10' height='3' fill='%2369C6EB' rx='1'%3E%3C/rect%3E%3C/svg%3E","flip-chart":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Cpolygon points='32,46 14,54 18,52' fill='%238A9099'%3E%3C/polygon%3E%3Cpolygon points='32,46 50,54 46,52' fill='%238A9099'%3E%3C/polygon%3E%3Crect x='18' y='10' width='28' height='34' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='20' y='12' width='24' height='30' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3Crect x='24' y='18' width='16' height='3' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='24' y='24' width='12' height='3' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","podium":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Cpolygon points='20,46 44,46 40,18 24,18' fill='%239A6738'%3E%3C/polygon%3E%3Cpolygon points='22,32 42,32 40,18 24,18' fill='%237E5430'%3E%3C/polygon%3E%3Crect x='30' y='12' width='4' height='8' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Ccircle cx='32' cy='12' r='2.5' fill='%232B2E34'%3E%3C/circle%3E%3C/svg%3E","projector-screen":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='8' width='112' height='5' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='10' y='13' width='108' height='12' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3Crect x='10' y='13' width='108' height='3' fill='%23C9CFD6'%3E%3C/rect%3E%3C/svg%3E","server-rack":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='16' y='12' width='32' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='20' y='18' width='24' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='20' y='24' width='24' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='20' y='30' width='24' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='20' y='36' width='24' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Ccircle cx='22' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='28' cy='48' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3Ccircle cx='42' cy='16' r='1.5' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","server-rack-row":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='14' y='12' width='28' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='18' y='18' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='18' y='24' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='18' y='30' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='18' y='36' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Ccircle cx='19' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='25' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Crect x='46' y='12' width='28' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='50' y='18' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='50' y='24' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='50' y='30' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='50' y='36' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Ccircle cx='51' cy='48' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3Ccircle cx='57' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Crect x='78' y='12' width='28' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='82' y='18' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='82' y='24' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='82' y='30' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='82' y='36' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Ccircle cx='83' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='89' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Crect x='110' y='12' width='28' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='114' y='18' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='114' y='24' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='114' y='30' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Crect x='114' y='36' width='20' height='3' fill='%2351565E' rx='1.5'%3E%3C/rect%3E%3Ccircle cx='115' cy='48' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3Ccircle cx='121' cy='48' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","desktop-pc":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='20' y='12' width='24' height='40' fill='%2351565E' rx='3'%3E%3C/rect%3E%3Crect x='24' y='28' width='16' height='3' fill='%232B2E34' rx='1.5'%3E%3C/rect%3E%3Crect x='24' y='33' width='16' height='3' fill='%232B2E34' rx='1.5'%3E%3C/rect%3E%3Crect x='24' y='38' width='16' height='3' fill='%232B2E34' rx='1.5'%3E%3C/rect%3E%3Crect x='24' y='18' width='16' height='5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Ccircle cx='40' cy='48' r='1.6' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","monitor":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 32' width='64' height='32'%3E%3Crect x='10' y='11' width='44' height='8' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='12' y='12' width='40' height='4' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='28' y='19' width='8' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","dual-monitor":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Cpolygon points='8,16 44,9 44,17 9,24' fill='%232B2E34'%3E%3C/polygon%3E%3Cpolygon points='88,16 52,9 52,17 87,24' fill='%232B2E34'%3E%3C/polygon%3E%3Crect x='44' y='12' width='8' height='8' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","laptop":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='14' y='11' width='36' height='19' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='17' y='13' width='30' height='15' fill='%233E84C4' rx='2'%3E%3C/rect%3E%3Crect x='14' y='32' width='36' height='19' fill='%235E656F' rx='3'%3E%3C/rect%3E%3Crect x='26' y='42' width='12' height='7' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='17' y='34' width='30' height='5' fill='%23464C54' rx='1'%3E%3C/rect%3E%3C/svg%3E","printer":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='13' y='16' width='38' height='32' fill='%2351565E' rx='4'%3E%3C/rect%3E%3Crect x='17' y='12' width='30' height='8' fill='%233C4047' rx='2'%3E%3C/rect%3E%3Crect x='20' y='20' width='24' height='8' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3Ccircle cx='43' cy='40' r='2.5' fill='%235DAE5B'%3E%3C/circle%3E%3Crect x='18' y='38' width='10' height='3' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","copier":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='11' y='12' width='42' height='42' fill='%2351565E' rx='4'%3E%3C/rect%3E%3Crect x='15' y='15' width='34' height='11' fill='%2369C6EB' rx='2'%3E%3C/rect%3E%3Crect x='15' y='15' width='34' height='11' fill='rgba(255,255,255,0.2)' rx='2'%3E%3C/rect%3E%3Crect x='15' y='40' width='34' height='8' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3Ccircle cx='20' cy='30' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='26' cy='30' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3Crect x='38' y='29' width='8' height='4' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","network-switch":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='10' width='80' height='13' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='12' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='19.6' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='27.2' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='34.8' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='42.4' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='50' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='57.599999999999994' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='65.19999999999999' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='72.8' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='80.39999999999999' y='14' width='5' height='5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Ccircle cx='82' cy='14' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='82' cy='19' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3C/svg%3E","patch-panel":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='10' width='80' height='13' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='12' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='18.3' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='24.6' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='30.9' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='37.2' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='43.5' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='49.8' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='56.1' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='62.4' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='68.69999999999999' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='75' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='81.3' y='13' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='12' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='18.3' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='24.6' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='30.9' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='37.2' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='43.5' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='49.8' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='56.1' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='62.4' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='68.69999999999999' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='75' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='81.3' y='18' width='4.5' height='4.5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","router":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 32' width='64' height='32'%3E%3Crect x='14' y='11' width='36' height='12' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Ccircle cx='20' cy='17' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='26' cy='17' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='32' cy='17' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3Crect x='18' y='8' width='3' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='43' y='8' width='3' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","wifi-ap":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='19' fill='%23F4F6F8'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='15' fill='%23E0E5EA'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='11' fill='none' stroke='%23C9CFD6' stroke-width='1.5'%3E%3C/circle%3E%3C/svg%3E","projector":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='15' y='17' width='34' height='28' fill='%23F4F6F8' rx='4'%3E%3C/rect%3E%3Crect x='19' y='22' width='8' height='3' fill='%23C9CFD6' rx='1.5'%3E%3C/rect%3E%3Crect x='19' y='26' width='8' height='3' fill='%23C9CFD6' rx='1.5'%3E%3C/rect%3E%3Ccircle cx='40' cy='31' r='6' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='40' cy='31' r='3' fill='%233E84C4'%3E%3C/circle%3E%3Ccircle cx='20' cy='40' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","video-wall":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='8' width='112' height='16' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='9.5' y='10' width='25' height='12' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='37.5' y='10' width='25' height='12' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='65.5' y='10' width='25' height='12' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='93.5' y='10' width='25' height='12' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3C/svg%3E","tv-screen":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='9' width='80' height='14' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='11' y='11' width='74' height='10' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='40' y='7' width='16' height='3' fill='%233C4047' rx='1'%3E%3C/rect%3E%3C/svg%3E","desk-phone":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='16' y='18' width='32' height='28' fill='%233C4047' rx='4'%3E%3C/rect%3E%3Crect x='13' y='13' width='38' height='8' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='22' y='26' width='4' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='30' y='26' width='4' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='38' y='26' width='4' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='22' y='33' width='4' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='30' y='33' width='4' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='38' y='33' width='4' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","conference-phone":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Cpath d='M32,14 C40,14 50,24 50,32 C50,40 40,50 32,50 C24,50 14,40 14,32 C14,24 24,14 32,14 Z' fill='%232B2E34'%3E%3C/path%3E%3Ccircle cx='32' cy='14' r='5' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='50' cy='40' r='5' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='14' cy='40' r='5' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='8' fill='%2351565E'%3E%3C/circle%3E%3Ccircle cx='32' cy='24' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","ups":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='20' y='12' width='24' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='24' y='18' width='16' height='8' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='26' y='20' width='12' height='4' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Ccircle cx='24' cy='46' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='40' cy='46' r='2' fill='%23F0A04B'%3E%3C/circle%3E%3C/svg%3E","kiosk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='18' y='16' width='28' height='32' fill='%233C4047' rx='3'%3E%3C/rect%3E%3Crect x='22' y='20' width='20' height='18' fill='%233E84C4' rx='2'%3E%3C/rect%3E%3Crect x='20' y='44' width='24' height='6' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3C/svg%3E","cctv":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='15' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='10' fill='%2351565E'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='5' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='30' cy='30' r='1.6' fill='rgba(255,255,255,0.5)'%3E%3C/circle%3E%3C/svg%3E","charging-station":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='16' y='16' width='32' height='32' fill='%23F4F6F8' rx='4'%3E%3C/rect%3E%3Crect x='20' y='20' width='24' height='9' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Ccircle cx='24' cy='24' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='30' cy='24' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Crect x='22' y='34' width='20' height='8' fill='%23C9CFD6' rx='2'%3E%3C/rect%3E%3Crect x='26' y='36' width='12' height='4' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","bookshelf":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='6' width='112' height='20' fill='%239A6738' rx='3'%3E%3C/rect%3E%3Crect x='11' y='9' width='106' height='14' fill='%237E5430' rx='2'%3E%3C/rect%3E%3Crect x='14' y='10' width='4' height='12' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='19.5' y='10' width='5' height='12' fill='%235DAE5B' rx='1'%3E%3C/rect%3E%3Crect x='26' y='10' width='6' height='12' fill='%2369C6EB' rx='1'%3E%3C/rect%3E%3Crect x='33.5' y='10' width='4' height='12' fill='%23F0A04B' rx='1'%3E%3C/rect%3E%3Crect x='39' y='10' width='5' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='45.5' y='10' width='6' height='12' fill='%237C838D' rx='1'%3E%3C/rect%3E%3Crect x='53' y='10' width='4' height='12' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='58.5' y='10' width='5' height='12' fill='%235DAE5B' rx='1'%3E%3C/rect%3E%3Crect x='65' y='10' width='6' height='12' fill='%2369C6EB' rx='1'%3E%3C/rect%3E%3Crect x='72.5' y='10' width='4' height='12' fill='%23F0A04B' rx='1'%3E%3C/rect%3E%3Crect x='78' y='10' width='5' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='84.5' y='10' width='6' height='12' fill='%237C838D' rx='1'%3E%3C/rect%3E%3Crect x='92' y='10' width='4' height='12' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='97.5' y='10' width='5' height='12' fill='%235DAE5B' rx='1'%3E%3C/rect%3E%3C/svg%3E","cabinet":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='14' y='12' width='36' height='40' fill='%23AEB4BC' rx='3'%3E%3C/rect%3E%3Crect x='18' y='16' width='28' height='9' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='28' y='19' width='8' height='2.5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='18' y='28' width='28' height='9' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='28' y='31' width='8' height='2.5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='18' y='40' width='28' height='9' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='28' y='43' width='8' height='2.5' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","supply-cabinet":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='13' y='10' width='38' height='44' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Crect x='16' y='13' width='15' height='38' fill='%23D7A86B' rx='2'%3E%3C/rect%3E%3Crect x='33' y='13' width='15' height='38' fill='%23D7A86B' rx='2'%3E%3C/rect%3E%3Crect x='29' y='30' width='2' height='8' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='33' y='30' width='2' height='8' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","lockers":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='6' width='80' height='20' fill='%2351565E' rx='3'%3E%3C/rect%3E%3Crect x='11' y='9' width='16' height='14' fill='%235E656F' rx='2'%3E%3C/rect%3E%3Crect x='22' y='11' width='2' height='5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='29.5' y='9' width='16' height='14' fill='%235E656F' rx='2'%3E%3C/rect%3E%3Crect x='40.5' y='11' width='2' height='5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='48' y='9' width='16' height='14' fill='%235E656F' rx='2'%3E%3C/rect%3E%3Crect x='59' y='11' width='2' height='5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='66.5' y='9' width='16' height='14' fill='%235E656F' rx='2'%3E%3C/rect%3E%3Crect x='77.5' y='11' width='2' height='5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","storage-shelf":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='7' width='80' height='18' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='11' y='9' width='74' height='14' fill='%23AEB4BC' rx='1'%3E%3C/rect%3E%3Crect x='14' y='11' width='11' height='10' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='28' y='11' width='11' height='10' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='42' y='11' width='11' height='10' fill='%2369C6EB' rx='1'%3E%3C/rect%3E%3Crect x='56' y='11' width='11' height='10' fill='%235DAE5B' rx='1'%3E%3C/rect%3E%3Crect x='70' y='11' width='11' height='10' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3C/svg%3E","credenza":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='7' width='112' height='18' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Crect x='8' y='7' width='112' height='12' fill='%23D7A86B' rx='3'%3E%3C/rect%3E%3Crect x='17' y='12' width='18' height='8' fill='%239E6F38' rx='1'%3E%3C/rect%3E%3Ccircle cx='26' cy='16' r='1.6' fill='%239E6F38'%3E%3C/circle%3E%3Crect x='45' y='12' width='18' height='8' fill='%239E6F38' rx='1'%3E%3C/rect%3E%3Ccircle cx='54' cy='16' r='1.6' fill='%239E6F38'%3E%3C/circle%3E%3Crect x='73' y='12' width='18' height='8' fill='%239E6F38' rx='1'%3E%3C/rect%3E%3Ccircle cx='82' cy='16' r='1.6' fill='%239E6F38'%3E%3C/circle%3E%3Crect x='101' y='12' width='18' height='8' fill='%239E6F38' rx='1'%3E%3C/rect%3E%3Ccircle cx='110' cy='16' r='1.6' fill='%239E6F38'%3E%3C/circle%3E%3C/svg%3E","coat-rack":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='5' fill='%238A9099'%3E%3C/circle%3E%3Crect x='31' y='18' width='2' height='28' fill='%23AEB4BC' rx='1'%3E%3C/rect%3E%3Crect x='18' y='31' width='28' height='2' fill='%23AEB4BC' rx='1'%3E%3C/rect%3E%3Ccircle cx='20' cy='20' r='5' fill='%235E656F'%3E%3C/circle%3E%3Ccircle cx='44' cy='44' r='5' fill='%2351565E'%3E%3C/circle%3E%3Ccircle cx='44' cy='20' r='4' fill='%23E6BE8E'%3E%3C/circle%3E%3C/svg%3E","safe":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='15' y='13' width='34' height='38' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='19' y='17' width='26' height='30' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Ccircle cx='38' cy='32' r='6' fill='%23AEB4BC'%3E%3C/circle%3E%3Ccircle cx='38' cy='32' r='3' fill='%232B2E34'%3E%3C/circle%3E%3Crect x='22' y='30' width='6' height='4' fill='%238A9099' rx='1'%3E%3C/rect%3E%3C/svg%3E","mail-slots":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='7' width='80' height='18' fill='%23BC8A4E' rx='2'%3E%3C/rect%3E%3Crect x='13' y='10' width='11' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='15' y='19' width='7' height='1.5' fill='%2351565E'%3E%3C/rect%3E%3Crect x='28' y='10' width='11' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='30' y='19' width='7' height='1.5' fill='%2351565E'%3E%3C/rect%3E%3Crect x='43' y='10' width='11' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='45' y='19' width='7' height='1.5' fill='%2351565E'%3E%3C/rect%3E%3Crect x='58' y='10' width='11' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='60' y='19' width='7' height='1.5' fill='%2351565E'%3E%3C/rect%3E%3Crect x='73' y='10' width='11' height='12' fill='%23E6BE8E' rx='1'%3E%3C/rect%3E%3Crect x='75' y='19' width='7' height='1.5' fill='%2351565E'%3E%3C/rect%3E%3C/svg%3E","plant":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='19' fill='%23479046'%3E%3C/circle%3E%3Ccircle cx='24' cy='26' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='40' cy='26' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='24' cy='40' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='40' cy='40' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='32' cy='22' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='22' cy='32' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='42' cy='32' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='32' cy='42' r='7' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='8' fill='%23BC8A4E'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='5' fill='%23E6BE8E'%3E%3C/circle%3E%3C/svg%3E","plant-large":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Ccircle cx='32' cy='32' r='21' fill='%235DAE5B'%3E%3C/circle%3E%3Cellipse cx='44' cy='32' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='40.48528137423857' cy='40.48528137423857' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='32' cy='44' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='23.514718625761432' cy='40.48528137423857' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='20' cy='32' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='23.51471862576143' cy='23.514718625761432' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='31.999999999999996' cy='20' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='40.48528137423857' cy='23.51471862576143' rx='5' ry='9' fill='%237BC479'%3E%3C/ellipse%3E%3Ccircle cx='32' cy='32' r='9' fill='%239A6738'%3E%3C/circle%3E%3Ccircle cx='32' cy='32' r='5' fill='%237E5430'%3E%3C/circle%3E%3C/svg%3E","plant-floor":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Cellipse cx='45' cy='32' rx='4' ry='11' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='42.517220926874316' cy='39.64120827980215' rx='4' ry='11' fill='%235DAE5B'%3E%3C/ellipse%3E%3Cellipse cx='36.017220926874316' cy='44.363734711837' rx='4' ry='11' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='27.982779073125684' cy='44.363734711837' rx='4' ry='11' fill='%235DAE5B'%3E%3C/ellipse%3E%3Cellipse cx='21.482779073125684' cy='39.64120827980215' rx='4' ry='11' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='19' cy='32' rx='4' ry='11' fill='%235DAE5B'%3E%3C/ellipse%3E%3Cellipse cx='21.482779073125684' cy='24.35879172019785' rx='4' ry='11' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='27.98277907312568' cy='19.636265288163003' rx='4' ry='11' fill='%235DAE5B'%3E%3C/ellipse%3E%3Cellipse cx='36.017220926874316' cy='19.636265288163003' rx='4' ry='11' fill='%237BC479'%3E%3C/ellipse%3E%3Cellipse cx='42.517220926874316' cy='24.358791720197846' rx='4' ry='11' fill='%235DAE5B'%3E%3C/ellipse%3E%3Ccircle cx='32' cy='32' r='22' fill='%23479046' opacity='0.0'%3E%3C/circle%3E%3Crect x='24' y='40' width='16' height='12' fill='%233C4047' rx='2'%3E%3C/rect%3E%3Crect x='24' y='40' width='16' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","desk-plant":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32'%3E%3Ccircle cx='16' cy='15' r='9' fill='%23479046'%3E%3C/circle%3E%3Ccircle cx='13' cy='13' r='4' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='19' cy='13' r='4' fill='%237BC479'%3E%3C/circle%3E%3Ccircle cx='16' cy='17' r='4' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='16' cy='16' r='5' fill='%239A6738'%3E%3C/circle%3E%3Crect x='11' y='18' width='10' height='8' fill='%23BC8A4E' rx='2'%3E%3C/rect%3E%3C/svg%3E","planter-divider":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='8' width='112' height='16' fill='%239A6738' rx='3'%3E%3C/rect%3E%3Crect x='10' y='9' width='108' height='5' fill='%237E5430' rx='2'%3E%3C/rect%3E%3Ccircle cx='16' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='28' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='40' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='52' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='64' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='76' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='88' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='100' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='112' cy='11' r='5' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","rug":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 96' width='128' height='96'%3E%3Crect x='12' y='14' width='104' height='68' fill='%23F0A04B' rx='4'%3E%3C/rect%3E%3Crect x='20' y='22' width='88' height='52' fill='%23E6BE8E' rx='3'%3E%3C/rect%3E%3Crect x='28' y='30' width='72' height='36' fill='%23F0A04B' rx='2'%3E%3C/rect%3E%3Crect x='14' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='14' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='20' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='20' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='26' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='26' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='32' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='32' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='38' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='38' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='44' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='44' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='50' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='50' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='56' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='56' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='62' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='62' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='68' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='68' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='74' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='74' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='80' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='80' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='86' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='86' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='92' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='92' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='98' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='98' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='104' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='104' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='110' y='8' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3Crect x='110' y='82' width='3' height='6' fill='%23BC8A4E' rx='1'%3E%3C/rect%3E%3C/svg%3E","clock":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32'%3E%3Ccircle cx='16' cy='16' r='13' fill='%23F4F6F8'%3E%3C/circle%3E%3Ccircle cx='16' cy='16' r='13' fill='none' stroke='%23C9CFD6' stroke-width='1.5'%3E%3C/circle%3E%3Crect x='15.2' y='9' width='1.6' height='8' fill='%233C4047' rx='1'%3E%3C/rect%3E%3Crect x='16' y='15' width='7' height='1.6' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Ccircle cx='16' cy='16' r='1.6' fill='%23E2574C'%3E%3C/circle%3E%3C/svg%3E","partition":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='11' width='112' height='9' fill='%237C838D' rx='3'%3E%3C/rect%3E%3Crect x='8' y='11' width='112' height='3' fill='%235E656F' rx='2'%3E%3C/rect%3E%3Crect x='10' y='20' width='5' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='113' y='20' width='5' height='4' fill='%2351565E' rx='1'%3E%3C/rect%3E%3C/svg%3E","glass-partition":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 32' width='128' height='32'%3E%3Crect x='8' y='12' width='112' height='7' fill='rgba(120,185,215,0.4)' rx='1'%3E%3C/rect%3E%3Crect x='8' y='11' width='4' height='10' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='60' y='11' width='4' height='10' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='116' y='11' width='4' height='10' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='8' y='12' width='112' height='2' fill='rgba(255,255,255,0.4)'%3E%3C/rect%3E%3C/svg%3E","acoustic-panel":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 32' width='64' height='32'%3E%3Crect x='10' y='9' width='44' height='14' fill='%235E656F' rx='3'%3E%3C/rect%3E%3Crect x='14' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='19' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='24' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='29' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='34' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='39' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='44' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='49' y='11' width='2' height='10' fill='%23464C54' rx='1'%3E%3C/rect%3E%3C/svg%3E","water-cooler":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='16' y='16' width='32' height='34' fill='%23E0E5EA' rx='5'%3E%3C/rect%3E%3Crect x='16' y='16' width='32' height='34' fill='none' rx='5' stroke='%23C9CFD6' stroke-width='1.3'%3E%3C/rect%3E%3Ccircle cx='32' cy='29' r='13' fill='%23A6E0F4'%3E%3C/circle%3E%3Ccircle cx='32' cy='29' r='13' fill='none' stroke='%2369C6EB' stroke-width='1.4'%3E%3C/circle%3E%3Ccircle cx='32' cy='29' r='8.5' fill='%2369C6EB'%3E%3C/circle%3E%3Cellipse cx='27.5' cy='25.5' rx='2.6' ry='3.6' fill='rgba(255,255,255,0.5)'%3E%3C/ellipse%3E%3Ccircle cx='32' cy='29' r='3.2' fill='%238A9099'%3E%3C/circle%3E%3Crect x='26.6' y='44' width='3.6' height='5.4' fill='%233BA6D4' rx='1.2'%3E%3C/rect%3E%3Crect x='33.8' y='44' width='3.6' height='5.4' fill='%23E2574C' rx='1.2'%3E%3C/rect%3E%3Crect x='23' y='49.5' width='18' height='3' fill='%23C9CFD6' rx='1.2'%3E%3C/rect%3E%3C/svg%3E","vending-machine":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='13' y='10' width='38' height='44' fill='%2351565E' rx='3'%3E%3C/rect%3E%3Crect x='17' y='13' width='21' height='33' fill='rgba(120,185,215,0.4)' rx='2'%3E%3C/rect%3E%3Crect x='19' y='17' width='17' height='4' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='19' y='23' width='17' height='4' fill='%23F0A04B' rx='1'%3E%3C/rect%3E%3Crect x='19' y='29' width='17' height='4' fill='%2369C6EB' rx='1'%3E%3C/rect%3E%3Crect x='40' y='15' width='8' height='16' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='40' y='40' width='8' height='8' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","coffee-machine":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='16' y='12' width='32' height='40' fill='%232B2E34' rx='3'%3E%3C/rect%3E%3Crect x='19' y='14' width='26' height='9' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Ccircle cx='23' cy='18' r='2' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='29' cy='18' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Crect x='26' y='30' width='12' height='7' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='28' y='37' width='3' height='5' fill='%23AEB4BC' rx='1'%3E%3C/rect%3E%3Crect x='33' y='37' width='3' height='5' fill='%23AEB4BC' rx='1'%3E%3C/rect%3E%3Crect x='25' y='45' width='14' height='5' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3C/svg%3E","microwave":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 32' width='64' height='32'%3E%3Crect x='8' y='8' width='48' height='16' fill='%2351565E' rx='3'%3E%3C/rect%3E%3Crect x='11' y='10' width='28' height='12' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='13' y='12' width='24' height='8' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='42' y='11' width='11' height='3' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='42' y='16' width='11' height='5' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3C/svg%3E","fridge":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='16' y='10' width='32' height='44' fill='%23F4F6F8' rx='4'%3E%3C/rect%3E%3Crect x='16' y='10' width='32' height='44' fill='none' rx='4' stroke='%23C9CFD6' stroke-width='1.5'%3E%3C/rect%3E%3Crect x='18' y='30' width='28' height='1.6' fill='%23C9CFD6'%3E%3C/rect%3E%3Crect x='20' y='16' width='3' height='10' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='20' y='36' width='3' height='10' fill='%238A9099' rx='2'%3E%3C/rect%3E%3C/svg%3E","trash-bin":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32'%3E%3Crect x='2.2' y='14.3' width='3.8' height='4.4' fill='%235E656F' rx='1.6'%3E%3C/rect%3E%3Crect x='26' y='14.3' width='3.8' height='4.4' fill='%235E656F' rx='1.6'%3E%3C/rect%3E%3Ccircle cx='16' cy='16.5' r='12' fill='%235E656F'%3E%3C/circle%3E%3Ccircle cx='16' cy='16.5' r='12' fill='none' stroke='%23464C54' stroke-width='1.3'%3E%3C/circle%3E%3Crect x='26.5' y='14.5' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='24.399186938124423' y='20.965637775217203' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='18.899186938124423' y='24.96162167924669' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='12.100813061875579' y='24.96162167924669' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='6.600813061875579' y='20.965637775217207' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='4.5' y='14.5' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='6.600813061875577' y='8.034362224782797' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='12.100813061875577' y='4.038378320753312' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='18.89918693812442' y='4.03837832075331' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Crect x='24.399186938124423' y='8.034362224782793' width='1' height='4' fill='rgba(0,0,0,0.07)' rx='0.5'%3E%3C/rect%3E%3Ccircle cx='16' cy='16' r='10.7' fill='%237C838D'%3E%3C/circle%3E%3Ccircle cx='16' cy='16' r='8.1' fill='%233C4047'%3E%3C/circle%3E%3Ccircle cx='16' cy='16' r='8.1' fill='none' stroke='%238A9099' stroke-width='1.3'%3E%3C/circle%3E%3Ccircle cx='13.6' cy='14.6' r='3' fill='%23F4F6F8'%3E%3C/circle%3E%3Ccircle cx='18.4' cy='16.6' r='2.7' fill='%23E0E5EA'%3E%3C/circle%3E%3Ccircle cx='15.6' cy='18.6' r='2.3' fill='%23C9CFD6'%3E%3C/circle%3E%3C/svg%3E","recycling-bins":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 32' width='64' height='32'%3E%3Crect x='9' y='11' width='13' height='14' fill='%235DAE5B' rx='3'%3E%3C/rect%3E%3Crect x='9' y='8.6' width='13' height='4.4' fill='%23479046' rx='2.5'%3E%3C/rect%3E%3Crect x='12' y='9.2' width='7' height='1.7' fill='rgba(0,0,0,0.22)' rx='1'%3E%3C/rect%3E%3Ccircle cx='15.5' cy='18.5' r='3.1' fill='rgba(255,255,255,0.92)'%3E%3C/circle%3E%3Cpolygon points='15.5,16.1 17.5,19.6 13.5,19.6' fill='%235DAE5B'%3E%3C/polygon%3E%3Crect x='26' y='11' width='13' height='14' fill='%2369C6EB' rx='3'%3E%3C/rect%3E%3Crect x='26' y='8.6' width='13' height='4.4' fill='%233BA6D4' rx='2.5'%3E%3C/rect%3E%3Crect x='29' y='9.2' width='7' height='1.7' fill='rgba(0,0,0,0.22)' rx='1'%3E%3C/rect%3E%3Ccircle cx='32.5' cy='18.5' r='3.1' fill='rgba(255,255,255,0.92)'%3E%3C/circle%3E%3Cpolygon points='32.5,16.1 34.5,19.6 30.5,19.6' fill='%2369C6EB'%3E%3C/polygon%3E%3Crect x='43' y='11' width='13' height='14' fill='%23F2C24B' rx='3'%3E%3C/rect%3E%3Crect x='43' y='8.6' width='13' height='4.4' fill='%23D9A93B' rx='2.5'%3E%3C/rect%3E%3Crect x='46' y='9.2' width='7' height='1.7' fill='rgba(0,0,0,0.22)' rx='1'%3E%3C/rect%3E%3Ccircle cx='49.5' cy='18.5' r='3.1' fill='rgba(255,255,255,0.92)'%3E%3C/circle%3E%3Cpolygon points='49.5,16.1 51.5,19.6 47.5,19.6' fill='%23F2C24B'%3E%3C/polygon%3E%3C/svg%3E","fire-extinguisher":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32'%3E%3Cpath d='M20,9.5 C27,11.5 27,20 21,24 C18.5,26 15.5,26 14,25.2' fill='none' stroke='%232B2E34' stroke-width='2.2' stroke-linecap='round'%3E%3C/path%3E%3Crect x='11' y='22.6' width='4.2' height='3.6' fill='%233C4047' rx='1.2'%3E%3C/rect%3E%3Ccircle cx='16' cy='18' r='8.7' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='16' cy='18' r='8.7' fill='none' stroke='%23C4453B' stroke-width='1.3'%3E%3C/circle%3E%3Cellipse cx='12.8' cy='15.4' rx='2.3' ry='3.6' fill='rgba(255,255,255,0.30)'%3E%3C/ellipse%3E%3Crect x='10' y='16.6' width='12' height='4.4' fill='rgba(255,255,255,0.9)' rx='1'%3E%3C/rect%3E%3Crect x='11.4' y='17.6' width='5.5' height='1' fill='%23C4453B'%3E%3C/rect%3E%3Crect x='12.5' y='5.4' width='7' height='7.2' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='9.3' y='4.6' width='8' height='2.4' fill='%233C4047' rx='1.2'%3E%3C/rect%3E%3Crect x='9.3' y='7.6' width='8' height='2.4' fill='%2351565E' rx='1.2'%3E%3C/rect%3E%3Ccircle cx='22.7' cy='8.4' r='2.8' fill='%23F4F6F8'%3E%3C/circle%3E%3Ccircle cx='22.7' cy='8.4' r='2.8' fill='none' stroke='%239AA0A8' stroke-width='0.9'%3E%3C/circle%3E%3Ccircle cx='22.7' cy='8.4' r='0.9' fill='%23E2574C'%3E%3C/circle%3E%3C/svg%3E","first-aid":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32'%3E%3Crect x='5' y='8' width='22' height='16' fill='%23F4F6F8' rx='2'%3E%3C/rect%3E%3Crect x='5' y='8' width='22' height='16' fill='none' rx='2' stroke='%23C9CFD6' stroke-width='1.5'%3E%3C/rect%3E%3Crect x='14' y='12' width='4' height='8' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3Crect x='12' y='14' width='8' height='4' fill='%23E2574C' rx='1'%3E%3C/rect%3E%3C/svg%3E","reception-desk":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 160 64' width='160' height='64'%3E%3Cpath d='M16,52 Q16,18 80,18 Q144,18 144,52 Z' fill='%23BC8A4E'%3E%3C/path%3E%3Cpath d='M24,52 Q24,26 80,26 Q136,26 136,52 Z' fill='%23D7A86B'%3E%3C/path%3E%3Crect x='64' y='40' width='32' height='12' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='64' y='40' width='32' height='12' fill='rgba(255,255,255,0.12)' rx='2'%3E%3C/rect%3E%3C/svg%3E","phone-booth":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='12' y='12' width='40' height='40' fill='%233C4047' rx='8'%3E%3C/rect%3E%3Crect x='17' y='17' width='30' height='30' fill='%2351565E' rx='6'%3E%3C/rect%3E%3Crect x='17' y='30' width='30' height='4' fill='%232B2E34' rx='1'%3E%3C/rect%3E%3Crect x='38' y='44' width='12' height='4' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3C/svg%3E","kitchen-counter":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='10' y='12' width='108' height='40' fill='%23E0E5EA' rx='4'%3E%3C/rect%3E%3Crect x='10' y='12' width='108' height='40' fill='none' rx='4' stroke='%23C9CFD6' stroke-width='1.5'%3E%3C/rect%3E%3Ccircle cx='40' cy='32' r='9' fill='%2351565E'%3E%3C/circle%3E%3Ccircle cx='40' cy='32' r='6' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='78' cy='32' r='9' fill='%2351565E'%3E%3C/circle%3E%3Ccircle cx='78' cy='32' r='6' fill='%232B2E34'%3E%3C/circle%3E%3Crect x='96' y='22' width='16' height='20' fill='%233C4047' rx='2'%3E%3C/rect%3E%3C/svg%3E","pantry-counter":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='10' y='12' width='108' height='40' fill='%23D7A86B' rx='4'%3E%3C/rect%3E%3Crect x='10' y='12' width='108' height='8' fill='%23BC8A4E' rx='4'%3E%3C/rect%3E%3Crect x='24' y='24' width='20' height='22' fill='%23F4F6F8' rx='3'%3E%3C/rect%3E%3Crect x='28' y='28' width='12' height='14' fill='%2369C6EB' rx='2'%3E%3C/rect%3E%3Crect x='56' y='22' width='16' height='24' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='60' y='26' width='8' height='6' fill='%2351565E' rx='1'%3E%3C/rect%3E%3Crect x='86' y='24' width='22' height='22' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Crect x='90' y='28' width='14' height='8' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3C/svg%3E","sink":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='14' y='14' width='36' height='36' fill='%23F4F6F8' rx='4'%3E%3C/rect%3E%3Crect x='20' y='22' width='24' height='22' fill='%2369C6EB' rx='4'%3E%3C/rect%3E%3Crect x='20' y='22' width='24' height='22' fill='rgba(255,255,255,0.25)' rx='4'%3E%3C/rect%3E%3Crect x='30' y='16' width='4' height='8' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Ccircle cx='32' cy='18' r='2.5' fill='%238A9099'%3E%3C/circle%3E%3C/svg%3E","cafeteria-table":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 64' width='192' height='64'%3E%3Crect x='8' y='22' width='176' height='20' fill='%23BC8A4E' rx='3'%3E%3C/rect%3E%3Crect x='8' y='22' width='176' height='14' fill='%23D7A86B' rx='3'%3E%3C/rect%3E%3Crect x='8' y='12' width='176' height='7' fill='%237C838D' rx='3'%3E%3C/rect%3E%3Crect x='8' y='45' width='176' height='7' fill='%237C838D' rx='3'%3E%3C/rect%3E%3C/svg%3E","toilet":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 96' width='64' height='96'%3E%3Crect x='18' y='10' width='28' height='16' fill='%23E0E5EA' rx='4'%3E%3C/rect%3E%3Crect x='38' y='14' width='5' height='3' fill='%2369C6EB' rx='1'%3E%3C/rect%3E%3Cellipse cx='32' cy='56' rx='18' ry='26' fill='%23F4F6F8'%3E%3C/ellipse%3E%3Cellipse cx='32' cy='58' rx='11' ry='17' fill='%23E0E5EA'%3E%3C/ellipse%3E%3Ccircle cx='32' cy='58' r='5' fill='%2369C6EB'%3E%3C/circle%3E%3C/svg%3E","urinal":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Cellipse cx='32' cy='30' rx='13' ry='17' fill='%23F4F6F8'%3E%3C/ellipse%3E%3Cellipse cx='32' cy='30' rx='13' ry='17' fill='none'%3E%3C/ellipse%3E%3Cellipse cx='32' cy='32' rx='8' ry='11' fill='%23E0E5EA'%3E%3C/ellipse%3E%3Ccircle cx='32' cy='34' r='4' fill='%2369C6EB'%3E%3C/circle%3E%3Ccircle cx='32' cy='16' r='2.5' fill='%2351565E'%3E%3C/circle%3E%3C/svg%3E","bathtub":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='12' y='14' width='104' height='40' fill='%23F4F6F8' rx='18'%3E%3C/rect%3E%3Crect x='20' y='20' width='88' height='28' fill='%2369C6EB' rx='14'%3E%3C/rect%3E%3Crect x='20' y='20' width='88' height='28' fill='rgba(255,255,255,0.2)' rx='14'%3E%3C/rect%3E%3Ccircle cx='100' cy='34' r='4' fill='%238A9099'%3E%3C/circle%3E%3Crect x='106' y='32' width='6' height='4' fill='%238A9099' rx='1'%3E%3C/rect%3E%3C/svg%3E","shower":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='12' y='12' width='40' height='40' fill='rgba(120,185,215,0.4)' rx='3'%3E%3C/rect%3E%3Crect x='12' y='12' width='40' height='40' fill='none' rx='3' stroke='%239AC4D6' stroke-width='1.5'%3E%3C/rect%3E%3Ccircle cx='20' cy='20' r='5' fill='%23AEB4BC'%3E%3C/circle%3E%3Ccircle cx='20' cy='20' r='2' fill='%233BA6D4'%3E%3C/circle%3E%3Crect x='38' y='40' width='10' height='8' fill='%23C9CFD6' rx='2'%3E%3C/rect%3E%3Ccircle cx='43' cy='44' r='2' fill='%2351565E'%3E%3C/circle%3E%3C/svg%3E","bathroom-sink":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Cellipse cx='32' cy='34' rx='16' ry='14' fill='%23F4F6F8'%3E%3C/ellipse%3E%3Cellipse cx='32' cy='34' rx='16' ry='14' fill='none'%3E%3C/ellipse%3E%3Cellipse cx='32' cy='35' rx='10' ry='8' fill='%23E0E5EA'%3E%3C/ellipse%3E%3Crect x='30' y='18' width='4' height='8' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Ccircle cx='32' cy='18' r='3' fill='%238A9099'%3E%3C/circle%3E%3Ccircle cx='32' cy='38' r='2' fill='%2351565E'%3E%3C/circle%3E%3C/svg%3E","door":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='10' y='28' width='10' height='7' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='44' y='28' width='10' height='7' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='20' y='30' width='4' height='22' fill='%23D7A86B' rx='1'%3E%3C/rect%3E%3Cpath d='M24,52 A28,28 0 0 0 50,30 L48,30 A26,26 0 0 1 24,50 Z' fill='%239E6F38'%3E%3C/path%3E%3C/svg%3E","double-door":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='8' y='28' width='12' height='7' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='108' y='28' width='12' height='7' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='20' y='30' width='4' height='22' fill='%23D7A86B' rx='1'%3E%3C/rect%3E%3Crect x='104' y='30' width='4' height='22' fill='%23D7A86B' rx='1'%3E%3C/rect%3E%3Cpath d='M24,52 A28,28 0 0 0 50,30 L48,30 A26,26 0 0 1 24,50 Z' fill='%239E6F38'%3E%3C/path%3E%3Cpath d='M104,52 A28,28 0 0 1 78,30 L80,30 A26,26 0 0 0 104,50 Z' fill='%239E6F38'%3E%3C/path%3E%3C/svg%3E","glass-door":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='10' y='28' width='10' height='7' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='44' y='28' width='10' height='7' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='20' y='30' width='4' height='22' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Cpath d='M24,52 A28,28 0 0 0 50,30 L48,30 A26,26 0 0 1 24,50 Z' fill='rgba(120,185,215,0.4)'%3E%3C/path%3E%3C/svg%3E","sliding-door":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 32' width='96' height='32'%3E%3Crect x='8' y='11' width='80' height='4' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='12' y='16' width='38' height='8' fill='rgba(120,185,215,0.4)' rx='1'%3E%3C/rect%3E%3Crect x='46' y='16' width='38' height='8' fill='rgba(120,185,215,0.4)' rx='1'%3E%3C/rect%3E%3Crect x='46' y='16' width='38' height='2' fill='rgba(255,255,255,0.4)'%3E%3C/rect%3E%3C/svg%3E","window":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 32' width='64' height='32'%3E%3Crect x='8' y='12' width='48' height='8' fill='%23464C54' rx='1'%3E%3C/rect%3E%3Crect x='10' y='14' width='44' height='4' fill='rgba(120,185,215,0.4)'%3E%3C/rect%3E%3Crect x='31' y='12' width='2' height='8' fill='%235E656F'%3E%3C/rect%3E%3C/svg%3E","stairs":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 128' width='64' height='128'%3E%3Crect x='12' y='10' width='40' height='108' fill='%23E0E5EA' rx='2'%3E%3C/rect%3E%3Crect x='12' y='12' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='25' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='38' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='51' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='64' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='77' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='90' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Crect x='12' y='103' width='40' height='2.5' fill='%238A9099'%3E%3C/rect%3E%3Cpolygon points='28,40 36,40 32,48' fill='%2351565E'%3E%3C/polygon%3E%3C/svg%3E","elevator":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 96 96' width='96' height='96'%3E%3Crect x='12' y='12' width='72' height='72' fill='%23AEB4BC' rx='2'%3E%3C/rect%3E%3Crect x='16' y='16' width='64' height='64' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Crect x='46' y='16' width='4' height='64' fill='%2351565E'%3E%3C/rect%3E%3Crect x='20' y='40' width='6' height='16' fill='%233C4047' rx='2'%3E%3C/rect%3E%3Ccircle cx='23' cy='36' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","escalator":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 128' width='64' height='128'%3E%3Crect x='12' y='10' width='40' height='108' fill='%238A9099' rx='2'%3E%3C/rect%3E%3Crect x='16' y='14' width='32' height='100' fill='%23AEB4BC' rx='1'%3E%3C/rect%3E%3Crect x='16' y='18' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Crect x='16' y='32' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Crect x='16' y='46' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Crect x='16' y='60' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Crect x='16' y='74' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Crect x='16' y='88' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Crect x='16' y='102' width='32' height='3' fill='%2351565E'%3E%3C/rect%3E%3Cpolygon points='28,44 36,44 32,52' fill='%232B2E34'%3E%3C/polygon%3E%3C/svg%3E","column":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32' width='32' height='32'%3E%3Ccircle cx='16' cy='16' r='12' fill='%23E0E5EA'%3E%3C/circle%3E%3Ccircle cx='16' cy='16' r='12' fill='none' stroke='%23C9CFD6' stroke-width='1.5'%3E%3C/circle%3E%3Ccircle cx='16' cy='16' r='8' fill='%23F4F6F8'%3E%3C/circle%3E%3C/svg%3E","turnstile":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64' width='64' height='64'%3E%3Crect x='12' y='16' width='12' height='32' fill='%23AEB4BC' rx='3'%3E%3C/rect%3E%3Crect x='40' y='16' width='12' height='32' fill='%23AEB4BC' rx='3'%3E%3C/rect%3E%3Crect x='24' y='29' width='16' height='6' fill='%2351565E' rx='2'%3E%3C/rect%3E%3Ccircle cx='18' cy='20' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3Ccircle cx='46' cy='20' r='2' fill='%235DAE5B'%3E%3C/circle%3E%3C/svg%3E","nap-pod":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='8' y='14' width='112' height='36' fill='%2351565E' rx='18'%3E%3C/rect%3E%3Crect x='8' y='14' width='112' height='36' fill='none' rx='18' stroke='%233C4047' stroke-width='2'%3E%3C/rect%3E%3Crect x='72' y='18' width='42' height='28' fill='%232B2E34' rx='14'%3E%3C/rect%3E%3Crect x='16' y='22' width='20' height='20' fill='%23F4F6F8' rx='6'%3E%3C/rect%3E%3C/svg%3E","ping-pong":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 96' width='192' height='96'%3E%3Crect x='16' y='16' width='160' height='64' fill='%23479046' rx='3'%3E%3C/rect%3E%3Crect x='20' y='20' width='152' height='56' fill='%235DAE5B' rx='2'%3E%3C/rect%3E%3Crect x='94' y='18' width='4' height='60' fill='%23F4F6F8' rx='1'%3E%3C/rect%3E%3Crect x='20' y='46' width='152' height='1.6' fill='%23F4F6F8'%3E%3C/rect%3E%3Cpolygon points='40,40 56,40 48,56' fill='%23E2574C'%3E%3C/polygon%3E%3Cpolygon points='152,40 136,40 144,56' fill='%232B2E34'%3E%3C/polygon%3E%3C/svg%3E","foosball":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 128 64' width='128' height='64'%3E%3Crect x='12' y='14' width='104' height='40' fill='%23479046' rx='3'%3E%3C/rect%3E%3Crect x='16' y='18' width='96' height='32' fill='%235DAE5B' rx='2'%3E%3C/rect%3E%3Crect x='30' y='10' width='3' height='48' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Ccircle cx='31.5' cy='24' r='3' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='31.5' cy='44' r='3' fill='%233C4047'%3E%3C/circle%3E%3Crect x='48' y='10' width='3' height='48' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Ccircle cx='49.5' cy='24' r='3' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='49.5' cy='44' r='3' fill='%233C4047'%3E%3C/circle%3E%3Crect x='66' y='10' width='3' height='48' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Ccircle cx='67.5' cy='24' r='3' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='67.5' cy='44' r='3' fill='%233C4047'%3E%3C/circle%3E%3Crect x='84' y='10' width='3' height='48' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Ccircle cx='85.5' cy='24' r='3' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='85.5' cy='44' r='3' fill='%233C4047'%3E%3C/circle%3E%3Crect x='102' y='10' width='3' height='48' fill='%238A9099' rx='1'%3E%3C/rect%3E%3Ccircle cx='103.5' cy='24' r='3' fill='%23E2574C'%3E%3C/circle%3E%3Ccircle cx='103.5' cy='44' r='3' fill='%233C4047'%3E%3C/circle%3E%3C/svg%3E","pool-table":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 192 96' width='192' height='96'%3E%3Crect x='12' y='12' width='168' height='72' fill='%239A6738' rx='4'%3E%3C/rect%3E%3Crect x='20' y='20' width='152' height='56' fill='%23479046' rx='3'%3E%3C/rect%3E%3Crect x='24' y='24' width='144' height='48' fill='%235DAE5B' rx='2'%3E%3C/rect%3E%3Ccircle cx='26' cy='26' r='4' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='96' cy='24' r='4' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='166' cy='26' r='4' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='26' cy='70' r='4' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='96' cy='72' r='4' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='166' cy='70' r='4' fill='%232B2E34'%3E%3C/circle%3E%3Ccircle cx='70' cy='48' r='3' fill='%23F4F6F8'%3E%3C/circle%3E%3Ccircle cx='120' cy='48' r='3' fill='%23F2C24B'%3E%3C/circle%3E%3Ccircle cx='126' cy='42' r='3' fill='%23E2574C'%3E%3C/circle%3E%3C/svg%3E","treadmill":"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 128' width='64' height='128'%3E%3Crect x='14' y='20' width='36' height='90' fill='%2351565E' rx='4'%3E%3C/rect%3E%3Crect x='18' y='24' width='28' height='70' fill='%232B2E34' rx='2'%3E%3C/rect%3E%3Crect x='14' y='10' width='36' height='12' fill='%233C4047' rx='3'%3E%3C/rect%3E%3Crect x='20' y='13' width='10' height='6' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3Crect x='34' y='13' width='10' height='6' fill='%233E84C4' rx='1'%3E%3C/rect%3E%3C/svg%3E"};

var _libPickCallback = null;
function openLibraryModal(pickCb){
  _libPickCallback = pickCb || null;
  document.getElementById('olib-overlay').classList.add('open');
  document.getElementById('olib-title').textContent = pickCb ? '베이스 오브젝트 선택' : '오브젝트 라이브러리';
  document.getElementById('olib-q').value='';
  _olibQ=''; _olibCat='All';
  _renderOlibChips();
  _renderOlibBody();
  setTimeout(function(){document.getElementById('olib-q').focus();},80);
}
function closeLibraryModal(){
  document.getElementById('olib-overlay').classList.remove('open');
  _libPickCallback = null;
}
var _olibCat='All', _olibQ='';
function _renderOlibChips(){
  var el=document.getElementById('olib-chips');
  var cats=[{k:'All',n:'전체'}].concat(OLIB_DATA.cats);
  el.innerHTML='';
  cats.forEach(function(c){
    var b=document.createElement('button');
    b.className='olib-chip'+(c.k===_olibCat?' on':'');
    b.textContent=c.n;
    b.onclick=function(){_olibCat=c.k;_renderOlibChips();_renderOlibBody();};
    el.appendChild(b);
  });
}
function _renderOlibBody(){
  var body=document.getElementById('olib-body');
  var q=_olibQ.trim().toLowerCase();
  var catMap={};OLIB_DATA.cats.forEach(function(c){catMap[c.k]=c.n;});
  var match=function(o){
    return (_olibCat==='All'||o.cat===_olibCat)&&
      (!q||o.name.toLowerCase().includes(q)||o.id.includes(q)||(o.tags||[]).some(function(t){return String(t).toLowerCase().includes(q);}));
  };
  var filtered=OLIB_DATA.objs.filter(match);
  var keys=_olibCat==='All'?OLIB_DATA.cats.map(function(c){return c.k;}):([_olibCat]);
  body.innerHTML='';
  var any=false;
  keys.forEach(function(k){
    var items=filtered.filter(function(o){return o.cat===k;});
    if(!items.length)return;
    any=true;
    var g=document.createElement('div');g.className='olib-grp';
    var hdr=document.createElement('div');hdr.className='olib-grph';
    hdr.innerHTML='<h3>'+(catMap[k]||k)+'</h3><span>'+items.length+'개</span>';
    var grid=document.createElement('div');grid.className='olib-grid';
    items.forEach(function(o){
      var card=document.createElement('div');card.className='olib-card';
      card.innerHTML='<div class="olib-thumb"><img src="'+OLIB_IMG[o.id]+'" alt="'+o.name+'" loading="lazy"></div>'+
        '<div class="olib-row"><span class="olib-nm">'+o.name+'</span><span class="olib-fp">'+o.fp+'</span></div>';
      (function(oid){ card.onclick=function(){ if(_libPickCallback){ var cb=_libPickCallback; closeLibraryModal(); cb(oid); } else { placeLibraryObject(oid); } }; })(o.id);
      grid.appendChild(card);
    });
    g.appendChild(hdr);g.appendChild(grid);
    body.appendChild(g);
  });
  if(!any){body.innerHTML='<div id="olib-empty">검색 결과가 없습니다.</div>';}
}
document.addEventListener('DOMContentLoaded',function(){
  document.getElementById('olib-q').addEventListener('input',function(e){
    _olibQ=e.target.value;_renderOlibBody();
  });
});

var _OLIB_INSETS={};
function _measureSVGInset(svgDataUri){
  try{
    var raw=svgDataUri.replace(/^data:image\/svg\+xml,/,'');
    var svgStr=decodeURIComponent(raw);
    var div=document.createElement('div');
    div.style.cssText='position:fixed;left:-9999px;top:-9999px;width:200px;height:200px;visibility:hidden;';
    div.innerHTML=svgStr;
    document.body.appendChild(div);
    var svgEl=div.querySelector('svg');
    if(!svgEl){document.body.removeChild(div);return null;}
    var vb=svgEl.viewBox.baseVal;
    var bbox=svgEl.getBBox();
    document.body.removeChild(div);
    if(!vb||!vb.width||!vb.height||!bbox.width||!bbox.height) return null;
    return{
      l:Math.max(0,bbox.x/vb.width),
      r:Math.max(0,(vb.width-bbox.x-bbox.width)/vb.width),
      t:Math.max(0,bbox.y/vb.height),
      b:Math.max(0,(vb.height-bbox.y-bbox.height)/vb.height)
    };
  }catch(e){return null;}
}
function _getObjBounds(obj){
  var br=obj.getBoundingRect(true);
  var ins=obj._contentInset;
  if(!ins) return br;
  return{
    left:  br.left  +br.width *ins.l,
    top:   br.top   +br.height*ins.t,
    width: br.width *(1-ins.l-ins.r),
    height:br.height*(1-ins.t-ins.b)
  };
}

function placeLibraryObject(id){
  var def=OLIB_DATA.objs.find(function(o){return o.id===id;});
  if(!def)return;
  var svgStr=OLIB_IMG[id];
  if(!svgStr)return;
  var tile=OLIB_DATA.tile;
  var parts=def.fp.split('×');
  var targetW=parseInt(parts[0])*tile;
  var targetH=parseInt(parts[1])*tile;
  if(pxPerM){targetW=Math.max(20,Math.round(parseInt(parts[0])*0.5*pxPerM));targetH=Math.max(12,Math.round(parseInt(parts[1])*0.5*pxPerM));}
  if(!_OLIB_INSETS[id]) _OLIB_INSETS[id]=_measureSVGInset(svgStr);
  fabric.loadSVGFromURL(svgStr,function(objects,options){
    var shape=fabric.util.groupSVGElements(objects,options);
    var vp=cv.viewportTransform;
    var cx=(cW/2-vp[4])/vp[0];
    var cy=(cH/2-vp[5])/vp[3];
    var _sn=(_placeStagger%6)*GRID;_placeStagger++;
    var pfx=id.toUpperCase().replace(/-/g,'_');
    furnitureCnt++;
    shape.set({
      left:Math.round(cx/GRID)*GRID+_sn,
      top:Math.round(cy/GRID)*GRID+_sn,
      originX:'center',originY:'center',
      scaleX:targetW/shape.width,
      scaleY:targetH/shape.height,
      _tool:'furniture',_objDef:id,
      _id:pfx+'-'+String(furnitureCnt).padStart(2,'0'),
      _name:def.name,
      _fieldDefs:[],_fieldValues:{},
      _contentInset:_OLIB_INSETS[id]||null
    });
    cv.add(shape);
    shape._sectionId = _findSectionForObj(shape);
    cv.setActiveObject(shape);cv.renderAll();
    closeLibraryModal();updatePanel();countUp();debouncePushHistory();
    addRecentObj(id);
  });
}

// ── Init ──────────────────────────────────────────────────
setTool('select');
// Initial history snapshot
pushHistory();
// Initial zoom display
updateZoomDisplay();
</script>

<div id="ex-loupe"><canvas id="ex-loupe-cv" width="120" height="120"></canvas></div>

<!-- ── Object Library Modal ───────────────────────────────── -->
<div id="olib-overlay" onclick="if(event.target===this)closeLibraryModal()">
  <div id="olib-panel">
    <div id="olib-head">
      <div id="olib-title-row">
        <span id="olib-title">오브젝트 라이브러리</span>
        <button id="olib-close" onclick="closeLibraryModal()">✕</button>
      </div>
      <div id="olib-search">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><circle cx="11" cy="11" r="7"/><line x1="16.5" y1="16.5" x2="22" y2="22"/></svg>
        <input id="olib-q" type="text" placeholder="검색 — 책상, sofa, server ...">
      </div>
      <div id="olib-chips"></div>
    </div>
    <div id="olib-body"></div>
  </div>
</div>
</body>
</html>

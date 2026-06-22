<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover">
<meta name="_csrf" content="${_csrf.token}"/>
<meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>스마트오피스 예약</title>
<script src="/sample/fabric.min.js"></script>
<style>
:root {
  --bg:     #EEF2F7;
  --sf:     #FFFFFF;
  --sf2:    #F8FAFC;
  --br:     #E2E8F0;
  --br2:    #CBD5E1;
  --t1:     #0F172A;
  --t2:     #475569;
  --t3:     #94A3B8;
  --ac:     #4F46E5;
  --ac-lt:  #EEF2FF;
  --ac-md:  #A5B4FC;
  --ok:     #059669;
  --ok-lt:  #D1FAE5;
  --no:     #DC2626;
  --no-lt:  #FEE2E2;
  --top:    #0F172A;
}
*, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
body {
  font-family: -apple-system,'Pretendard','Inter','Malgun Gothic',sans-serif;
  background: var(--bg);
  color: var(--t1);
  height: 100vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
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
  border-bottom: 1px solid #1E293B;
}
.tb-brand {
  display: flex;
  align-items: center;
  gap: 9px;
  color: #F1F5F9;
  font-size: 14px;
  font-weight: 700;
  letter-spacing: -.02em;
  flex-shrink: 0;
}
.tb-brand-icon {
  width: 30px; height: 30px;
  background: var(--ac);
  border-radius: 8px;
  display: flex; align-items: center; justify-content: center;
  font-size: 15px;
  box-shadow: 0 2px 8px rgba(79,70,229,.4);
}
.tb-div {
  width: 1px; height: 22px;
  background: #1E293B;
  flex-shrink: 0;
}
.tb-controls { display: flex; align-items: center; gap: 16px; }
.tb-ctrl { display: flex; flex-direction: column; gap: 2px; }
.tb-lbl {
  font-size: 10px;
  color: #475569;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: .06em;
}
.tb-sel, .tb-date {
  background: #1E293B;
  border: 1px solid #334155;
  color: #E2E8F0;
  font-size: 13px;
  font-weight: 500;
  padding: 5px 10px;
  border-radius: 8px;
  outline: none;
  cursor: pointer;
  transition: border-color .15s;
}
.tb-sel:hover, .tb-date:hover { border-color: #475569; }
.tb-sel:focus, .tb-date:focus { border-color: var(--ac); }
.tb-sel { min-width: 160px; }
.tb-date { width: 140px; color-scheme: dark; }
.tb-spacer { flex: 1; }
.tb-cal-btn {
  display: flex; align-items: center; gap: 6px;
  padding: 6px 14px; border: 1px solid #334155; border-radius: 8px;
  background: transparent; color: #CBD5E1; font-size: 13px; font-weight: 500;
  cursor: pointer; transition: all .15s;
}
.tb-cal-btn:hover { background: #1E293B; border-color: #4F46E5; color: #A5B4FC; }

/* ── Workspace ── */
.workspace { flex: 1; display: flex; overflow: hidden; }

/* ── Canvas ── */
.view-canvas {
  flex: 1;
  background: #E0E8F4;
  background-image: radial-gradient(circle, #C8D5E8 1px, transparent 1px);
  background-size: 22px 22px;
  position: relative;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.cv-empty {
  text-align: center;
  color: var(--t3);
  line-height: 2.2;
  font-size: 13px;
  user-select: none;
}
.cv-empty-icon { font-size: 48px; opacity: .2; margin-bottom: 6px; }
.cv-hint {
  position: absolute;
  bottom: 18px; left: 50%;
  transform: translateX(-50%);
  background: rgba(15,23,42,.82);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  color: #E2E8F0;
  font-size: 12px; font-weight: 500;
  padding: 7px 18px;
  border-radius: 24px;
  pointer-events: none;
  transition: opacity .6s;
  white-space: nowrap;
}

/* ── Panel ── */
.panel {
  width: 308px;
  flex-shrink: 0;
  background: var(--sf);
  border-left: 1px solid var(--br);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  box-shadow: -2px 0 12px rgba(0,0,0,.04);
}
.panel-header {
  padding: 16px 20px 14px;
  border-bottom: 1px solid var(--br);
  flex-shrink: 0;
}
.ph-title { font-size: 13px; font-weight: 700; color: var(--t1); }
.ph-sub   { font-size: 11px; color: var(--t3); margin-top: 2px; }

/* Empty */
.panel-empty {
  flex: 1;
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 10px; padding: 40px 20px;
  color: var(--t3); text-align: center;
}
.pe-icon { font-size: 40px; opacity: .2; }
.pe-text { font-size: 12px; line-height: 1.9; }

/* Body */
.panel-body {
  flex: 1;
  overflow-y: auto;
  display: none;
  flex-direction: column;
  scrollbar-width: thin;
  scrollbar-color: var(--br2) transparent;
}

/* Seat info */
.seat-info {
  padding: 16px 20px;
  border-bottom: 1px solid var(--br);
  background: linear-gradient(135deg, var(--ac-lt) 0%, #fff 60%);
}
.seat-badge {
  display: inline-flex; align-items: center;
  padding: 3px 10px;
  border-radius: 20px;
  font-size: 10px; font-weight: 700;
  background: var(--ac);
  color: #fff;
  margin-bottom: 8px;
  letter-spacing: .04em;
}
.seat-name {
  font-size: 20px; font-weight: 800;
  color: var(--t1);
  letter-spacing: -.03em;
  margin-bottom: 10px;
}
.seat-meta { display: flex; gap: 16px; flex-wrap: wrap; }
.sm-item {
  display: flex; align-items: center; gap: 5px;
  font-size: 11px; color: var(--t2);
}
.sm-icon { font-size: 13px; }

/* Day timeline */
.day-timeline-wrap {
  padding: 14px 20px;
  border-bottom: 1px solid var(--br);
}
.sec-label {
  font-size: 10px; font-weight: 700;
  color: var(--t3);
  text-transform: uppercase;
  letter-spacing: .07em;
  margin-bottom: 10px;
}
.day-timeline {
  position: relative;
  height: 10px;
  background: #E2F0E9;
  border-radius: 6px;
  overflow: hidden;
  margin-bottom: 7px;
}
.dt-booked {
  position: absolute; top: 0; height: 100%;
  background: #FCA5A5;
  border-radius: 2px;
}
.dt-selected {
  position: absolute; top: 0; height: 100%;
  background: var(--ac);
  border-radius: 2px;
  opacity: .8;
  transition: left .15s, width .15s;
}
.dt-ticks {
  display: flex;
  justify-content: space-between;
  font-size: 9px; color: var(--t3); font-weight: 600;
}
.bk-list { margin-top: 8px; }
.bk-item {
  display: flex; align-items: center;
  gap: 8px; padding: 5px 0;
  border-bottom: 1px solid var(--br);
  font-size: 11px;
}
.bk-item:last-child { border-bottom: none; }
.bk-dot {
  width: 7px; height: 7px;
  border-radius: 50%; background: #FCA5A5;
  flex-shrink: 0;
}
.bk-time { font-weight: 600; color: var(--t1); }
.bk-who  { color: var(--t3); margin-left: auto; font-size: 10px; }
.bk-empty { font-size: 11px; color: var(--t3); padding: 2px 0; }

/* Time selection */
.time-section {
  padding: 14px 20px;
  border-bottom: 1px solid var(--br);
}

.hour-chips {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 5px;
  margin-bottom: 14px;
}
.hc {
  padding: 8px 4px;
  border-radius: 8px;
  border: 1.5px solid var(--br);
  background: var(--sf2);
  font-size: 11px; font-weight: 500;
  color: var(--t2);
  text-align: center;
  cursor: pointer;
  transition: all .12s;
  line-height: 1;
}
.hc:hover:not(.hc-busy) {
  border-color: var(--ac-md);
  background: var(--ac-lt);
  color: var(--ac);
}
.hc.hc-active {
  background: var(--ac);
  border-color: var(--ac);
  color: #fff;
  font-weight: 700;
  box-shadow: 0 2px 8px rgba(79,70,229,.3);
}
.hc.hc-busy {
  background: #FEF2F2;
  border-color: #FECACA;
  color: #FCA5A5;
  cursor: not-allowed;
  text-decoration: line-through;
  opacity: .6;
}

.dur-chips {
  display: flex; gap: 6px; flex-wrap: wrap;
}
.dc {
  padding: 6px 13px;
  border-radius: 20px;
  border: 1.5px solid var(--br);
  background: var(--sf2);
  font-size: 11px; font-weight: 500;
  color: var(--t2);
  cursor: pointer;
  transition: all .12s;
}
.dc:hover { border-color: var(--ac-md); color: var(--ac); }
.dc.dc-active {
  background: var(--ac-lt);
  border-color: var(--ac);
  color: var(--ac);
  font-weight: 700;
}

/* Status */
.avail-status {
  display: flex; align-items: center; gap: 8px;
  padding: 10px 14px;
  border-radius: 10px;
  font-size: 12px; font-weight: 500;
  margin-top: 12px;
  transition: background .2s, color .2s;
}
.avail-status.as-ok   { background: var(--ok-lt); color: var(--ok); }
.avail-status.as-no   { background: var(--no-lt); color: var(--no); }
.avail-status.as-none { background: var(--sf2);   color: var(--t3); }
.as-dot {
  width: 7px; height: 7px;
  border-radius: 50%; background: currentColor;
  flex-shrink: 0;
}
.as-time { margin-left: auto; font-size: 11px; opacity: .8; font-weight: 600; }

/* Book button */
.btn-area {
  padding: 16px 20px;
  margin-top: auto;
  flex-shrink: 0;
  background: var(--sf);
  border-top: 1px solid var(--br);
}
.btn-book {
  width: 100%;
  padding: 14px;
  background: var(--ac);
  color: #fff;
  border: none;
  border-radius: 12px;
  font-size: 14px; font-weight: 700;
  cursor: pointer;
  transition: all .15s;
  letter-spacing: -.01em;
}
.btn-book:hover:not(:disabled) {
  background: #4338CA;
  transform: translateY(-1px);
  box-shadow: 0 6px 16px rgba(79,70,229,.35);
}
.btn-book:active:not(:disabled) { transform: none; box-shadow: none; }
.btn-book:disabled {
  background: var(--br);
  color: var(--t3);
  cursor: not-allowed;
  box-shadow: none; transform: none;
}

/* Toast */
.toast {
  position: fixed;
  bottom: 28px; left: 50%;
  transform: translateX(-50%) translateY(8px);
  background: #0F172A;
  color: #E2E8F0;
  padding: 10px 22px;
  border-radius: 24px;
  font-size: 13px; font-weight: 500;
  opacity: 0;
  transition: opacity .25s, transform .25s;
  pointer-events: none;
  z-index: 999;
  box-shadow: 0 6px 24px rgba(0,0,0,.25);
  white-space: nowrap;
}
.toast.show { opacity: 1; transform: translateX(-50%) translateY(0); }

/* ── Mobile ── */
.panel-close { display: none; }
.panel-backdrop { display: none; }

@media (max-width: 767px) {
  .topbar { height: auto; flex-wrap: wrap; padding: 10px 14px; gap: 8px; }
  .tb-brand { font-size: 13px; }
  .tb-div { display: none; }
  .tb-controls { width: 100%; gap: 8px; }
  .tb-ctrl { flex: 1; }
  .tb-sel { width: 100%; min-width: 0; }
  .tb-date { width: 100%; }

  .workspace { position: relative; }

  .panel {
    position: fixed; bottom: 0; left: 0; right: 0;
    width: 100%; max-height: 78vh;
    border-left: none;
    border-radius: 22px 22px 0 0;
    box-shadow: 0 -10px 40px rgba(0,0,0,.15);
    transform: translateY(100%);
    transition: transform .3s cubic-bezier(.4,0,.2,1);
    z-index: 200;
  }
  .panel.open { transform: translateY(0); }
  .panel::before {
    content: '';
    display: block;
    width: 36px; height: 4px;
    background: var(--br2);
    border-radius: 2px;
    margin: 13px auto 0;
    flex-shrink: 0;
  }
  .panel-close {
    display: flex; align-items: center; justify-content: center;
    position: absolute; top: 11px; right: 15px;
    width: 28px; height: 28px; border-radius: 50%;
    background: var(--bg); border: none; cursor: pointer;
    font-size: 16px; color: var(--t2); z-index: 1;
  }
  .panel-header { padding: 10px 48px 10px 20px; }
  .btn-area { padding: 14px 20px calc(14px + env(safe-area-inset-bottom)); }
  .toast { bottom: calc(28px + 72vh); }
  .panel-backdrop {
    display: none;
    position: fixed; inset: 0;
    background: rgba(15,23,42,.4);
    z-index: 199;
    opacity: 0; transition: opacity .3s;
    backdrop-filter: blur(3px);
    -webkit-backdrop-filter: blur(3px);
  }
  .panel-backdrop.show { display: block; opacity: 1; }
  .seat-name { font-size: 17px; }
}

/* ── Calendar view ── */
#cal-view { flex: 1; display: flex; flex-direction: column; overflow: hidden; background: var(--bg); }
.cal-subbar {
  display: flex; align-items: center; gap: 8px; flex-wrap: wrap;
  padding: 10px 16px; background: #fff;
  border-bottom: 1px solid var(--br); flex-shrink: 0;
}
.cal-nav-btn {
  width: 28px; height: 28px; border: 1px solid var(--br); border-radius: 6px;
  background: #fff; cursor: pointer; font-size: 16px; color: var(--t2);
  display: flex; align-items: center; justify-content: center; transition: all .15s;
}
.cal-nav-btn:hover { background: var(--ac-lt); border-color: var(--ac); color: var(--ac); }
#cal-date-lbl { font-size: 13px; font-weight: 700; color: var(--t1); min-width: 160px; text-align: center; }
.cal-today-btn {
  padding: 4px 10px; border: 1px solid var(--ac); border-radius: 6px;
  background: var(--ac-lt); color: var(--ac); font-size: 12px; font-weight: 600; cursor: pointer;
}
.cal-today-btn:hover { background: var(--ac); color: #fff; }
#cal-space-cnt { font-size: 11px; color: var(--t3); margin-left: auto; }
.cal-vtabs { display: flex; gap: 2px; background: #F1F5F9; border-radius: 8px; padding: 3px; }
.cal-vbtn {
  padding: 4px 11px; border: none; border-radius: 6px;
  background: transparent; color: var(--t2); font-size: 12px; font-weight: 500; cursor: pointer;
}
.cal-vbtn.active { background: #fff; color: var(--ac); font-weight: 700; box-shadow: 0 1px 3px rgba(0,0,0,.1); }

/* Legend */
.cal-legend {
  display: flex; align-items: center; gap: 14px;
  padding: 6px 16px; background: var(--sf2);
  border-bottom: 1px solid var(--br); font-size: 11px; color: var(--t2); flex-shrink: 0;
}
.cal-leg { display: flex; align-items: center; gap: 5px; }
.cal-leg-dot { width: 10px; height: 10px; border-radius: 3px; }
.cal-leg-dot.avail  { background: #DCFCE7; border: 1px solid #86EFAC; }
.cal-leg-dot.booked { background: var(--no-lt); border: 1px solid #FCA5A5; }
.cal-leg-dot.nowork { background: #F1F5F9; border: 1px solid var(--br2); }

/* Two-section layout */
.cal-main { flex: 1; overflow-y: auto; overflow-x: hidden; }
.cal-section { border-bottom: 4px solid var(--bg); }
.cal-sec-hdr {
  display: flex; align-items: center; gap: 8px;
  padding: 9px 16px; background: #fff;
  border-bottom: 1px solid var(--br);
  font-size: 13px; font-weight: 700; color: var(--t1);
  position: sticky; top: 0; z-index: 5;
}
.cal-sec-sub { font-size: 11px; font-weight: 400; color: var(--t3); }
.cal-sec-body { overflow-x: auto; -webkit-overflow-scrolling: touch; background: var(--bg); }
.cal-empty { padding: 28px; text-align: center; color: var(--t3); font-size: 13px; background: #fff; }

/* Resource table */
.res-tbl { border-collapse: collapse; background: #fff; min-width: 400px; width: 100%; }
.res-tbl th, .res-tbl td { border: 1px solid #E2E8F0; }
.res-tbl .spc-col {
  width: 148px; min-width: 148px; padding: 8px 10px;
  background: #F8FAFC; position: sticky; left: 0; z-index: 4;
  border-right: 2px solid var(--br2);
}
.res-tbl th.spc-col { background: #F1F5F9; font-size: 10px; font-weight: 700; color: var(--t3); text-transform: uppercase; letter-spacing: .05em; padding: 7px 10px; }
.spc-inner { display: flex; align-items: center; gap: 6px; }
.spc-bdg { padding: 2px 6px; border-radius: 4px; font-size: 10px; font-weight: 700; flex-shrink: 0; }
.spc-bdg.desk    { background: var(--ac-lt); color: var(--ac); }
.spc-bdg.meeting { background: #FEF3C7; color: #D97706; }
.spc-nm  { font-size: 12px; font-weight: 600; color: var(--t1); }
.spc-sub { font-size: 10px; color: var(--t3); margin-top: 1px; }
.t-hdr {
  text-align: center; padding: 6px 3px; min-width: 62px;
  background: #F8FAFC; color: var(--t2); font-size: 11px; font-weight: 700; white-space: nowrap;
}
.t-hdr.is-now   { color: var(--ac); background: var(--ac-lt); }
.t-hdr.is-wknd  { color: var(--t3); }
.sl-cell {
  cursor: pointer; height: 44px; min-width: 62px;
  transition: filter .1s;
}
.sl-cell:hover { filter: brightness(.91); }
.sl-cell.avail  { background: #DCFCE7; }
.sl-cell.booked { background: var(--no-lt); }
.sl-cell.nowork { background: #F1F5F9; cursor: default; }
.sl-cell.nowork:hover { filter: none; }
.sl-inn {
  display: flex; align-items: center; justify-content: center; height: 100%;
  font-size: 10px; color: var(--no); font-weight: 600; padding: 0 3px;
  overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.sl-cell.avail .sl-inn { color: var(--ok); }

/* Booking bottom sheet */
.cal-bs-backdrop {
  display: none; position: fixed; inset: 0;
  background: rgba(15,23,42,.45); z-index: 299;
  backdrop-filter: blur(3px);
}
.cal-bs-backdrop.show { display: block; }
.cal-bs {
  position: fixed; bottom: 0; left: 0; right: 0; z-index: 300;
  background: #fff; border-radius: 20px 20px 0 0;
  padding: 0 20px 40px; max-height: 75vh; overflow-y: auto;
  transform: translateY(100%); transition: transform .3s cubic-bezier(.4,0,.2,1);
  box-shadow: 0 -8px 32px rgba(0,0,0,.18);
}
.cal-bs.open { transform: translateY(0); }
.cbs-drag { width: 36px; height: 4px; background: var(--br2); border-radius: 2px; margin: 14px auto 0; }
.cbs-head {
  display: flex; align-items: flex-start; justify-content: space-between;
  padding: 16px 0 14px; border-bottom: 1px solid var(--br);
}
.cbs-title  { font-size: 16px; font-weight: 700; color: var(--t1); }
.cbs-sub    { font-size: 12px; color: var(--t3); margin-top: 3px; }
.cbs-close  { border: none; background: none; font-size: 22px; color: var(--t3); cursor: pointer; line-height: 1; padding: 0; }
.cbs-field  { padding: 14px 0; border-bottom: 1px solid #F1F5F9; display: flex; align-items: center; gap: 12px; }
.cbs-lbl    { font-size: 12px; color: var(--t3); width: 52px; flex-shrink: 0; }
.cbs-val    { font-size: 14px; font-weight: 600; color: var(--t1); }
.cbs-sel {
  padding: 7px 10px; border: 1px solid var(--br); border-radius: 8px;
  font-size: 14px; color: var(--t1); background: #fff; cursor: pointer; outline: none; flex: 1;
}
.cbs-sel:focus { border-color: var(--ac); }
.cbs-sep { font-size: 13px; color: var(--t3); }
.cbs-note {
  flex: 1; padding: 8px 10px; border: 1px solid var(--br); border-radius: 8px;
  font-size: 13px; font-family: inherit; resize: none; outline: none; color: var(--t1);
}
.cbs-note:focus { border-color: var(--ac); }
.cbs-btn {
  display: block; width: 100%; padding: 15px; margin-top: 22px;
  background: var(--ac); color: #fff; border: none; border-radius: 12px;
  font-size: 15px; font-weight: 700; cursor: pointer; transition: opacity .15s;
}
.cbs-btn:hover { opacity: .9; }
.cbs-btn:disabled { background: var(--t3); cursor: default; opacity: 1; }

/* Tooltip */
.cal-tip {
  position: fixed; z-index: 9999; background: #0F172A; color: #fff;
  border-radius: 8px; padding: 10px 14px; font-size: 12px; line-height: 1.6;
  pointer-events: none; opacity: 0; transition: opacity .12s;
  max-width: 220px; box-shadow: 0 6px 20px rgba(0,0,0,.25);
}
.cal-tip.show { opacity: 1; }
.ct-ttl { font-weight: 700; font-size: 13px; margin-bottom: 3px; color: #F1F5F9; }
.ct-row { color: #94A3B8; }
.ct-row b { color: #E2E8F0; }
.ct-ok { color: #86EFAC; font-weight: 700; }

/* Space type tabs */
.cal-type-bar {
  display: flex; background: #fff; border-bottom: 1px solid var(--br); flex-shrink: 0; padding: 0 12px;
}
.cal-type-btn {
  padding: 11px 18px; border: none; background: none;
  font-size: 13px; font-weight: 600; color: var(--t3); cursor: pointer;
  border-bottom: 2px solid transparent; margin-bottom: -1px;
  transition: color .15s, border-color .15s;
}
.cal-type-btn.active { color: var(--ac); border-bottom-color: var(--ac); }
.cal-type-btn:hover:not(.active) { color: var(--t1); }

/* Topbar query */
.tb-query-btn {
  height: 34px; padding: 0 14px; background: var(--ac); color: #fff;
  border: none; border-radius: 8px; font-size: 13px; font-weight: 600;
  cursor: pointer; white-space: nowrap; flex-shrink: 0; transition: opacity .15s;
}
.tb-query-btn:hover { opacity: .88; }
.tb-query-btn:disabled { opacity: .55; cursor: default; }
.tb-clear-btn {
  height: 34px; padding: 0 10px; background: transparent; color: var(--t3);
  border: 1px solid var(--br); border-radius: 8px; font-size: 12px; cursor: pointer; white-space: nowrap;
}
.tb-clear-btn:hover { border-color: var(--no); color: var(--no); }
.tb-time-ctrl { display: flex; align-items: center; gap: 4px; }
.tb-time-ctrl .tb-sel { width: auto; min-width: 70px; }
.tb-sep-lbl { font-size: 12px; color: var(--t3); }

/* Mobile cal */
@media (max-width: 767px) {
  .cal-subbar { padding: 8px 12px; gap: 6px; }
  #cal-date-lbl { min-width: 0; flex: 1; font-size: 12px; }
  #cal-space-cnt { display: none; }
  .res-tbl .spc-col { width: 100px; min-width: 100px; padding: 6px 8px; }
  .spc-nm { font-size: 11px; }
  .spc-bdg { font-size: 9px; padding: 1px 4px; }
  .t-hdr { min-width: 48px; font-size: 10px; }
  .sl-cell { min-width: 48px; }
  #tb-time-ctrl { display: none !important; }
  .tb-query-btn { padding: 0 10px; font-size: 12px; }
}
</style>
</head>
<body>

<div class="topbar">
  <div class="tb-brand">
    스마트오피스
  </div>
  <div class="tb-div"></div>
  <div class="tb-controls">
    <div class="tb-ctrl">
      <div class="tb-lbl">사무실</div>
      <select class="tb-sel" id="layout-sel" onchange="loadLayout(this.value)">
        <option value="">— 선택 —</option>
      </select>
    </div>
    <div class="tb-ctrl">
      <div class="tb-lbl">시작</div>
      <input type="date" class="tb-date" id="tb-date" onchange="onDateChange()">
    </div>
    <span class="tb-sep-lbl">~</span>
    <div class="tb-ctrl">
      <div class="tb-lbl">종료</div>
      <input type="date" class="tb-date" id="tb-end-date">
    </div>
    <div class="tb-ctrl" id="tb-time-ctrl">
      <div class="tb-lbl">시간</div>
      <div style="display:flex;align-items:center;gap:4px">
        <select class="tb-sel" id="tb-qsh" style="min-width:70px"></select>
        <span class="tb-sep-lbl">~</span>
        <select class="tb-sel" id="tb-qeh" style="min-width:70px"></select>
      </div>
    </div>
  </div>
  <div class="tb-spacer"></div>
  <button class="tb-query-btn" id="tb-query-btn" onclick="doQuery()">조회</button>
  <button class="tb-clear-btn" id="tb-clear-btn" onclick="clearQuery()" style="display:none">초기화</button>
  <div style="width:8px;flex-shrink:0"></div>
  <button class="tb-cal-btn" id="view-toggle-btn" onclick="toggleCalView()">리스트 보기</button>
</div>

<div class="panel-backdrop" id="panel-backdrop" onclick="closeSheet()"></div>

<div class="workspace">
  <div class="view-canvas" id="view-canvas">
    <div class="cv-empty" id="cv-empty">
      사무실을 선택하면<br>평면도가 표시됩니다
    </div>
    <canvas id="carea" style="display:none"></canvas>
    <div class="cv-hint" id="cv-hint" style="display:none">예약할 좌석을 클릭하세요</div>
  </div>

  <div class="panel" id="main-panel">
    <button class="panel-close" onclick="closeSheet()">×</button>

    <div class="panel-header">
      <div class="ph-title">좌석 예약</div>
      <div class="ph-sub" id="ph-sub">좌석을 선택해주세요</div>
    </div>

    <div class="panel-empty" id="panel-empty">
      <div class="pe-text">평면도에서<br>좌석을 클릭해 예약하세요</div>
    </div>

    <div class="panel-body" id="panel-body">

      <div class="seat-info">
        <div class="seat-badge" id="seat-badge"></div>
        <div class="seat-name"  id="seat-name"></div>
        <div class="seat-meta">
          <div class="sm-item"><span id="seat-cap"></span></div>
          <div class="sm-item"><span id="seat-dept"></span></div>
        </div>
      </div>

      <div class="day-timeline-wrap" id="day-timeline-wrap">
        <div class="sec-label">당일 예약 현황</div>
        <div class="day-timeline" id="day-timeline"></div>
        <div class="dt-ticks"><span>08:00</span><span>12:00</span><span>16:00</span><span>20:00</span></div>
        <div class="bk-list" id="bk-list"></div>
      </div>

      <div class="time-section">
        <div class="sec-label" style="margin-bottom:10px">시작 시간</div>
        <div class="hour-chips" id="hour-chips"></div>

        <div class="sec-label" style="margin-bottom:8px">이용 시간</div>
        <div class="dur-chips">
          <button class="dc"          data-min="30"  onclick="setDur(30)">30분</button>
          <button class="dc dc-active" data-min="60"  onclick="setDur(60)">1시간</button>
          <button class="dc"          data-min="120" onclick="setDur(120)">2시간</button>
          <button class="dc"          data-min="180" onclick="setDur(180)">3시간</button>
          <button class="dc"          data-min="240" onclick="setDur(240)">4시간</button>
        </div>

        <div class="avail-status as-none" id="avail-status">
          <div class="as-dot"></div>
          <span id="avail-text">시간을 선택해주세요</span>
          <span class="as-time" id="avail-time"></span>
        </div>
      </div>

      <!-- Desk: end date for multi-day booking -->
      <div class="time-section" id="desk-enddate-section" style="display:none">
        <div class="sec-label" style="margin-bottom:8px">종료일</div>
        <input type="date" class="tb-date" id="desk-end-date" style="width:100%;padding:8px 10px;border:1px solid var(--br);border-radius:8px;font-size:13px" onchange="checkDeskAvail()">
      </div>

      <div class="btn-area">
        <button class="btn-book" id="btn-book" disabled onclick="doBook()">예약하기</button>
      </div>
    </div>
  </div>
</div>

<!-- Calendar view (toggled in-place) -->
<div id="cal-view" style="display:none;flex:1;flex-direction:column;overflow:hidden;">
  <div class="cal-type-bar">
    <button class="cal-type-btn active" data-type="MEETING" onclick="setCalSpaceTab('MEETING')">회의실</button>
    <button class="cal-type-btn"        data-type="DESK"    onclick="setCalSpaceTab('DESK')">책상</button>
  </div>
  <div class="cal-subbar">
    <button class="cal-nav-btn" onclick="calMovePrev()">&#8249;</button>
    <span id="cal-date-lbl"></span>
    <button class="cal-nav-btn" onclick="calMoveNext()">&#8250;</button>
    <button class="cal-today-btn" onclick="calGoToday()">오늘</button>
    <span id="cal-space-cnt"></span>
  </div>
  <div class="cal-legend">
    <div class="cal-leg"><div class="cal-leg-dot avail"></div>예약 가능</div>
    <div class="cal-leg"><div class="cal-leg-dot booked"></div>예약됨</div>
    <div class="cal-leg"><div class="cal-leg-dot nowork"></div>비업무</div>
  </div>
  <div class="cal-main" id="cal-main">
    <div class="cal-section" id="cal-sec-meetings">
      <div class="cal-sec-body" id="cal-meetings-body">
        <div class="cal-empty">사무실을 선택하세요</div>
      </div>
    </div>
    <div class="cal-section" id="cal-sec-desks" style="display:none">
      <div class="cal-sec-body" id="cal-desks-body">
        <div class="cal-empty">사무실을 선택하세요</div>
      </div>
    </div>
  </div>
</div>
<div class="cal-tip" id="cal-tip"></div>

<!-- Cal booking bottom sheet -->
<div class="cal-bs-backdrop" id="cal-bs-backdrop" onclick="calCloseSheet()"></div>
<div class="cal-bs" id="cal-bs">
  <div class="cbs-drag"></div>
  <div class="cbs-head">
    <div>
      <div class="cbs-title" id="cbs-title">예약</div>
      <div class="cbs-sub"   id="cbs-sub"></div>
    </div>
    <button class="cbs-close" onclick="calCloseSheet()">&#xd7;</button>
  </div>
  <div class="cbs-field">
    <span class="cbs-lbl" id="cbs-date-lbl">날짜</span>
    <span class="cbs-val" id="cbs-date-val"></span>
  </div>
  <div class="cbs-field" id="cbs-enddate-field" style="display:none">
    <span class="cbs-lbl">종료일</span>
    <input type="date" class="cbs-sel" id="cbs-end-date" style="flex:1">
  </div>
  <div class="cbs-field" id="cbs-time-field">
    <span class="cbs-lbl">시간</span>
    <select class="cbs-sel" id="cbs-sh" onchange="calUpdateEndOpts()"></select>
    <span class="cbs-sep">~</span>
    <select class="cbs-sel" id="cbs-eh"></select>
  </div>
  <div class="cbs-field">
    <span class="cbs-lbl">메모</span>
    <textarea class="cbs-note" id="cbs-note" rows="2" placeholder="선택 사항"></textarea>
  </div>
  <button class="cbs-btn" id="cbs-book-btn" onclick="calDoBook()">예약하기</button>
</div>

<div class="toast" id="toast"></div>

<script>
var csrfToken  = (document.querySelector('meta[name="_csrf"]')  || {}).content || '';
var csrfHeader = (document.querySelector('meta[name="_csrf_header"]') || {}).content || 'X-CSRF-TOKEN';

var cv = null;
var currentLayoutId = null;
var selectedEl      = null;
var selectedEls     = [];   // multi-select desks
var isMultiMode     = false;
var dayBookings     = [];
var selectedHour    = null;
var selectedDur     = 60;

var HOURS = ['08','09','10','11','12','13','14','15','16','17','18','19'];

// ── Init date & time selects ──
(function() {
  var now = new Date();
  var today = now.getFullYear() + '-' + pad(now.getMonth()+1) + '-' + pad(now.getDate());
  document.getElementById('tb-date').value    = today;
  document.getElementById('tb-end-date').value = today;
})();
initTimeSelects();

// ── Layout list ──
fetch('/sample/so/list.jsp')
  .then(function(r){ return r.json(); })
  .then(function(list) {
    var sel = document.getElementById('layout-sel');
    list.forEach(function(item) {
      if (item.error) return;
      var o = document.createElement('option');
      o.value = item.layoutId; o.textContent = item.layoutName;
      sel.appendChild(o);
    });
    var urlId = (location.search.match(/[?&]id=([^&]+)/) || [])[1];
    if (urlId) { sel.value = urlId; loadLayout(urlId); }
    else if (sel.options.length > 1) {
      sel.selectedIndex = 1;
      loadLayout(sel.options[1].value);
    }
  });

// ── Load layout ──
function loadLayout(id) {
  if (!id) return;
  currentLayoutId = id;
  clearSel();
  // Reset query state without side effects
  queryActive = false; queryAvailIds = {}; queryBookedIds = {};
  document.getElementById('tb-clear-btn').style.display = 'none';
  if (calMode) { calLoadAndRender(); return; }
  fetch('/sample/so/get.jsp?id=' + encodeURIComponent(id))
    .then(function(r){ return r.json(); })
    .then(function(data) {
      if (!data.ok) throw new Error(data.error);
      initCanvas(data.layout, data.elements || []);
    })
    .catch(function(e){ showToast('로드 실패: ' + e.message); });
}

// ── Date change ──
function onDateChange() {
  if (selectedEl) loadDayBookings();
  if (queryActive) clearQuery();
  // 회의실 탭이면 종료일 = 시작일 자동 동기화
  if (calSpaceTab === 'MEETING') {
    var ed = document.getElementById('tb-end-date');
    if (ed) ed.value = document.getElementById('tb-date').value;
  }
}

/* ══════════════════════════════════════════
   Calendar / List view  (v3)
══════════════════════════════════════════ */
var calMode       = false;
var calSpaceTab   = 'MEETING'; // 'MEETING' | 'DESK'
var calViewMode   = 'hour';    // 'hour' for MEETING, 'day' for DESK
var calDate       = new Date();
var calSpaces     = [];
var calBookings   = [];
var calBookTarget = null;
var queryActive    = false;
var queryAvailIds  = {};
var queryBookedIds = {};

// ── Toggle ──
function toggleCalView() {
  calMode = !calMode;
  var btn = document.getElementById('view-toggle-btn');
  var ws  = document.querySelector('.workspace');
  var cv2 = document.getElementById('cal-view');
  if (calMode) {
    closeSheet();
    ws.style.display  = 'none';
    cv2.style.display = 'flex';
    btn.textContent   = '지도 보기';
    calDate = new Date();
    calUpdateLabel();
    if (queryActive && calSpaces.length) { calRenderAll(); return; }
    if (currentLayoutId) calLoadAndRender();
  } else {
    calCloseSheet();
    cv2.style.display = 'none';
    ws.style.display  = '';
    btn.textContent   = '리스트 보기';
    if (queryActive) applyMapAvailability();
  }
}

// ── Space type tab ──
function setCalSpaceTab(tab) {
  calSpaceTab = tab;
  calViewMode = tab === 'MEETING' ? 'hour' : 'day';
  document.querySelectorAll('.cal-type-btn').forEach(function(b){
    b.classList.toggle('active', b.dataset.type === tab);
  });
  // 회의실: 시간 선택 표시 + 종료일을 시작일로 자동 동기화
  // 책상: 시간 선택 숨김 + 종료일 자유롭게 설정 가능
  var tc = document.getElementById('tb-time-ctrl');
  if (tc) tc.style.display = tab === 'MEETING' ? '' : 'none';
  if (tab === 'MEETING') {
    // 회의실: 종료일 = 시작일 (동일날)
    var sd = document.getElementById('tb-date').value;
    var ed = document.getElementById('tb-end-date');
    if (ed) ed.value = sd;
  } else {
    // 책상: 종료일 기본값 = 시작일 (비어있으면)
    var sd2 = document.getElementById('tb-date').value;
    var ed2 = document.getElementById('tb-end-date');
    if (ed2 && !ed2.value) ed2.value = sd2;
  }
  calUpdateLabel();
  if (queryActive && calSpaces.length) { calRenderAll(); return; }
  if (currentLayoutId) calLoadAndRender();
}

// ── Date navigation ──
function calMovePrev() { calShift(-1); calUpdateLabel(); if (currentLayoutId) calLoadAndRender(); }
function calMoveNext() { calShift(+1); calUpdateLabel(); if (currentLayoutId) calLoadAndRender(); }
function calGoToday()  { calDate = new Date(); calUpdateLabel(); if (currentLayoutId) calLoadAndRender(); }

function calShift(dir) {
  if (calSpaceTab === 'MEETING') calDate.setDate(calDate.getDate() + dir);
  else                           calDate.setDate(calDate.getDate() + dir * 7);
}

function calUpdateLabel() {
  var d = calDate, lbl = '';
  if (calSpaceTab === 'MEETING') {
    lbl = d.getFullYear() + '. ' + (d.getMonth()+1) + '. ' + d.getDate() + '.';
  } else {
    var end14 = new Date(d); end14.setDate(end14.getDate() + 13);
    lbl = calFmt(d) + ' ~ ' + calFmt(end14);
  }
  document.getElementById('cal-date-lbl').textContent = lbl;
}

// ── Fetch & render ──
function calLoadAndRender() {
  var activeBodyId = calSpaceTab === 'MEETING' ? 'cal-meetings-body' : 'cal-desks-body';
  document.getElementById(activeBodyId).innerHTML = '<div class="cal-empty">불러오는 중...</div>';

  var rng = calRange();
  fetch('/sample/so/bookings.jsp?layout_id=' + encodeURIComponent(currentLayoutId) +
        '&start=' + rng.start + '&end=' + rng.end)
    .then(function(r){ return r.json(); })
    .then(function(data) {
      if (!data.ok) throw new Error(data.error || '오류');
      calSpaces   = data.spaces   || [];
      calBookings = data.bookings || [];
      calRenderAll();
    })
    .catch(function(e) {
      document.getElementById(activeBodyId).innerHTML =
        '<div class="cal-empty" style="color:var(--no)">'+e.message+'</div>';
    });
}

function calRange() {
  var d = calDate;
  if (calSpaceTab === 'MEETING') { var s=calDstr(d); return {start:s, end:s}; }
  // DESK: 14 days
  var e=new Date(d); e.setDate(e.getDate()+13); return {start:calDstr(d), end:calDstr(e)};
}

// ── Column slot generators ──
function calGetSlots() {
  var d = calDate;
  if (calSpaceTab === 'MEETING') return [new Date(d)]; // hourly grid uses slots differently
  var r=[]; for(var i=0;i<14;i++){var dd=new Date(d);dd.setDate(dd.getDate()+i);r.push(dd);} return r;
}

function calRenderAll() {
  var allMeetings = calSpaces.filter(function(s){ return s.type==='MEETING'; });
  var allDesks    = calSpaces.filter(function(s){ return s.type==='DESK'; });
  var meetings = queryActive ? allMeetings.filter(function(s){ return queryAvailIds[s.id]; }) : allMeetings;
  var desks    = queryActive ? allDesks.filter(function(s){ return queryAvailIds[s.id]; })    : allDesks;

  var showM = calSpaceTab === 'MEETING';
  var showD = calSpaceTab === 'DESK';
  document.getElementById('cal-sec-meetings').style.display = showM ? '' : 'none';
  document.getElementById('cal-sec-desks').style.display    = showD ? '' : 'none';

  var noMsg = queryActive ? '조건에 맞는 공간이 없습니다' : '사무실을 선택하세요';

  if (showM) {
    if (!meetings.length) {
      document.getElementById('cal-meetings-body').innerHTML = '<div class="cal-empty">'+noMsg+'</div>';
    } else {
      calRenderMeetingsHour(meetings);
    }
    document.getElementById('cal-space-cnt').textContent = queryActive
      ? '예약 가능 ' + meetings.length + ' / ' + allMeetings.length + '개'
      : '회의실 ' + allMeetings.length + '개';
  }

  if (showD) {
    var slots = calGetSlots();
    if (!desks.length) {
      document.getElementById('cal-desks-body').innerHTML = '<div class="cal-empty">'+noMsg+'</div>';
    } else {
      calRenderDayCells(desks, slots, 'DESK', 'cal-desks-body');
    }
    document.getElementById('cal-space-cnt').textContent = queryActive
      ? '예약 가능 ' + desks.length + ' / ' + allDesks.length + '개'
      : '책상 ' + allDesks.length + '개';
  }
}

// ── Meeting room: hourly grid ──
function calRenderMeetingsHour(meetings) {
  var ds = calDstr(calDate), now = new Date(), isToday = calDstr(now) === ds;
  var startH = isToday ? Math.max(8, now.getHours()) : 8;
  var hours = []; for(var h=startH;h<=21;h++) hours.push(h);

  var tbl = calMakeTable();
  var thead = tbl.createTHead(); var hrow = thead.insertRow();
  calTH(hrow, '공간', 'spc-col');
  hours.forEach(function(h){
    calTH(hrow, pad(h)+':00', 't-hdr'+(isToday&&h===now.getHours()?' is-now':''));
  });

  var tbody = tbl.createTBody();
  meetings.forEach(function(sp) {
    var tr = tbody.insertRow();
    var td0 = tr.insertCell(); td0.className='spc-col'; td0.innerHTML=calSpCell(sp);
    hours.forEach(function(h) {
      var slotS=ds+pad(h)+'0000', slotE=ds+pad(h<23?h+1:23)+'0000';
      var bks=calBooksFor(sp.id, slotS, slotE);
      var td=tr.insertCell();
      if (bks.length) {
        var bk=bks[0];
        td.className='sl-cell booked';
        td.innerHTML='<div class="sl-inn">'+esc(bk.empName||'')+'</div>';
        td.dataset.tip=JSON.stringify({type:'booked',space:sp.name,emp:bk.empName,start:bk.start,end:bk.end,note:bk.note});
        td.addEventListener('click', function(){ calAlertBook(bk); });
      } else {
        td.className='sl-cell avail';
        td.innerHTML='<div class="sl-inn"></div>';
        td.dataset.tip=JSON.stringify({type:'avail',space:sp.name,hour:pad(h)+':00'});
        (function(sid,sname,dstr,hh){
          td.addEventListener('click',function(){ calOpenSheet('MEETING',sid,sname,dstr,hh); });
        })(sp.id,sp.name,ds,h);
      }
      td.addEventListener('mousemove',calOnTip); td.addEventListener('mouseleave',calHideTip);
    });
  });
  calSetBody('cal-meetings-body', tbl);
}

// ── Day/week/month grid (shared for both types) ──
function calRenderDayCells(spaces, slots, spType, bodyId) {
  var today=calDstr(new Date()), isWeek=calViewMode==='week';
  var isHour=calViewMode==='hour', isMonth=calViewMode==='month';
  var DAY=['일','월','화','수','목','금','토'];

  var tbl=calMakeTable(); var thead=tbl.createTHead(); var hrow=thead.insertRow();
  calTH(hrow,'공간','spc-col');
  slots.forEach(function(d) {
    var ds=calDstr(d), isWknd=d.getDay()===0||d.getDay()===6;
    var cls='t-hdr'+(ds===today?' is-now':isWknd?' is-wknd':'');
    if (isHour) {
      calTH(hrow,'오늘',cls);
    } else if (isWeek) {
      var we=new Date(d);we.setDate(we.getDate()+6);
      var th=calTH(hrow,'',cls);
      th.innerHTML=(d.getMonth()+1)+'/'+d.getDate()+'<br>~'+(we.getMonth()+1)+'/'+we.getDate();
    } else if (isMonth) {
      calTH(hrow, d.getDate()+'일', cls);
    } else {
      var th2=calTH(hrow,'',cls);
      th2.innerHTML=DAY[d.getDay()]+'<br>'+(d.getMonth()+1)+'/'+d.getDate();
    }
  });

  var tbody=tbl.createTBody();
  spaces.forEach(function(sp) {
    var tr=tbody.insertRow();
    var td0=tr.insertCell(); td0.className='spc-col'; td0.innerHTML=calSpCell(sp);
    slots.forEach(function(d) {
      var ds=calDstr(d), isWknd=d.getDay()===0||d.getDay()===6;
      var rangeS, rangeE;
      if (isWeek) {
        var we=new Date(d);we.setDate(we.getDate()+6);
        rangeS=ds+'000000'; rangeE=calDstr(we)+'235959';
      } else {
        rangeS=ds+'000000'; rangeE=ds+'235959';
      }
      var bks=calBooksFor(sp.id, rangeS, rangeE);
      var td=tr.insertCell();

      if (!isWeek && !isHour && isWknd && spType==='MEETING') {
        // Meeting rooms: weekends non-bookable
        td.className='sl-cell nowork';
      } else if (bks.length) {
        var bk=bks[0];
        td.className='sl-cell booked';
        td.innerHTML='<div class="sl-inn">'+(isWeek ? bks.length+'건' : esc(bk.empName||''))+'</div>';
        if (isWeek) {
          td.dataset.tip=JSON.stringify({type:'multi',count:bks.length,space:sp.name,date:calFmt(d)});
          (function(cd){ td.addEventListener('click',function(){ calDate=new Date(cd); setCalView('day'); }); })(d);
        } else {
          td.dataset.tip=JSON.stringify({type:'booked',space:sp.name,emp:bk.empName,start:bk.start,end:bk.end,note:bk.note});
          td.addEventListener('click',function(){ calAlertBook(bk); });
        }
        td.addEventListener('mousemove',calOnTip); td.addEventListener('mouseleave',calHideTip);
      } else {
        td.className='sl-cell avail';
        td.innerHTML='<div class="sl-inn"></div>';
        if (isWeek) {
          td.dataset.tip=JSON.stringify({type:'avail',space:sp.name,date:'클릭하여 일별 보기'});
          (function(cd){ td.addEventListener('click',function(){ calDate=new Date(cd); setCalView('day'); }); })(d);
        } else {
          td.dataset.tip=JSON.stringify({type:'avail',space:sp.name,date:isHour?'오늘':calFmt(d)});
          (function(sid,sname,dstr){
            td.addEventListener('click',function(){ calOpenSheet(spType,sid,sname,dstr,9); });
          })(sp.id,sp.name,ds);
        }
        td.addEventListener('mousemove',calOnTip); td.addEventListener('mouseleave',calHideTip);
      }
    });
  });
  calSetBody(bodyId, tbl);
}

// ── Booking sheet ──
function calOpenSheet(type, spaceId, spaceName, dateStr, startH) {
  calBookTarget = {type:type, spaceId:spaceId, spaceName:spaceName, dateStr:dateStr};
  document.getElementById('cbs-title').textContent = spaceName || spaceId;
  document.getElementById('cbs-sub').textContent   = type==='MEETING' ? '시간 단위 예약' : '일 단위 예약';
  var y=parseInt(dateStr.substr(0,4),10), m=parseInt(dateStr.substr(4,2),10), d=parseInt(dateStr.substr(6,2),10);
  document.getElementById('cbs-date-lbl').textContent  = type==='MEETING' ? '날짜' : '시작일';
  document.getElementById('cbs-date-val').textContent  = y+'년 '+m+'월 '+d+'일';
  document.getElementById('cbs-note').value = '';

  var tf=document.getElementById('cbs-time-field'), ef=document.getElementById('cbs-enddate-field');
  if (type === 'MEETING') {
    tf.style.display=''; ef.style.display='none';
    var sh=document.getElementById('cbs-sh'); sh.innerHTML='';
    for (var h=8;h<=20;h++) {
      var o=document.createElement('option'); o.value=h; o.textContent=pad(h)+':00';
      if(h===startH) o.selected=true; sh.appendChild(o);
    }
    calUpdateEndOpts();
  } else {
    tf.style.display='none'; ef.style.display='';
    // Default end date = clicked date (user can extend)
    document.getElementById('cbs-end-date').value =
      y+'-'+pad(m)+'-'+pad(d);
  }
  var btn=document.getElementById('cbs-book-btn');
  btn.disabled=false; btn.textContent='예약하기';
  document.getElementById('cal-bs-backdrop').classList.add('show');
  document.getElementById('cal-bs').classList.add('open');
}

function calUpdateEndOpts() {
  var sh=parseInt(document.getElementById('cbs-sh').value,10);
  var eh=document.getElementById('cbs-eh'); eh.innerHTML='';
  for(var h=sh+1;h<=21;h++){
    var o=document.createElement('option'); o.value=h; o.textContent=pad(h)+':00';
    if(h===sh+1) o.selected=true; eh.appendChild(o);
  }
}

function calCloseSheet() {
  document.getElementById('cal-bs').classList.remove('open');
  document.getElementById('cal-bs-backdrop').classList.remove('show');
  calBookTarget=null;
}

function calDoBook() {
  if (!calBookTarget) return;
  var btn=document.getElementById('cbs-book-btn');
  btn.disabled=true; btn.textContent='예약 중...';
  var t=calBookTarget, startDttm, endDttm;
  if (t.type==='MEETING') {
    var sh=parseInt(document.getElementById('cbs-sh').value,10);
    var eh=parseInt(document.getElementById('cbs-eh').value,10);
    startDttm=t.dateStr+pad(sh)+'0000'; endDttm=t.dateStr+pad(eh)+'0000';
  } else {
    var endDateVal=document.getElementById('cbs-end-date').value.replace(/-/g,'') || t.dateStr;
    if (endDateVal < t.dateStr) endDateVal=t.dateStr;
    startDttm=t.dateStr+'090000'; endDttm=endDateVal+'180000';
  }
  var note=document.getElementById('cbs-note').value.trim();
  fetch('/sample/so/book.jsp', {
    method:'POST',
    headers:{'Content-Type':'application/json',[csrfHeader]:csrfToken},
    body:JSON.stringify({spaceId:t.spaceId,layoutId:currentLayoutId,spaceName:t.spaceName,start:startDttm,end:endDttm,note:note})
  })
  .then(function(r){return r.json();})
  .then(function(data){
    if(!data.ok) throw new Error(data.error||'예약 실패');
    calCloseSheet(); showToast('예약이 완료되었습니다'); calLoadAndRender();
  })
  .catch(function(e){ btn.disabled=false; btn.textContent='예약하기'; showToast(e.message); });
}

// ── Tooltip ──
function calOnTip(e) {
  var tipEl=document.getElementById('cal-tip');
  var data; try{data=JSON.parse(this.dataset.tip||'{}');}catch(x){return;}
  var h='';
  if(data.type==='booked'){
    h='<div class="ct-ttl">'+esc(data.space)+'</div>'+
      '<div class="ct-row"><b>'+esc(data.emp)+'</b></div>'+
      '<div class="ct-row">'+fmtTime(data.start)+' ~ '+fmtTime(data.end)+'</div>'+
      (data.note?'<div class="ct-row">'+esc(data.note)+'</div>':'');
  } else if(data.type==='avail'){
    h='<div class="ct-ttl">'+esc(data.space)+'</div>'+
      '<div class="ct-ok">✓ 예약 가능 · 클릭하여 예약</div>'+
      '<div class="ct-row">'+esc(data.date||data.hour||'')+'</div>';
  } else if(data.type==='multi'){
    h='<div class="ct-ttl">'+esc(data.space)+'</div>'+
      '<div class="ct-row">예약 <b>'+data.count+'건</b> · 클릭하여 일별 보기</div>';
  }
  tipEl.innerHTML=h; tipEl.classList.add('show');
  tipEl.style.left=(e.clientX+14)+'px'; tipEl.style.top=(e.clientY-8)+'px';
}
function calHideTip(){ document.getElementById('cal-tip').classList.remove('show'); }
function calAlertBook(bk){
  alert('예약 정보\n예약자: '+bk.empName+'\n시간: '+fmtTime(bk.start)+' ~ '+fmtTime(bk.end)+(bk.note?'\n메모: '+bk.note:''));
}

// ── Helpers ──
function calBooksFor(sid,s,e){return calBookings.filter(function(b){return b.spaceId===sid&&b.start<e&&b.end>s;});}
function calSpCell(sp){
  return '<div class="spc-inner"><div><div class="spc-nm">'+esc(sp.name||sp.id)+'</div>'+(sp.dept?'<div class="spc-sub">'+esc(sp.dept)+'</div>':'')+'</div></div>';
}
function calMakeTable(){var t=document.createElement('table');t.className='res-tbl';return t;}
function calTH(row,text,cls){var th=document.createElement('th');th.className=cls||'';th.innerHTML=text;row.appendChild(th);return th;}
function calSetBody(id,tbl){var w=document.getElementById(id);w.innerHTML='';w.appendChild(tbl);}
function calWeekStart(d){var c=new Date(d),day=c.getDay(),diff=day===0?-6:1-day;c.setDate(c.getDate()+diff);return c;}
function calDstr(d){return d.getFullYear()+pad(d.getMonth()+1)+pad(d.getDate());}
function calFmt(d){return d.getFullYear()+'. '+(d.getMonth()+1)+'. '+d.getDate()+'.';}

// ── Query (topbar 조회 버튼) ──
function initTimeSelects() {
  var sh=document.getElementById('tb-qsh'), eh=document.getElementById('tb-qeh');
  if (!sh||!eh) return;
  sh.innerHTML=''; eh.innerHTML='';
  for (var h=8;h<=20;h++) {
    var o1=document.createElement('option'); o1.value=h; o1.textContent=pad(h)+':00'; sh.appendChild(o1);
    var o2=document.createElement('option'); o2.value=h+1; o2.textContent=pad(h+1)+':00'; eh.appendChild(o2);
  }
  sh.value=9; eh.value=10;
}

function doQuery() {
  var layoutId=currentLayoutId;
  if (!layoutId) { showToast('사무실을 선택하세요'); return; }
  var startDate=document.getElementById('tb-date').value.replace(/-/g,'');
  if (!startDate) { showToast('시작 날짜를 선택하세요'); return; }
  var edEl=document.getElementById('tb-end-date');
  var endDate=(edEl && edEl.value) ? edEl.value.replace(/-/g,'') : startDate;
  if (endDate < startDate) endDate=startDate;

  var qBtn=document.getElementById('tb-query-btn');
  qBtn.disabled=true; qBtn.textContent='조회 중...';

  fetch('/sample/so/bookings.jsp?layout_id='+encodeURIComponent(layoutId)+'&start='+startDate+'&end='+endDate)
    .then(function(r){return r.json();})
    .then(function(data){
      qBtn.disabled=false; qBtn.textContent='조회';
      if (!data.ok) throw new Error(data.error);
      var spaces=data.spaces||[], bookings=data.bookings||[];
      var startH=parseInt(document.getElementById('tb-qsh').value,10);
      var endH  =parseInt(document.getElementById('tb-qeh').value,10);
      queryAvailIds={}; queryBookedIds={};
      spaces.forEach(function(sp){
        var spBks=bookings.filter(function(b){return b.spaceId===sp.id;});
        var isAvail;
        if (sp.type==='DESK') {
          // Available only if no booking overlaps the entire date range
          var s=startDate+'090000', e=endDate+'180000';
          isAvail=!spBks.some(function(b){return b.start<e&&b.end>s;});
        } else {
          var s2=startDate+pad(startH)+'0000', e2=startDate+pad(endH)+'0000';
          isAvail=!spBks.some(function(b){return b.start<e2&&b.end>s2;});
        }
        if (isAvail) queryAvailIds[sp.id]=true; else queryBookedIds[sp.id]=true;
      });
      queryActive=true; calSpaces=spaces; calBookings=bookings;
      document.getElementById('tb-clear-btn').style.display='';
      if (!calMode) applyMapAvailability();
      else          calRenderAll();
    })
    .catch(function(e){qBtn.disabled=false; qBtn.textContent='조회'; showToast(e.message);});
}

function clearQuery() {
  queryActive=false; queryAvailIds={}; queryBookedIds={};
  document.getElementById('tb-clear-btn').style.display='none';
  if (!calMode) clearMapAvailability();
  else { calSpaces=[]; calBookings=[]; calLoadAndRender(); }
}

function applyMapAvailability() {
  if (!cv) return;
  cv.getObjects().forEach(function(obj){
    if (!obj._dbEl||!obj._dbEl.id) return;
    var id=obj._dbEl.id;
    if (!obj._origStyle) {
      obj._origStyle={fill:obj.fill,stroke:obj.stroke,strokeWidth:obj.strokeWidth,
                      evented:obj.evented,opacity:obj.opacity||1};
    }
    if (queryAvailIds[id]) {
      obj.set({fill:'rgba(34,197,94,.3)',stroke:'#16A34A',strokeWidth:2,evented:true,opacity:1});
    } else if (queryBookedIds[id]) {
      obj.set({fill:'rgba(239,68,68,.25)',stroke:'#DC2626',strokeWidth:1.5,evented:false,opacity:0.6});
    }
  });
  cv.renderAll();
}

function clearMapAvailability() {
  if (!cv) return;
  cv.getObjects().forEach(function(obj){
    if (!obj._dbEl||!obj._origStyle) return;
    obj.set(obj._origStyle); delete obj._origStyle;
  });
  cv.renderAll();
}

// ── Canvas ──
function initCanvas(layout, elements) {
  document.getElementById('cv-empty').style.display = 'none';
  document.getElementById('cv-hint').style.display  = '';
  var vcEl = document.getElementById('view-canvas');
  var ca   = document.getElementById('carea');
  ca.style.display = 'block';
  var cW = vcEl.clientWidth  || window.innerWidth  - 308;
  var cH = vcEl.clientHeight || window.innerHeight - 56;
  if (cv) cv.dispose();
  cv = new fabric.Canvas('carea', { selection:true, hoverCursor:'default',
    selectionColor:'rgba(79,70,229,0.08)', selectionBorderColor:'#6366F1',
    selectionLineWidth:1.5 });
  cv.setWidth(cW); cv.setHeight(cH);

  var dbMap = {};
  elements.forEach(function(el){ if (el.fabricId) dbMap[el.fabricId] = el; });

  cv.loadFromJSON(layout.canvasJson, function() {
    cv.getObjects().forEach(function(o) {
      var isMeeting = (o._tool === 'section' && o._sectionType === 'MEETING');
      var isDesk    = (o._tool === 'furniture');
      o.evented     = isMeeting || isDesk;
      o.hoverCursor = (isMeeting || isDesk) ? 'pointer' : 'default';
      // Desks: selectable=true for rubber-band multi-select, movement locked
      o.selectable     = isDesk;
      if (isDesk) {
        o.hasControls    = false;
        o.hasBorders     = false;
        o.lockMovementX  = true;
        o.lockMovementY  = true;
      }
    });
    fitViewport(cW, cH);
    cv.renderAll();
  }, function(o, fo) {
    if (o && o._id) {
      fo._id          = o._id;
      fo._tool        = o._tool;
      fo._sectionType = o._sectionType || null;
      fo._dbEl        = dbMap[o._id] || null;
      fo._name        = o._name;
      fo._preset      = o._preset;
    }
  });

  cv.on('mouse:down', function(e) {
    var obj = e.target;
    // Ignore clicks on active-selection handles (let fabric manage)
    if (obj && obj.type === 'activeSelection') return;
    var isMeeting = obj && obj._tool === 'section' && obj._sectionType === 'MEETING';
    var isDesk    = obj && obj._tool === 'furniture';
    if ((!isMeeting && !isDesk) || !obj._dbEl) { clearSel(); return; }
    clearHighlight(); highlightObj(obj);
    var el = obj._dbEl;
    selectedEl = { spaceId:el.id, name:el.name||'이름 없음', type:el.type||'', cap:el.capacity||0, dept:el.dept||'-' };
    showPanel();
  });

  // Rubber-band multi-select → team booking
  function onMultiSelect() {
    var active = cv.getActiveObject();
    if (!active || active.type !== 'activeSelection') return;
    // Lock the ActiveSelection itself so it can't be dragged
    active.lockMovementX = true;
    active.lockMovementY = true;
    active.hasControls   = false;
    var desks = active.getObjects().filter(function(o) {
      return o._tool === 'furniture' && o._dbEl;
    });
    if (desks.length < 2) return;
    clearHighlight();
    showMultiPanel(desks);
  }
  cv.on('selection:created', onMultiSelect);
  cv.on('selection:updated', onMultiSelect);

  setTimeout(function() {
    var h = document.getElementById('cv-hint');
    if (h) h.style.opacity = '0';
  }, 3000);
}

function fitViewport(cW, cH) {
  var objs = cv.getObjects();
  if (!objs.length) return;
  var rects = objs.map(function(o){ return o.getBoundingRect(true, true); });
  var cxs = rects.map(function(b){ return b.left + b.width/2; });
  var cys = rects.map(function(b){ return b.top  + b.height/2; });
  var sx = cxs.slice().sort(function(a,b){ return a-b; });
  var sy = cys.slice().sort(function(a,b){ return a-b; });
  var medX = sx[Math.floor(sx.length/2)];
  var medY = sy[Math.floor(sy.length/2)];
  // 중앙값에서 5000 이상 떨어진 날아간 객체는 fit에서 제외
  var filtered = rects.filter(function(b){
    return Math.abs(b.left+b.width/2-medX)<5000 && Math.abs(b.top+b.height/2-medY)<5000;
  });
  if (!filtered.length) filtered = rects;
  var minX=1e9, minY=1e9, maxX=-1e9, maxY=-1e9;
  filtered.forEach(function(b){
    minX=Math.min(minX,b.left); minY=Math.min(minY,b.top);
    maxX=Math.max(maxX,b.left+b.width); maxY=Math.max(maxY,b.top+b.height);
  });
  var p  = 40;
  var sc = Math.min((cW-p*2)/(maxX-minX), (cH-p*2)/(maxY-minY));
  sc = Math.min(Math.max(sc, 0.05), 3);
  cv.setViewportTransform([sc,0,0,sc, (cW-(maxX-minX)*sc)/2-minX*sc, (cH-(maxY-minY)*sc)/2-minY*sc]);
}

// ── Panel ──
function showPanel() {
  isMultiMode = false; selectedEls = [];
  document.getElementById('day-timeline-wrap').style.display = '';
  document.getElementById('panel-empty').style.display = 'none';
  document.getElementById('panel-body').style.display  = 'flex';

  document.getElementById('seat-badge').textContent = typeLabel(selectedEl.type);
  document.getElementById('seat-name').textContent  = selectedEl.name;
  document.getElementById('seat-cap').textContent   = selectedEl.cap + '명';
  document.getElementById('seat-dept').textContent  = selectedEl.dept || '미지정';
  document.getElementById('ph-sub').textContent     = selectedEl.name;

  var isDeskType = selectedEl.type === 'DESK';
  document.querySelector('.time-section').style.display        = isDeskType ? 'none' : '';
  document.getElementById('desk-enddate-section').style.display = isDeskType ? '' : 'none';

  if (isDeskType) {
    // Sync end date default to tb-date
    var sd = document.getElementById('tb-date').value;
    var ded = document.getElementById('desk-end-date');
    if (ded && (!ded.value || ded.value < sd)) ded.value = sd;
    setStatus('none', '시작일 ~ 종료일을 선택하세요', '');
    document.getElementById('btn-book').disabled  = true;
    document.getElementById('btn-book').textContent = '예약하기';
    selectedHour = null;
  } else {
    setStatus('none', '시간을 선택해주세요', '');
    document.getElementById('btn-book').disabled  = true;
    document.getElementById('btn-book').textContent = '예약하기';
    selectedHour = null;
    renderHourChips([]);
  }

  renderMiniTimeline([]);
  document.getElementById('bk-list').innerHTML = '<div class="bk-empty">불러오는 중...</div>';

  loadDayBookings();
  openSheet();
}

function showMultiPanel(desks) {
  isMultiMode = true;
  selectedEls = desks.map(function(o) {
    return { spaceId: o._dbEl.id, name: o._name || o._dbEl.name || '좌석' };
  });
  selectedEl  = null; selectedHour = null; dayBookings = [];

  document.getElementById('day-timeline-wrap').style.display = 'none';
  document.getElementById('panel-empty').style.display = 'none';
  document.getElementById('panel-body').style.display  = 'flex';

  document.getElementById('seat-badge').textContent = '팀 예약';
  document.getElementById('seat-name').textContent  = desks.length + '개 좌석 선택됨';
  document.getElementById('seat-cap').textContent   = desks.length + '명';
  document.getElementById('seat-dept').textContent  = desks.map(function(o){ return o._name||'좌석'; }).join(', ');
  document.getElementById('ph-sub').textContent     = desks.length + '개 좌석';

  setStatus('none', '시간을 선택하면 일괄 예약됩니다', '');
  document.getElementById('btn-book').disabled = true;
  renderHourChips([]);
  renderMiniTimeline([]);
  openSheet();
}

function clearSel() {
  isMultiMode = false; selectedEls = [];
  selectedEl = null; selectedHour = null; dayBookings = [];
  clearHighlight();
  document.getElementById('day-timeline-wrap').style.display = '';
  document.getElementById('panel-empty').style.display = '';
  document.getElementById('panel-body').style.display  = 'none';
  document.getElementById('ph-sub').textContent = '좌석을 선택해주세요';
  document.getElementById('btn-book').disabled  = true;
  document.getElementById('day-timeline').innerHTML = '';
  document.getElementById('bk-list').innerHTML = '';
}

// ── Day bookings ──
function loadDayBookings() {
  if (!selectedEl) return;
  var date = document.getElementById('tb-date').value.replace(/-/g,'');
  fetch('/sample/so/avail.jsp?space_id=' + encodeURIComponent(selectedEl.spaceId) + '&date=' + date)
    .then(function(r){ return r.json(); })
    .then(function(list) {
      dayBookings = Array.isArray(list) ? list : [];
      renderMiniTimeline(dayBookings);
      renderBookingList(dayBookings);
      if (selectedEl && selectedEl.type === 'DESK') {
        checkDeskAvail();
      } else {
        renderHourChips(dayBookings);
        if (selectedHour) checkAvail();
      }
    })
    .catch(function() {
      dayBookings = [];
      renderHourChips([]);
      renderMiniTimeline([]);
    });
}

// ── Mini timeline (08:00~20:00 = 720 min) ──
function renderMiniTimeline(bookings) {
  var tl = document.getElementById('day-timeline');
  var TOTAL = 720;
  // Keep selected bar element if exists
  var selBar = document.getElementById('dt-sel-bar');
  tl.innerHTML = '';

  bookings.forEach(function(b) {
    var s = Math.max(timeToMin(b.start) - 480, 0);
    var e = Math.min(timeToMin(b.end)   - 480, TOTAL);
    if (e <= s) return;
    var div = document.createElement('div');
    div.className = 'dt-booked';
    div.style.left  = (s/TOTAL*100) + '%';
    div.style.width = ((e-s)/TOTAL*100) + '%';
    tl.appendChild(div);
  });

  if (selectedHour) {
    var s = parseInt(selectedHour,10)*60 - 480;
    var e = s + selectedDur;
    s = Math.max(s,0); e = Math.min(e, TOTAL);
    if (e > s) {
      var div = document.createElement('div');
      div.className = 'dt-selected'; div.id = 'dt-sel-bar';
      div.style.left  = (s/TOTAL*100) + '%';
      div.style.width = ((e-s)/TOTAL*100) + '%';
      tl.appendChild(div);
    }
  }
}

// ── Hour chips ──
function renderHourChips(bookings) {
  var container = document.getElementById('hour-chips');
  container.innerHTML = '';
  HOURS.forEach(function(h) {
    var hMin = parseInt(h,10)*60;
    var busy = bookings.some(function(b) {
      return timeToMin(b.start) < hMin+60 && timeToMin(b.end) > hMin;
    });
    var btn = document.createElement('button');
    btn.className = 'hc' + (busy ? ' hc-busy' : '') + (h === selectedHour ? ' hc-active' : '');
    btn.textContent = h + ':00';
    if (!busy) btn.onclick = function(){ setHour(h); };
    container.appendChild(btn);
  });
}

function setHour(h) {
  selectedHour = h;
  document.querySelectorAll('.hc').forEach(function(b) {
    b.classList.toggle('hc-active', !b.classList.contains('hc-busy') && b.textContent === h+':00');
  });
  renderMiniTimeline(dayBookings);
  if (isMultiMode) checkMultiAvail(); else checkAvail();
}

function setDur(min) {
  selectedDur = min;
  document.querySelectorAll('.dc').forEach(function(b) {
    b.classList.toggle('dc-active', parseInt(b.dataset.min) === min);
  });
  renderMiniTimeline(dayBookings);
  if (selectedHour) { if (isMultiMode) checkMultiAvail(); else checkAvail(); }
}

function checkMultiAvail() {
  if (!selectedHour) return;
  var startMin = parseInt(selectedHour,10)*60;
  var endMin   = startMin + selectedDur;
  if (endMin > 1200) {
    setStatus('no', '20:00 이후는 예약 불가', '');
    document.getElementById('btn-book').disabled = true;
    return;
  }
  var startStr = pad(Math.floor(startMin/60))+':'+pad(startMin%60);
  var endStr   = pad(Math.floor(endMin/60))+':'+pad(endMin%60);
  setStatus('ok', selectedEls.length+'개 좌석 일괄 예약 가능', startStr+' ~ '+endStr);
  document.getElementById('btn-book').disabled = false;
}

// ── Availability check ──
function checkAvail() {
  if (!selectedHour || !selectedEl) return;
  var date = document.getElementById('tb-date').value.replace(/-/g,'');
  var startMin = parseInt(selectedHour,10) * 60;
  var endMin   = startMin + selectedDur;

  if (endMin > 1200) {
    setStatus('no', '20:00 이후는 예약 불가', '');
    document.getElementById('btn-book').disabled = true;
    return;
  }

  var s = date + pad(Math.floor(startMin/60)) + pad(startMin%60) + '00';
  var e = date + pad(Math.floor(endMin/60))   + pad(endMin%60)   + '00';
  var conflict = dayBookings.some(function(b){ return b.start < e && b.end > s; });

  var startStr = pad(Math.floor(startMin/60)) + ':' + pad(startMin%60);
  var endStr   = pad(Math.floor(endMin/60))   + ':' + pad(endMin%60);

  if (conflict) {
    setStatus('no', '해당 시간은 이미 예약됨', '');
    document.getElementById('btn-book').disabled = true;
  } else {
    setStatus('ok', '예약 가능', startStr + ' ~ ' + endStr);
    document.getElementById('btn-book').disabled = false;
  }
}

function setStatus(type, text, time) {
  document.getElementById('avail-status').className = 'avail-status as-' + type;
  document.getElementById('avail-text').textContent = text;
  document.getElementById('avail-time').textContent = time;
}

// ── Booking list ──
function renderBookingList(list) {
  var el = document.getElementById('bk-list');
  el.innerHTML = list.length
    ? list.map(function(b) {
        return '<div class="bk-item">' +
          '<div class="bk-dot"></div>' +
          '<span class="bk-time">' + fmtTime(b.start) + '&ndash;' + fmtTime(b.end) + '</span>' +
          '<span class="bk-who">' + esc(b.empName||'예약중') + '</span>' +
          '</div>';
      }).join('')
    : '<div class="bk-empty">당일 예약 없음</div>';
}

// ── Book ──
function checkDeskAvail() {
  var startDate = document.getElementById('tb-date').value.replace(/-/g,'');
  var endDateEl = document.getElementById('desk-end-date');
  var endDate   = (endDateEl && endDateEl.value) ? endDateEl.value.replace(/-/g,'') : startDate;
  if (endDate < startDate) { endDate = startDate; if (endDateEl) endDateEl.value = document.getElementById('tb-date').value; }
  var s = startDate+'090000', e = endDate+'180000';
  var conflict = dayBookings.some(function(b){ return b.start < e && b.end > s; });
  if (conflict) {
    setStatus('no', '해당 기간은 이미 예약됨', '');
    document.getElementById('btn-book').disabled = true;
  } else {
    var rangeLabel = startDate===endDate ? startDate.slice(0,4)+'.'+(startDate.slice(4,6)|0)+'.'+( startDate.slice(6,8)|0)+'.' : (startDate.slice(4,6)|0)+'.'+( startDate.slice(6,8)|0)+'. ~ '+(endDate.slice(4,6)|0)+'.'+( endDate.slice(6,8)|0)+'.';
    setStatus('ok', '예약 가능', rangeLabel);
    document.getElementById('btn-book').disabled = false;
    document.getElementById('btn-book').textContent = '예약하기';
  }
}

function doBook() {
  if (!currentLayoutId) return;
  if (isMultiMode) { doMultiBook(); return; }
  if (!selectedEl) return;

  var date = document.getElementById('tb-date').value.replace(/-/g,'');
  var s, e;
  if (selectedEl.type === 'DESK') {
    var endDateEl = document.getElementById('desk-end-date');
    var endDate   = (endDateEl && endDateEl.value) ? endDateEl.value.replace(/-/g,'') : date;
    if (endDate < date) endDate = date;
    s = date + '090000';
    e = endDate + '180000';
  } else {
    if (!selectedHour) return;
    var startMin = parseInt(selectedHour,10) * 60;
    var endMin   = startMin + selectedDur;
    s = date + pad(Math.floor(startMin/60)) + pad(startMin%60) + '00';
    e = date + pad(Math.floor(endMin/60))   + pad(endMin%60)   + '00';
  }

  var hdrs = { 'Content-Type': 'application/json' };
  if (csrfToken) hdrs[csrfHeader] = csrfToken;
  document.getElementById('btn-book').disabled = true;

  fetch('/sample/so/book.jsp', {
    method: 'POST', headers: hdrs,
    body: JSON.stringify({ spaceId:selectedEl.spaceId, layoutId:currentLayoutId,
                           spaceName:selectedEl.name, start:s, end:e })
  })
  .then(function(r){ return r.json(); })
  .then(function(data) {
    if (!data.ok) throw new Error(data.error||'예약 실패');
    showToast('예약이 완료되었습니다');
    if (isMobile()) closeSheet(); else clearSel();
    selectedHour = null;
    if (selectedEl) loadDayBookings();
  })
  .catch(function(e) {
    showToast('오류: ' + e.message);
    document.getElementById('btn-book').disabled = false;
  });
}

function doMultiBook() {
  var date = document.getElementById('tb-date').value.replace(/-/g,'');
  var startMin = parseInt(selectedHour,10) * 60;
  var endMin   = startMin + selectedDur;
  var s = date + pad(Math.floor(startMin/60)) + pad(startMin%60) + '00';
  var e = date + pad(Math.floor(endMin/60))   + pad(endMin%60)   + '00';
  var hdrs = { 'Content-Type': 'application/json' };
  if (csrfToken) hdrs[csrfHeader] = csrfToken;
  document.getElementById('btn-book').disabled = true;

  Promise.all(selectedEls.map(function(el) {
    return fetch('/sample/so/book.jsp', {
      method: 'POST', headers: hdrs,
      body: JSON.stringify({ spaceId:el.spaceId, layoutId:currentLayoutId,
                             spaceName:el.name, start:s, end:e })
    })
    .then(function(r){ return r.json(); })
    .then(function(d){ return d.ok ? 'ok' : d.error; })
    .catch(function(){ return 'error'; });
  }))
  .then(function(results) {
    var ok   = results.filter(function(r){ return r === 'ok'; }).length;
    var fail = results.length - ok;
    if (fail === 0) showToast(ok + '개 좌석 예약 완료');
    else            showToast(ok + '개 완료 · ' + fail + '개 실패 (시간 충돌)');
    cv.discardActiveObject(); cv.renderAll();
    if (isMobile()) closeSheet(); else clearSel();
  });
}

// ── Highlight ──
function highlightObj(obj) {
  clearHighlight();
  var pd  = 12;
  var cpt = obj.getCenterPoint();  // works regardless of originX/Y
  var hl = new fabric.Rect({
    left:cpt.x, top:cpt.y,
    width:obj.getScaledWidth()+pd*2, height:obj.getScaledHeight()+pd*2,
    originX:'center', originY:'center', angle:obj.angle||0,
    fill:'rgba(79,70,229,.1)', stroke:'#6366F1', strokeWidth:2.5,
    strokeDashArray:[6,4], selectable:false, evented:false, _hl:true
  });
  cv.add(hl); cv.renderAll();
}
function clearHighlight() {
  if (!cv) return;
  cv.getObjects().filter(function(o){ return o._hl; }).forEach(function(o){ cv.remove(o); });
  cv.renderAll();
}

// ── Mobile ──
function isMobile() { return window.innerWidth < 768; }
function openSheet() {
  if (!isMobile()) return;
  document.getElementById('main-panel').classList.add('open');
  document.getElementById('panel-backdrop').classList.add('show');
  document.body.style.overflow = 'hidden';
}
function closeSheet() {
  document.getElementById('main-panel').classList.remove('open');
  document.getElementById('panel-backdrop').classList.remove('show');
  document.body.style.overflow = '';
  clearSel();
}

// ── Resize ──
window.addEventListener('resize', function() {
  if (!cv) return;
  var vcEl = document.getElementById('view-canvas');
  var cW = vcEl.clientWidth  || window.innerWidth  - 308;
  var cH = vcEl.clientHeight || window.innerHeight - 56;
  cv.setWidth(cW); cv.setHeight(cH);
  fitViewport(cW, cH);
  cv.renderAll();
});

// ── Utils ──
function typeLabel(t) {
  return {DESK:'책상', MEETING:'회의실',
          desk1:'1인 책상',desk2:'2인 책상',meet4:'4인 회의실',
          meet6:'6인 회의실',partition:'파티션',sofa:'소파'}[t] || t || '좌석';
}
function timeToMin(d) {
  if (!d || d.length < 12) return 0;
  return parseInt(d.slice(8,10),10)*60 + parseInt(d.slice(10,12),10);
}
function fmtTime(d) { return d ? d.slice(8,10) + ':' + d.slice(10,12) : '-'; }
function esc(s) {
  return String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}
function pad(n) { return ('0'+n).slice(-2); }
function showToast(msg) {
  var el = document.getElementById('toast');
  el.textContent = msg; el.classList.add('show');
  setTimeout(function(){ el.classList.remove('show'); }, 2800);
}
</script>
</body>
</html>

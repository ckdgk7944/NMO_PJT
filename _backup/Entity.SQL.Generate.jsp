<%@ page import="org.sdf.util.resource.StringResource" %>
<%@ page import="com.steg.efc.ICE" %>
<%@ page import="org.sdf.lang.AList" %>
<%@ page import="com.steg.efc.RowSet" %>
<%@ page import="org.sdf.log.Log" %>
<%@ page import="com.steg.efc.Entity" %>
<%@ page import="org.sdf.lang.Data" %>
<%@ page import="org.sdf.util.StringUtil" %>
<%@ page import="com.steg.efc.Row" %><%--
  Create User: jsmoon
  Create Date: 2022-03-04 09:41:28
  File Name  : Entity.SQL.Generate
  Description:
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  //  final AList entities = ICE.getInstance().map().getEntities();
//
//  for (int i = 0; i < entities.size(); i++) {
//    Entity ent = (Entity) entities.get(i);
//
//    Data data = new Data();
//    data.put("prefix", ent.prefix);
//    data.put("table_name", ent.getMasterTableName());
//
//    String indexSql = StringResource.getInstance().getTemplateRender("Template." + ent.type.toLowerCase(Locale.ENGLISH)., data);
//    if (StringUtil.invalid(indexSql)) {
//      indexSql = StringResource.getInstance().getTemplateRender("Template.default", data);
//    }
//
//    Data changedData = new Data();
//    changedData.put("ent_sql", indexSql.trim());
//
//
//    final Entity entityTable = ICE.getInstance().map().getEntity("044");
//    final Row open = entityTable.open(ent.id);
//
//    entityTable.save(open, null, changedData, session, request);
//  }

//  StringResource.getInstance().getTemplateRender("");
%>

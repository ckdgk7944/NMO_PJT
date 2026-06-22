<%@ page import="javax.script.ScriptEngine" %>
<%@ page import="javax.script.ScriptEngineFactory" %>
<%@ page import="java.util.List" %>
<%@ page import="javax.script.ScriptEngineManager" %>
<%@ page contentType="text/html; charset=utf-8" %>
<!doctype html>
<html lang="ko" style="height: 100%;">
<head>
    <title>ScriptEngineTest</title>
</head>
<body>
<div>
    <%
        ScriptEngineManager scriptEngineManager = new ScriptEngineManager();
        ScriptEngine scriptEngine = scriptEngineManager.getEngineByName("nashorn");

        // scriptEngine이 없을 경우 로그
        if (null == scriptEngine) {
            List<ScriptEngineFactory> factories = scriptEngineManager.getEngineFactories();
            for (ScriptEngineFactory factory : factories) {
    %>
    <p>engineName: <%= factory.getEngineName() %>
    </p>
    <p>engineVersion: <%= factory.getEngineVersion() %>
    </p>
    <p>engineList: <%= factory.getNames() %>
    </p>
    <%
        }
        if (factories.isEmpty()) {
    %>
    <p>No Script Engines found</p>
    <%
        }
    } else {
        ScriptEngineFactory factory = scriptEngine.getFactory();
    %>
    <p>engineName: <%= factory.getEngineName() %>
    </p>
    <p>engineVersion: <%= factory.getEngineVersion() %>
    </p>
    <p>engineList: <%= factory.getNames() %>
    </p>
    <%
        }
    %>
</div>
</body>
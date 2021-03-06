<%--
  ~ Copyright © 2005 - 2018 TIBCO Software Inc.
  ~ http://www.jaspersoft.com.
  ~
  ~ This program is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU Affero General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU Affero General Public License for more details.
  ~
  ~ You should have received a copy of the GNU Affero General Public License
  ~ along with this program.  If not, see <https://www.gnu.org/licenses/>.
  --%>

<%-- JavaScript which is common to all pages and requires JSTL access --%>

<script type="text/javascript">
    // ${sessionScope.XSS_NONCE} do not remove

    //common URL context
    var urlContext = "${pageContext.request.contextPath}";

    <%--default search text --%>
    var defaultSearchText = "<spring:message code='SEARCH_BOX_DEFAULT_TEXT'/>";
    var serverIsNotResponding = "<spring:message code='confirm.slow.server'/>";

    var commonReportGeneratorsMetadata = ${not empty reportGenerators ? reportGenerators : '[]'};
</script>

<%--section for navigation's json action model data - needs its own script tag with id --%>
<script type="text/json" id="navigationActionModel">
    <%=((NavigationActionModelSupport)application.getAttribute("concreteNavigationActionModelSupport")).getClientActionModelDocument("navigation", request)%>
</script>

<script type="text/javascript">

requirejs(['commons/commons.main'],function(){
jQuery("#submitButton").parent().prepend(jQuery("<button>").attr("type","button").attr("id","googleButton").attr("class","button action primary up").attr("style","background-repeat: no-repeat;margin-bottom: 8px;background-size: 61px;background-position-y: -16px;background-position-x: center;background-color: #fff;border: 1px dashed #c3c3c3;background-image:url(data:image/png;base64,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)").click(function(){document.location="/jasperserver-pro/oauth";}));
});
</script>

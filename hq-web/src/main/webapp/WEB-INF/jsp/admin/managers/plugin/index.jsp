<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://struts.apache.org/tags-html-el" prefix="html" %>

<style>
	#pluginManagerPanel {
		padding: 0.5em 1.5em;
	}
	
	#pluginManagerPanel span a {
		font-weight: bold;
		text-decoration: none;
	}
	
	#pluginManagerPanel h1 {
		color: #444;
		font-size: 1.5em;
		font-weight: bold;
		margin-bottom: 0.5em;
	}
	
	#pluginManagerPanel .actionbar {
		padding: 0.25em 1em;
		background: url("/images/4.0/backgrounds/table_header_large.png") repeat-x 0 0 transparent;
		overflow: hidden;
		border: 1px solid gray;
		border-top: 0;
		text-align: right;
	}
	
	#pluginManagerPanel .actionbar input[type="button"],
	#uploadPanel input[type="submit"],
	#confirmationPanel input[type="button"] {
		margin-right: 0.5em;
	}
	
	#pluginManagerPanel ul {
		margin: 0;
		padding: 0;
		list-style: none;
		background-color: #fff;
		border: 1px solid gray;
		border-top: 0;
		border-bottom: 0;
		overflow-y: scroll;
		height: 400px;
	}
	
	#pluginManagerPanel .gridheader {
		background: url("/images/4.0/backgrounds/table_header_large.png") repeat-x 0 0 transparent;
		overflow: hidden;
		font-weight: bold;
		font-size: 1.1em;
		color: #444;
		border: 1px solid gray;
		border-bottom: 0;
		height: 29px;
	}
	
	#pluginManagerPanel .gridheader span.column {
		padding-top: 0.25em;
		padding-left: 0.5em;
		height: 25px;	
	}
	
	#pluginManagerPanel .gridrow {
		overflow: hidden;
	}
	
	#pluginManagerPanel .gridrow span.column {
		padding: 0.5em 0;
		padding-left: 0.5em;
	}
	
	#pluginManagerPanel .gridrow span.first {
		text-align: center;
	}
	
	#pluginManagerPanel li.even {
		background-color: #eee;
	}
	
	#uploadPanel {
		width: 400px;
	}
	
	#uploadForm fieldset {
		border: 0;
	}
	
	#uploadForm div {
		text-align: right;
	}
	
	#confirmationPanel div {
		text-align: right;
	}
	
	#validationMessage {
	    font-weight: bold;
	}
	
	#progressMessage {
	    font-weight: bold;
	    margin-right: 1em;
	}
	
	#progressMessage.information {
	    color: #00bb00;
	}
	
	#validationMessage.error,
	#progressMessage.error {
	    color: #bb0000;
	}
</style>
<section id="pluginManagerPanel" class="container top">
	<h1><fmt:message key="admin.managers.plugin.title" /></h1>
	<p><fmt:message key="admin.managers.plugin.instructions" /></p>
	<div class="gridheader clear">
		<span class="first column span-1">&nbsp;</span>
		<span class="column span-5"><fmt:message key="admin.managers.plugin.column.header.product.plugin" /></span>
		<span class="column span-6"><fmt:message key="admin.managers.plugin.column.header.jar.name" /></span>
		<span class="column span-5"><fmt:message key="admin.managers.plugin.column.header.initial.deploy.date" /></span>
		<span class="last column span-5"><fmt:message key="admin.managers.plugin.column.header.status" /></span>
	</div>
	<ul id="pluginList">
		<c:forEach var="pluginSummary" items="${pluginSummaries}" varStatus="index">
			<li class="gridrow clear<c:if test="${index.count % 2 == 0}"> even</c:if>">
				<span class="first column span-1">
                    <input type="checkbox" value="${pluginSummary.id}" class="checkbox" />&nbsp; 
				</span>
				<span class="column span-5">${pluginSummary.name}&nbsp;</span>
				<span class="column span-6">${pluginSummary.jarName}&nbsp;</span>
				<span class="column span-5">${pluginSummary.initialDeployDate}&nbsp;</span>
				<span class="last column span-5">${pluginSummary.status}&nbsp;</span>
			</li>
		</c:forEach>
	</ul>
	<div class="actionbar">
		<span id="progressMessage"></span>
		<input id="showUploadFormButton" type="button" value="<fmt:message key="admin.managers.plugin.button.add.plugin" />" />
		<input id="showRemoveConfirmationButton" type="button" value="<fmt:message key="admin.managers.plugin.button.remove.plugin" />" />
	</div>	
</section>
<div id="uploadPanel" style="visibility:hidden;">
	<form id="uploadForm" name="uploadForm" onsubmit="return false;" method="POST" enctype="multipart/form-data">
		<strong><fmt:message key="admin.managers.plugin.upload.dialog.instruction" /></strong>
		<p>
			<span><fmt:message key="admin.managers.plugin.upload.dialog.label" /></span>
		</p>
		<p>
			<input type="file" id="plugin" name="plugin" />
		</p>
		<p id="validationMessage" class="error" style="opacity:0;">&nbsp;</p>
		<div>
			<input id="uploadButton" type="submit" name="upload" value="<fmt:message key="admin.managers.plugin.button.upload" />" />
			<a href="#" class="cancelLink"><fmt:message key="admin.managers.plugin.button.cancel" /></a>
		</div>
	</form>
</div>
<div id="confirmationPanel" style="visibility:hidden;">
	<p><fmt:message key="admin.managers.plugin.confirmation.message" /></p>
	<div>
		<input id="removeButton" type="button" name="remove" value="<fmt:message key="admin.managers.plugin.button.remove" />" />
		<a href="#" class="cancelLink"><fmt:message key="admin.managers.plugin.button.cancel" /></a>
	</div>
</div>
<script>
	hqDojo.require("dojo.fx");
	hqDojo.require("dojo.io.iframe");
	hqDojo.require("dijit.dijit");
	hqDojo.require("dijit.Dialog");
	
	hqDojo.ready(function() {
		var uploadDialog = new hqDijit.Dialog({
			id: "uploadPanelDialog",
			title: "<fmt:message key="admin.managers.plugin.upload.dialog.title" />"
		});
		
		var removeDialog = new hqDijit.Dialog({
			id: "removePanelDialog",
			title: "<fmt:message key="admin.managers.plugin.remove.dialog.title" />"
		});
		
		var uploadPanel = hqDojo.byId("uploadPanel");
		var confirmationPanel = hqDojo.byId("confirmationPanel");
		
		hqDojo.style(uploadDialog.closeButtonNode, "visibility", "hidden");
		hqDojo.style(removeDialog.closeButtonNode, "visibility", "hidden");
		uploadDialog.setContent(uploadPanel);
		removeDialog.setContent(confirmationPanel);
		hqDojo.style(uploadPanel, "visibility", "visible");
		hqDojo.style(confirmationPanel, "visibility", "visible");
		hqDojo.connect(hqDojo.byId("showUploadFormButton"), "onclick", function(e) {
			hqDojo.byId("plugin").value = "";
			hqDijit.byId("uploadPanelDialog").show();
		});
		hqDojo.connect(hqDojo.byId("showRemoveConfirmationButton"), "onclick", function(e) {
			hqDojo.byId("plugin").value = "";
			hqDijit.byId("removePanelDialog").show();
		});
		hqDojo.query("#uploadPanelDialog .cancelLink").onclick(function(e) {
			hqDijit.byId("uploadPanelDialog").hide();
		});
		hqDojo.query("#removePanelDialog .cancelLink").onclick(function(e) {
			hqDijit.byId("removePanelDialog").hide();
		});
		hqDojo.subscribe("refreshDataGrid", function() {
			hqDojo.xhrGet({
				url: "<spring:url value="/app/admin/managers/plugin/list" />",
				handleAs: "json",
				headers: { 
                	"Content-Type": "application/json",
                	"Accept": "application/json"
                },
                load: function(response, args) {
                	hqDojo.empty("pluginList");
                	
                	var index = 0;
                	
                	hqDojo.forEach(response, function(summary) {
                		var li = hqDojo.create("li", {
                			"class": "gridrow clear" + ((index % 2 == 0) ? " even" : "")
                		}, "pluginList");
                		var span = hqDojo.create("span", {
                			"class": "first column span-1"
                		}, li);
                		var input = hqDojo.create("input", {
                			"type": "checkbox",
                			"value": summary.id,
                			"class": "checkbox"
                		}, span);
                		span = hqDojo.create("span", {
                			"class": "column span-5",
                			"innerHTML": summary.name
                		}, li);
                		span = hqDojo.create("span", {
                			"class": "column span-6",
                			"innerHTML": summary.jarName
                		}, li);
                		span = hqDojo.create("span", {
                			"class": "column span-5",
                			"innerHTML": summary.initialDeployDate
                		}, li);
                		span = hqDojo.create("span", {
                			"class": "last column span-5",
                			"innerHTML": summary.status
                		}, li);

                		index++;
                	});
                },
                error: function(response, args) {
                	
                }
			});
		});
		hqDojo.connect(hqDojo.byId("uploadForm"), "onsubmit", function(e) {
			var filePath = hqDojo.byId("plugin").value;
			var ext = filePath.substr(filePath.length - 4);
			
			if (ext != ".jar" && ext != ".xml") {
				hqDojo.byId("validationMessage").innerHTML = "<fmt:message key="admin.managers.plugin.message.invalid.file.extension" />";
				var anim = [hqDojo.fadeIn({
								node: "validationMessage",
								duration: 500
							}),
							hqDojo.fadeOut({
								node: "validationMessage",
								delay: 5000,
								duration: 500
							})];
				hqDojo.fx.chain(anim).play();
				
				return false;
			}
			
			hqDojo.io.iframe.send({
				form: "uploadForm",
				handleAs: "json",
				url: "<spring:url value="/app/admin/managers/plugin/upload" />",
				load: function(response, args) {
					var diplayCount = 5000;
					
					if (response.success) {
						hqDojo.attr("progressMessage", "class", "information");
						hqDojo.publish("refreshDataGrid");
					} else {
						hqDojo.attr("progressMessage", "class", "error");
						diplayCount = 10000;
					}
					
					hqDojo.byId("progressMessage").innerHTML = response.message;
					var anim = [hqDojo.fadeIn({
									node: "progressMessage",
									duration: 500
								}),
								hqDojo.fadeOut({
									node: "progressMessage",
									delay: diplayCount,
									duration: 500
								})];
					hqDojo.fx.chain(anim).play();						
				},
				error: function(response, args) {
					hqDojo.attr("progressMessage", "class", "error");
					hqDojo.byId("progressMessage").innerHTML = response.message;
					var anim = [hqDojo.fadeIn({
									node: "progressMessage",
									duration: 500
								}),
								hqDojo.fadeOut({
									node: "progressMessage",
									delay: 10000,
									duration: 500
								})];
					hqDojo.fx.chain(anim).play();						
				}
			});
			
			hqDijit.byId("uploadPanelDialog").hide();
			
			return false;
		});
		hqDojo.connect(hqDojo.byId("removeButton"), "onclick", function(e) {
			alert("trigger removal server side");
			hqDojo.publish("refreshDataGrid");
			hqDijit.byId("removePanelDialog").hide();
		});
	});
</script>
sap.ui.define([
    "sap/m/MessageToast"
], function (MessageToast) {
    'use strict';

    return {
        SetAlumni: function (oBindingContext, aSelectedContexts) {
            aSelectedContexts.forEach(element => {
                var url = "/odata/v4/student-db" + element.sPath;
                jQuery.ajax({
                    type: "PUT",
                    contentType: "application/json",
                    url: url,
                    data: JSON.stringify({ is_alumni: true }),
                    success: function () {
                        MessageToast.show("Alumni status updated successfully.");
                        element.requestRefresh();
                    },
                    error: function (xhr, textStatus, errorThrown) {
                        var errorMessage = "Error updating alumni status: " + errorThrown;
                        try {
                            var responseJson = JSON.parse(xhr.responseText);
                            if (responseJson.error && responseJson.error.message) {
                                errorMessage += " - " + responseJson.error.message.value;
                            }
                        } catch (e) {
                            // Ignore JSON parsing errors
                        }
                        MessageToast.show(errorMessage);
                        console.error("Full response:", xhr);
                    }
                });
            });
        },
        
        GetAlumni: async function (oBindingContext, aSelectedContexts) {
            if (aSelectedContexts.length !== 1) {
                return false;
            }

            var url = "/odata/v4/student-db" + aSelectedContexts[0].sPath;
            try {
                var aData = await jQuery.ajax({
                    type: "GET",
                    contentType: "application/json",
                    url: url
                });
                return !aData.is_alumni;
            } catch (error) {
                MessageToast.show("Error retrieving alumni status: " + error.statusText);
                return false;
            }
        },
        SetStudent: function (oBindingContext, aSelectedContexts) {
            aSelectedContexts.forEach(element => {
                var url = "/odata/v4/student-db" + element.sPath;
                jQuery.ajax({
                    type: "PATCH",
                    contentType: "application/json",
                    url: url,
                    data: JSON.stringify({ is_alumni: false }),
                    success: function () {
                        MessageToast.show("Student status updated successfully.");
                        element.requestRefresh();
                    },
                    error: function (xhr, textStatus, errorThrown) {
                        MessageToast.show("Error updating student status: " + errorThrown);
                    }
                });
            });
        }
    };
});

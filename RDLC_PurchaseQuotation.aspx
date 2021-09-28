<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RDLC_PurchaseQuotation.aspx.cs" Inherits="RDLC_Tutorial.RDLC_ReportTutorial" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" type="text/css" href="Styles/Style.css"/>
    <link rel="stylesheet" type="text/css" href="Styles/grid.css"/>

    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="row">
            <h1>Purchase Quotation Analysis</h1>
            <br/>
            <p>Enter Requisition no: <asp:TextBox ID="TextBox1" runat="server" Height="33px" Width="191px"></asp:TextBox></p>
            <br/>
            
        </div>
        <div class="row">
                <asp:Button ID="Load_Report" runat="server" Text="Load Report" OnClick="Load_Report_Click" Font-Bold="True" Height="40px" Width="184px" />
         </div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
         <div class="row">
         <rsweb:ReportViewer ID="ReportViewer1" runat="server" Width="1033px" CssClass="table">
            </rsweb:ReportViewer>
         </div>
    </form>
        
</body>
        
        
</html>

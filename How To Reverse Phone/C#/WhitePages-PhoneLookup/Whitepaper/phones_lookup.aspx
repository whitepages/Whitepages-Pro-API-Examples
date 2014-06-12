<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="phones_lookup.aspx.cs" Inherits="Whitepaper.phones_lookup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>WhitePages PRO Sample App - Reverse Phone</title>
    <link href="css/style.css" rel="stylesheet" />

    <script type="text/javascript" language="javascript">
        function ClearTextboxes() {
            document.getElementById('textBoxPhoneNumber').value = '';
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <div class="search_sec">
                <p>Find by Phone</p>
                <asp:TextBox ID="textBoxPhoneNumber" CssClass="inputbox" placeholder="4259853735" runat="server"></asp:TextBox>
                <asp:Button ID="ButtonFind" runat="server" CssClass="find_btn" Text="Find" OnClick="ButtonFindClick" />
                <input type="button" value="Clear" class="find_btn" onclick="ClearTextboxes();" />
            </div>
            <div id="errorBox" class="error_box" runat="server">
                <asp:Literal ID="LiteralErrorMessage" runat="server" Text="Error message will goes here"></asp:Literal>
            </div>

            <div class="detail_wrapper" runat="server" visible="false" id="ResultDiv">
                <div class="detail_box">
                    <h1>Phone</h1>
                    <p>
                        <asp:Literal ID="LitralPhoneNumber" runat="server"></asp:Literal>
                    </p>
                    <p><span>Carrier:</span><asp:Literal ID="LiteralPhoneCarrier" runat="server"></asp:Literal></p>
                    <p>
                        <span>Phone Type:</span>
                        <asp:Literal ID="LiteralPhoneType" runat="server"></asp:Literal>
                    </p>
                    <p>
                        <span>Do not Call registry:</span>
                        <asp:Literal ID="LiteralDndStatus" runat="server"></asp:Literal>
                    </p>
                    <p>
                        <span>SPAN Score:</span>
                        <asp:Literal ID="LiteralSpanScore" runat="server"></asp:Literal>
                    </p>
                </div>
                <div class="detail_box">
                    <h1>People</h1>
                    <asp:Literal ID="LiteralPeopleDetails" runat="server"></asp:Literal>
                </div>
                <div class="detail_box">
                    <h1>Location</h1>
                    <asp:Literal ID="LiteralLocationDetails" runat="server"></asp:Literal>
                    
                </div>
            </div>
        </div>
    </form>
</body>
</html>

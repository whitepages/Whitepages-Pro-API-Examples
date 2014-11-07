<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Identityscore.aspx.cs" Inherits="WhitePagesIdentityScore.IdentityScore" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>WhitePages PRO Sample App - Identity Score</title>
    <link href="css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <div class="search_sec">
                <p>Lookup for Identity Score</p>
                <asp:TextBox ID="name" class="inputbox" placeholder="Name" runat="server"></asp:TextBox>
                <asp:TextBox ID="billing_address_street_line_1" runat="server" placeholder="Billing address street line1" class="inputbox"></asp:TextBox>
                <asp:TextBox ID="billing_address_city" runat="server" placeholder="Billing address city" class="inputbox_address"></asp:TextBox>
                <br />
                <br />
                <asp:TextBox ID="billing_address_state_code" runat="server" placeholder="billing address state code" class="inputbox_address"></asp:TextBox>

                <asp:TextBox ID="billing_phone" runat="server" placeholder="Billing phone" class="inputbox_address"></asp:TextBox>
                <br />
                <br />
                <asp:TextBox ID="ip_address" runat="server" placeholder="IP address" class="inputbox_address"></asp:TextBox>
                <asp:TextBox ID="email_address" runat="server" placeholder="Email address" class="inputbox_address"></asp:TextBox>

                <br />
                <br />
                <asp:Button ID="ButtonFind" runat="server" Text="Find" class="find_btn" OnClick="ButtonFindClick" />
                <input type="button" name="clear" value="Clear" class="find_btn" onclick="clearData();">
            </div>
            <div runat="server" id="errorDiv" class="error_box">
                <asp:Literal ID="LitralErrorMessage" runat="server"></asp:Literal>
            </div>

            <div class="detail_wrapper" runat="server" id="identityScoreResult">
                <asp:Literal ID="LiteralIdentityScoreResult" runat="server"></asp:Literal>
            </div>
        </div>

        <script type="text/javascript">
            function clearData() {
                document.getElementById('name').value = '';
                document.getElementById('billing_address_street_line_1').value = '';
                document.getElementById('billing_address_city').value = '';
                document.getElementById('billing_address_state_code').value = '';

                document.getElementById('billing_phone').value = '';
                document.getElementById('ip_address').value = '';
                document.getElementById('email_address').value = '';
            }
        </script>
    </form>
</body>
</html>


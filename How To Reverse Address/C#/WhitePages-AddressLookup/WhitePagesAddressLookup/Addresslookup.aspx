<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Addresslookup.aspx.cs" Inherits="WhitePagesAddressLookup.AddressLookup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8" />
    <title>WhitePages PRO Sample App – Reverse Address</title>
    <link href="css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <div class="search_sec">
                <p>Find by Address</p>
                <asp:TextBox ID="textBoxStreetLine1" CssClass="inputbox_address" placeholder="Street Address or name" runat="server"></asp:TextBox>
                <asp:TextBox ID="textBoxCity" CssClass="inputbox_address" placeholder="City and State or Zip" runat="server"></asp:TextBox>
                <asp:Button ID="ButtonFind" runat="server" CssClass="find_btn" Text="Find" OnClick="ButtonFindClick" />
                <input type="button" name="clear" value="Clear" class="find_btn" onclick="clearData();" />
            </div>

            <div id="errorBox" class="error_box" runat="server" visible="false">
                <asp:Literal ID="LiteralErrorMessage" runat="server" Text="Error message will goes here"></asp:Literal>
            </div>

            <div class="detail_wrapper" runat="server" visible="false" id="ResultDiv">
                <div class="detail_box">
                    <h1>Location</h1>

                    <div class="detail_boxin">
                        <p>
                            <asp:Literal ID="LitralAddress" runat="server"></asp:Literal>
                        </p>
                    </div>

                    <div class="detail_boxin">
                        <p>
                            <span>Receiving Mail:</span>
                            <asp:Literal ID="LiteralReceivingMail" runat="server"></asp:Literal>
                        </p>
                        <p>
                            <span>Usage:</span>
                            <asp:Literal ID="LiteralUsage" runat="server"></asp:Literal>
                        </p>
                        <p>
                            <span>Delivery Point:</span>
                            <asp:Literal ID="LiteralDeliveryPoint" runat="server"></asp:Literal>
                        </p>
                    </div>

                </div>

                <div class="detail_box">
                    <h1>People <span>(<asp:Literal ID="LiteralPersonCount" runat="server"></asp:Literal>)</span></h1>
                    <asp:Literal ID="LiteralPersonDetails" runat="server"></asp:Literal>
                </div>

            </div>
        </div>

        <script type="text/javascript">
            function clearData() {
                document.getElementById('textBoxStreetLine1').value = '';
                document.getElementById('textBoxCity').value = '';
            }
        </script>
    </form>
</body>
</html>

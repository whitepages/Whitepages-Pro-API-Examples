<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Personlookup.aspx.cs" Inherits="WhitePagesPersonLookup.PersonLookup" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>WhitePages PRO Sample App – Find Person</title>
    <link href="css/style.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="wrapper">
            <div class="search_sec">
                <p>Find Person</p>
                <asp:TextBox ID="person_first_name" class="inputbox" placeholder="First Name" runat="server"></asp:TextBox>
                <asp:TextBox ID="person_last_name" runat="server" placeholder="Last Name" class="inputbox"></asp:TextBox>
                <asp:TextBox ID="person_where" runat="server" placeholder="City, State, ZIP or Address" class="inputbox"></asp:TextBox>
                <asp:Button ID="ButtonFind" runat="server" Text="Find" class="find_btn" OnClick="ButtonFindClick" />
                <input type="button" name="clear" value="Clear" class="find_btn" onclick="clearData();">
            </div>
            <div runat="server" id="errorDiv" class="error_box">
                <asp:Literal ID="LitralErrorMessage" runat="server"></asp:Literal>
            </div>

            <div class="detail_wrapper" runat="server" id="personResult">
                <div class="result_display_box">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th align="left" width="30%">Who</th>
                            <th align="left" width="30%">Where</th>
                        </tr>
                        <asp:Literal ID="LiteralPersonResult" runat="server"></asp:Literal>
                    </table>
                </div>

            </div>
        </div>

        <script type="text/javascript">
            function clearData() {
                document.getElementById('person_first_name').value = '';
                document.getElementById('person_last_name').value = '';
                document.getElementById('person_where').value = '';
            }
        </script>
    </form>
</body>
</html>


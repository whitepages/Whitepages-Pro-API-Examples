<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="address_lookup.aspx.cs" Inherits="Whitepaper.address_lookup" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8" />
    <title>WhitePages PRO Sample App – Reverse Address</title>
    <link href="css/style.css" rel="stylesheet" />
    <style>
        * {
            margin: 0px;
            padding: 0px;
        }

        .wrapper {
            margin: 50px auto;
            width: 1000px;
        }

        .search_sec {
            float: left;
            width: 1000px;
            margin: 0px 0px 20px 0px;
            padding: 0px;
        }

            .search_sec p {
                font: 14px Arial, Helvetica, sans-serif;
                color: #333;
                font-weight: bold;
                margin-bottom: 8px;
            }

        .inputbox {
            font: 13px Arial, Helvetica, sans-serif;
            color: #333;
            font-weight: normal;
            padding: 5px;
            width: 170px;
            border: 1px solid #CCC;
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            -o-border-radius: 5px;
            -ms-border-radius: 5px;
        }

        .detail_wrapper {
            float: left;
            width: 1000px;
            margin: 0px;
            padding: 0px;
        }

        .detail_box {
            float: left;
            width: 300px;
            margin: 0px 30px 0px 0px;
            padding: 10px;
            background: #f8f8f8;
            border: 1px solid #CCC;
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            -o-border-radius: 5px;
            -ms-border-radius: 5px;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            -webkit-box-sizing: border-box;
            -o-box-sizing: border-box;
            -ms-box-sizing: border-box;
            min-height: 170px;
        }

            .detail_box h1 {
                font: 14px Arial, Helvetica, sans-serif;
                color: #33;
                font-weight: bold;
                padding-bottom: 6px;
            }

            .detail_box p {
                font: 13px Arial, Helvetica, sans-serif;
                color: #333;
                font-weight: normal;
                padding-bottom: 6px;
            }


        .inputbox_address {
            font: 13px Arial, Helvetica, sans-serif;
            color: #333;
            font-weight: normal;
            padding: 5px;
            width: 220px;
            border: 1px solid #CCC;
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            -o-border-radius: 5px;
            -ms-border-radius: 5px;
        }


        .detail_boxin {
            float: left;
            width: 278px;
            margin: 0px 0px 10px 0px;
            padding: 10px;
            background: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            -o-border-radius: 5px;
            -ms-border-radius: 5px;
            box-sizing: border-box;
            -moz-box-sizing: border-box;
            -webkit-box-sizing: border-box;
            -o-box-sizing: border-box;
            -ms-box-sizing: border-box;
            min-height: 80px;
        }

            .detail_boxin:last-child {
                margin-bottom: 0px;
            }
    </style>
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

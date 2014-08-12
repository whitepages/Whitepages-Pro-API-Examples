<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="identity_score.aspx.cs" Inherits="WhitePagesIdentityScore.identity_score" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>WhitePages PRO Sample App � Identity Score</title>
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

        .find_btn {
            font: 13px Arial, Helvetica, sans-serif;
            color: #fff;
            font-weight: normal;
            padding: 5px 10px;
            background: #333;
            border: 1px solid #CCC;
            border-radius: 5px;
            -moz-border-radius: 5px;
            -webkit-border-radius: 5px;
            -o-border-radius: 5px;
            -ms-border-radius: 5px;
            cursor: pointer;
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

        .error_box {
            float: left;
            width: 725px;
            margin: 0px 0px 20px 0px;
            padding: 10px;
            background: #F5E2DE;
            border: 1px solid #934038;
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
            font: 13px Arial, Helvetica, sans-serif;
            color: #954338;
            font-weight: normal;
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

        .disp_result_box {
            float: left;
            width: 960px;
            margin: 0px 0px 20px 0px;
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
            font: 13px Arial, Helvetica, sans-serif;
            color: #333;
            font-weight: normal;
        }

            .disp_result_box table {
                margin: 0px;
                padding: 0px;
            }

                .disp_result_box table tr, td, th {
                    margin: 0px;
                    padding: 0px;
                    border-collapse: collapse;
                }

                .disp_result_box table th {
                    padding: 10px 0px;
                }

                .disp_result_box table td {
                    padding: 10px 0px 10px 10px;
                    border-top: 1px solid #ccc;
                }

                .disp_result_box table tr:hover {
                    background: #fff;
                }

                .disp_result_box table tr:first-child {
                    background: none;
                }
    </style>
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
                <asp:Button ID="ButtonFind" runat="server" Text="Find" class="find_btn" OnClick="ButtonFind_Click" />
                <input type="button" name="clear" value="Clear" class="find_btn" onclick="clearData();">
            </div>
            <div runat="server" id="errorDiv" class="error_box">
                <asp:Literal ID="LitralErrorMessage" runat="server"></asp:Literal>
            </div>

            <div class="detail_wrapper" runat="server" id="identityScoreResult">
                <%--<div class="disp_result_box">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th align="left" width="30%">Score Name</th>
                            <th align="left" width="30%">Score</th>
                        </tr>
                        :IDENTITY_SCORE_RESULT

                    </table>
                </div>--%>

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


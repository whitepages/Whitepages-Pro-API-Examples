<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="personlookup.aspx.cs" Inherits="Whitepaper.personlookup" %>


<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
<head>
    <meta charset="UTF-8">
    <title>WhitePages PRO Sample App � Reverse Person</title>
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
                <p>Find Person</p>
                <asp:TextBox ID="person_first_name" class="inputbox" placeholder="First Name" runat="server"></asp:TextBox>
                <asp:TextBox ID="person_last_name" runat="server" placeholder="Last Name" class="inputbox"></asp:TextBox>
                <asp:TextBox ID="person_where" runat="server" placeholder="City, State, ZIP or Address" class="inputbox_address"></asp:TextBox>
                <asp:Button ID="ButtonFind" runat="server" Text="Find" class="find_btn" OnClick="ButtonFind_Click" />
                <input type="button" name="clear" value="Clear" class="find_btn" onclick="clearData();">
            </div>
            <div runat="server" id="errorDiv" class="error_box">
                <asp:Literal ID="LitralErrorMessage" runat="server"></asp:Literal>
            </div>

            <div class="detail_wrapper" runat="server" id="personResult">
                <div class="disp_result_box">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <th align="left" width="30%">Who</th>
                            <th align="left" width="30%">Where</th>
                        </tr>
                        <%--<tr>
                            <td>
                                <p>Rajnish Agarwal</p>
                                <p><span>Age:</span> 40+</p>
                                <p><span>Type:</span> Home </p>
                            </td>
                            <td>
                                <p>5939 189th Pl NE</p>
                                <p>Redmond, WA 98052-8569</p>
                                <p><span>Receiving Mail:</span> yes </p>
                                <p><span>Usage:</span> Residential </p>
                                <p>
                                    <span>Delivery Point:</span>
                                    Single Unit
                                </p>
                            </td>
                        </tr>--%>
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


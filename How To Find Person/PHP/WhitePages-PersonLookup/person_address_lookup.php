<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>WhitePages PRO Sample App – Reverse Person</title>
        <style>
            *{
                margin:0px;
                padding:0px;
            }

            .wrapper{
                margin:50px auto;
                width:1000px;
            }

            .search_sec{
                float:left;
                width:1000px;
                margin:0px 0px 20px 0px;
                padding:0px;
            }

            .search_sec p{ 
                font:14px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:bold;
                margin-bottom:8px;
            }

            .inputbox{ 
                font:13px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:normal;
                padding:5px;
                width:170px;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
            }

            .find_btn{ 
                font:13px Arial, Helvetica, sans-serif;
                color:#fff;
                font-weight:normal;
                padding:5px 10px;
                background:#333;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
                cursor:pointer;
            }

            .detail_wrapper{
                float:left;
                width:1000px;
                margin:0px;
                padding:0px;
            }

            .detail_box{
                float:left;
                width:300px;
                margin:0px 30px 0px 0px;
                padding:10px;
                background:#f8f8f8;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px; 
                box-sizing:border-box;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                -o-box-sizing:border-box;
                -ms-box-sizing:border-box;
                min-height:170px;
            }

            .detail_box h1{
                font:14px Arial, Helvetica, sans-serif;
                color:#33;
                font-weight:bold;
                padding-bottom:6px;
            }

            .detail_box p{
                font:13px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:normal;
                padding-bottom:6px;
            }

            .error_box{
                float:left;
                width:725px;
                margin:0px 0px 20px 0px;
                padding:10px;
                background:#F5E2DE;
                border:1px solid #934038;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px; 
                box-sizing:border-box;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                -o-box-sizing:border-box;
                -ms-box-sizing:border-box;
                font:13px Arial, Helvetica, sans-serif;
                color:#954338;
                font-weight:normal;
            }


            .inputbox_address{ 
                font:13px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:normal;
                padding:5px;
                width:220px;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
            } 


            .detail_boxin {
                float:left;
                width:278px;
                margin:0px 0px 10px 0px;
                padding:10px;
                background:#fff;
                border:1px solid #ccc;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
                box-sizing:border-box;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                -o-box-sizing:border-box;
                -ms-box-sizing:border-box;
                min-height:80px;	
            }

            .detail_boxin:last-child{
                margin-bottom:0px;
            }

            .disp_result_box {
                float:left;
                width:960px;
                margin:0px 0px 20px 0px;
                padding:10px;
                background:#f8f8f8;
                border:1px solid #CCC;
                border-radius:5px;
                -moz-border-radius:5px;
                -webkit-border-radius:5px;
                -o-border-radius:5px;
                -ms-border-radius:5px;
                box-sizing:border-box;
                -moz-box-sizing:border-box;
                -webkit-box-sizing:border-box;
                -o-box-sizing:border-box;
                -ms-box-sizing:border-box;
                font:13px Arial, Helvetica, sans-serif;
                color:#333;
                font-weight:normal;
            }

            .disp_result_box table{
                margin:0px;
                padding:0px;
            }

            .disp_result_box table tr, td, th{
                margin:0px;
                padding:0px;
                border-collapse:collapse;
            }

            .disp_result_box table th{
                padding:10px 0px;
            }

            .disp_result_box table td{
                padding:10px 0px 10px 10px;
                border-top:1px solid #ccc;
            }

            .disp_result_box table tr:hover{
                background:#fff;
            }

            .disp_result_box table tr:first-child{
                background: none;
            }

        </style>
    </head>
    <body> 
        <?php include 'parse_person_address.php'; ?>  
        <div class="wrapper">
            <div class="search_sec">  
                <p>Find Person</p>  
                <form method="post" action="person_address_lookup.php">  
                    <input type="text" id="person_first_name" name="first_name" placeholder="First Name" value="<?php echo $first_name ?>" class="inputbox">
                    <input type="text" id="person_last_name" name="last_name" placeholder="Last Name"  value="<?php echo $last_name ?>" class="inputbox"> 
                    <input type="text" id="person_where" name="where" placeholder="City, State, ZIP or Address"  value="<?php echo $where ?>"  class="inputbox_address">
                    <input type="Submit" name="submit" value="Find" class="find_btn" > 
                    <input type="button" name="clear" value="Clear" class="find_btn"  onclick="clearData();"> 
                </form> 
            </div> 
            <?php if (!empty($error)) { ?>
                <div class="error_box">
                    <?php echo $error; ?> 
                </div>
            <?php } ?>

            <?php if (empty($error) && $data_type) { ?>

                <div class="detail_wrapper"> 
                    <?php if (count($names) > 0) { ?>

                        <div class="disp_result_box">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <th align="left" width="30%">Who</th>
                                    <th align="left" width="30%">Where</th> 
                                </tr>  

                                <?php foreach ($names as $key => $value) { ?>

                                    <?php //print_r($value);?> 
                                    <tr>
                                        <td> 
                                            <p><?php echo $value; ?></p> 
                                            <?php if ($person_age_range[$key] != "") { ?><p><span>Age:</span> <?php echo $person_age_range[$key] ?>+</p> <?php } ?>
                                            <p><span>Type:</span> <?php echo $pesson_type[$key] ?> </p> 
                                        </td>
                                        <td>
                                            <?php if (!empty($standard_address_line1[$key])) { ?>  <p><?php echo $standard_address_line1[$key]; ?></p> <?php } ?>
                                            <?php if (!empty($standard_address_line2[$key])) { ?> <p><?php echo $standard_address_line2[$key]; ?></p> <?php } ?>
                                            <?php if (!empty($standard_address_location[$key])) { ?> <p><?php echo $standard_address_location[$key]; ?></p> <?php } ?>
                                            <p><span>Receiving Mail:</span> <?php echo $is_receiving_mail[$key] ?> </p> 
                                            <p><span>Usage:</span> <?php echo $usage[$key]; ?> </p> 
                                            <p><span>Delivery Point:</span> 

                                                <?php
                                                if (strlen($delivery_point[$key]) > 0) {
                                                    echo substr($delivery_point[$key], 0, -4) . " Unit";
                                                    ?>
                                                    <?php
                                                }
                                                ?>     


                                            </p> 
                                        </td> 
                                    </tr>
                                <?php } ?> 

                            </table>

                        </div>
                    <?php } ?> 
                </div> 
            <?php } ?>
        </div>  

        <script type="text/javascript">
            function clearData() {
                document.getElementById('person_first_name').value = '';
                document.getElementById('person_last_name').value = '';
                document.getElementById('person_where').value = '';
            }
        </script>        
    </body>
</html>

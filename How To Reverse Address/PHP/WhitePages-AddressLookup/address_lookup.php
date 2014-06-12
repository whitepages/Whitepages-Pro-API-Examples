<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>WhitePages PRO Sample App – Reverse Address</title>
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
                width:588px;
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

        </style>
    </head>
    <body> 
        <?php include 'parse_address_data.php'; ?>       

        <div class="wrapper">
            <div class="search_sec">  
                <p>Find by Address</p>  
                <form method="post" action="address_lookup.php">  
                    <input type="text" name="street_line_1" value="<?php echo $street_line_1 ?>" id="street_line_1" class="inputbox_address" placeholder="Street Address or name"> 
                    <input type="text" name="city" value="<?php echo $city ?>" id="city" class="inputbox_address" placeholder="City and State or Zip" >
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

                <div class="detail_box">
                    <h1>Location</h1>

                    <div class="detail_boxin">
                        <p>

                            <?php if (!empty($standard_address_line1)) { echo $standard_address_line1 ?><br /> <?php } ?>
                            <?php if (!empty($standard_address_line2)) { echo $standard_address_line2 ?><br /> <?php } ?>
                            <?php if (!empty($standard_address_location)) { echo $standard_address_location ?> <?php } ?></p> 
                    </div>

                    <div class="detail_boxin"> 
                        <p><span>Receiving Mail:</span> <?php echo $is_receiving_mail ?></p>
                        <p><span>Usage:</span> <?php echo $usage ?></p>
                        <p><span>Delivery Point:</span>  
                            <?php
                            if (!empty($delivery_point)) {
                            $deliveryPieces = explode("Unit", $delivery_point);
                            echo $deliveryPieces[0] . " Unit";
                            ?>
                            <?php
                            }
                            ?>   </p>
                    </div> 

                </div>

                <div class="detail_box"> 
                    <h1>People <span>(<?php echo count($related_names); ?>)</span></h1>
                    <?php if (count($related_names) > 0) { ?>
                    <?php foreach ($related_names as $key => $value) {
                    ?> 
                    <div class="detail_boxin">
                        <p><?php echo $value ?></p> 
                        <?php  if (count($related_age_range_start[$key])>0) { ?> <p><span>Age:</span> <?php  echo $related_age_range_start[$key] ?>+</p><?php   } ?>
                        <p><span>Type:</span>  <?php echo $contact_types[$key] ?></p>
                    </div>
                    <?php
                    }
                    }
                    ?>
                </div>

            </div> 
            <?php } ?>
        </div>  

        <script type="text/javascript">
            function clearData() {
                document.getElementById('street_line_1').value = '';
                document.getElementById('city').value = '';
            }
        </script>        
    </body>
</html>

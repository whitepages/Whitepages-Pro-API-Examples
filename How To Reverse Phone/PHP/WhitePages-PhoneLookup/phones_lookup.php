<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <meta charset="UTF-8">
        <title>WhitePages PRO Sample App – Reverse Phone</title>
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
                width:606px;
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

        </style>
    </head>
    <body>   
        <?php include 'parse_phone_data.php'; ?>    
        <div class="wrapper">
            <div class="search_sec"> 
                <p>Find by Phone</p>  
                <form method="post" action="phones_lookup.php">  
                    <input type="text" name="phone" placeholder="Phone number" value="<?php echo $req_phone_number ?>" id="phone" class="inputbox" > 
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
                        <h1>Phone</h1>
                        <p>+<?php echo $phone_country_calling_code ?>-<?php echo substr($phone_phone_number, 0, 3) . "-" . substr($phone_phone_number, 3, 3) . "-" . substr($phone_phone_number, 6); ?></p>
                        <p><span>Carrier:</span> <?php echo $phone_carrier ?> </p>
                        <p><span>Phone Type:</span> <?php echo $phone_line_type ?> </p>
                        <p><span>Do not Call registry:</span> <?php echo $phone_do_not_call ?></p>
                        <p><span>SPAN Score:</span> <?php echo $phone_spam_score ?>%</p>
                    </div>
                    <div class="detail_box">
                        <h1>People</h1>
                        <?php foreach($names as $key => $val){ ?>
                        <p><?php echo $val  ?></p>
                        
                        <p><span>Type:</span> <?php echo $contact_types[$key] ?></p> 
                        <p><br /></p>  
                        <?php } ?> 
                    </div>
                    <div class="detail_box">
                        <h1>Location </h1>
                        
                        <?php foreach($location_urls as $key => $val){ ?>
                        <p>
                            <?php echo $location_address[$key] ?>  
                        </p>
                        <p><span>Receiving mail:</span> <?php echo $is_receiving_mail[$key] ?></p>
                        <p><span>Usage:</span> <?php echo $usage[$key] ?></p>
                                <p><span>Delivery Point:</span> 
                                <?php
                                if (strlen($delivery_point[$key])>0) {   
                                    echo substr($delivery_point[$key], 0, -4) . " Unit";
                                    ?>
                                    <?php
                                }
                                ?>  </p>
                                <p><br /></p>  
                        <?php } ?>       
                    </div>
                    <br />

                    <br />
                </div> 
            <?php } ?>
        </div>   
        <script type="text/javascript">
            function clearData() {
                document.getElementById('phone').value = '';
            }
        </script>       

    </body>
</html>

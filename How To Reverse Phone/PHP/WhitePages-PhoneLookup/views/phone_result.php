<div class="detail_wrapper">
    <div class="detail_box">
        <h1>Phone</h1>
        <div class="detail_boxin">
            <p>+<?php echo $value['phone']['country_code'] ?>-<?php echo substr($value['phone']['number'], 0, 3) . "-" . substr($value['phone']['number'], 3, 3) . "-" . substr($value['phone']['number'], 6); ?></p>
            <?php
            if (!empty($value['phone']['phone_carrier'])) { ?>
                <p>
                    <span>Carrier:</span>
                    <?php echo $value['phone']['phone_carrier']; ?>
                </p>
            <?php
            }
            ?>
        </div>
        <div class="detail_boxin">
            <?php
            if (!empty($value['phone']['phone_type'])) { ?>
                <p>
                    <span>Phone Type:</span>
                    <?php echo $value['phone']['phone_type']; ?>
                </p>
            <?php
            }
            if (!empty($value['phone']['do_not_call'])) { ?>
                <p>
                    <span>Do not Call registry:</span>
                    <?php echo $value['phone']['do_not_call']; ?>
                </p>
            <?php
            }
            if (!empty($value['phone']['reputation'])) { ?>
                <p><span>SPAN Score:</span>
                    <?php echo $value['phone']['reputation']; ?>%
                </p>
            <?php
            }
            ?>
        </div>
    </div>
    <div class="detail_box">
        <h1>People</h1>
        <?php foreach($value['people'] as $key => $val) {
            if (!empty($val)) { ?>
                <div class="detail_boxin">
                    <?php
                    if (!empty($val['name'] )) { ?>
                        <p>
                            <?php echo $val['name']; ?>
                        </p>
                    <?php
                    }
                    if (!empty($val['people_type'])) { ?>
                        <p>
                            <span>Type:</span>
                            <?php echo $val['people_type']; ?>
                        </p>
                    <?php
                    }
                    ?>
                </div>
            <?php
            }
        } ?>
    </div>
    <div class="detail_box">
        <h1>Location </h1>
        <?php foreach($value['location'] as $l_key => $l_val) {
            if (!empty($l_val)) { ?>
                <div class="detail_boxin">
                    <p>
                        <?php echo $l_val['address_line1'];
                        if (!empty($l_val['address_line2'])) { ?>
                            &nbsp;,<?php echo $l_val['address_line2'];
                        }
                        echo $l_val['city']; ?>&nbsp;<?php echo $l_val['state_code']; ?>&nbsp;<?php echo $l_val['postal_code']; ?>
                    </p>
                    <?php
                    if (!empty($l_val['is_receiving_mail'])) { ?>
                        <p>
                            <span>Receiving mail:</span>
                            <?php echo $l_val['is_receiving_mail']; ?>
                        </p>
                    <?php
                    }
                    if (!empty($l_val['usage'])) { ?>
                        <p>
                            <span>Usage:</span>
                            <?php echo $l_val['usage']; ?>
                        </p>

                    <?php
                    }
                    if (!empty($l_val['delivery_point'])) { ?>
                        <p>
                            <span>Delivery Point:</span>
                            <?php
                            if (strlen($l_val['delivery_point'])>0) {
                                echo substr($l_val['delivery_point'], 0, -4) . " Unit";
                            }
                            ?>
                        </p>
                    <?php
                    }
                    ?>
                </div>
            <?php
            }
        }
        ?>
    </div>
</div>
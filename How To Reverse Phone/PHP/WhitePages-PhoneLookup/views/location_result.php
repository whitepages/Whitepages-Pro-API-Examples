<div class="detail_box">
    <h1>Location </h1>
    <?php foreach($result->location as $key => $val) {
        if (!empty($val)) { ?>
            <div class="detail_box_in_result">
                <p>
                    <?php echo $val['standard_address_line1'];
                    if (!empty($val['standard_address_line2'])) { ?>
                        &nbsp;,<?php echo $val['standard_address_line2'];
                    }
                    echo $val['city']; ?>
                    <br />
                    <?php echo $val['state_code']; ?>&nbsp;<?php echo $val['postal_code']; ?>
                </p>
                <p>
                    <span>Receiving mail:</span>
                    <?php echo $val['is_deliverable']? 'Yes' : 'No'; ?>
                </p>
                <?php
                if (!empty($val['usage'])) { ?>
                    <p>
                        <span>Usage:</span>
                        <?php echo $val['usage']; ?>
                    </p>

                <?php
                }
                if (!empty($val['delivery_point'])) { ?>
                    <p>
                        <span>Delivery Point:</span>
                        <?php
                        if (strlen($val['delivery_point'])>0) {
                            echo substr($val['delivery_point'], 0, -4) . " Unit";
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
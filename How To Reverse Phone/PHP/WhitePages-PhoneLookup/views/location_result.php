<div class="detail_box">
    <h1>Location </h1>
    <?php foreach($result->location as $key => $val) {
        if (!empty($val)) { ?>
            <div class="detail_box_in_result">
                <p>
                    <?php
                    if (!empty($val['standard_address_line1'])) { ?>
                        <?php echo $val['standard_address_line1'];
                    }

                    if (!empty($val['standard_address_line2'])) { ?>
                        <?php echo ' ' . $val['standard_address_line2'];
                    }

                    if (!empty($val['city'])) { ?>
                        <?php echo ' ' . $val['city'];
                    }

                    if (!empty($val['state_code'])) { ?>
                        <?php echo ' ' . $val['state_code'];
                    }
                    ?>
                    <br />
                    <?php
                    if (!empty($val['postal_code'])) { ?>
                        <?php echo $val['postal_code'];
                    }

                    if (!empty($val['zip4'])) { ?>
                        <?php echo ' ' .  $val['zip4'];
                    }
                    ?>
                </p>
                <p>
                    <span>Receiving mail:</span>
                    <?php echo $val['is_deliverable']? 'Yes' : 'Unknown'; ?>
                </p>

                <p>
                    <span>Usage:</span>
                    <?php echo $val['usage']? $val['usage'] : 'Unknown'; ?>
                </p>

                <p>
                    <span>Delivery Point:</span>
                    <?php
                    if (!empty($val['delivery_point'])) {
                        echo substr($val['delivery_point'], 0, -4) . " Unit";
                    } else {
                        echo 'Unknown';
                    }
                    ?>
                </p>
            </div>
        <?php
        }
    }
    ?>
</div>
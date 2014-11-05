<div class="detail_box">
    <h1>Location</h1>
    <div class="detail_boxin">
        <p>
            <?php echo $value['location']['address_line1']; ?>
            <br />
            <?php echo $value['location']['city'] .' '. $value['location']['state_code'] .' '. $value['location']['postal_code']; ?>
        </p>
    </div>
    <div class="detail_boxin">
        <p><span>Receiving Mail:</span> <?php echo $value['location']['is_receiving_mail']; ?></p>
        <?php
        if (!empty($value['location']['usage'])) { ?>
            <p><span>Usage:</span>  <?php echo $value['location']['usage']; ?></p>
        <?php
        }
        ?>
        <?php
        if (!empty($value['location']['delivery_point'])) { ?>
            <p><span>Delivery Point:</span>
                <?php
                if (!empty($value['location']['delivery_point'])) {
                    $deliveryPieces = explode("Unit", $value['location']['delivery_point']);
                    echo $deliveryPieces[0] . " Unit";
                    ?>
                <?php
                }
                ?>
            </p>
        <?php
        }
        ?>
    </div>
</div>


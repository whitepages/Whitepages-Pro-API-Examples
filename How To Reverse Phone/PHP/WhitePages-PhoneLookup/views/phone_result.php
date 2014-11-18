<div class="detail_box">
    <h1>Phone</h1>
    <div class="detail_box_in_result">
        <p>+<?php echo $result->phone['country_calling_code'] ?>-<?php echo substr($result->phone['phone_number'], 0, 3) . "-" . substr($result->phone['phone_number'], 3, 3) . "-" . substr($result->phone['phone_number'], 6); ?></p>
        <?php
        if (!empty($result->phone['carrier'])) { ?>
            <p>
                <span>Carrier:</span>
                <?php echo $result->phone['carrier']; ?>
            </p>
        <?php
        }
        ?>
    </div>
    <div class="detail_box_in_result">
        <?php
        if (!empty($result->phone['line_type'])) { ?>
            <p>
                <span>Phone Type:</span>
                <?php echo $result->phone['line_type']; ?>
            </p>
        <?php
        }
        ?>
        <p>
            <span>Do not Call registry:</span>
            <?php echo $result->phone['line_type']? 'Yes' : 'Unknown'; ?>
        </p>
        <p>
            <span>Spam Score:</span>
            <?php echo $result->phone['reputation']? $result->phone['reputation'] : 0; ?>%
        </p>
    </div>
</div>


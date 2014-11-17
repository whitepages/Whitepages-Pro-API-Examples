<?php
if (isset($result->phone)) {
    if (!empty($result->phone)) { ?>
        <div class="detail_wrapper">
            <?php
            include 'phone_result.php';
            if (!empty($result->people)) {
                include 'person_result.php';
            }
            if (!empty($result->location)) {
                include 'location_result.php';
            }
            ?>
        </div>
    <?php
    } else {
        include 'message.php';
    }
}


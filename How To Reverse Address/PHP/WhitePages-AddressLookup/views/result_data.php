<?php
if (isset($result->location)) {
    if (!empty($result->location)) {
        foreach ($result->location as $key => $val) { ?>
            <div class="detail_wrapper">
                <?php include 'location_result.php'; ?>
                <?php include 'person_result.php'; ?>
            </div>
        <?php }
    } else {
        include 'message.php';
    }
}

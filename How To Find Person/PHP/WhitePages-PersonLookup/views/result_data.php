<?php
if (isset($result_data)) {
    if (!empty($result_data)) {
        include 'people.php';
    } else { ?>
        <div class="error_box">
            No result found.
        </div>
    <?php
    }
}

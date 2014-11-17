<div class="error_box">
    <?php
    if (!empty($result->error)) {
        echo $result->error;
    } else {
        echo $error;
    }
    ?>
</div>

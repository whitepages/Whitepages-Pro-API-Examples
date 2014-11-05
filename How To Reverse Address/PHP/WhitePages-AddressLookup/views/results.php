<?php if (!empty($error)) { ?>
    <div class="error_box">
        <?php echo $error; ?>
    </div>
<?php } elseif (!empty($result_data)) { ?>
    <?php foreach ($result_data as $key => $value) { ?>
        <div class="detail_wrapper">
            <?php include 'location.php'; ?>
            <?php include 'people.php'; ?>
        </div>
    <?php }
}

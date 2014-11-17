<td>
    <p>
        <?php echo $value['name']; ?>
    </p>
    <?php
    if (!empty($value['age_range'])) { ?>
        <p>
            <span>Age:</span>
            <?php echo $value['age_range']['start']; ?>+
        </p>
    <?php
    }
    if (!empty($value['type'])) { ?>
        <p>
            <span>Type:</span>
            <?php echo $value['type']; ?>
        </p>
    <?php
    }
    ?>
</td>
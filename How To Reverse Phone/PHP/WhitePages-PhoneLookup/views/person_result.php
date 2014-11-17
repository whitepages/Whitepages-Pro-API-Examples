<div class="detail_box">
    <h1>People</h1>
    <?php foreach($result->people as $key => $val) {
        if (!empty($val)) { ?>
            <div class="detail_box_in_result">
                <?php
                if (!empty($val['name'] )) { ?>
                    <p>
                        <?php echo $val['name']; ?>
                    </p>
                <?php
                }
                if (!empty($val['type'])) { ?>
                    <p>
                        <span>Type:</span>
                        <?php echo $val['type']; ?>
                    </p>
                <?php
                }
                if (!empty($val['age_range'])) { ?>
                    <p>
                        <span>Type:</span>
                        <?php echo $val['age_range']['start']; ?>+
                    </p>
                <?php
                }
                ?>
            </div>
        <?php
        }
    } ?>
</div>

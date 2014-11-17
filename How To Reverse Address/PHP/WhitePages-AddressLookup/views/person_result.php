<div class="detail_box">
    <h1>People ( <?php echo count($val['legal_entities_at']); ?> )</h1>
    <?php foreach($val['legal_entities_at'] as $key => $val) {
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

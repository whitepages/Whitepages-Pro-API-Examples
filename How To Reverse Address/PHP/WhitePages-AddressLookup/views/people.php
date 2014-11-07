<div class="detail_box">
    <h1>People <span>( <?php echo count($value['people']); ?> )</span></h1>
    <?php if (!empty($value['people'])) { ?>
        <?php foreach ($value['people'] as $people_key => $people_value) { ?>
            <div class="detail_boxin">
                <p>
                    <?php echo $people_value['name']; ?>
                </p>
                <?php
                if (!empty($people_value['age'])) { ?>
                    <p>
                        <span>Age:</span>
                        <?php echo $people_value['age']['start']; ?>+
                    </p>
                <?php
                }
                if (!empty($people_value['contact_type'])) { ?>
                    <p>
                        <span>Type:</span>
                        <?php echo $people_value['contact_type']; ?>
                    </p>
                <?php
                }
                ?>
            </div>
        <?php
        }
    }
    ?>
</div>


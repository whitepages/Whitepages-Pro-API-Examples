<div class="detail_wrapper">
    <div class="disp_result_box">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
            <tr >
                <th align="left" width="50%">Who</th>
                <th align="left" width="50%">Where</th>
            </tr>
            <?php foreach ($result_data as $key => $value) { ?>
                <tr class="detail_boxin" style="float: none;" >
                    <td>
                        <p>
                            <?php echo $value['person']['name']; ?>
                        </p>
                        <?php
                        if (!empty($value['person']['age'])) { ?>
                            <p>
                                <span>Age:</span>
                                <?php echo $value['person']['age']['start']; ?>+
                            </p>
                        <?php
                        }
                        if (!empty($value['person']['contact_type'])) { ?>
                            <p>
                                <span>Type:</span>
                                <?php echo $value['person']['contact_type']; ?>
                            </p>
                        <?php
                        }
                        ?>
                    </td>
                    <td>
                        <?php if (!empty($value['address'])) { ?>
                            <?php if (!empty($value['address']['address_line1'])) { ?>
                                <p>
                                    <?php echo $value['address']['address_line1'] ?>
                                    <?php if (!empty($value['address']['address_line2'])) { ?>
                                        <br/>
                                        <?php echo $value['address']['address_line2']; ?>
                                    <?php
                                    }
                                    ?>
                                </p>
                            <?php
                            }
                            ?>
                            <p>
                                <?php if (!empty($value['address']['city'])) { ?>
                                    <?php echo $value['address']['city']; ?>
                                <?php
                                }
                                ?>
                                <?php if (!empty($value['address']['state_code'])) { ?>
                                    &nbsp;<?php echo $value['address']['state_code']; ?>
                                <?php
                                }
                                ?>
                                <?php if (!empty($value['address']['postal_code'])) { ?>
                                    &nbsp;<?php echo $value['address']['postal_code']; ?>
                                <?php
                                }
                                ?>
                            </p>
                            <?php if (!empty($value['address']['is_receiving_mail'])) { ?>
                                <p>
                                    <span>Receiving Mail:</span>
                                    <?php echo $value['address']['is_receiving_mail']; ?>
                                </p>
                            <?php
                            }
                            ?>
                            <?php if (!empty($value['address']['usage'])) { ?>
                                <p>
                                    <span>Usage:</span>
                                    <?php echo $value['address']['usage']; ?>
                                </p>
                            <?php
                            }
                            ?>
                            <?php if (!empty($value['address']['delivery_point'])) { ?>
                                <p>
                                    <span>Delivery Point:</span>
                                    <?php echo substr($value['address']['delivery_point'], 0, -4) . " Unit"; ?>
                                </p>
                            <?php
                            }
                        }
                        ?>
                    </td>
                </tr>
            <?php
            }
            ?>
            </tbody>
        </table>
    </div>
</div>

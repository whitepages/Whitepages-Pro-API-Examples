<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-04
 */

include 'whitepages_lib.php';
include 'result.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['phone'])) {
        $param = array(
            'phone' => trim($_POST['phone'])
        );
        $whitepages_obj = new WhitepagesLib();
        $api_response = $whitepages_obj->reverse_phone($param);
        try {
            if ($api_response === false) {
                throw new Exception;
            }
            $result = new Result($api_response);
        } catch(Exception $exception) {
            echo "Error Api response";
        }
    } else {
        $error = 'Please enter phone number';
    }
}


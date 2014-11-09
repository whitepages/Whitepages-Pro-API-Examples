<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-04
 */

include 'whitepages_lib.php';
include 'phone.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['phone'])) {
        $param = array(
            'phone' => trim($_POST['phone'])
        );
        $whitepages_obj = new WhitepagesLib();
        $response = $whitepages_obj->reversePhone($param);
        try {
            if ($response === false) {
                throw new Exception;
            }
            if (!empty($response['error'])) {
                $error = $response['error']['message'];
            } elseif (!empty($response['results'])) {
                $person_obj = new Phone($response);
                $result_data = $person_obj->formattedResult();
            } else {
                $error = 'No records found';
            }

        } catch(Exception $exception) {
            echo "Error Api response";
        }

    } else {
        $error = 'Please enter phone number';
    }
}


<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-01
 */
include 'whitepages_lib.php';
include 'address.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['street_line_1'])) {
        if (!empty($_POST['city'])) {
            $param = array(
                'street_line_1' => trim($_POST['street_line_1']),
                'city' => trim($_POST['city'])
            );
            $whitepages_obj = new WhitepagesLib();
            $response = $whitepages_obj->findAddress($param);
            try {
                if ($response === false) {
                    throw new Exception;
                }
                if ($response) {
                    if (!empty($response['error'])) {
                        $error = $response['error']['message'];
                    } else {
                        $person_obj = new Address($response);
                        $result_data = $person_obj->formattedResult();
                    }
                } else {
                    $error = 'No records found';
                }
            } catch (Exception $exception) {
                echo "Error Api response";
            }

        } else {
            $error = 'Please enter city and state or zip.';
        }
    } else {
        $error = 'Please enter your address details.';
    }
}


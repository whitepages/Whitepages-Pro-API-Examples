<?php
include 'whitepages_lib.php';
include 'result.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['first_name'])) {
        if (!empty($_POST['last_name'])) {
            if (!empty($_POST['where'])) {
                $param = array(
                    'first_name' => trim($_POST['first_name']),
                    'last_name' => trim($_POST['last_name']),
                    'address' => trim($_POST['where'])
                );
                $whitepages_obj = new WhitepagesLib();
                $api_response = $whitepages_obj->find_person($param);
                try {
                    if ($api_response === false) {
                        throw new Exception;
                    }
                    $result = new Result($api_response);
                } catch (Exception $exception) {
                    echo "Error Api response";
                }

            } else {
                $error = 'Please enter city and state or zip.';
            }
        } else {
            $error = 'Please enter last name.';
        }
    } else {
        $error = 'Please enter first name.';
    }
}

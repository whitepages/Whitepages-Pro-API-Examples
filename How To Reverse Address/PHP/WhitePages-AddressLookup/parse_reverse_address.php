<?php
include 'models/api_response.php';
include 'models/address.php';

if (isset($_POST['submit'])) {
    if (!empty($_POST['street_line_1'])) {
        if (!empty($_POST['city'])) {
            $response_api = new Models\ApiResponse($_POST['street_line_1'], $_POST['city']);
            $json_response = $response_api->getJsonResonse();
            if (!empty($json_response['error'])) {
                $error = $json_response['error']['message'];
            } elseif (!empty($json_response['results'])) {
                $address_obj = new Models\Address($json_response);
                $result_data = $address_obj->formattedResult();
            } else {
                $error = 'No records found';
            }
        } else {
            $error = 'Please enter city and state or zip.';
        }
    } else {
        $error = 'Please enter your address details.';
    }
}


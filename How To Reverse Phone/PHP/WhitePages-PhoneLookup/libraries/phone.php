<?php
/**
 * Library for abstraction of methods to use Whitepages Pro API
 * @require     PHP5
 *
 * @author      Kushal Shah
 * @date        2014-06-02
 */

class Phone
{
    public $response;


    public function __construct($response)
    {
        $this->response = $response;
    }

    // return formatted result array
    public function formattedResult()
    {
        $resultData = array();
        while (list(, $val) = each($this->response['results'])) {
            array_push($resultData, $this->getResultData($val));
        }
        return $resultData;
    }

    // return formatted result array
    private function getResultData($id)
    {
        return array(
            'phone' => $this->getPhoneDetails($id),
            'people' => $this->getPeopleDetails($id),
            'location' => $this->getLocationDetails($id)
        );
    }

    // for getting object from id
    private function retrieveById($id)
    {
        if (!empty($this->response) && !empty($this->response['dictionary']) && !empty($this->response['dictionary'][$id])){
            return $this->response['dictionary'][$id];
        } else {
            return '';
        }
    }

    // getting people id from belongs to attr
    // getting people details by people id
    private function getPeopleDetails($id)
    {
        $belongsTo = $this->belongsTo($id);
        $peoples = array();
        if (!empty($belongsTo)) {
            while (list(, $value) = each($belongsTo)) {
                $data = $this->getPeopleData($value);
                array_push($peoples, $data);
            }
        }
        return $peoples;
    }

    // getting best location id
    private function getLocationIds($id)
    {
        $belongsTo = $this->belongsTo($id);
        $belongsToLocationIds = array();
        if (!empty($belongsTo)) {
            while (list(, $val) = each($belongsTo)) {
                $location_id = $this->getBestLocationId($val);
                if (!empty($location_id)) {
                    array_push($belongsToLocationIds, $location_id);
                }
            }
        }

        if (empty($belongsToLocationIds)) {
            $entity =  $this->retrieveById($id);
            if (!empty($entity['best_location'])) {
                $location_id = $entity['best_location']['id']['key'];
                array_push($belongsToLocationIds, $location_id);
            }
        }
        $belongsToLocationIds = array_unique($belongsToLocationIds);
        return $belongsToLocationIds;
    }

    private function getLocationDetails($id)
    {
        $locations = $this->getLocationIds($id);
        $addressDetails = array();
        if (!empty($locations)) {
            while (list(, $value) = each($locations)) {
                $location = $this->locationDetails($value);
                array_push($addressDetails, $location);
            }
        }
        return $addressDetails;
    }
    // getting location details using location id
    private function locationDetails($id)
    {
        $entity =  $this->retrieveById($id);
        return array(
            'address_line1' => $entity['standard_address_line1'],
            'address_line2' => $entity['standard_address_line2'],
            'city' => $entity['city'],
            'postal_code' => $entity['postal_code'],
            'state_code' => $entity['state_code'],
            'country_code' => $entity['country_code'],
            'is_receiving_mail' => $entity['is_receiving_mail']? 'Yes' : 'No',
            'usage' => $entity['usage'],
            'delivery_point' => $entity['delivery_point']);
    }

    private function belongsTo($id)
    {
        $entity =  $this->retrieveById($id);
        $belongsToIds = array();
        if (!empty($entity) && !empty($entity['belongs_to'])) {
            while (list(, $val) = each($entity['belongs_to'])) {
                if (!empty($val['id'])) {
                    array_push($belongsToIds, $val['id']['key']);
                }
            }
        }
        return array_unique($belongsToIds);
    }

    // return best location id
    private function getBestLocationId($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['best_location']) && !empty($entity['best_location']['id'])) {
            return $entity['best_location']['id']['key'];
        } elseif (!empty($entity['locations'])) {
            return $entity['locations'][0]['id']['key'];
        } else {
            return '';
        }
    }

    private function getPeopleData($id)
    {
        return array('name' => $this->getPeopleName($id),
            'people_type' => $this->getContactType($id)
        );
    }

    private function getReputation($entity)
    {
        if (!empty($entity['reputation'])) {
            return $entity['reputation']['spam_score'];
        }
    }

    //  getting phone details using phone id
    public function getPhoneDetails($id)
    {
        $entity =  $this->retrieveById($id);
        return array(
            'number' => $entity['phone_number'],
            'country_code' => $entity['country_calling_code'],
            'phone_type' => $entity['line_type'],
            'phone_carrier' => $entity['carrier'],
            'do_not_call' => $entity['do_not_call']? 'Registered' : 'Not Registered',
            'reputation' => $this->getReputation($entity)
        );
    }

    // for name (business or person)
    private function getPeopleName($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['best_name'])) {
            return $entity['best_name'];
        } elseif (!empty($entity['name'])) {
            return $entity['name'];
        } else {
            return '';
        }
    }

    // for people contact type
    private function getContactType($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['id'])) {
            return $entity['id']['type'];
        } else {
            return '';
        }
    }

}

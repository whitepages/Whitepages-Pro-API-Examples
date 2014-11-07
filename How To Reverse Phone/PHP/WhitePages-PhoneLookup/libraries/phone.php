<?php

namespace Libraries;

class Phone
{
    public $response;
    public $resultData;
    public $belongsToId;
    public $peoples;
    public $locations;
    public $locationIds;

    public function __construct($response)
    {
        $this->response = $response;
        $this->resultData = array();
        $this->belongsToId = array();
        $this->peoples = array();
        $this->locations = array();
        $this->locationIds = array();
    }

    public function formattedResult()
    {
        while (list(, $val) = each($this->response['results'])) {
            array_push($this->resultData, $this->getResultData($val));
        }
        return $this->resultData;
    }

    // for getting object id
    private function retrieveById($id)
    {
        if (!empty($this->response) && !empty($this->response['dictionary']) && !empty($this->response['dictionary'][$id])) {
            return $this->response['dictionary'][$id];
        } else {
            return '';
        }
    }

    private function phoneBelongsTo($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['belongs_to'])) {
            while (list(, $val) = each($entity['belongs_to'])) {
                if (!empty($val['id'])) {
                    array_push($this->belongsToId, $val['id']['key']);
                }
            }
        } else {
            return '';
        }
    }

    // for best location id
    private function getBestLocation($entity)
    {
        if (!empty($entity['best_location']) && !empty($entity['best_location']['id'])) {
            return $entity['best_location']['id']['key'];
        } elseif (!empty($entity['locations'])) {
            return $entity['locations'][0]['id']['key'];
        } else {
            return '';
        }
    }

    // return location entity
    private function getLocation($id)
    {
        return $this->retrieveById($id);
    }

    private function addressLine1($entity)
    {
        return $entity['standard_address_line1'];
    }

    public function addressLine2($entity)
    {
        return $entity['standard_address_line2'];
    }

    private function getCity($entity)
    {
        return $entity['city'];
    }

    private function getPostalCode($entity)
    {
        return $entity['postal_code'];
    }

    private function getStateCode($entity)
    {
        return $entity['state_code'];
    }

    private function getReceivingMail($entity)
    {
        return $entity['is_receiving_mail'];
    }

    private function getUsage($entity)
    {
        return $entity['usage'];
    }

    private function getDeliveryPoint($entity)
    {
        return $entity['delivery_point'];
    }

    private function getPersonDetails($id)
    {
        return array('name' => $this->getName($id),
            'age' => $this->getAge($id),
            'contact_type' => $this->getContactType($id)
        );
    }


    private function getPhoneNumber($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['phone_number'];
    }

    private function getCountryCode($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['country_calling_code'];
    }

    private function getPhoneType($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['line_type'];
    }

    private function getPhoneCarrier($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['carrier'];
    }

    private function getDoNotCall($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['do_not_call']? 'Registered' : 'Not Registered';
    }

    private function getReputation($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['reputation'])) {
            return $entity['reputation']['spam_score'];
        }
    }

    public function getPhoneDetails($id)
    {
        return array('number' => $this->getPhoneNumber($id),
            'country_code' => $this->getCountryCode($id),
            'phone_type' => $this->getPhoneType($id),
            'phone_carrier' => $this->getPhoneCarrier($id),
            'do_not_call' => $this->getDoNotCall($id),
            'reputation' => $this->getReputation($id)
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

    private function getPeopleData($id)
    {
        return array('name' => $this->getPeopleName($id),
            'people_type' => $this->getContactType($id)
        );
    }

    private function getAddressData($entity)
    {
        return array('address_line1' => $this->addressLine1($entity),
            'address_line2' => $this->addressLine2($entity),
            'city' => $this->getCity($entity),
            'postal_code' => $this->getPostalCode($entity),
            'state_code' => $this->getStateCode($entity),
            'is_receiving_mail' => $this->getReceivingMail($entity)? 'Yes' : 'No',
            'usage' => $this->getUsage($entity),
            'delivery_point' => $this->getDeliveryPoint($entity)
        );
    }

    private function getLocationData($val, $id)
    {
        $location_entity =  $this->retrieveById($val);
        if (!empty($location_entity)) {
            $location_id = $this->getBestLocation($location_entity);
            if (!empty($location_id)) {
                if (!in_array($location_id, $this->locationIds)) {
                    array_push($this->locationIds, $location_id);
                    $entity =  $this->retrieveById($location_id);
                    return $this->getAddressData($entity);
                }
            } else {
                $entity =  $this->retrieveById($id);
                if (!empty($entity['best_location'])) {
                    if (!empty($entity['best_location']['id'])) {
                        $location_id = $entity['best_location']['id']['key'];
                        array_push($this->locationIds, $location_id);
                        $entity =  $this->retrieveById($location_id);
                        return $this->getAddressData($entity);
                    } else {
                        return array();
                    }
                } else {
                    return array();
                }
            }
        }
    }

    private function getPeopleDetails($id)
    {
        $this->phoneBelongsTo($id);
        if (!empty($this->belongsToId)) {
            while (list(, $val) = each($this->belongsToId)) {
                array_push($this->peoples, $this->getPeopleData($val));
            }
        }
        return $this->peoples;
    }

    private function getLocationDetails($id)
    {
        $this->phoneBelongsTo($id);
        if (!empty($this->belongsToId)) {
            while (list(, $val) = each($this->belongsToId)) {
                if (!empty($val)) {
                    array_push($this->locations, $this->getLocationData($val, $id));
                }
            }
        }
        return $this->locations;
    }

    private function getResultData($id)
    {
        return array(
            'phone' => $this->getPhoneDetails($id),
            'people' => $this->getPeopleDetails($id),
            'location' => $this->getLocationDetails($id)
        );
    }

}


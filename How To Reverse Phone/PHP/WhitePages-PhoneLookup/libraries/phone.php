<?php

namespace Libraries;

class Phone
{
    public $response;
    public $resultData;
    public $belongsToId;
    public $peoples;
    public $locations;

    public function __construct($params)
    {
        $this->response = $params;
        $this->resultData = array();
        $this->belongsToId = array();
        $this->peoples = array();
        $this->locations = array();
    }

    // for getting object id
    public function retrieveById($id)
    {
        if (!empty($this->response) && !empty($this->response['dictionary']) && !empty($this->response['dictionary'][$id])) {
            return $this->response['dictionary'][$id];
        }
    }

    public function phoneBelongsTo($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['belongs_to'])) {
            while (list(, $val) = each($entity['belongs_to'])) {
                if (!empty($val['id'])) {
                    array_push($this->belongsToId, $val['id']['key']);
                }
            }
        }
    }

    // for best location id
    public function getBestLocation($entity)
    {
        if (!empty($entity['best_location']) && !empty($entity['best_location']['id'])) {
            return $entity['best_location']['id']['key'];
        } elseif (!empty($entity['locations'])) {
            return $entity['locations'][0]['id']['key'];
        }
    }

    // return location entity
    public function getLocation($id)
    {
        return $this->retrieveById($id);
    }

    public function addressLine1($entity)
    {
        return $entity['standard_address_line1'];
    }

    public function addressLine2($entity)
    {
        return $entity['standard_address_line2'];
    }

    public function getCity($entity)
    {
        return $entity['city'];
    }

    public function getPostalCode($entity)
    {
        return $entity['postal_code'];
    }

    public function getStateCode($entity)
    {
        return $entity['state_code'];
    }

    public function getReceivingMail($entity)
    {
        return $entity['is_receiving_mail'];
    }

    public function getUsage($entity)
    {
        return $entity['usage'];
    }

    public function getDeliveryPoint($entity)
    {
        return $entity['delivery_point'];
    }

    public function getPersonDetails($id)
    {
        return array('name' => $this->getName($id),
            'age' => $this->getAge($id),
            'contact_type' => $this->getContactType($id)
        );
    }


    public function getPhoneNumber($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['phone_number'];
    }

    public function getCountryCode($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['country_calling_code'];
    }

    public function getPhoneType($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['line_type'];
    }

    public function getPhoneCarrier($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['carrier'];
    }

    public function getDoNotCall($id)
    {
        $entity =  $this->retrieveById($id);
        return $entity['do_not_call']? 'Registered' : 'Not Registered';
    }

    public function getReputation($id)
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
    public function getPeopleName($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['best_name'])) {
            $name = $entity['best_name'];
        } elseif (!empty($entity['name'])) {
            $name = $entity['name'];
        }
        return $name;
    }

    // for people contact type
    public function getPeopleContactType($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['locations'])) {
            while (list(, $val) = each($entity['locations'])) {
                if (!empty($val['id'])) {
                    if ($val['id']['key'] == $this->getBestLocation($entity)) {
                        $contact_type = $val['contact_type'];
                        break;
                    }
                }
            }
        }
        return empty($contact_type)? '' : $contact_type;
    }

    public function getPeopleData($id)
    {
        return array('name' => $this->getPeopleName($id),
            'people_type' => $this->getPeopleContactType($id)
        );
    }

    public function getLocationData($id)
    {
        $location_entity =  $this->retrieveById($id);
        if (!empty($location_entity)) {
            $location_id = $this->getBestLocation($location_entity);
            if (!empty($location_id)) {
                $entity =  $this->retrieveById($location_id);
                return array('address_line1' => $this->addressLine1($entity),
                    'address_line2' => $this->addressLine2($entity),
                    'city' => $this->getCity($entity),
                    'postal_code' => $this->getPostalCode($entity),
                    'state_code' => $this->getStateCode($entity),
                    'is_receiving_mail' => $this->getReceivingMail($entity)? 'Yes' : 'No',
                    'usage' => $this->getUsage($entity),
                    'delivery_point' => $this->getDeliveryPoint($entity));
            }
        }
    }

    public function getPeopleDetails($id)
    {
        $this->phoneBelongsTo($id);
        if (!empty($this->belongsToId)) {
            while (list(, $val) = each($this->belongsToId)) {
                array_push($this->peoples, $this->getPeopleData($val));
            }
        }
        return $this->peoples;
    }

    public function getLocationDetails($id)
    {
        $this->phoneBelongsTo($id);
        if (!empty($this->belongsToId)) {
            while (list(, $val) = each($this->belongsToId)) {
                if (!empty($val)) {
                    array_push($this->locations, $this->getLocationData($val));
                }
            }
        }
        return $this->locations;
    }

    public function getResultData($id)
    {
        return array(
            'phone' => $this->getPhoneDetails($id),
            'people' => $this->getPeopleDetails($id),
            'location' => $this->getLocationDetails($id)
        );
    }

    public function formattedResult()
    {
        while (list(, $val) = each($this->response['results'])) {
            array_push($this->resultData, $this->getResultData($val));
        }
        return $this->resultData;
    }
}


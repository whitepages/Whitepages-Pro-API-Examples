<?php

namespace Libraries;

class Person
{
    public $response;
    public $resultData;

    public function __construct($params)
    {
        $this->response = $params;
        $this->resultData = array();
    }

    // for getting object id
    public function retrieveById($id)
    {
        if (!empty($this->response) && !empty($this->response['dictionary']) && !empty($this->response['dictionary'][$id])) {
            return $this->response['dictionary'][$id];
        }
    }

    // for best location id
    public function getBestLocation($entity)
    {
        if (!empty($entity['best_location']) && !empty($entity['best_location']['id'])) {
            return $entity['best_location']['id']['key'];
        }
    }

    // for best location id
    public function getLocation($id)
    {
        return $this->retrieveById($id);
    }

    // for name (business or person)
    public function getName($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['best_name'])) {
            return $name = $entity['best_name'];
        } elseif (!empty($entity['name'])) {
            return $name = $entity['name'];
        }
    }

    // for person age
    public function getAge($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['age_range'])) {
            return $entity['age_range'];
        }
    }

    // for person contact type
    public function getContactType($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity['locations'])) {
            while (list(, $val) = each($entity['locations'])) {
                if (!empty($val['id'])) {
                    if ($val['id']['key'] == $this->getBestLocation($entity)) {
                        return $contact_type = $val['contact_type'];
                        break;
                    }
                }
            }
        }
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

    public function getCountryCode($entity)
    {
        return $entity['country_code'];
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

    public function getLocationDetails($id)
    {
        $entity =  $this->retrieveById($id);
        if (!empty($entity)) {
            $location = $this->getLocation($this->getBestLocation($entity));
            return array('address_line1' => $this->addressLine1($location),
                'address_line2' => $this->addressLine2($location),
                'city' => $this->getCity($location),
                'postal_code' => $this->getPostalCode($location),
                'state_code' => $this->getStateCode($location),
                'country_code' => $this->getCountryCode($location),
                'is_receiving_mail' => $this->getReceivingMail($location)? 'Yes' : 'No',
                'usage' => $this->getUsage($location),
                'delivery_point' => $this->getDeliveryPoint($location));
        }
    }

    public function getPersonDetails($id)
    {
        return array('name' => $this->getName($id),
            'age' => $this->getAge($id),
            'contact_type' => $this->getContactType($id)
        );
    }

    public function getResultData($id)
    {
        return array('person' => $this->getPersonDetails($id),
            'address' => $this->getLocationDetails($id)
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

